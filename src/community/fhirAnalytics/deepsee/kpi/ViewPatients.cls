Class community.fhirAnalytics.deepsee.kpi.ViewPatients Extends %ZEN.Component.page
{

XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="Forwarding to original NTSB report..." enclosingStyle="padding: 20px;">
<html id="htmlRedirect" OnDrawContent="DrawRedirect" />
</page>
}

Method DrawRedirect(pSeed As %String) As %Status
{
  Set redirectURL = "http://localhost:32783/csp/user/fhirUI/index.html"
  Write "<script language=""JavaScript"" type=""text/javascript"">location.href=`"_redirectURL_"?${window.location.search.substr(1)}`;</script>"
  Return $$$OK
	/*
	set tSC = $$$OK
	try {
		set tID = $g(%request.Data("ID",1))
		if (tID="") {
			write "<p>No event ID specified</p>"
			quit
		} elseif $f(tID,",") {
			set tID = $p(tID,",",1)
			write "<p>Multiple tIDs specified, only the first one will be used (""",tID,""")"
		}
		
		set tEvent = ##class(Aviation.Event).PKINDEXOpen(tID)
		if (tEvent="") {
			write "<p>Unknown event ID: ",tID," </p>"
			quit
		}
		
		set tURL = "http://dms.ntsb.gov/aviation/GenPDF.aspx?id="_tEvent.NTSBId_"&rpt=fa"
		
		&html<<p>Redirecting to NTSB.gov...</p><p>&nbsp;Please note some the NTSB report server might not always be available.</p>>
		write "<script language=""JavaScript"" type=""text/javascript"">location.href='"_tURL_"';</script>"
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
	*/
}

}
