import React from 'react';
import Page from './Page';
import Hero from '../components/Hero';
import Monitor from '../components/Monitor';
import TopBar from '../components/nav/TopBar';
import GetApp from '../components/get-app/GetApp';
import MapSection from '../components/MapSection/MapSection';
import { NewsletterSection } from '../components/NewsletterSection';
import AirQuality from '../components/AirQuality';

const HomePage = () => (
    <Page>
        <div className="HomePage">
            <TopBar />
            <Hero />
            <AirQuality />
            <Monitor />
            <MapSection />
            <GetApp />
            <NewsletterSection />
        </div>
    </Page>
);

export default HomePage;
