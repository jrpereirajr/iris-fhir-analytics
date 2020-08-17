# iris4health-fhir-analytics

A set of IRIS Analytics resources built on IRIS for Health FHIR server.

## What's ready?

* A sample FHIR server setup on a IRIS for Health instance.
* A POC for:
  * A simple cube, pivot table and dashboard for patients using IRIS Analytics (formerly known as DeepSee);
  * Create a cube manager.
  * [DeepSeeWeb](https://openexchange.intersystems.com/package/DeepSeeWeb) support
  * An example for setup a dashboard in Microsoft Power BI

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

A simple IRIS Analytics patient dashboard will also be available in this URL:

*Credentials*:
 * Username: _SYSTEM
 * Password: SYS

```
http://localhost:32783/csp/healthshare/fhirserver/_DeepSee.UserPortal.DashboardViewer.zen?DASHBOARD=User/Patient.dashboard
```
<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/Lt94eO0NZa.gif"></img>

This same dashboard can be viewed using [DeepSeeWeb](https://openexchange.intersystems.com/package/DeepSeeWeb):

```
http://localhost:32783/dsw/index.html#!/d/User/Patient.dashboard?ns=FHIRSERVER
```
<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/lN0F0MSNJr.gif"></img>

You can also use cube create for FHIR data to feed up a Microsoft Power BI dashboard (instructions [here](power-bi-creating-patient-dashboard.md).

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/xUxNmpMvvQ.gif"></img>