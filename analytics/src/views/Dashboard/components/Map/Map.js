import React from 'react';
import clsx from 'clsx';
import PropTypes from 'prop-types';
import { makeStyles } from '@material-ui/styles';
import { Map as LeafletMap, TileLayer, Popup, Marker} from 'react-leaflet';
import {Link } from 'react-router-dom';
import {
  Card,
  CardContent, 
  CardHeader,
  Divider
} from '@material-ui/core';
import { useEffect, useState } from 'react';
import FullscreenControl from 'react-leaflet-fullscreen';
import 'react-leaflet-fullscreen/dist/styles.css';
import L from 'leaflet';
import CheckboxContainer from './checkboxcontainer';
// import Legend from "./Legend";

const useStyles = makeStyles(theme => ({
  root: {
    height: '100%',
    padding: '0',
	  margin: 0,
	  border: 0,  
  },
  content: {
    alignItems: 'center',
    display: 'flex'
  },
  title: {
    fontWeight: 700
  },
  avatar: {
    backgroundColor: theme.palette.primary.main,
    color: theme.palette.primary.contrastText,
    height: 56,
    width: 56
  },
  icon: {
    height: 32,
    width: 32
  },
  progress: {
    marginTop: theme.spacing(3)
  }
}));

const Map = props => {
  const { className, ...rest } = props;

  const classes = useStyles();

  const [contacts,setContacts ] = useState([]);

  useEffect(() => {
   fetch('https://analytcs-bknd-service-dot-airqo-250220.uc.r.appspot.com/api/v1/dashboard/monitoringsites?organisation_name=KCCA')
    //fetch('http://127.0.0.1:5000/api/v1/dashboard/monitoringsites?organisation_name=KCCA')
      .then(res => res.json())
      .then((contactData) => {
        setContacts(contactData.airquality_monitoring_sites)
      })
      .catch(console.log)
  },[]);

  let getPm25CategoryColorClass = (aqi) =>{
    return aqi > 250.4  ? 'pm25Harzadous' :
      aqi > 150.4  ? 'pm25VeryUnHealthy' :
        aqi > 55.4   ? 'pm25UnHealthy' :
          aqi > 35.4   ? 'pm25UH4SG' :
            aqi > 12   ? 'pm25Moderate' :
              aqi > 0   ? 'pm25Good' :
                'pm25UnCategorised';
  }
  let markerfilter = (box) =>{
    return box > 250.4  ? 'Harzadous' :
      box > 150.4  ? 'VeryUnHealthy' :
        box > 55.4   ? 'UnHealthy' :
          box > 35.4   ? 'UH4SG' :
            box > 12   ? 'Moderate' :
              box > 0   ? 'Good' :
                'pm25UnCategorised';
  }

  return (
    <Card
      {...rest}
      className={clsx(classes.root, className)}
    >
      <CardHeader        
        title="PM 2.5 Accross the Network for the Previous Hour "
      />
      <Divider />
            
      <CardContent>
        <LeafletMap
          animate
          attributionControl
          center={[0.3341424,32.5600613]}
          doubleClickZoom
          dragging
          easeLinearity={0.35}
          scrollWheelZoom
          zoom={12}
          // maxZoom={20}
          
          zoomControl        
          
        >
          <TileLayer
            url="http://{s}.tile.osm.org/{z}/{x}/{y}.png"
          />           
          {contacts.map((contact) => (
                      
          var grayscale = ({contact.Last_Hour_PM25_Value == 0?'':contact.Last_Hour_PM25_Value});
          var streets   = {contact.Last_Hour_PM25_Value == 0?'':contact.Last_Hour_PM25_Value};
          var metro   = {contact.Last_Hour_PM25_Value == 0?'':contact.Last_Hour_PM25_Value};
          var mixed = {
            "Grayscale": grayscale, // BaseMaps
            "Streets": streets, 		// BaseMaps
            "Metro": metro, 				// BaseMaps
          };

          L.control.layers(null, mixed).addTo(map);
           

            <Marker 
              position={[contact.Latitude,contact.Longitude]}
              fill="true"
              key={contact._id} 
              clickable="true"  
              icon={
                L.divIcon({
                html:`${contact.Last_Hour_PM25_Value == 0?'':contact.Last_Hour_PM25_Value}`,
                iconSize: 35,
                className:`leaflet-marker-icon ${getPm25CategoryColorClass(contact.Last_Hour_PM25_Value)}`
                 })}
              >
                              
              <Popup>
                <h2>{contact.Parish} - {contact.Division} Division</h2> 
                <h4>{contact.LocationCode}</h4>

                <h1> {contact.Last_Hour_PM25_Value == 0?'':contact.Last_Hour_PM25_Value}</h1> 
                <span>Last Refreshed: {contact.LastHour} (UTC)</span>
                <Divider/>
             
                <Link to="/graph/4">More Details</Link>
                
              </Popup>
            </Marker>   
          ))}  
            <FullscreenControl position="topright" />
        </LeafletMap>
      </CardContent>
    </Card>
  );
};

Map.propTypes = {
  className: PropTypes.string
};

export default Map;
