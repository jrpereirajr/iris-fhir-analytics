Class community.fhirAnalytics.deepsee.kpi.ViewPatients2 Extends %ZEN.Component.page
{

XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="" enclosingStyle="padding: 20px;">
<html id="htmlRedirect" OnDrawContent="DrawRedirect" />
</page>
}

Method DrawRedirect(pSeed As %String) As %Status
{
  Set redirectURL = "http://localhost:32783/csp/user/fhirUI2/index.html"
  Write "<script language=""JavaScript"" type=""text/javascript"">location.href=`"_redirectURL_"?${window.location.search.substr(1)}`;</script>"
  Return $$$OK
}

}
