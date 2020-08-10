Class community.fhirAnalytics.utils.DSTIME Extends %RegisteredObject
{

ClassMethod InjectDSTIME(pClassName As %String) As %Status
{
  Set status = $$$OK
  Set paramName = "DSTIME"
  Set className = pClassName
  Set paramId = className_"||"_paramName

  // Set classDef = ##class(%Dictionary.ClassDefinition).%OpenId(className, , .status)
  Set classDef = ..GetClassDefById(className, .status)
  Return:($$$ISERR(status)) status

  Set status = ..DeletePreviousParameterIfExists(paramId)
  Return:($$$ISERR(status)) status

  Set status = ..CreateNewParameter(paramName, classDef)
  Return:($$$ISERR(status)) status

  Set status = ..CompileClass(className)
  Return:($$$ISERR(status)) status
  
  Return status
}

ClassMethod GetClassDefById(pClassName As %String, ByRef pStatus As %Status) As %ObjectHandle [ Private ]
{
  Return ##class(%Dictionary.ClassDefinition).%OpenId(pClassName, , .pStatus)
}

ClassMethod DeletePreviousParameterIfExists(pParameterId As %String) As %Status [ Private ]
{
  If (##class(%Dictionary.ParameterDefinition).%ExistsId(pParameterId)) {
    Return ##class(%Dictionary.ParameterDefinition).%DeleteId(pParameterId)
  }
  Return $$$OK
}

ClassMethod CreateNewParameter(pParameterName As %String, pClassDef As %Dictionary.ClassDefinition) As %Status [ Private ]
{
  Set oParam = ##Class(%Dictionary.ParameterDefinition).%New()    
  Set oParam.Name = pParameterName
  Set oParam.parent = pClassDef
  Set oParam.Type = "STRING"
  Set oParam.Default = "AUTO"
  Return oParam.%Save()
}

ClassMethod CompileClass(pClassName As %String) As %Status [ Private ]
{
  Return $System.OBJ.Compile(pClassName, "ck")
}

}
