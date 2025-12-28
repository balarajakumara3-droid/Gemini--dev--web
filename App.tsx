import React from 'react';
import { BrowserRouter as Router, Routes, Route, Outlet } from 'react-router-dom';
import VirtualTraderPage from './pages/VirtualTraderPage';
import { HelmetProvider } from 'react-helmet-async';
import { Navbar } from './components/Navbar';
import { Footer } from './components/Footer';
import { CustomCursor } from './components/CustomCursor';
import { HomePage } from './pages/HomePage';
import { AboutPage } from './pages/AboutPage';
import { ContactPage } from './pages/ContactPage';
import BlogListPage from './pages/BlogListPage';
import BlogPostPage from './pages/BlogPostPage';
import ServicesPage from './pages/ServicesPage';
import WorkPage from './pages/WorkPage';
import { RealEstateLayout } from './components/demos/real-estate/Layout';
import { RealEstateHome } from './pages/demos/real-estate/HomePage';
import { RealEstateListing } from './pages/demos/real-estate/ListingPage';
import { RealEstateDetails } from './pages/demos/real-estate/DetailsPage';
import { RealEstateAgents } from './pages/demos/real-estate/AgentsPage';
import { RealEstateAbout } from './pages/demos/real-estate/AboutPage';
import { RealEstateContact } from './pages/demos/real-estate/ContactPage';

const App: React.FC = () => {
    return (
        <HelmetProvider>
            <Router>
                <div className="bg-background text-primary min-h-screen selection:bg-accent selection:text-white overflow-x-hidden max-w-full font-sans">
                    <CustomCursor />
                    <Routes>
                        <Route path="/virtual-trader" element={<VirtualTraderPage />} />

                        {/* Real Estate Demo Routes */}
                        <Route path="/demos/real-estate" element={<RealEstateLayout />}>
                            <Route index element={<RealEstateHome />} />
                            <Route path="properties" element={<RealEstateListing />} />
                            <Route path="properties/:id" element={<RealEstateDetails />} />
                            <Route path="agents" element={<RealEstateAgents />} />
                            <Route path="about" element={<RealEstateAbout />} />
                            <Route path="contact" element={<RealEstateContact />} />
                            {/* Fallback for other demo links */}
                            <Route path="*" element={<RealEstateHome />} />
                        </Route>

                        <Route element={<><Navbar /><Outlet /><Footer /></>}>
                            <Route path="/" element={<HomePage />} />
                            <Route path="/about" element={<AboutPage />} />
                            <Route path="/services" element={<ServicesPage />} />
                            <Route path="/work" element={<WorkPage />} />
                            <Route path="/contact" element={<ContactPage />} />
                            <Route path="/blogs" element={<BlogListPage />} />
                            <Route path="/blogs/:slug" element={<BlogPostPage />} />
                        </Route>
                    </Routes>
                </div>
            </Router>
        </HelmetProvider>
    );
};

export default App;