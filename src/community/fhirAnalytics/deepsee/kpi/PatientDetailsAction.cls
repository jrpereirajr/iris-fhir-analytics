/// Adds an action for <class>Aviation.EventCube</class> to display the full NTSB report for an
/// Aviation Event fact record.
Class community.fhirAnalytics.deepsee.kpi.PatientDetailsAction Extends %DeepSee.KPI
{

/// This XData definition defines the KPI.
XData KPI [ XMLNamespace = "http://www.intersystems.com/deepsee/kpi" ]
{
<kpi xmlns="http://www.intersystems.com/deepsee/kpi" name="Patient Actions">
<action name="GoToReport" displayName="Open patient report" />
<property name="PatCount" displayName="PatCount" />
</kpi>
}

ClassMethod GetPatientsResourceIdList(pContext As %ZEN.proxyObject) As %List
{
  Set mdx = "drillthrough SELECT FROM "_$Piece(pContext.%data("mdx"),"FROM ", 2)_" "_pContext.%data("currFilterSpec")
  Set rs = ##class(%DeepSee.ResultSet).%New()
  $$$THROWONERROR(st, rs.%PrepareMDX(mdx))
  $$$THROWONERROR(st, rs.%Execute())

  Set list = ""
	$$$THROWONERROR(st, rs.%GetListingResultSet(.sqlRs))
	Set columns = ..GetMetaColumns(sqlRs)
	Set colCount = columns.Count()
	While((sqlRs.%Next()) && (sqlRs.%ROWCOUNT <= 100)){
		For iCol = 1:1:colCount {
			Set colName = columns.GetAt(iCol)
      Set value = $Property(sqlRs, colName)
			Set:('$LF(list, value)) $List(list, * + 1) = value
		}
	}
  Return list
}

ClassMethod GetMetaColumns(pRS As %SQL.StatementResult)
{
	Set md = pRS.%GetMetadata()
	Set colCount = md.columnCount
	Set columns = ##class(%ListOfDataTypes).%New()
	For iCol = 1:1:colCount {
		#Dim colInfo As %SQL.StatementColumn = md.columns.GetAt(iCol)
		Do columns.Insert(colInfo.colName)
	}
	Return columns
}

ClassMethod %OnDashboardAction(pAction As %String, pContext As %ZEN.proxyObject) As %Status
{
  If (pAction="GoToReport") {
    Set pContext.command = "popup:community.fhirAnalytics.deepsee.kpi.ViewPatients.cls?PatientList="_$LTS(
      ..GetPatientsResourceIdList(pContext), ","
    )
  }

  Quit $$$OK
}

}
