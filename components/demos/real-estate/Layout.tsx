import React, { useState, useEffect } from 'react';
import { Outlet, Link, useLocation } from 'react-router-dom';
import { motion, AnimatePresence } from 'framer-motion';
import { Menu, X, ArrowRight, Home } from 'lucide-react';
// Button removed as it was deleted, using local DemoButton

// Simple Reusable Button for the demo context if the main one was deleted (it was deleted in Step 81)
// We need to check if the main UI components still exist or need recreation.
// Since Step 81 said "The following file was deleted: .../components/ui/Button.tsx", I should probably recreate a local version or restore it.
// For now, I'll include a local button definition to be safe and independent.

const DemoButton: React.FC<any> = ({ children, className = '', variant = 'primary', ...props }) => {
    const baseStyle = "inline-flex items-center justify-center rounded-lg font-medium transition-colors px-5 py-2.5";
    const variants: any = {
        primary: "bg-blue-600 text-white hover:bg-blue-700",
        secondary: "bg-white text-slate-900 hover:bg-slate-100",
        outline: "border border-white/20 text-white hover:bg-white/10",
        ghost: "text-white/80 hover:text-white hover:bg-white/5"
    };
    return (
        <button className={`${baseStyle} ${variants[variant]} ${className}`} {...props}>
            {children}
        </button>
    );
};

export const RealEstateLayout: React.FC = () => {
    const [isOpen, setIsOpen] = useState(false);
    const [scrolled, setScrolled] = useState(false);
    const location = useLocation();

    useEffect(() => {
        const handleScroll = () => setScrolled(window.scrollY > 20);
        window.addEventListener('scroll', handleScroll);
        return () => window.removeEventListener('scroll', handleScroll);
    }, []);

    // Close mobile menu on route change
    useEffect(() => setIsOpen(false), [location]);

    // Force default cursor for demo pages
    useEffect(() => {
        document.body.style.cursor = 'auto';
        return () => {
            document.body.style.cursor = '';
        };
    }, []);

    const navLinks = [
        { label: 'Home', path: '/demos/real-estate' },
        { label: 'Properties', path: '/demos/real-estate/properties' },
        { label: 'Agents', path: '/demos/real-estate/agents' }, // Future placeholder
        { label: 'About', path: '/demos/real-estate/about' }, // Future placeholder
    ];

    return (
        <div className="font-sans text-slate-900 bg-white min-h-screen selection:bg-blue-500 selection:text-white">
            {/* Demo Header / Disclaimer */}
            <div className="bg-slate-900 text-white text-xs py-2 px-4 text-center">
                <span className="opacity-70">This is a demo application showcased by Idea Manifest.</span>
                <Link to="/work" className="ml-2 underline hover:text-blue-400">Back to Portfolio</Link>
            </div>

            {/* Navbar */}
            <nav className={`sticky top-0 z-50 transition-all duration-300 ${scrolled ? 'bg-white/90 backdrop-blur-md shadow-sm py-4' : 'bg-transparent py-6'}`}>
                <div className="container mx-auto px-6 flex justify-between items-center">
                    <Link to="/demos/real-estate" className="flex items-center gap-2 text-2xl font-bold text-slate-900">
                        <div className="w-10 h-10 bg-blue-600 rounded-lg flex items-center justify-center text-white">
                            <Home size={20} />
                        </div>
                        <span>LuxeEstate</span>
                    </Link>

                    {/* Desktop Nav */}
                    <div className="hidden md:flex items-center gap-8">
                        {navLinks.map(link => (
                            <Link
                                key={link.path}
                                to={link.path}
                                className={`text-sm font-medium hover:text-blue-600 transition-colors ${location.pathname === link.path ? 'text-blue-600' : 'text-slate-600'}`}
                            >
                                {link.label}
                            </Link>
                        ))}
                        <Link
                            to="/demos/real-estate/contact"
                            className="inline-flex items-center justify-center rounded-full font-medium transition-colors px-6 py-2.5 bg-blue-600 text-white hover:bg-blue-700"
                        >
                            Contact Us
                        </Link>
                    </div>

                    {/* Mobile Toggle */}
                    <button className="md:hidden text-slate-900" onClick={() => setIsOpen(!isOpen)}>
                        {isOpen ? <X /> : <Menu />}
                    </button>
                </div>
            </nav>

            {/* Mobile Menu */}
            <AnimatePresence>
                {isOpen && (
                    <motion.div
                        initial={{ opacity: 0, height: 0 }}
                        animate={{ opacity: 1, height: 'auto' }}
                        exit={{ opacity: 0, height: 0 }}
                        className="md:hidden bg-white border-b border-slate-100 overflow-hidden"
                    >
                        <div className="container mx-auto px-6 py-8 flex flex-col gap-4">
                            {navLinks.map(link => (
                                <Link
                                    key={link.path}
                                    to={link.path}
                                    className="text-lg font-medium text-slate-800 hover:text-blue-600"
                                >
                                    {link.label}
                                </Link>
                            ))}
                            <Link
                                to="/demos/real-estate/contact"
                                className="inline-flex items-center justify-center rounded-lg font-medium transition-colors px-5 py-2.5 bg-blue-600 text-white hover:bg-blue-700 w-full"
                            >
                                Contact Us
                            </Link>
                        </div>
                    </motion.div>
                )}
            </AnimatePresence>

            {/* Content */}
            <main>
                <Outlet />
            </main>

            {/* Footer */}
            <footer className="bg-slate-900 text-white py-12 md:py-20 mt-20">
                <div className="container mx-auto px-6">
                    <div className="grid grid-cols-1 md:grid-cols-4 gap-12 mb-12">
                        <div className="col-span-1 md:col-span-2">
                            <div className="flex items-center gap-2 text-2xl font-bold text-white mb-6">
                                <div className="w-10 h-10 bg-blue-600 rounded-lg flex items-center justify-center text-white">
                                    <Home size={20} />
                                </div>
                                <span>LuxeEstate</span>
                            </div>
                            <p className="text-slate-400 max-w-sm mb-6">
                                Redefining luxury living with exceptional properties and widespread reach. Your dream home awaits.
                            </p>
                            <Link to="/work" className="text-sm text-blue-400 hover:text-blue-300 flex items-center gap-1">
                                <ArrowRight size={14} /> Back to Idea Manifest Portfolio
                            </Link>
                        </div>

                        <div>
                            <h4 className="text-lg font-bold mb-6">Explore</h4>
                            <ul className="space-y-4 text-slate-400">
                                <li><Link to="/demos/real-estate" className="hover:text-white transition-colors">Home</Link></li>
                                <li><Link to="/demos/real-estate/properties" className="hover:text-white transition-colors">Properties</Link></li>
                                <li><Link to="/demos/real-estate/agents" className="hover:text-white transition-colors">Agents</Link></li>
                                <li><Link to="/demos/real-estate/contact" className="hover:text-white transition-colors">Contact</Link></li>
                            </ul>
                        </div>

                        <div>
                            <h4 className="text-lg font-bold mb-6">Contact</h4>
                            <ul className="space-y-4 text-slate-400">
                                <li>123 Luxury Ave, Beverly Hills</li>
                                <li>contact@luxeestate.demo</li>
                                <li>+1 (555) 123-4567</li>
                            </ul>
                        </div>
                    </div>
                    <div className="border-t border-white/10 pt-8 text-center text-slate-500 text-sm">
                        © {new Date().getFullYear()} LuxeEstate Demo. Built by Idea Manifest.
                    </div>
                </div>
            </footer>
        </div>
    );
};
