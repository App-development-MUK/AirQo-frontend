import React, { useState, useEffect } from 'react';
import { makeStyles } from '@material-ui/styles';
import PropTypes from 'prop-types';
import { Card, CardContent, Grid, Button,Typography } from '@material-ui/core';
import clsx from 'clsx';
import Select from 'react-select';
import axios from 'axios';
import { useParams } from 'react-router-dom';
import TextField from '@material-ui/core/TextField';
import { TableContainer, Table, TableBody, TableCell, TableHead, TableRow, Paper } from '@material-ui/core';
import { Link } from "react-router-dom";
import LoadingOverlay from 'react-loading-overlay';
//import './assets/css/location-registry.css';
import '../../../assets/css/location-registry.css';
import { Map, FeatureGroup, LayerGroup, TileLayer, Marker, Popup } from "react-leaflet";
import 'leaflet/dist/leaflet.css'



const useStyles = makeStyles(theme => ({
  root: {
    padding: theme.spacing(3),
  },
  content: {
    marginTop: theme.spacing(2)
  },
  title: {
    fontWeight: 700,
    color: '#000000',
    fontSize: 20,
    fontFamily: 'Open Sans'
  },
  avatar: {
    backgroundColor: theme.palette.success.main,
    height: 56,
    width: 56
  },
  icon: {
    height: 32,
    width: 32
  },
  difference: {
    marginTop: theme.spacing(2),
    display: 'flex',
    alignItems: 'center'
  },
  differenceIcon: {
    color: theme.palette.success.dark
  },
  differenceValue: {
    color: theme.palette.success.dark,
    marginRight: theme.spacing(1)
  },

  formControl: {
    margin: theme.spacing(3),
    fontFamily: 'Open Sans'
  },

  table: {
    fontFamily: 'Open Sans'
  }
  
  
}));

