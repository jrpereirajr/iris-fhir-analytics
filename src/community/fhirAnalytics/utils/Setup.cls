Class community.fhirAnalytics.utils.Setup Extends %RegisteredObject
{

ClassMethod SetupDSTIME()
{
  $$$THROWONERROR(st, ##class(community.fhirAnalytics.utils.DSTIME).InjectDSTIME("HSFHIR.I0001.S.Patient"))
  $$$THROWONERROR(st, ##class(community.fhirAnalytics.utils.DSTIME).InjectDSTIME("HSFHIR.I0001.S.AllergyIntolerance"))
  $$$THROWONERROR(st, ##class(community.fhirAnalytics.utils.DSTIME).InjectDSTIME("community.fhirAnalytics.deepsee.table.PatientTable"))
  $$$THROWONERROR(st, $System.OBJ.Compile("community.fhirAnalytics.deepsee.cube.PatientCube", "ck"))
}

ClassMethod SetupCubeRegistry()
{
  Set tCGerenciador = "community.fhirAnalytics.deepsee.FHIRAnalyticsCubeManager"
  Set tMap = ##class(%DeepSee.CubeManager.Utils).BuildRegistryMap(.st, tCGerenciador, 1)
  $$$THROWONERROR(st, st)
	$$$THROWONERROR(st, ##class(%DeepSee.CubeManager.Utils).WriteToRegistry(tMap))
	$$$THROWONERROR(st, ##class(%DeepSee.CubeManager.Utils).ScheduleUpdaterTasks(tMap))
	$$$THROWONERROR(st, ##class(%DeepSee.CubeManager.Utils).SetActiveRegistry(tCGerenciador))
}

ClassMethod Run()
{
  Write !, "Inserting DSTIME parameter..."
  Do ..SetupDSTIME()
  Write !, "Ok!"

  Write !, "Registring cubes..."
  Do ..SetupCubeRegistry()
  Write !, "OK!"

  Write !, "Building cubes..."
  $$$THROWONERROR(st, ##class(%DeepSee.CubeManager.Utils).BuildAllRegisteredGroups())
  Write !, "OK!"

  Write !, "Installing DeepSeeWeb..."
  ZPM "install dsw 2.1.43"
  // I don't know why, but it's necessary call install twice in order to create /dsw csp app...
  ZPM "install dsw 2.1.43"
  Write !, "OK!"
}

}
