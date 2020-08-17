# A quick tutorial on creating a dashboard in Microsoft Power BI to visualize IRIS FHIR data

There are some tutorials on DC about how to use IRIS as data provider for Power BI. Even though, I decide to did a quick tutorial, specific on how to use cubes created on FHIR schema data as data source for Power BI dashboards.

This example uses Microsoft Power BI Desktop. You can get a trial version [here](https://powerbi.microsoft.com/en-us/get-started/).

If you need more information on setting up connection between IRIS and Power BI (as Cache as well), please, search for ["Power BI" in DC](https://community.intersystems.com/search?search=Power+bi&type%5B%5D=articles&interval=all_time&sort=rel).

So, let's started.

*Note: this document was created on a previous cube version and the dimensions shown below aren't available anymore. However, you can follow the same steps and easily adapt them to the new structure.*

## 1) Create a connection to IRIS or open a previous one in Power BI

In this case, I've used a previous connection to IRIS. If you need help in order to create a new one, please refer to this [document](power-bi-config.md).

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/vlc_mAmrs4UJlj.png"></img>

## 2) Select fact and dimensions tables as source for the dashboard

The IRIS connector for Power BI retrieves the star schema for cubes within the namespace defined in connection parameters. So, you can select the fact table and its dimensions as source for your dashboard.

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/vlc_1VhPiBsYpR.png"></img>

## 3) Import or create a link to data

You can import data or create a link to it in IRIS server. In this case, I chose the direct link option instead of import data.

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/vlc_UEZuJjhAEc.png"></img>

## 4) Check tables relationship

For some reason, some relations between star schema tables should not be recognized by Power BI. Without such relations, features like drill down could not work properly.

So, after connecting to IRIS, check if all expected relations were recognized by Power BI.

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/vlc_lXZfdwdb5k.png"></img>

If something was missed, you can define relations manually, like shown below.

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/8bxuLiWpZK.gif"></img>

## 5) Setup the dashboard

After creating and configure the connection to IRIS, it's time to setup a simple dashboard.

First, select a chart - I've selected clustered bar chart. Then, you need to define data for axis and values - the vertical and horizontal axes respectively in this type of chart.

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/vlc_ilwK5ns7b5_labeled.png"></img>

Note that measures defined in fact table was automatically recognized. A measure is pictured in Power BI by a summation symbol (Σ) beside fact table's fields.

If relations between tables was corrected imported and setup, Power BI can automatically infer drill down logic, as shown below.

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/JOauZ4scuB.gif"></img>