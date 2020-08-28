Class community.fhirAnalytics.deepsee.kpi.NoKnowProblemsInconsistenceKPI Extends %DeepSee.KPI
{

XData KPI [ XMLNamespace = "http://www.intersystems.com/deepsee/kpi" ]
{
<kpi name="NoKnowProblemsInconsistence" 
displayName="NoKnowProblemsInconsistence" 
sourceType="sql">

<property name="Encounter" 
displayName="Encounter" 
 columnNo="2"/>

<property name="EncounterDate" 
displayName="Encounter date" 
 columnNo="3"/>

<property name="InconsistenciesCount" 
displayName="Inconsistencies for NKP" 
 columnNo="4"/>

</kpi>
}

Method %OnGetSQL(ByRef pSQL As %String) As %Status
{
  Set pSQL = 
  // conditions with "no known problems" no properly 
  "SELECT "_
    "'', "_
    "encounter ""Encounter"", "_
    "recordedDate ""Encounter date"", "_
    "COUNT(*) ""InconsistenciesCount"" "_
  "FROM HSFHIR_I0001_S.Condition "_
  "WHERE "_
    // data inserted for last 7 days
    "_lastUpdated BETWEEN DATEADD('dd', -7, CURRENT_TIMESTAMP) and CURRENT_DATE "_
    // 160245001 = no known problems "_
    "AND $FIND(code, 160245001) > 0 "_
    // more than 1 condition code recorded (each code recorded generates 2 entries into code list - code and its description)
    "AND $LISTLENGTH(code) > 2"

  Quit $$$OK
}

}
