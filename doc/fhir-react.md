# Using fhir-react UI framework for quick visualization

The [fhir-react](https://github.com/1uphealth/fhir-react#readme) project is a React UI framework based on Google Material Design, which [covers almost all FHIR resources](https://github.com/1uphealth/fhir-react#available-resources) for versions DSTU2, STU3 and R4.

It design it's really friendly - there's just one component! As FHIR resource types are standards, the framework resolves internally what rendering class must be used. 

To display your FHIR resource just write this component:

```xml
<FhirResource fhirResource={fhirResource} fhirVersion={fhirVersions.STU3} />
```

Where fhirResource is a JSON containing any FHIR resource.

In FHIR REST API, there's an operator which grabs all resources from patients: $everything:

```
http://localhost:32783/fhir/r4/Patient/1/$everything
```

This return all sort of resources relate to patient.

So, as fhir-react can handle with almost every FHIR resource, I used it to display resources returned by $everything calls, improving my application patient visualization feature.

First, only resources of type Patient are returned, and each one of them are rendered with a button nearby. When this button is clicked, a $everything call is issued to server. Then, resources are grouped by type and rendered using a tab component.

The results are shown below:

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/WQcdE2huU2.gif"></img>

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/FVIjalYu9r.gif"></img>

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/xl4IBx5532.gif"></img>

[Here](https://github.com/jrpereirajr/iris-fhir-analytics/tree/master/fhirUI/react-fhir-react/README.md) you can find the sources files and instructions for build this web application.

You can refer to [this document](https://github.com/jrpereirajr/iris-fhir-analytics/blob/master/doc/fhir-rest-api.md) to get more information about how to use FHIR REST API with IRIS Analytics and Power BI.