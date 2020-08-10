Class community.fhirAnalytics.deepsee.table.PatientTable Extends %Persistent
{

Index idxPatientId On PatientId;

Index idxAllergyIntoleranceId On AllergyIntoleranceId;

Index idxCountPatient On CountPatient;

Property PatientId As HSFHIR.I0001.S.Patient [ Required ];

Property AllergyIntoleranceId As HSFHIR.I0001.S.AllergyIntolerance;

Property CountPatient As %Boolean [ SqlComputeCode = {Set {*} = ##class(community.fhirAnalytics.deepsee.table.PatientTablePatientUtils).IsCountPatientOnInsertUpdate({PatientId})}, SqlComputed ];

Property CountAllergyIntolerance As %Boolean [ SqlComputeCode = {Set {*} = ##class(community.fhirAnalytics.deepsee.table.PatientTableAllergyIntoleranceUtils).IsCountAllergyIntoleranceOnInsertUpdate({AllergyIntoleranceId})}, SqlComputed ];

ForeignKey fkPatient(PatientId) References HSFHIR.I0001.S.Patient() [ OnDelete = cascade ];

ForeignKey fkAllergyIntolerance(AllergyIntoleranceId) References HSFHIR.I0001.S.AllergyIntolerance() [ OnDelete = cascade ];

ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Private, ServerOnly = 1 ]
{
  Set status = $$$OK
  Try {
    Set id = $LG(oid, 1)

    Set patientId = ..PatientIdGetStored(id)
    $$$THROWONERROR(st, ##class(community.fhirAnalytics.deepsee.table.PatientTablePatientUtils).CheckCountPatientOnDelete(patientId, id))
    
    Set allergyIntoleranceId = ..AllergyIntoleranceIdGetStored(id)
    $$$THROWONERROR(st, ##class(community.fhirAnalytics.deepsee.table.PatientTableAllergyIntoleranceUtils).CheckCountAllergyIntoleranceOnDelete(allergyIntoleranceId, id))
  } Catch(e) {
    Set status = e.AsStatus()
  }
  Return status
}

Trigger CheckCountPatientOnDeleteTrigger [ Event = DELETE ]
{
  If ( {CountPatient*O} = 1) {
    $$$THROWONERROR(st, ##class(community.fhirAnalytics.deepsee.table.PatientTablePatientUtils).CheckCountPatientOnDelete({PatientId}, {ID}))
  }
}

Trigger CheckCountAllergyIntoleranceOnDeleteTrigger [ Event = DELETE ]
{
  If ( {CountAllergyIntolerance*O} = 1) {
    $$$THROWONERROR(st, ##class(community.fhirAnalytics.deepsee.table.PatientTableAllergyIntoleranceUtils).CheckCountAllergyIntoleranceOnDelete({AllergyIntoleranceId}, {ID}))
  }
}

ClassMethod Load() As %Status
{
  New SQLCODE
  &sql(
    TRUNCATE TABLE community_fhirAnalytics_deepsee_table.PatientTable
  )
  Return:(SQLCODE '= 0) ##class(%SYSTEM.Error).FromSQLCode(SQLCODE).Status
  &sql(
    INSERT INTO community_fhirAnalytics_deepsee_table.PatientTable (
      PatientId, AllergyIntoleranceId
    )
    SELECT 
      patient.ID1 patient, allergy.ID1 allergy
    FROM HSFHIR_I0001_S.Patient patient
    LEFT JOIN HSFHIR_I0001_S.AllergyIntolerance allergy
      ON allergy.patient = patient.Key
  )
  Return:(SQLCODE '= 0) ##class(%SYSTEM.Error).FromSQLCode(SQLCODE).Status
  Return $$$OK
}

Storage Default
{
<Data name="PatientTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientId</Value>
</Value>
<Value name="3">
<Value>AllergyIntoleranceId</Value>
</Value>
<Value name="4">
<Value>CountPatient</Value>
</Value>
<Value name="5">
<Value>CountAllergyIntolerance</Value>
</Value>
</Data>
<DataLocation>^community.fhiAE69.PatientTableD</DataLocation>
<DefaultData>PatientTableDefaultData</DefaultData>
<IdLocation>^community.fhiAE69.PatientTableD</IdLocation>
<IndexLocation>^community.fhiAE69.PatientTableI</IndexLocation>
<StreamLocation>^community.fhiAE69.PatientTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
