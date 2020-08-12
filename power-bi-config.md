# Steps for connection IRIS as a Power BI data source

## Install Power BI Desktop

This example used Microsoft Power BI Desktop. You can get a trial version [here](https://powerbi.microsoft.com/en-us/get-started/).

## Check your ODBC driver

Power BI needs OBDC in order to connect to IRIS, so you must check if you have ODBC drivers for IRIS. You can download the installer [here](ftp://ftp.intersystems.com/pub/iris/odbc/2019/). In my test, I used version ODBC-2019.2.0.107.0-win_x64.exe.
Note if you have a previous Cache ODBC driver already installed, you also must install new version for IRIS.

## Setup a connection to IRIS on Power BI

After installed ODBC driver, open Power BI, click in "Get Data", fill up the required fields and you should see FHIR cubes available for use.

Credentials are:

* User: _SYSTEM
* Password: SYS

Theses steps are shown below:
<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/esNeBGOCPp.gif"></img>

If you're having difficulty with Portuguese labels, you can find instructions in English [here](https://youtu.be/MmrePiLBDac?t=1858).