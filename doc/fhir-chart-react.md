# Using FHIR model to create charts with any configuration

The [fhir-react](https://github.com/1uphealth/fhir-react#readme) project defines a unique component which renders the interface based on FHIR resource type. There's no need for any configuration because the library uses the standard of defined by the resource type.

So, I decided to apply the same idea, but for charts. The basic idea is depicted below:

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/diagram1.png"></img>

For instance, some FHIR resources like Observation, Condition etc., has a code. Thus, we can aggregate all codes and count them. 

Such aggregation creates a standard data model.

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/Screenshot_1.png.png"></img>

Finally, this model could be adapted for any char library.

In order to demonstrate this idea, I implemented it for FHIR resources with *code* property and HighCharts as chart library:

```javascript
<FhirResourceChart fhirResources={resources}/>
```

Where *fhirResources* is an array of FHIR resource like Observation for instance. No more configuration is needed.

The result is shown below:

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/LxWO1IR5KK.gif"></img>