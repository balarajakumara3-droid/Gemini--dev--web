import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { ArrowRight, Star, Shield, Zap, Search, MapPin } from 'lucide-react';
import { Link } from 'react-router-dom';
import { DEMO_PROPERTIES } from '../../../data/demos/real-estate/mockData';

// Recreated PropertyCard for Demo Context - Portal Style
const DemoPropertyCard: React.FC<{ property: any, index: number }> = ({ property, index }) => {
    return (
        <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5, delay: index * 0.1 }}
            className="group relative bg-white border border-slate-200 rounded-lg overflow-hidden hover:shadow-xl transition-all duration-300"
        >
            <div className="relative aspect-[4/3] overflow-hidden">
                <img
                    src={property.images[0]}
                    alt={property.title}
                    className="object-cover w-full h-full transition-transform duration-700 group-hover:scale-110"
                />
                <div className="absolute top-3 left-3 bg-[#d93025] text-white text-xs font-bold px-2 py-1 rounded">
                    {property.type === 'Sale' ? 'FOR SALE' : 'FOR RENT'}
                </div>
                <div className="absolute bottom-3 left-3 bg-black/50 backdrop-blur-sm text-white text-xs px-2 py-1 rounded flex items-center gap-1">
                    <div className="w-2 h-2 rounded-full bg-green-500 animate-pulse"></div> New - 2 hours ago
                </div>
            </div>
            <div className="p-4">
                <div className="flex justify-between items-start mb-2">
                    <div>
                        <h3 className="text-2xl font-bold text-slate-900">${property.price.toLocaleString()}</h3>
                        <div className="flex items-center gap-3 text-slate-600 text-sm font-medium mt-1">
                            <span className="flex items-center gap-1"><strong>{property.specs.bedrooms}</strong> bed</span>
                            <span className="w-1 h-1 rounded-full bg-slate-300"></span>
                            <span className="flex items-center gap-1"><strong>{property.specs.bathrooms}</strong> bath</span>
                            <span className="w-1 h-1 rounded-full bg-slate-300"></span>
                            <span className="flex items-center gap-1"><strong>{property.specs.sqft}</strong> sqft</span>
                        </div>
                    </div>
                </div>

                <p className="text-slate-500 text-sm mb-4 truncate">{property.location}</p>

                <Link
                    to={`/demos/real-estate/properties/${property.id}`}
                    className="w-full block text-center py-2 rounded border border-slate-300 text-slate-700 font-bold hover:border-[#d93025] hover:text-[#d93025] transition-colors"
                >
                    View Details
                </Link>
            </div>
        </motion.div>
    );
};

