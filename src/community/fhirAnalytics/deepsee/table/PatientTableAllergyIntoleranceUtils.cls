Class community.fhirAnalytics.deepsee.table.PatientTableAllergyIntoleranceUtils Extends %RegisteredObject
{

ClassMethod IsCountAllergyIntoleranceOnInsertUpdate(pAllergyIntoleranceId As %String) As %Boolean
{
  Set isAllergyIntolerance = 1
  If (pAllergyIntoleranceId) {
    &sql(
      SELECT COUNT(*) INTO :isAllergyIntolerance
      FROM community_fhirAnalytics_deepsee_table.PatientTable
      WHERE CountAllergyIntolerance = 1 AND AllergyIntoleranceId = :pAllergyIntoleranceId
    )
  }
  Return isAllergyIntolerance = 0
}

ClassMethod CheckCountAllergyIntoleranceOnDelete(pAllergyIntoleranceId As %String, pId As %String) As %Status
{
  Set status = $$$OK
  If (pAllergyIntoleranceId) {
    New SQLCODE
    &sql(
      UPDATE community_fhirAnalytics_deepsee_table.PatientTable
      SET CountAllergyIntolerance = 1
      WHERE ID = (
        SELECT TOP 1 ID
        FROM community_fhirAnalytics_deepsee_table.PatientTable
        WHERE AllergyIntoleranceId = :pAllergyIntoleranceId AND Id <> :pId
      )
    )
    Set:((SQLCODE '= 0) && (SQLCODE '= 100)) status = ##class(%SYSTEM.Error).FromSQLCode(SQLCODE).Status
  }
  Return status
}

}
