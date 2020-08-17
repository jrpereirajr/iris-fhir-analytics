/// 
Class community.fhirAnalytics.deepsee.cube.PatientCube Extends %DeepSee.CubeDefinition [ DependsOn = community.fhirAnalytics.deepsee.table.PatientCubeSource, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="Patient" displayName="Patient" disabled="false" abstract="false" sourceClass="community.fhirAnalytics.deepsee.table.PatientCubeSource" namedFactNums="true" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="PatientKeyD" displayName="PatientKeyD" disabled="false" hasAll="false" allCaption="All Key" allDisplayName="Key" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="PatientKey" displayName="PatientKey" disabled="false" sourceProperty="PatientId.Key" factName="DxPatientKey" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="2">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="PatientAllergyIntoleranceKeyD" displayName="PatientAllergyIntoleranceKeyD" disabled="false" hasAll="false" allCaption="All AllergyIntoleranceId" allDisplayName="AllergyIntoleranceId" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="AllergyIntoleranceKey" displayName="AllergyIntoleranceKey" disabled="false" sourceProperty="AllergyIntoleranceId.Key" factName="DxAllergyIntoleranceKey" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="3">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="PatientGenderD" displayName="Patient gender" disabled="false" hasAll="false" allCaption="All PatientGenderD" allDisplayName="PatientGenderD" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Gender" displayName="Gender" disabled="false" sourceExpression="##class(HSFHIR.I0001.S.Patient).KeyIdxOpen(%source.PatientId.Key).gender" factName="DxPatientGender" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="4">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="AllergyIntoleranceD" displayName="Allergy Intolerance" disabled="false" hasAll="false" allCaption="All AllergyIntoleranceD" allDisplayName="AllergyIntoleranceD" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="AllergyIntolerance" displayName="Allergy Intolerance" disabled="false" sourceExpression="$Case(%source.AllergyIntoleranceId, &quot;&quot;:&quot;&quot;, :##class(HSFHIR.I0001.R.Rsrc).%OpenId(##class(HSFHIR.I0001.S.AllergyIntolerance).%OpenId(%source.AllergyIntoleranceId.%ID).&quot;_id&quot;).ResourceObject.code.text)" factName="DxAllergyIntoleranceCode" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="5">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="PatientAgeD" displayName="Patient age" disabled="false" hasAll="false" allCaption="All PatientAgeD" allDisplayName="PatientAgeD" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="AgeRange" displayName="AgeRange" disabled="false" sourceExpression="%expression.PatientAge" factName="DxAgeRange" list="false" rangeExpression="[0,2):0 to 1;[2,12):2 to 11;[12,18):12 to 17;[18,30):18 to 29;[30,45):30 to 44;[45,65):45 to 64;(65,):65+;" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="6">
      </level>
      <level name="Age" displayName="Age" disabled="false" sourceExpression="%expression.PatientAge" factName="DxAge" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="7">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="PatientAddressD" displayName="Patient address" disabled="false" hasAll="false" allCaption="All addressCountry" allDisplayName="addressCountry" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="PatientCountryD" displayName="Patient Country" disabled="false" sourceProperty="addressCountry" factName="DxPatientCountry" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="8">
      </level>
      <level name="PatientStateD" displayName="Patient State" disabled="false" sourceProperty="addressState" factName="DxPatientState" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="9">
      </level>
      <level name="PatientCityD" displayName="Patient City" disabled="false" sourceProperty="addressCity" factName="DxPatientCity" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="10">
      </level>
    </hierarchy>
  </dimension>
  <expression name="PatientAge" disabled="false" sourceExpression="($H - $ZDH(##class(HSFHIR.I0001.S.Patient).KeyIdxOpen(%source.PatientId.Key).birthdate, 3)) \ 365">
  </expression>
  <calculatedMember name="PatientAllergyIntoleranceCount" displayName="Patient/Allergy Intolerance Count" disabled="false" dimension="Measures" valueExpression="%mdx(&quot;SELECT NON EMPTY COUNT([PatientAllergyIntoleranceKeyD].[H1].[AllergyIntoleranceKey].Members, EXCLUDEEMPTY) ON 0 FROM [PATIENT] %FILTER [PatientAllergyIntoleranceKeyD].[H1].[AllergyIntoleranceKey].&amp;[&lt;null&gt;].%NOT&quot;,&quot;%CONTEXT&quot;)" hidden="false">
  </calculatedMember>
  <calculatedMember name="PatientCount" displayName="Patient Count" disabled="false" dimension="Measures" valueExpression="%mdx(&quot;SELECT NON EMPTY COUNT([PatientKeyD].[H1].[PatientKey].Members, EXCLUDEEMPTY) ON 0 FROM [PATIENT] %FILTER [PatientKeyD].[H1].[PatientKey].&amp;[&lt;null&gt;].%NOT&quot;,&quot;%CONTEXT&quot;)" hidden="false">
  </calculatedMember>
</cube>
}

ClassMethod %OnBuildCube(pFactList As %List) As %Status
{
  Write "Loading data into source class PatientCubeSource... "
  $$$THROWONERROR(st, ##class(community.fhirAnalytics.deepsee.table.PatientCubeSource).Load())
  Write "OK!", !
	Quit $$$OK
}

Parameter DOMAIN;

}
