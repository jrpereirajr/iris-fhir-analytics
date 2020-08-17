Class community.fhirAnalytics.deepsee.table.PatientTable Extends %Persistent
{

Index idxPatientId On PatientId;

Index idxAllergyIntoleranceId On AllergyIntoleranceId;

Index idxObservationId On ObservationId;

Index idxCountPatient On CountPatient;

Index idxCountAllergyIntolerance On CountAllergyIntolerance;

Index idxCountObservation On CountObservation;

Property PatientId As HSFHIR.I0001.S.Patient [ Required ];

Property AllergyIntoleranceId As HSFHIR.I0001.S.AllergyIntolerance;

Property ObservationId As HSFHIR.I0001.S.Observation;

Property AllergyIntoleranceResourceId As HSFHIR.I0001.R.Rsrc;

Property ObservationResourceId As HSFHIR.I0001.R.Rsrc;

Property CountPatient As %Boolean [ SqlComputeCode = {Set {*} = ##class(community.fhirAnalytics.deepsee.table.PatientTablePatientUtils).IsCountPatientOnInsertUpdate({PatientId})}, SqlComputed ];

Property CountAllergyIntolerance As %Boolean [ SqlComputeCode = {Set {*} = ##class(community.fhirAnalytics.deepsee.table.PatientTableAllergyIntoleranceUtils).IsCountAllergyIntoleranceOnInsertUpdate({AllergyIntoleranceId})}, SqlComputed ];

Property CountObservation As %Boolean [ SqlComputeCode = {Set {*} = ##class(community.fhirAnalytics.deepsee.table.PatientTableObservationUtils).IsCountObservationOnInsertUpdate({ObservationId})}, SqlComputed ];

ForeignKey fkPatient(PatientId) References HSFHIR.I0001.S.Patient() [ OnDelete = cascade ];

ForeignKey fkAllergyIntolerance(AllergyIntoleranceId) References HSFHIR.I0001.S.AllergyIntolerance() [ OnDelete = cascade ];

ForeignKey fkObservation(ObservationId) References HSFHIR.I0001.S.Observation() [ OnDelete = cascade ];

ForeignKey fkAllergyIntoleranceResource(AllergyIntoleranceResourceId) References HSFHIR.I0001.R.Rsrc() [ OnDelete = cascade ];

ForeignKey fkObservationResource(ObservationResourceId) References HSFHIR.I0001.R.Rsrc() [ OnDelete = cascade ];

ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Private, ServerOnly = 1 ]
{
  Set status = $$$OK
  Try {
    Set id = $LG(oid, 1)

    // ------------------------
    // todo: use some design pattern to automate this code smell (code duplication)...

    Set patientId = ..PatientIdGetStored(id)
    $$$THROWONERROR(st, ##class(community.fhirAnalytics.deepsee.table.PatientTablePatientUtils).CheckCountPatientOnDelete(patientId, id))
    
    Set allergyIntoleranceId = ..AllergyIntoleranceIdGetStored(id)
    $$$THROWONERROR(st, ##class(community.fhirAnalytics.deepsee.table.PatientTableAllergyIntoleranceUtils).CheckCountAllergyIntoleranceOnDelete(allergyIntoleranceId, id))
    
    Set observationId = ..ObservationIdGetStored(id)
    $$$THROWONERROR(st, ##class(community.fhirAnalytics.deepsee.table.PatientTableObservationUtils).CheckCountObservationOnDelete(observationId, id))

    // ------------------------
  } Catch(e) {
    Set status = e.AsStatus()
  }
  Return status
}

Trigger CheckCountPatientOnDeleteTrigger [ Event = DELETE ]
{
  // todo: merge all CheckCount***OnDeleteTrigger
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

Trigger CheckCountObservationOnDeleteTrigger [ Event = DELETE ]
{
  If ( {CountObservation*O} = 1) {
    $$$THROWONERROR(st, ##class(community.fhirAnalytics.deepsee.table.PatientTableObservationUtils).CheckCountObservationOnDelete({ObservationId}, {ID}))
  }
}

ClassMethod Load() As %Status
{
  // todo: adapt this method to synch...

  New SQLCODE
  &sql(
    TRUNCATE TABLE community_fhirAnalytics_deepsee_table.PatientTable
  )
  Return:(SQLCODE '= 0) ##class(%SYSTEM.Error).FromSQLCode(SQLCODE).Status
  &sql(
    INSERT INTO community_fhirAnalytics_deepsee_table.PatientTable (
      PatientId,
      AllergyIntoleranceId,
      ObservationId,
      AllergyIntoleranceResourceId,
      ObservationResourceId
    )
    SELECT 
      patient.ID1 patient,
      allergy.ID1 allergy,
      obs.ID1 observation,
      (SELECT res_allergy.ID FROM HSFHIR_I0001_R.Rsrc res_allergy WHERE res_allergy.ResourceId = allergy._id) allergyResId,
      (SELECT res_obs.ID FROM HSFHIR_I0001_R.Rsrc res_obs WHERE res_obs.ResourceId = obs._id) obsResId
    FROM HSFHIR_I0001_S.Patient patient
    LEFT JOIN HSFHIR_I0001_S.AllergyIntolerance allergy
      ON allergy.patient = patient.Key
    LEFT JOIN HSFHIR_I0001_S.Observation obs
      ON obs.patient = patient.Key
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
<Value>ObservationId</Value>
</Value>
<Value name="5">
<Value>CountPatient</Value>
</Value>
<Value name="6">
<Value>CountAllergyIntolerance</Value>
</Value>
<Value name="7">
<Value>CountObservation</Value>
</Value>
<Value name="8">
<Value>ResourceId</Value>
</Value>
<Value name="9">
<Value>AllergyIntoleranceResourceId</Value>
</Value>
<Value name="10">
<Value>ObservationResourceId</Value>
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
