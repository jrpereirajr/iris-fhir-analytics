# IRIS for Health SQL schema

In order to install a FHIR server, you must install a foundation, a namespace and an instance. The code snippet below shows these steps:

``` objectscript
zn "HSLIB"
set namespace="FHIRSERVER"
Set appKey = "/fhir/r4"
Set strategyClass = "HS.FHIRServer.Storage.Json.InteractionsStrategy"
Set metadataConfigKey = "HL7v40"
set importdir="/opt/irisapp/src"

//Install a Foundation namespace and change to it
Do ##class(HS.HC.Util.Installer).InstallFoundation(namespace)
zn namespace

// Install elements that are required for a FHIR-enabled namespace
Do ##class(HS.FHIRServer.Installer).InstallNamespace()

// Install an instance of a FHIR Service into the current namespace
Do ##class(HS.FHIRServer.Installer).InstallInstance(appKey, strategyClass, metadataConfigKey,"",0)
```

After that, two SQL schemas will be created in namespace where production were installed, in order to store FHIR data. In case of this project, these schemas are called HSFHIR_I0001_R and HSFHIR_I0001_S, but their names may change depending on installation configuration.

The 'S' schema stores FHIR entities and their relationship.

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/power-bi-01/img/chrome_wFvK7ooyoF.png"></img>

The 'R' schema stores details for resource referenced by entities.

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/power-bi-01/img/chrome_sXFZJDAUj3.png"></img>

So, in order to retrieve information about some FHIR entity, you can:

* Access the HSFHIR_I0001_R.Rsrc table directly and reference a FHIR entity:

``` sql
/* Get details of the observation/16 */
SELECT 
ID, Key, ResourceString
FROM HSFHIR_I0001_R.Rsrc where Key = 'Observation/16'
```
<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/power-bi-01/img/chrome_GeKFyKxgsA.png"></img>

* Or, perform a join between an entity table in 'S' schema and HSFHIR_I0001_R.Rsrc table. Each FHIR entity table has a '_id' field, which is a reference to ResourceId field in entity's details table HSFHIR_I0001_R.Rsrc, in 'R' schema:

``` sql
/* Get details of the first observation stored in FHIR */
SELECT top 1 r.ResourceString, s.*
FROM HSFHIR_I0001_S.Observation s 
JOIN HSFHIR_I0001_R.Rsrc r ON r.ResourceId = s._id
```
<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/power-bi-01/img/chrome_dX58BZ1nK4.png"></img>

As you can see, IRIS stores FHIR entities details in JSON format. You can use GetJSON() and GetProp() functions to handle with JSON in SQL:

``` sql
/* Use GetJSON() function to retrieve only the valueQuantity object of whole JSON object for observation/16 */
SELECT 
ID, Key, 
GetJSON(ResourceString,'valueQuantity') as valueQuantity
FROM HSFHIR_I0001_R.Rsrc where Key = 'Observation/16'
```
<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/power-bi-01/img/chrome_Yppv96mVwC.png"></img>

``` sql
/* Use GetProp() function to retrieve only the value property for valueQuantity object for observation/16 */
SELECT 
ID, Key, 
GetProp(GetJSON(ResourceString,'valueQuantity'),'value') as value
FROM HSFHIR_I0001_R.Rsrc where Key = 'Observation/16'
```
<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/power-bi-01/img/chrome_1DvEDXHXAj.png"></img>

Another useful SQL examples can be found [here](../misc/sql/example.sql).