const LocationView = props => {
  const { className, ...rest } = props;
  let params = useParams();
  const classes = useStyles();

  const [locData, setLocData] = useState('')
  const [isLoading, setIsLoading] = useState(false);
  const [loaded, setLoaded] = useState(false);
  const [position, setPosition] = useState([0,0]);
  
  useEffect(() => {
    setIsLoading(true);
    axios.get(
      'http://127.0.0.1:4000/api/v1/location_registry?loc_ref='+params.loc_ref
    )
    .then(
      res=>{
        
        setIsLoading(false);
        const data = res.data;
        console.log(data);
        setLocData(data);
        setPosition([data.latitude, data.longitude]);
        //console.log(locData);
        setLoaded(true);
    }).catch(
      console.log
    )
  }, []);
 
    return(
      
    <div className={classes.root}>
      <LoadingOverlay
      active={isLoading}
      spinner
      text='Loading Location details...'
    >
      <div>
        <Typography  className={classes.title} variant="h6" id="tableTitle" component="div">
          {locData.loc_ref} : {locData.location_name}
        </Typography> 
      </div>
      <br/>

      <div style={{width: '250px', align: 'center'}} >  

       <Map center={[0.32, 32.10]} zoom={13} scrollWheelZoom={false}>
        <TileLayer
          attribution='&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
          url='http://{s}.tile.osm.org/{z}/{x}/{y}.png'
        />
        <Marker position={[0.32, 32.10]}>
          <Popup>
            <span>A pretty CSS3 popup. <br/> Easily customizable.</span>
          </Popup>
        </Marker>
      </Map>  

      {/*}  
     
      <Map
          center={[locData.latitude, locData.longitude]}
          //zoom={this.props.mapDefaults.zoom}
        >

      <TileLayer
            attribution='&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
            url="http://{s}.tile.osm.org/{z}/{x}/{y}.png"
          />
    </Map>*/}
      </div>

      <div>

     <TableContainer component={Paper} className = {classes.table}>  
        <Table stickyHeader  aria-label="sticky table">  
         {/* <TableHead>  
            <TableRow align='center'>  {locData.loc_ref}: {locData.location_name}
              {/*<TableCell align="center">{locData.loc_ref}: {locData.location_name}</TableCell> *
            </TableRow> 
          </TableHead> */}
          <TableBody>  
            <TableRow>  
              <TableCell className = {classes.table}>Host Name: <b>{locData.host}</b></TableCell>  
              <TableCell className = {classes.table}>Parish: <b>{locData.parish}</b></TableCell> 
              <TableCell className = {classes.table}>Altitude: <b>{locData.altitude}</b></TableCell>   
            </TableRow> 
            <TableRow>  
              <TableCell className = {classes.table}>Mobility: <b>{locData.mobility}</b></TableCell>  
              <TableCell className = {classes.table}>Internet: <b>{locData.internet}</b></TableCell> 
              <TableCell className = {classes.table}>Aspect: <b>{locData.aspect}</b></TableCell>   
            </TableRow> 
            <TableRow>  
              <TableCell className = {classes.table}>Latitude: <b>{locData.latitude}</b></TableCell>  
              <TableCell className = {classes.table}>Power Type: <b>{locData.power}</b></TableCell> 
              <TableCell className = {classes.table}>Landform (90): <b>{locData.landform_90}</b></TableCell>   
            </TableRow> 
            <TableRow>  
              <TableCell className = {classes.table}>Longitude: <b>{locData.longitude}</b></TableCell>  
              <TableCell className = {classes.table}>Height above ground (m): <b>{locData.height_above_ground}</b></TableCell> 
              <TableCell className = {classes.table}>Landform (270): <b>{locData.landform_270}</b></TableCell>   
            </TableRow> 
            <TableRow>  
              <TableCell className = {classes.table}>Country: <b>{locData.country}</b></TableCell>  
              <TableCell className = {classes.table}>Road Intensity: <b>{locData.road_intensity}</b></TableCell> 
              <TableCell className = {classes.table}>Distance to nearest road (m): <b>{locData.distance_from_nearest_road}</b></TableCell>   
            </TableRow> 
            <TableRow>  
              <TableCell className = {classes.table}>Region: <b>{locData.region}</b></TableCell>  
              <TableCell className = {classes.table}>Installation Description: <b>{locData.installation_type}</b></TableCell> 
              <TableCell className = {classes.table}>Distance to nearest residential road (m): <b>{locData.distance_from_residential}</b></TableCell>   
            </TableRow> 
            <TableRow>  
              <TableCell className = {classes.table}>District: <b>{locData.district}</b></TableCell>  
              <TableCell className = {classes.table}>Road Status: <b>{locData.road_status}</b></TableCell> 
              <TableCell className = {classes.table}>Distance to nearest motorway (m): <b>{locData.distance_from_motorway}</b></TableCell>   
            </TableRow> 
            <TableRow>  
              <TableCell className = {classes.table}>Subcounty: <b>{locData.subcounty}</b></TableCell>  
              {/*<TableCell className = {classes.table}>Local Activities:<b>{locData.local_activities.map(item => {return item+','})}</b></TableCell> */}
              {
              loaded?
                    <TableCell className = {classes.table}>Local Activities: <b>{locData.local_activities.join()}</b></TableCell>
                    :
                    <TableCell className = {classes.table}>Local Activities: <b>{locData.local_activities}</b></TableCell>
                }
              <TableCell className = {classes.table}>Distance to nearest city/town (m): <b>{locData.distance_from_city}</b></TableCell>   
            </TableRow> 
          </TableBody> 
        </Table> 
     </TableContainer>
     </div>

     <br/>

     <div>    
     <Link to={`/edit/${locData.loc_ref}`}>
     <Button 
          variant="contained" 
          color="primary"              
          type="submit"
          align = "centre"
          fontFamily = 'Open Sans'
        > Edit Location
        </Button>
     </Link>    
      </div>
      </LoadingOverlay>
    </div>
    )

  }
 


LocationView.propTypes = {
  className: PropTypes.string
};

export default LocationView;