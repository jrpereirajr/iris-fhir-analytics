# Finding inconsistencies in FHIR data

A useful usage for FHIR unified schema is search for inconsistencies. As suggested by [Qi Li](https://community.intersystems.com/user/qi-li), one example could be find patients with records for diabetes medication, however without diabetes condition.

Another example is search conditions with findings (like diabetes, for instance) and a record for resources denoting "no known problems", e.g., SNOMED CT: "160245001 |No current problems or disability (situation)|", as discussed in [HL7 FHIR documentation](https://www.hl7.org/fhir/condition.html#9.2.3.4).

So, in order to deal with them, I setup two SQL KPIs for querying FHIR SQL schema and return resources which match to these kinds of inconsistencies. For input, I manually changed some files which are imported when the container is created.

For diabetes medication inconsistence, I choose a patient without diabetes conditions and insert manually a diabetes medication (file Mikel238_Dickinson688_62644b68-f18b-46e0-86f9-56b3cb2f6737.json). I found the medication code by searching for "snomed ct insulin".

```json
"medicationCodeableConcept": {
  "coding": [
    {
      "system": "http://snomed.info/sct",
      "code": "325072002",
      "display": "Insulin Aspart (substance)"
    }
  ],
  "text": "Lantus 100 unit/ml injectable solution"
```

For "no known problems" inconsistencies, I changed the file Adina377_Corkery305_cb12851a-2ebd-4c15-88a9-5bee0f308afc.json, and add a "160245001 |No current problems or disability|" record in an pre-existing "190905008" |Cystic Fibrosis|" condition.

```json
"coding": [
  {
    "system": "http://snomed.info/sct",
    "code": "160245001",
    "display": "No current problems or disability"
  },
  {
    "system": "http://snomed.info/sct",
    "code": "190905008",
    "display": "Cystic Fibrosis"
  }
],
```

Then, the two SQL shown below were setup. The first one gets diabetes medication inconsistencies; the second, "no known problems" inconsistencies:

```sql
-- patients with diabetes medication but no diabetes condition
SELECT 
	(
	SELECT GetProp(GetJSON(GetAtJSON(GetJSON(GetJSON(ResourceString, 'medicationCodeableConcept'), 'coding'),0), 'display'), 'display') FROM HSFHIR_I0001_R.Rsrc r where r.Key = m.Key
	) "Medication (ingredient)",
	encounter "Encounter",
	authoredon "Encounter date"
FROM HSFHIR_I0001_S.MedicationRequest m
WHERE 
	-- data inserted for last 7 days
	_lastUpdated BETWEEN DATEADD('dd', -7, CURRENT_TIMESTAMP) and CURRENT_DATE
	-- diabetes medication
	AND $LISTGET(m.code, 1) %inlist $LISTBUILD('96367001','420837001','421367005','420609005','325072002','427292001','414515005','411529005','411530000','412210000','426313003','422346007')
	-- no diabetes condition
	AND 0 = (
		SELECT count(*) FROM HSFHIR_I0001_S.Condition c
		WHERE 
		-- diabetes conditions
		$LISTGET(c.code, 1) %inlist $LISTBUILD('73211009','733072002','530558861000132104','609568004','609569007','105401000119101','199223000','703136005','46635009','44054006','111552007','716362006','123763000','722206009','8801005') 
		AND m.patient = c.patient
	)
  
-- conditions with "no known problems" no properly 
SELECT 
	'',
	encounter "Encounter",
	onsetDate "Encounter date"
FROM HSFHIR_I0001_S.Condition 
WHERE 
	-- data inserted for last 7 days
	_lastUpdated BETWEEN DATEADD('dd', -7, CURRENT_TIMESTAMP) and CURRENT_DATE
	-- 160245001 = no known problems
	AND $FIND(code, 160245001) > 0
	-- more than 1 condition code recorded (each code recorded generates 2 entries into code list - code and its description)
	AND $LISTLENGTH(code) > 2
  ```

I found codes for diabetes conditions and medications in the CDC site, [here](https://phinvads.cdc.gov/vads/http:/phinvads.cdc.gov/vads/ViewCodeSystemConcept.action?oid=2.16.840.1.113883.6.96&code=96367001) and [here](https://phinvads.cdc.gov/vads/ViewCodeSystemConcept.action?oid=2.16.840.1.113883.6.96&code=73211009).

These SQL feed up the KPIs [DiabetesMedicationInconsistence](../src/community/fhirAnalytics/deepsee/kpi/DiabetesMedicationInconsistence.cls) and [NoKnowProblemsInconsistence](../src/community/fhirAnalytics/deepsee/kpi/NoKnowProblemsInconsistence.cls), respectively.

Finally, I setup a dashboard where this information is diplayed. Note that two inconsistencies issue were detected - one for each of them.

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/chrome_ncTSj4WZrg.png"></img>

You can access this dashboard by these links:

```
http://localhost:32783/csp/healthshare/fhirserver/_DeepSee.UserPortal.DashboardViewer.zen?DASHBOARD=User/Inconsistencies.dashboard

http://localhost:32783/dsw/index.html#!/d/User/Inconsistencies.dashboard?ns=FHIRSERVER
```