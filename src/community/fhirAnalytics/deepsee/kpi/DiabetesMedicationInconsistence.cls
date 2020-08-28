Class community.fhirAnalytics.deepsee.kpi.DiabetesMedicationInconsistenceKPI Extends %DeepSee.KPI
{

XData KPI [ XMLNamespace = "http://www.intersystems.com/deepsee/kpi" ]
{
<kpi name="DiabetesMedicationInconsistence" 
displayName="DiabetesMedicationInconsistence" 
sourceType="sql">

<property name="Medication" 
displayName="Medication (ingredient)" 
 columnNo="1" />

<property name="Encounter" 
displayName="Encounter" 
 columnNo="2"/>

<property name="EncounterDate" 
displayName="Encounter date" 
 columnNo="3"/>

<property name="InconsistenciesCount" 
displayName="Inconsistencies for diabetes" 
 columnNo="4"/>

</kpi>
}

Method %OnGetSQL(ByRef pSQL As %String) As %Status
{
  Set pSQL = 
  // patients with diabetes medication but no diabetes condition
  "SELECT "_
    "( "_
    "SELECT GetProp(GetJSON(GetAtJSON(GetJSON(GetJSON(ResourceString, 'medicationCodeableConcept'), 'coding'),0), 'display'), 'display') FROM HSFHIR_I0001_R.Rsrc r where r.Key = m.Key "_
    ") ""Medication (ingredient)"", "_
    "encounter ""Encounter"", "_
    "authoredon ""Encounter date"", "_
    "COUNT(*) ""InconsistenciesCount"" "_
  "FROM HSFHIR_I0001_S.MedicationRequest m "_
  "WHERE "_
    //data inserted for last 7 days
    "_lastUpdated BETWEEN DATEADD('dd', -7, CURRENT_TIMESTAMP) and CURRENT_DATE "_
    //diabetes medication
    "AND $LISTGET(m.code, 1) %inlist $LISTBUILD('96367001','420837001','421367005','420609005','325072002','427292001','414515005','411529005','411530000','412210000','426313003','422346007') "_
    //no diabetes condition
    "AND 0 = ( "_
      "SELECT count(*) FROM HSFHIR_I0001_S.Condition c "_
      "WHERE  "_
      // diabetes conditions
      "$LISTGET(c.code, 1) %inlist $LISTBUILD('73211009','733072002','530558861000132104','609568004','609569007','105401000119101','199223000','703136005','46635009','44054006','111552007','716362006','123763000','722206009','8801005') "_
      "AND m.patient = c.patient "_
    ")"

  Quit $$$OK
}

}
