import React from 'react';
import { BrowserRouter as Router, Routes, Route, Outlet } from 'react-router-dom';
import VirtualTraderPage from './pages/VirtualTraderPage';
import { HelmetProvider } from 'react-helmet-async';
import { Navbar } from './components/Navbar';
import { Footer } from './components/Footer';
import { CustomCursor } from './components/CustomCursor';
import { HomePage } from './pages/HomePage';
import { AboutPage } from './pages/AboutPage';
import { FaqPage } from './pages/FaqPage';
import { ContactPage } from './pages/ContactPage';
import BlogListPage from './pages/BlogListPage';
import BlogPostPage from './pages/BlogPostPage';

const App: React.FC = () => {
    return (
        <HelmetProvider>
            <Router>
                <div className="bg-background text-primary min-h-screen selection:bg-accent selection:text-white overflow-x-hidden font-sans">
                    <CustomCursor />
                    <Routes>
                        <Route path="/virtual-trader" element={<VirtualTraderPage />} />
                        <Route element={<><Navbar /><Outlet /><Footer /></>}>
                            <Route path="/" element={<HomePage />} />
                            <Route path="/about" element={<AboutPage />} />
                            <Route path="/faq" element={<FaqPage />} />
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