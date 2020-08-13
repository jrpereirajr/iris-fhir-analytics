Class community.fhirAnalytics.deepsee.table.PatientTableObservationUtils Extends %RegisteredObject
{

ClassMethod IsCountObservationOnInsertUpdate(pObservationId As %String) As %Boolean
{
  Set isCountObservation = 1
  If (pObservationId) {
    &sql(
      SELECT COUNT(*) INTO :isCountObservation
      FROM community_fhirAnalytics_deepsee_table.PatientTable
      WHERE CountObservation = 1 AND ObservationId = :pObservationId
    )
  }
  Return isCountObservation = 0
}

ClassMethod CheckCountObservationOnDelete(pObservationId As %String, pId As %String) As %Status
{
  Set status = $$$OK
  If (pObservationId) {
    New SQLCODE
    &sql(
      UPDATE community_fhirAnalytics_deepsee_table.PatientTable
      SET CountObservation = 1
      WHERE ID = (
        SELECT TOP 1 ID
        FROM community_fhirAnalytics_deepsee_table.PatientTable
        WHERE ObservationId = :pObservationId AND Id <> :pId
      )
    )
    Set:((SQLCODE '= 0) && (SQLCODE '= 100)) status = ##class(%SYSTEM.Error).FromSQLCode(SQLCODE).Status
  }
  Return status
}

}
