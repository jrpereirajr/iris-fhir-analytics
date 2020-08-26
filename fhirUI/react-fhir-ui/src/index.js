import React from 'react'
import ReactDOM from 'react-dom'
import { createMuiTheme, ThemeProvider } from '@material-ui/core/styles'
import { MuiPickersUtilsProvider } from '@material-ui/pickers'
import lightBlue from '@material-ui/core/colors/lightBlue'
import MomentUtils from '@date-io/moment'

import { PatientCard, MyPatientTable } from 'fhir-ui'

var qs = window.location.search.substr(1)
	.split('&')
	.map(p => p.split('='))
	.reduce((acc, curr) => { acc[curr[0]] = curr[1]; return acc; }, {});

// Create a theme instance.
const theme = createMuiTheme({
  palette: {
    primary: {
      light: lightBlue[300],
      main: lightBlue[500],
      dark: lightBlue[900],
      contrastText: '#FFF',
    },
    secondary: {
      light: lightBlue[300],
      main: lightBlue[500],
      dark: lightBlue[900],
      contrastText: '#FFF',
    },
    background: {
      default: '#f9f9f9',
    },
  },
})

const App = () => {
	return(
	  <ThemeProvider theme={theme}>
		<MuiPickersUtilsProvider utils={MomentUtils}>
		  <MyPatientTable
				patients={patients}
				tableTitle="Patient List"
				tableRowSize="small"
				defaultRowsPerPage={5}
				onGetDetailsData={getPatientDetails}
		  />
		</MuiPickersUtilsProvider>
	  </ThemeProvider>
)}

const getPatientDetails = (patientInfo, resourceType) => {
	console.log(patientInfo, resourceType)
	if (!patientInfo || !patientInfo.id) return Promise.resolve();
	const base = 'http://localhost:32783/fhir/r4';
	let url = '';
	let formatter = (obj) => (obj.entry || []).map(e => e.resource);
	switch(resourceType) {
		case 'Bundle':
			url = `${base}/Patient?_id=${patientInfo.id}`;
			formatter = (obj) => obj;
			break;
		case 'Patient':
			url = `${base}/Patient?_id=${patientInfo.id}`;
			break;
		case 'AllergyIntolerance':
			url = `${base}/Patient/${patientInfo.id}/AllergyIntolerance`;
			break;
		case 'Conditions':
			url = `${base}/Patient/${patientInfo.id}/Condition`;
			break;
		case 'Observations':
			url = `${base}/Patient/${patientInfo.id}/Observation`;
			break;
	}
	return fetch(url, {
		"headers": {
			"accept": "application/fhir+json",
			"cache-control": "no-cache",
			"content-type": "application/fhir+json;charset=UTF-8",
			"pragma": "no-cache",
			"sec-fetch-dest": "empty",
			"sec-fetch-mode": "cors",
			"x-requested-with": "XMLHttpRequest"
		},
		"referrer": "http://localhost:32783/csp/user/fhirUI/FHIRAppDemo.html?$ZEN_POPUP=1&$ZEN_SOFTMODAL=1&PatientList=1,172,459,705,1002,1510,1984,1996",
		"referrerPolicy": "no-referrer-when-downgrade",
		"body": null,
		"method": "GET",
		"mode": "cors",
		"credentials": "include"
	}).then(r => r.json()).then(formatter);
}
let patients = [];
getPatientDetails({id: qs.PatientList}, "Patient").then(r => {
	patients = r;
	ReactDOM.render(<App />, document.getElementById('root'));
});
