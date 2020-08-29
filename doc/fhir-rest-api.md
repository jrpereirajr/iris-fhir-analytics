# Using FHIR REST API to show patients information

When you're using a standard like FHIR, you could tak advantages also in stardard UI. So you can easily plug nice UI into your application.

In order to illustrate how to use FHIR REST API, I adapted a UI framework based on Google Material Design - [fhir-ui](https://github.com/healthintellect/fhir-ui), to receive a patient list from analytics tools and display basic information about them. To see a more complete UI framework, please [check this document out](https://github.com/jrpereirajr/iris-fhir-analytics/blob/master/doc/fhir-react.md) after read this one.

This UI framework is specific for FHIR data, which means that you can get information returned by IRIR FHIR API and present it to the interface, with almost no need to futher processing.

```xml
<MyPatientTable
  patients={patients}
  tableTitle="Patient List"
  tableRowSize="small"
  defaultRowsPerPage={5}
  onGetDetailsData={getPatientDetails}
/>
```

Here, the patient property is a instance of FHIR resouce of type Patient:

```json
{
  "resourceType": "Patient",
  "name": [
    {
      "text": "Cersi Lannister",
      "prefix": [
        "Queen"
      ],
      "family": [
        "Lannister"
      ],
      "given": [
        "Cersi"
      ],
      "suffix": [
        "Baratheon"
      ],
      "resourceType": "HumanName"
    }
  ],
  "active": true,
  "birthDate": "1973-10-03",
  "gender": "female",
  ...
  ```

Futhermore, the modern UI frameworks make easy provide features like responsive design:

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/m9T1sQwc94.gif"></img>

The web interface was developed using React JS; the project are availble [here](https://github.com/jrpereirajr/iris-fhir-analytics/tree/master/fhirUI/react-fhir-ui). Note that I had to customize some components, so I forked the original project in order to reference as dependency for my project in package.json.

## The Web interface

The interface receives a comma-separated list in it query string and uses FHIR REST API to acquire basic information about such patients.

The query string looks like this:

```
http://localhost:32783/csp/user/fhirUI/index.html?PatientList=1,172
```

First, the patient list is retrieved from query string:

```js
var qs = window.location.search.substr(1)
  .split('&')
  .map(p => p.split('='))
  .reduce((acc, curr) => { acc[curr[0]] = curr[1]; return acc; }, {});
```

After applied to the previous query string, this code produces an object like this:

```js
{PatientList: "1,172"}
```

Then, such list it's used to setup a FHIR REST call:

```js
const getPatientDetails = (patientInfo, resourceType) => {
	if (!patientInfo || !patientInfo.id) return Promise.resolve();
	const base = 'http://localhost:32783/fhir/r4';
	let url = '';
	let formatter = (obj) => (obj.entry || []).map(e => e.resource);
	switch(resourceType) {
		case 'Bundle':
			url = `${base}/Patient?_id=${patientInfo.id}`;
			formatter = (obj) => obj;
			break;
		case 'Patient':
			url = `${base}/Patient?_id=${patientInfo.id}`;
			break;
		case 'AllergyIntolerance':
			url = `${base}/Patient/${patientInfo.id}/AllergyIntolerance`;
			break;
		case 'Conditions':
			url = `${base}/Patient/${patientInfo.id}/Condition`;
			break;
		case 'Observations':
			url = `${base}/Patient/${patientInfo.id}/Observation`;
			break;
	}
	return fetch(url, {
		"headers": {
			"accept": "application/fhir+json",
			"cache-control": "no-cache",
			"content-type": "application/fhir+json;charset=UTF-8",
			"pragma": "no-cache",
			"sec-fetch-dest": "empty",
			"sec-fetch-mode": "cors",
			"x-requested-with": "XMLHttpRequest"
		},
		"referrer": "http://localhost:32783/csp/user/fhirUI/FHIRAppDemo.html?$ZEN_POPUP=1&$ZEN_SOFTMODAL=1&PatientList=1,172,459,705,1002,1510,1984,1996",
		"referrerPolicy": "no-referrer-when-downgrade",
		"body": null,
		"method": "GET",
		"mode": "cors",
		"credentials": "include"
	}).then(r => r.json()).then(formatter);
}
```

Now, the interface it's ready to be called by analytics tools.

## Calling the Web interface from IRIS Analytics

In order to call the interface from a IRIS Analytics dashboard, you need an Action KPI. Even though there's an already action for navigate to URLs, you'll need more flexibility than provided by this built in action.

First an action KPI is created and in its %OnDashboardAction method, getting the resources IDs for patients selected in the context of the dashboard and setting a command to display them in a popup window.

```objectscript
ClassMethod %OnDashboardAction(pAction As %String, pContext As %ZEN.proxyObject) As %Status
{
  If (pAction="GoToReport") {
    Set pContext.command = "popup:community.fhirAnalytics.deepsee.kpi.ViewPatients.cls?PatientList="_$LTS(
      ..GetPatientsResourceIdList(pContext), ","
    )
  }

  Quit $$$OK
}
```

The patient list is retrieved by executing a DRILLTHROUGH operation on MDX query provided by dashboard context.

```objectscript
ClassMethod GetPatientsResourceIdList(pContext As %ZEN.proxyObject) As %List
{
  Set mdx = "DRILLTHROUGH SELECT FROM "_$Piece(pContext.%data("mdx"),"FROM ", 2)_" "_pContext.%data("currFilterSpec")
  Set rs = ##class(%DeepSee.ResultSet).%New()
  $$$THROWONERROR(st, rs.%PrepareMDX(mdx))
  $$$THROWONERROR(st, rs.%Execute())

  Set list = ""
	$$$THROWONERROR(st, rs.%GetListingResultSet(.sqlRs))
	Set columns = ..GetMetaColumns(sqlRs)
	Set colCount = columns.Count()
	While((sqlRs.%Next()) && (sqlRs.%ROWCOUNT <= 100)){
		For iCol = 1:1:colCount {
			Set colName = columns.GetAt(iCol)
      Set value = $Property(sqlRs, colName)
			Set:('$LF(list, value)) $List(list, * + 1) = value
		}
	}
  Return list
}
```

This drill operation uses a cube listing which return the patients resources IDs:

```xml
<cube xmlns="http://www.intersystems.com/deepsee" name="Patient" displayName="Patient" disabled="false" abstract="false" sourceClass="community.fhirAnalytics.deepsee.table.PatientCubeSource" actionClass="community.fhirAnalytics.deepsee.kpi.PatientDetailsAction" namedFactNums="true" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  ...
  <listing name="PatientResourceIdListing" disabled="false" listingType="table" fieldList="PatientId-&gt;_id">
  </listing>
  ...
</cube>
```

As you may note, the popup URL isn't the HTML file for the Web interface, but a ZEN page instead. This is necessary because IRIS Analytics need to perform some logic where a ZEN context it's necessary.

The ZEN page acts just like a forwarder class, redirecting the request to the Web interface and passing through the patient list:

```objectscript
Method DrawRedirect(pSeed As %String) As %Status
{
  Set redirectURL = "http://localhost:32783/csp/user/fhirUI/index.html"
  Write "<script language=""JavaScript"" type=""text/javascript"">location.href=`"_redirectURL_"?${window.location.search.substr(1)}`;</script>"
  Return $$$OK
}
```

Finally, we need to setup a control in the IRIS Analytics dashboard to use this KPI. First, choose one widget in dashboard and add a control to it. This control must be of type "GoToReport", defined in KPI PatientDetailsAction.
Note that in order to the KPI being available to the widget's actions, such KPI was setup as the default KPI action for the cube in its "actionClass" property.
The picture below, show such configuration:

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/yls3kZjO1q.gif"></img>

Checkout the classes [PatientDetailsAction](../src/community/fhirAnalytics/deepsee/kpi/PatientDetailsAction.cls), [ViewPatients](../src/community/fhirAnalytics/deepsee/kpi/ViewPatients.cls) and [PatientCube](../src/community/fhirAnalytics/deepsee/cube/PatientCube.cls) for more information.

## Calling the Web interface from Power BI

Similarly, to IRIS Analytics, a URL calling the Web interface containing the selected patients in its PatientList query string parameter must be setup and opened by Power BI.

First we need a metric which will setup the URL to the Web interface with the selected patients resource list. In order to do that, create a metric and provide the following DAX code:

```objectscript
SelectedPatientsResourceList = 
// Create a measure called SelectedPatientsResourceList which generates a URL to a Web interface, passing out the selected patients resources IDs
CONCATENATE(
    "http://localhost:32783/csp/user/fhirUI/index.html?PatientList=", 
    CONCATENATEX(
        // Filter DxPatientKey table by IDs in selected ones in field DxPatientKey of Fact table
        FILTER(
            'DxPatientKey', 
            'DxPatientKey'[ID] IN VALUES('Fact'[DxPatientKey])
        ), 
        // Use values in DxPatientResourceId column for concatenation
        'DxPatientKey'[DxPatientResourceId],
        // Concatenates using a comma as separator
	    ","
    )
)
```

Then, creates a button and set its type to "Web URL". On the "Web URL" property, choose the metric "SelectedPatientsResourceList" create early.

Now you can perform some filtering and view the patients by clicking in the button while holding the CTRL key.

The whole process is depicted below:

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/RB4qgvGisH.gif"></img>