import React from "react";
import ReactDOM from "react-dom";
import PropTypes from 'prop-types'
import {
	Button,
	AppBar,
	Tabs,
	Tab,
  Typography,
	Box,
	Divider
} from '@material-ui/core'
import { lighten, makeStyles } from '@material-ui/core/styles'
import { FhirResource, fhirVersions } from "fhir-react";
import './index.css';

// Import optional styles
import "fhir-react/build/style.css";
import "fhir-react/build/bootstrap-reboot.min.css";

var qs = window.location.search.substr(1)
	.split('&')
	.map(p => p.split('='))
	.reduce((acc, curr) => { acc[curr[0]] = curr[1]; return acc; }, {});

function TabPanel(props) {
  const { children, value, index, ...other } = props;

	return(
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`simple-tabpanel-${index}`}
      aria-labelledby={`simple-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box p={3}>
          <Typography>{children}</Typography>
        </Box>
)}
    </div>
  );
}

TabPanel.propTypes = {
  children: PropTypes.node,
  index: PropTypes.any.isRequired,
  value: PropTypes.any.isRequired
};

function a11yProps(index) {
  return {
    id: `simple-tab-${index}`,
    "aria-controls": `simple-tabpanel-${index}`
  };
}

const useStylesTab = makeStyles((theme) => ({
  root: {
    flexGrow: 1,
    backgroundColor: theme.palette.background.paper
  }
}));

class App extends React.Component {
	
  constructor(props) {
    super(props);
    this.state = {};
  }

	getDetailsHandler() {
		this.setState({isShowDetails: !this.state.isShowDetails});
	}
	
  render() {
		return (
			<div className="App">
				{resources.length 
					? resources.map(element => {return(
							<PatientRow resource={element}/>
						)})
					: <span>No data</span>
				}
			</div>
		);
	}
};

class PatientRow extends React.Component {
	
  constructor(props) {
    super(props);
    this.state = {
			tabValue: 0,
			isShowDetails: false,
			resourceTypes: [],
			resources: []
		};
  }
	
	getDetailsHandler() {
		if (!this.props.resource || !this.props.resource.id) return;
		if (this.state.isShowDetails) {
			this.setState({isShowDetails: false});
			return;
		}
		
		fetch(`http://localhost:32783/fhir/r4/Patient/${this.props.resource.id}/$everything`, {
			"headers": {
				"accept": "application/fhir+json",
				"accept-language": "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7,es;q=0.6",
				"cache-control": "no-cache",
				"content-type": "application/fhir+json;charset=UTF-8",
				"pragma": "no-cache",
				"sec-fetch-dest": "empty",
				"sec-fetch-mode": "cors",
				"sec-fetch-site": "same-origin",
				"x-requested-with": "XMLHttpRequest"
			},
			"referrer": "http://localhost:32783/csp/user/fhirUI/FHIRAppDemo.html",
			"referrerPolicy": "no-referrer-when-downgrade",
			"body": null,
			"method": "GET",
			"mode": "cors",
			"credentials": "include"
		}).then(r => r.json()).then(d => {
			let resources = d.entry
				.map(e => e.resource)
				.reduce((acc, curr) => { 
					if(!acc.hasOwnProperty(curr.resourceType)){ acc[curr.resourceType] = []; } 
					acc[curr.resourceType].push(curr); 
					return acc; 
				}, {});
			delete resources["Patient"]
			
			this.setState({isShowDetails: !this.state.isShowDetails});
			this.setState({resourceTypes: Object.keys(resources).sort()});
			this.setState({resources: resources});
		});
	}
	
	handleChangeTab(event, newValue) {
		let promise = Promise.resolve();
		promise.then(() => this.setState({tabValue: newValue}));
	};
	
  render() {
		return (
			<React.Fragment>
				<FhirResource 
				fhirResource={this.props.resource} 
				fhirVersion={fhirVersions.R4}
				thorough={true}/>
				<Button onClick={() => this.getDetailsHandler()}>{!this.state.isShowDetails ? 'More' : 'Less'}</Button>
				{ this.state.isShowDetails ? 
					<React.Fragment>
						<AppBar position="static">
							<Tabs
								value={this.state.tabValue}
								onChange={(event, newValue) => this.handleChangeTab(event, newValue)}
								aria-label="simple tabs example"
								variant="scrollable"
								scrollButtons="auto"
							>
							{this.state.resourceTypes.map((e, i) => {return(
								<Tab label={e} {...a11yProps(i)} />
							)})}
							</Tabs>
						</AppBar>
						{this.state.resourceTypes.map((resourceType, i) => {
							let resources = this.state.resources[resourceType] || [];
							return(
								<TabPanel value={this.state.tabValue} index={i}>
									{resources.map(resource => {return (
										<FhirResource 
										fhirResource={resource} 
										fhirVersion={fhirVersions.R4}
										thorough={true}/>
									)})}
								</TabPanel>
							)
						})}
					</React.Fragment>
					: null
				}
				<Divider/>
			</React.Fragment>
		);
	}
};

const getPatients = (patientsList) => {
	if (!patientsList) return Promise.resolve([]);
	
	const url = `http://localhost:32783/fhir/r4/Patient?_id=${patientsList}`;
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
		"referrerPolicy": "no-referrer-when-downgrade",
		"body": null,
		"method": "GET",
		"mode": "cors",
		"credentials": "include"
	}).then(r => r.json());
}
let resources = [];
getPatients(qs.PatientList).then(d => {
	resources = d && d.entry ? d.entry.map(i => i.resource) : [];
	ReactDOM.render(<App />, document.getElementById('root'));
});