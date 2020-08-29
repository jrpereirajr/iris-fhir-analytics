# iris4health-fhir-analytics

An example on how to use IRIS for Health FHIR SQL schema to build analytics features.

## What you'll find in this technology example?

* **FHIR Server REST API usage** for get details about patient from analytics context using UI framework specific for FHIR data (connect your data directly to the interface)
* **FHIR SQL Schema usage** for create a simple cube, pivot tables and dashboard for patients using IRIS Analytics (formerly known as DeepSee)
  * [DeepSeeWeb](https://openexchange.intersystems.com/package/DeepSeeWeb) support
  * An example for setup a dashboard in Microsoft Power BI
  * Using complexy queries to find inconsistencies in data, [check it out](https://github.com/jrpereirajr/iris-fhir-analytics/tree/master/doc/fhir-inconsistencies.md)
* **Healthcare standards transformations** - use an IRIS Interoperability production to import messages in ADT/HL7 format and convert them to FHIR messages (thanks for [grongierisc](https://github.com/grongierisc/FHIR-HL7v2-SQL-Demo))
* **Docker container usage** configuration for easy deploy

## Installing

Clone this repository

```
https://github.com/jrpereirajr/iris-fhir-analytics.git
```

Build up the docker container:

```
cd .\iris-fhir-analytics\
docker-compose up -d
```

*Credentials*:
 * Username: _SYSTEM
 * Password: SYS

## Exploring it

After installation, some data will be uploaded to IRIS for Health. Wait for IRIS initialization and then you can explorer data using analytics tools and nice UI frameworks specific for detail FHIR data, like [fhir-ui](https://github.com/healthintellect/fhir-ui) for instance:

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/FVIjalYu9r.gif"></img>

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/xl4IBx5532.gif"></img>

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/fIXdOhasCS.gif"></img>

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/qZpmWkm2qG.gif"></img>

More information on how to use FHIR REST API with DeepSee and Power BI [here](https://github.com/jrpereirajr/iris-fhir-analytics/tree/master/doc/fhir-rest-api.md).

A IRIS Analytics patient dashboard will also be available in this URL:

```
http://localhost:32783/csp/healthshare/fhirserver/_DeepSee.UserPortal.DashboardViewer.zen?DASHBOARD=User/Patient.dashboard
```

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/Lt94eO0NZa.gif"></img>

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/d2kAcL27Uo.gif"></img>

This same dashboard can be viewed using [DeepSeeWeb](https://openexchange.intersystems.com/package/DeepSeeWeb):

```
http://localhost:32783/dsw/index.html#!/d/User/Patient.dashboard?ns=FHIRSERVER
```

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/lN0F0MSNJr.gif"></img>

You can also use cube created for FHIR data to feed up a Microsoft Power BI dashboard (instructions [here](https://github.com/jrpereirajr/iris-fhir-analytics/tree/master/doc/power-bi-creating-patient-dashboard.md)).

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/xUxNmpMvvQ.gif"></img>

Analytics capabilities are possibile thanks to IRIS FHIR SQL schema:

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/Screenshot_36.png"></img>

More information on FHIR SQL schema can be found [here](https://github.com/jrpereirajr/iris-fhir-analytics/tree/master/doc/fhir-sql-schema.md).

In order to healthcare standards transformations, a IRIS Interoperability production was setup. Such functionalaty is very useful for ETL tasks. To see it in action, put some ADT messages files in data directory, like shown below:

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/speoEKCUPO.gif"></img>