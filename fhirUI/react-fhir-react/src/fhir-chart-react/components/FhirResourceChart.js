import React, {Component} from 'react';
import ReactDOM from "react-dom";
import Highcharts from 'highcharts'
import HighchartsReact from 'highcharts-react-official'

export class FhirResourceChart extends React.Component {
	
  constructor(props) {
    super(props);
    this.state = {
			resourcesChartData: null,
			error: null
		};
  }
	
	componentWillMount() {
		this.getChartData();
	}
	
	/*
	componentWillUnmount() {
		console.log('componentWillUnmount');
	}
	*/
	
	groupBy(array, keyGetter, labelGetter) {
		const data = array
			.reduce((acc, curr) => {
				const key = keyGetter(curr);
				const label = labelGetter(curr);
				if (!acc.hasOwnProperty(key)){
					acc[key] = {"key": key, "label": label, "count": 0}
				}
				acc[key].count++;
				return acc;
			}, {});
		return Object.keys(data).map(k => data[k]);
	}
	
	validateSource(source, sourceProperty) {
		let isValid = true;
		if (!source.length) {
			return false;
		}
		if(!source[0].hasOwnProperty(sourceProperty)) {
			this.setState({error: `There isn't chart available for ${source[0].resourceType} resource.`});
			return false;
		}
		return isValid
	}
	
	getChartData() {
		let resourcesChartData = this.state.resourcesChartData;
		if (!resourcesChartData) {
			const sortByValue = (a, b) => b.count - a.count;
			const sortByLabel = (a, b) => a.label < b.label ? -1 : a.label === b.label ? 0 : 1;
			const sourceData = this.props.fhirResources;
			const sourceProperty = 'code';
			if (this.validateSource(sourceData, sourceProperty)) {
				const chartData = this.groupBy(
					sourceData,
					(o) => o.code.coding[0].code,
					(o) => o.code.coding[0].display,
				).sort(sortByLabel).sort(sortByValue);
				resourcesChartData = {
						chart: {
								//type: 'bar'
								type: 'column'
						},
						title: {
								text: `Patient's ${sourceData[0].resourceType} history`
						},
						xAxis: {
								categories: chartData.map(i => i.label)
						},
						yAxis: {
								min: 0,
								/*title: {
										text: 'Total fruit consumption'
								}*/
						},
						legend: {
								reversed: false
						},
						plotOptions: {
								/*series: {
										stacking: 'normal'
								}*/
						},
						series: [{
								name: 'Count',
								data: chartData.map(i => i.count)
						}]
				}
				this.setState({resourcesChartData: resourcesChartData});
			}
		}
	}
	
  render() {
		return (
			<React.Fragment>
			{this.state.error 
				? <div>{this.state.error}</div>
				: <HighchartsReact
						highcharts={Highcharts}
						options={this.state.resourcesChartData}
					/>
			}
			</React.Fragment>
		);
	}
	
};

export default FhirResourceChart;