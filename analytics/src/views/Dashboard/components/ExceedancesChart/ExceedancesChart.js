import React, { useState, useEffect } from 'react';
import { makeStyles } from '@material-ui/styles';
import { Bar } from 'react-chartjs-2';
import PropTypes from 'prop-types';
import { Card, CardContent, Grid, Button} from '@material-ui/core';
import clsx from 'clsx';
import axios from 'axios';
import LoadingSpinner from '../../../Graphs/loadingSpinner';


const useStyles = makeStyles(theme => ({
    root: {
      padding: theme.spacing(4)
    },
    chartCard:{
  
    },
    differenceIcon: {
      color: theme.palette.text.secondary,
    },
    chartContainer: {
      height: 200,
      position: 'relative'
    },
    actions: {
      justifyContent: 'flex-end'
    }
  }));

const ExceedancesChart = props => {
    const { className, ...rest } = props;
  
    const classes = useStyles();
    const [loading, setLoading] = useState(false);
    const [open, setOpen] = React.useState(false);

    const [locations, setLocations] =useState([]);
    const [exceedanceValues, setExceedanceValues] = useState([]);
    const [customChartTitle, setCustomChartTitle] = useState('PM 2.5 Exceedances over the past 28 days');
    const [exceedancesData, setExceedancesData] = useState([]);
    
    const [standard, setStandard] = useState('WHO');
    const standardOptions = [
        { value: 'AQI', label: 'AQI' },
        { value: 'WHO', label: 'WHO' },
      ];
    const handleStandardChange = standard => {
        setStandard(standard);
      };
  
    const [pollutant, setPollutant] =  useState('PM 2.5');
    const pollutantOptions = [
        { value: 'PM 2.5', label: 'PM 2.5' },
        { value: 'PM 10', label: 'PM 10' },
        { value: 'NO2', label: 'NO2' }
      ];
    const handlePollutantChange = pollutant => {
        setPollutant(pollutant);
      };
     
    const handleClickOpen = () => {
      setOpen(true);
    };
  
    const handleClose = () => {
      setOpen(false);
    };
    
    /*useEffect(() => {
      //fetch('https://analytcs-bknd-service-dot-airqo-250220.uc.r.appspot.com/api/v1/dashboard/monitoringsites/locations?organisation_name=KCCA')
      fetch('http://127.0.0.1:5000/api/v1/dashboard/monitoringsites/locations?organisation_name=KCCA')
        .then(res => res.json())
        .then((filterLocationsData) => {
          setFilterLocations(filterLocationsData.airquality_monitoring_sites)
        })
        .catch(console.log)
    },[]);*/

  
    /*useEffect(() => {
      
      axios.get('https://analytcs-bknd-service-dot-airqo-250220.uc.r.appspot.com/api/v1/dashboard/customisedchart/random')
      //axios.get('http://127.0.0.1:5000/api/v1/dashboard/customisedchart/random')
        .then(res => res.data)
        .then((customisedChartData) => {
          setCustomisedGraphData(customisedChartData)
          //console.log('customisedChartData');  //var newTime = new Date(element.time)
          //console.log(typeof new Date(customisedChartData.results[0].chart_data.labels[1]));
          setCustomChartTitle(customisedChartData.custom_chart_title)
        })
        .catch(console.log)
    },[]);*/
  
    
    /*let  handleSubmit = (e) => {
      e.preventDefault();
      
      let filter ={ 
        locations: values.selectedOption,
        startDate:  selectedDate,
        endDate:  selectedEndDate,
        chartType:  selectedChart.value,
        frequency:  selectedFrequency.value,
        pollutant: selectedPollutant.value,
        organisation_name: 'KCCA'     
      }
      //console.log(JSON.stringify(filter));
  
      axios.post(
        'https://analytcs-bknd-service-dot-airqo-250220.uc.r.appspot.com/api/v1/dashboard/customisedchart',      
        //'http://127.0.0.1:5000/api/v1/dashboard/customisedchart', 
        JSON.stringify(filter),
        { headers: { 'Content-Type': 'application/json' } }
      ).then(res => res.data)
        .then((customisedChartData) => {
          setCustomisedGraphData(customisedChartData)    
          console.log(customisedChartData)
  
          setCustomChartTitle(customisedChartData.custom_chart_title)
        }).catch(
          console.log
        )    
    }*/
    let  handleSubmit = (e) => {
        e.preventDefault();
        setLoading(true);
    
        let filter ={ 
          locations: values.selectedOption,
          startDate:  selectedDate,
          endDate:  selectedEndDate,
          chartType:  selectedChart.value,
          frequency:  selectedFrequency.value,
          pollutant: selectedPollutant.value,
          organisation_name: 'KCCA'     
        }
        console.log(JSON.stringify(filter));
    
        axios.post(
          //'https://analytcs-bknd-service-dot-airqo-250220.uc.r.appspot.com/api/v1/device/graph',
          'http://127.0.0.1:5000//api/v1/dashboard/exceedances', 
          JSON.stringify(filter),
          { headers: { 'Content-Type': 'application/json' } }
        )
        .then(
          res=>{
            const myData = res.data;
            console.log(myData);
            console.log(myData[0])
            setLoading(false)
            //setMyStandard(selectedChart.value);
            //setMyPollutant(selectedPollutant.value);
            /*if (typeof myData[0] == 'number'){
              let myValues = [];
              myData.forEach(element => {
                myValues.push(element);
              });
              setPollutionValues(myValues)
            }*/
    
            /*else if (typeof myData[0]== 'object'){
              let myTimes = [];
              let myValues = [];
              let myColors = [];
              myData.forEach(element => {
                var newTime = new Date(element.time);
                var finalTime = newTime.getFullYear()+'-'+appendLeadingZeroes(newTime.getMonth()+1)+'-'+appendLeadingZeroes(newTime.getDate())+
                ' '+appendLeadingZeroes(newTime.getHours())+':'+ appendLeadingZeroes(newTime.getMinutes())+':'+appendLeadingZeroes(newTime.getSeconds());
                myTimes.push(finalTime);
                
                myColors.push(element.backgroundColor)
                if (element.hasOwnProperty('characteristics') && element.characteristics.hasOwnProperty('pm2_5ConcMass')){
                  myValues.push(element.characteristics.pm2_5ConcMass.value);
                }
                else if (element.hasOwnProperty('characteristics') && element.characteristics.hasOwnProperty('pm10ConcMass')){
                  myValues.push(element.characteristics.pm10ConcMass.value);
                }
                else if (element.hasOwnProperty('characteristics') && element.characteristics.hasOwnProperty('no2Conc')){
                  myValues.push(element.characteristics.no2Conc.value);
                }
                else{
                  console.log('none of the above');
                }
              });
              setTimes(myTimes);
              setPollutionValues(myValues);
              setBackgroundColors(myColors)
            }
            else{
              //pass
            }*/
    
        }).catch(
          console.log
        )
      }
  
    
    
    return (
      <Card
        {...rest}
        className={clsx(classes.root, className)}
      >
        <CardHeader  
          action={
            <IconButton size="small" color="primary" onClick={handleClickOpen}>
              <MoreHoriz />
            </IconButton>
          }      
          
          title= {customChartTitle}
          style={{ textAlign: 'center' }}
        />
        <Divider />
        <CardContent>
                  
          <Grid
            container
            spacing={1}
          >
            <Grid
              item
              lg={12}
              sm={12}
              xl={12}
              xs={12}
            >           
              
        <div>
        {loading ? <LoadingSpinner /> : 
        <Bar
        data= {
            {
            labels: times,
            datasets:[
               {
                  label:myPollutant,
                  data: pollutionValues,
                  backgroundColor: backgroundColors,
                  borderColor: 'rgba(0,0,0,1)',   
                  borderWidth: 1
               }
            ]
         }
        }
        options={{
          title:{
            display:true,
            text: 'Bar graph showing '+myPollutant+ ' data over the specified period',
            fontColor: "black",
            fontSize: 20,
            fontWeight:5
          },

          scales: {
            yAxes: [{
              scaleLabel: {
                display: true,
                labelString: generateLabel(myPollutant),
                fontWeight:4,
                fontColor: "black",
                fontSize:20,
                padding: 10
              },
              ticks: {
                fontColor:"black"                 
                },
              gridLines:{
                lineWidth: 5
              }
            }],
            xAxes: [{
              scaleLabel: {
                display: true,
                labelString: 'Time',
                fontWeight:4,
                fontColor: "black",
                fontSize: 20,
                padding: 6
              },
              ticks: {
                fontColor:"black"                 
                },
              gridLines:{
                lineWidth: 5
              }

            }],
          },
         /* legend:{
            display: true,
            position: 'right'
          },*/
          maintainAspectRatio: true,
          responsive: true
          }}/>}
        </div>
              
            </Grid>
          
            <Grid
              item
              lg={12}
              sm={12}
              xl={12}
              xs={12}
              
            > 
              <Dialog open={open} onClose={handleClose} aria-labelledby="form-dialog-title">
                <DialogTitle id="form-dialog-title">Customise Chart by Selecting the Various Options</DialogTitle>
                <Divider/>
                <DialogContent>
                  
                  <form 
                    onSubmit={handleSubmit} 
                    id="customisable-form"
                  >             
                    
                    <Grid
                      container
                      spacing={2}
                    >             
                      <Grid
                        item
                        md={12}
                        xs={12}
                      >
                        <Select
                          fullWidth
                          className="reactSelect"
                          name="pollutant"
                          placeholder="Pollutant(s)"
                          value={pollutant}
                          options={pollutantOptions}
                          onChange={handlePollutantChange}
                          isMulti
                          variant="outlined"
                          margin="dense"
                        />
                      </Grid>
  
                      <Grid
                        item
                        md={4}
                        xs={12}
                      >                
                        <Select
                          fullWidth
                          label="standard"
                          className="reactSelect"
                          name="standard"
                          placeholder="Standard"
                          value={standard}
                          options={standardOptions}
                          onChange={handleStandardChange}    
                          variant="outlined"
                          margin="dense"        
                        />
                      </Grid>          
                    
                    </Grid>
                  </form>            
                
                </DialogContent>
                <Divider/>
                <DialogActions>
                  <Button 
                    onClick={handleClose} 
                    color="primary"
                    variant="outlined"
                  >
                    Cancel
                  </Button>
                  <Button
                    variant="outlined" 
                    onClick={handleClose} 
                    color="primary"                  
                    type="submit"        
                    form="customisable-form"
                  >
                    Customise
                  </Button>
                </DialogActions>
              </Dialog>                          
            </Grid>
            
          </Grid>
  
        </CardContent>
      </Card>
    );
  };
  
ExceedancesChart.propTypes = {
    className: PropTypes.string
  };
  
export default ExceedancesChart;
  
