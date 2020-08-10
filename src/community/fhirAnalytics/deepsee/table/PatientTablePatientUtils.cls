Class community.fhirAnalytics.deepsee.table.PatientTablePatientUtils Extends %RegisteredObject
{

ClassMethod IsCountPatientOnInsertUpdate(pPatientId As %String) As %Boolean
{
  Set isCountPatient = 1
  If (pPatientId) {
    &sql(
      SELECT COUNT(*) INTO :isCountPatient
      FROM community_fhirAnalytics_deepsee_table.PatientTable
      WHERE CountPatient = 1 AND PatientId = :pPatientId
    )
  }
  Return isCountPatient = 0
}

ClassMethod CheckCountPatientOnDelete(pPatientId As %String, pId As %String) As %Status
{
  Set status = $$$OK
  If (pPatientId) {
    New SQLCODE
    &sql(
      UPDATE community_fhirAnalytics_deepsee_table.PatientTable
      SET CountPatient = 1
      WHERE ID = (
        SELECT TOP 1 ID
        FROM community_fhirAnalytics_deepsee_table.PatientTable
        WHERE PatientId = :pPatientId AND Id <> :pId
      )
    )
    Set:((SQLCODE '= 0) && (SQLCODE '= 100)) status = ##class(%SYSTEM.Error).FromSQLCode(SQLCODE).Status
  }
  Return status
}

}
