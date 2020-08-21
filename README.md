# iris4health-fhir-analytics

An example on how to use IRIS for Health FHIR SQL schema to build analytics features.

## What's ready?

* **FHIR Server REST API usage** for create a simple cube, pivot tables and dashboard for patients using IRIS Analytics (formerly known as DeepSee)
  * [DeepSeeWeb](https://openexchange.intersystems.com/package/DeepSeeWeb) support
  * An example for setup a dashboard in Microsoft Power BI
* **FHIR Server REST API usage** for get details about patient from analytics context
* **Docker container usage** for easy deploy

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

## Exploring it

After installation, some data will be uploaded to IRIS for Health. Wait for IRIS initialization and then you can check out such data via FHIR SQL schema database:

<img src="https://raw.githubusercontent.com/jrpereirajr/iris4health-fhir-analytics/master/img/Screenshot_36.png"></img>

More information on FHIR SQL schema can be found [here](doc/fhir-sql-schema.md).

A simple IRIS Analytics patient dashboard will also be available in this URL:

*Credentials*:
 * Username: _SYSTEM
 * Password: SYS

```
http://localhost:32783/csp/healthshare/fhirserver/_DeepSee.UserPortal.DashboardViewer.zen?DASHBOARD=User/Patient.dashboard
```

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/power-bi-01/img/Lt94eO0NZa.gif"></img>

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/power-bi-01/img/d2kAcL27Uo.gif"></img>

This same dashboard can be viewed using [DeepSeeWeb](https://openexchange.intersystems.com/package/DeepSeeWeb):

```
http://localhost:32783/dsw/index.html#!/d/User/Patient.dashboard?ns=FHIRSERVER
```

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/power-bi-01/img/lN0F0MSNJr.gif"></img>

You can also use cube create for FHIR data to feed up a Microsoft Power BI dashboard (instructions [here](doc/power-bi-creating-patient-dashboard.md)).

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/power-bi-01/img/xUxNmpMvvQ.gif"></img>

FHIR REST API support is used to view patients details in drill througth operations:

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/power-bi-01/img/5y80LWQD7H.gif"></img>

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/power-bi-01/img/hm33IIGQWl.gif"></img>

More information on how to use FHIR REST API with DeepSee and Power BI [here](doc/fhir-rest-api.md).