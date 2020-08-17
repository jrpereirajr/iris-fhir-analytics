Class community.fhirAnalytics.deepsee.table.PatientCubeSource Extends %Persistent
{

Property PatientId As HSFHIR.I0001.S.Patient;

Property AllergyIntoleranceId As HSFHIR.I0001.S.AllergyIntolerance;

Property addressCountry As %String;

Property addressState As %String;

Property addressCity As %String;

Index idxPatientId On PatientId;

Index idxAllergyIntolerance On AllergyIntoleranceId;

ForeignKey fkPatient(PatientId) References HSFHIR.I0001.S.Patient() [ OnDelete = cascade ];

ForeignKey fkAllergyIntoleranceId(AllergyIntoleranceId) References HSFHIR.I0001.S.AllergyIntolerance() [ OnDelete = cascade ];

ClassMethod Load() As %Status
{
  // Limitation: get just the first patient address

  New SQLCODE
  &sql(
    TRUNCATE TABLE community_fhirAnalytics_deepsee_table.PatientCubeSource
  )
  Return:(SQLCODE '= 0) ##class(%SYSTEM.Error).FromSQLCode(SQLCODE).Status
  &sql(
    INSERT INTO community_fhirAnalytics_deepsee_table.PatientCubeSource (
      PatientId,
      AllergyIntoleranceId,
      addressCountry,
      addressState,
      addressCity
    )
    SELECT
      patient.ID1 patient,
      allergy.ID1 allergy,
      $Listget(patient.addressCountry, 1),
      $Listget(patient.addressState, 1),
      $Listget(patient.addressCity, 1)
    FROM HSFHIR_I0001_S.Patient patient
    LEFT JOIN HSFHIR_I0001_S.AllergyIntolerance allergy
      ON allergy.patient = patient.Key
  )
  Return:(SQLCODE '= 0) ##class(%SYSTEM.Error).FromSQLCode(SQLCODE).Status
  Return $$$OK
}

Storage Default
{
<Data name="PatientCubeSourceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AllergyIntoleranceId</Value>
</Value>
<Value name="3">
<Value>addressCountry</Value>
</Value>
<Value name="4">
<Value>addressState</Value>
</Value>
<Value name="5">
<Value>addressCity</Value>
</Value>
<Value name="6">
<Value>PatientId</Value>
</Value>
</Data>
<DataLocation>^communityAE69.PatientCubeFC03D</DataLocation>
<DefaultData>PatientCubeSourceDefaultData</DefaultData>
<IdLocation>^communityAE69.PatientCubeFC03D</IdLocation>
<IndexLocation>^communityAE69.PatientCubeFC03I</IndexLocation>
<StreamLocation>^communityAE69.PatientCubeFC03S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
