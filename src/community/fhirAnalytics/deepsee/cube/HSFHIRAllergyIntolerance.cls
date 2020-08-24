/// 
Class community.fhirAnalytics.deepsee.cube.HSFHIRAllergyIntolerance Extends %DeepSee.CubeDefinition [ DependsOn = HSFHIR.I0001.S.AllergyIntolerance, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="HSFHIRAllergyIntolerance" displayName="HSFHIRAllergyIntolerance" disabled="false" abstract="false" sourceClass="HSFHIR.I0001.S.AllergyIntolerance" buildRestriction="0=1" namedFactNums="true" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
</cube>
}

ClassMethod %OnProcessFact(pID As %String, ByRef pFacts As %String, Output pSkip As %Boolean, pInsert As %Boolean) As %Status
{
  Set pSkip = 1
	Quit $$$OK
}

Parameter DOMAIN;

}