export const RealEstateHome: React.FC = () => {
    const featuredProperties = DEMO_PROPERTIES.slice(0, 3);
    const [activeTab, setActiveTab] = useState('Buy');

    return (
        <div className="bg-white">
            {/* Search Hero Section */}
            <section className="relative h-[550px] flex items-center justify-center overflow-hidden">
                <div className="absolute inset-0">
                    <img
                        src="https://images.unsplash.com/photo-1512917774080-9991f1c4c750?q=80&w=2670&auto=format&fit=crop"
                        alt="Hero Background"
                        className="w-full h-full object-cover"
                    />
                    <div className="absolute inset-0 bg-black/30" />
                </div>

                <div className="relative z-10 container mx-auto px-6 w-full max-w-4xl">
                    <div className="text-center mb-8">
                        <motion.h1
                            initial={{ opacity: 0, y: 20 }}
                            animate={{ opacity: 1, y: 0 }}
                            className="text-4xl md:text-5xl font-bold text-white mb-2 shadow-sm"
                        >
                            The Home of Your Dreams is Here
                        </motion.h1>
                        <motion.p
                            initial={{ opacity: 0, y: 20 }}
                            animate={{ opacity: 1, y: 0 }}
                            transition={{ delay: 0.1 }}
                            className="text-white/90 text-lg font-medium"
                        >
                            Browse the most comprehensive real estate listings.
                        </motion.p>
                    </div>

                    <motion.div
                        initial={{ opacity: 0, y: 30 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: 0.2 }}
                        className="bg-white/95 backdrop-blur-sm rounded-xl p-2 shadow-2xl"
                    >
                        {/* Search Tabs */}
                        <div className="flex gap-1 mb-2 px-2">
                            {['Buy', 'Rent', 'Sell', 'Pre-approval'].map(tab => (
                                <button
                                    key={tab}
                                    onClick={() => setActiveTab(tab)}
                                    className={`px-6 py-2 rounded-lg font-bold text-sm transition-colors ${activeTab === tab ? 'bg-slate-900 text-white' : 'text-slate-600 hover:bg-slate-100'}`}
                                >
                                    {tab}
                                </button>
                            ))}
                        </div>

                        {/* Search Bar */}
                        <div className="relative flex group">
                            <input
                                type="text"
                                placeholder="Address, School, City, Zip or Neighborhood"
                                className="w-full h-16 pl-6 pr-40 rounded-lg border-2 border-transparent bg-slate-100 text-slate-900 placeholder:text-slate-500 font-medium text-lg outline-none focus:bg-white focus:border-[#d93025] transition-all"
                            />
                            <div className="absolute right-2 top-2 bottom-2">
                                <button className="h-full px-8 bg-[#d93025] hover:bg-[#b02018] text-white rounded-lg font-bold transition-colors flex items-center justify-center">
                                    <Search size={24} />
                                </button>
                            </div>
                        </div>
                    </motion.div>
                </div>
            </section>

            {/* Quick Links */}
            <section className="bg-slate-50 border-b border-slate-200">
                <div className="container mx-auto px-6">
                    <div className="flex justify-center divide-x divide-slate-200">
                        <Link to="/demos/real-estate/properties" className="flex-1 py-6 text-center hover:bg-white transition-colors group">
                            <div className="text-[#d93025] font-bold mb-1 group-hover:underline">Buy a Home</div>
                            <div className="text-slate-500 text-sm">Find your place with an immersive photo experience.</div>
                        </Link>
                        <Link to="/demos/real-estate/properties" className="flex-1 py-6 text-center hover:bg-white transition-colors group">
                            <div className="text-[#d93025] font-bold mb-1 group-hover:underline">Rent a Home</div>
                            <div className="text-slate-500 text-sm">We’re creating a seamless online experience.</div>
                        </Link>
                        <Link to="/demos/real-estate/about" className="flex-1 py-6 text-center hover:bg-white transition-colors group">
                            <div className="text-[#d93025] font-bold mb-1 group-hover:underline">Sell a Home</div>
                            <div className="text-slate-500 text-sm">Whatever your path, we can help you navigate.</div>
                        </Link>
                    </div>
                </div>
            </section>


            {/* Featured Section */}
            <section className="py-16 px-6 bg-white">
                <div className="container mx-auto">
                    <div className="flex justify-between items-end mb-8">
                        <div>
                            <h2 className="text-2xl font-bold text-slate-900 mb-2">New Listings in Beverly Hills, CA</h2>
                            <Link to="/demos/real-estate/properties" className="text-[#d93025] font-medium hover:underline text-sm">View all 140 new listings</Link>
                        </div>
                        <Link to="/demos/real-estate/properties" className="hidden md:flex items-center gap-2 text-slate-900 font-bold hover:text-[#d93025] transition-colors">
                            See All <ArrowRight size={18} />
                        </Link>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                        {featuredProperties.map((p, i) => (
                            <DemoPropertyCard key={p.id} property={p} index={i} />
                        ))}
                    </div>
                </div>
            </section>

            {/* Value Prop / Promo */}
            <section className="py-20 px-6 bg-slate-50">
                <div className="container mx-auto grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
                    <div>
                        <img
                            src="https://images.unsplash.com/photo-1560518883-ce09059eeffa?q=80&w=2573&auto=format&fit=crop"
                            alt="Mobile App"
                            className="rounded-xl shadow-2xl"
                        />
                    </div>
                    <div>
                        <h2 className="text-3xl font-bold text-slate-900 mb-4">Take Us With You</h2>
                        <p className="text-slate-600 text-lg mb-8">Keep the "Realtor.demo" experience in your pocket. Real-time updates, instant notifications, and saved searches.</p>

                        <div className="flex gap-4">
                            <button className="px-6 py-3 bg-slate-900 text-white rounded-lg font-bold hover:bg-slate-800 transition-colors">
                                Download App
                            </button>
                            <button className="px-6 py-3 border border-slate-300 text-slate-700 rounded-lg font-bold hover:bg-white hover:text-[#d93025] hover:border-[#d93025] transition-colors">
                                Learn More
                            </button>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    );
};
