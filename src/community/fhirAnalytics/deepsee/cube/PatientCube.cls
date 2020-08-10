/// 
Class community.fhirAnalytics.deepsee.cube.PatientCube Extends %DeepSee.CubeDefinition [ DependsOn = (community.fhirAnalytics.deepsee.table.PatientTable, HSFHIR.I0001.S.Patient, HSFHIR.I0001.S.AllergyIntolerance), ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="Patient" displayName="Patient" disabled="false" abstract="false" sourceClass="community.fhirAnalytics.deepsee.table.PatientTable" namedFactNums="true" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="Address" disabled="false" hasAll="false" allCaption="All Address" allDisplayName="Address" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="addressCountry" disabled="false" sourceProperty="PatientId.addressCountry" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="2">
      </level>
      <level name="addressState" disabled="false" sourceProperty="PatientId.addressState" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="3">
      </level>
      <level name="addressCity" disabled="false" sourceProperty="PatientId.addressCity" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="4">
      </level>
    </hierarchy>
  </dimension>
  <measure name="PatientCount" displayName="Patients count" disabled="false" sourceProperty="CountPatient" factName="MxPatientCount" aggregate="SUM" type="integer" hidden="false" searchable="true" factNumber="1">
  </measure>
  <measure name="AllergyIntoleranceCount" displayName="Allergies count" disabled="false" sourceProperty="CountAllergyIntolerance" factName="MxAllergyIntoleranceCount" aggregate="SUM" type="integer" hidden="false" searchable="true" factNumber="2">
  </measure>
</cube>
}

Parameter DOMAIN;

ClassMethod %OnBuildCube(pFactList As %List) As %Status
{
  Write "Loading data into source class PatientTable... "
  $$$THROWONERROR(st, ##class(community.fhirAnalytics.deepsee.table.PatientTable).Load())
  Write "OK!", !
	Quit $$$OK
}

}
