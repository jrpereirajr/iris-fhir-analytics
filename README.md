# iris4health-fhir-analytics

A set of IRIS Analytics resources built on IRIS for Health FHIR server.

## What's ready?

* A sample FHIR server setup on a IRIS for Health instance.
* A POC for:
  * A simple cube, pivot table and dashboard for patientsusing IRIS Analytics (formerly known as DeepSee);
  * Create a cube manager.
  * [DeepSeeWeb](https://openexchange.intersystems.com/package/DeepSeeWeb) support

## What's coming soon?

* More dashboards

## Installing

Clone this repository

```
https://github.com/jrpereirajr/iris-fhir-analytics.git
```

Build and up the docker container:

```
cd .\iris-fhir-analytics\
docker-compose build
docker-compose up -d
```

## Exploring

After ran population method, some data will be uploaded to FHIR database:

<img src="https://raw.githubusercontent.com/jrpereirajr/iris4health-fhir-analytics/master/img/Screenshot_36.png"></img>

A simple IRIS Analytics patient dashboard will also be availble in this URL:

*Credentials*:
 * Username: _SYSTEM
 * Password: SYS

```
http://localhost:32783/csp/healthshare/fhirserver/_DeepSee.UserPortal.DashboardViewer.zen?DASHBOARD=User/Patient.dashboard
```
<img src="https://raw.githubusercontent.com/jrpereirajr/iris4health-fhir-analytics/master/img/ZFq9Wnsdh4.gif"></img>

This same dashboard can be viewed using [DeepSeeWeb](https://openexchange.intersystems.com/package/DeepSeeWeb):

```
http://localhost:32783/dsw/index.html#!/d/User/Patient.dashboard?ns=FHIRSERVER
```
<img src="https://raw.githubusercontent.com/jrpereirajr/iris4health-fhir-analytics/master/img/lj4mZjlnp5.gif"></img>