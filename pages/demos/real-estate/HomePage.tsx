import React from 'react';
import { motion } from 'framer-motion';
import { ArrowRight, Star, Shield, Zap } from 'lucide-react';
import { Link } from 'react-router-dom';
import { DEMO_PROPERTIES } from '../../../data/demos/real-estate/mockData';

// Recreated PropertyCard for Demo Context
const DemoPropertyCard: React.FC<{ property: any, index: number }> = ({ property, index }) => {
    return (
        <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5, delay: index * 0.1 }}
            className="group relative bg-white border border-slate-200 rounded-2xl overflow-hidden hover:shadow-xl transition-all duration-300"
        >
            <div className="relative aspect-[4/3] overflow-hidden">
                <img
                    src={property.images[0]}
                    alt={property.title}
                    className="object-cover w-full h-full transition-transform duration-700 group-hover:scale-110"
                />
                <div className="absolute top-4 right-4 bg-white/90 backdrop-blur-md px-3 py-1.5 rounded-full shadow-sm">
                    <span className="text-slate-900 font-bold text-sm">
                        ${property.price.toLocaleString()}
                    </span>
                </div>
                <div className="absolute top-4 left-4 bg-blue-600/90 backdrop-blur-md px-3 py-1.5 rounded-full">
                    <span className="text-white text-xs font-semibold uppercase tracking-wider">
                        {property.type}
                    </span>
                </div>
            </div>
            <div className="p-6">
                <h3 className="text-xl font-bold text-slate-900 mb-2 line-clamp-1">{property.title}</h3>
                <p className="text-slate-500 text-sm mb-4">{property.location}</p>

                <div className="flex items-center justify-between text-slate-600 text-sm border-t border-slate-100 pt-4">
                    <span>{property.specs.bedrooms} Beds</span>
                    <span>{property.specs.bathrooms} Baths</span>
                    <span>{property.specs.sqft} SqFt</span>
                </div>

                <Link
                    to={`/demos/real-estate/properties/${property.id}`}
                    className="mt-4 flex items-center justify-center w-full py-2.5 rounded-lg bg-slate-50 text-slate-900 font-medium hover:bg-slate-100 transition-colors"
                >
                    View Details
                </Link>
            </div>
        </motion.div>
    );
};

export const RealEstateHome: React.FC = () => {
    const featuredProperties = DEMO_PROPERTIES.slice(0, 3);

    return (
        <div className="bg-white">
            {/* Hero Section */}
            <section className="relative h-[90vh] min-h-[600px] flex items-center justify-center overflow-hidden">
                <div className="absolute inset-0">
                    <img
                        src="https://images.unsplash.com/photo-1512917774080-9991f1c4c750?q=80&w=2670&auto=format&fit=crop"
                        alt="Luxury Hero"
                        className="w-full h-full object-cover"
                    />
                    <div className="absolute inset-0 bg-black/40" />
                </div>

                <div className="relative z-10 container mx-auto px-6 text-center text-white">
                    <motion.h1
                        initial={{ opacity: 0, y: 30 }}
                        animate={{ opacity: 1, y: 0 }}
                        className="text-5xl md:text-7xl font-serif font-bold mb-6 leading-tight"
                    >
                        Find Your Perfect <br />
                        <span className="text-transparent bg-clip-text bg-gradient-to-r from-blue-300 to-white">Sanctuary</span>
                    </motion.h1>
                    <motion.p
                        initial={{ opacity: 0, y: 30 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: 0.2 }}
                        className="text-xl text-white/90 mb-10 max-w-2xl mx-auto font-light"
                    >
                        Discover a curated collection of the world's most desirable properties.
                    </motion.p>
                    <motion.div
                        initial={{ opacity: 0, y: 30 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: 0.4 }}
                        className="flex flex-col sm:flex-row gap-4 justify-center"
                    >
                        <Link to="/demos/real-estate/properties" className="px-8 py-4 bg-blue-600 text-white rounded-full font-bold hover:bg-blue-700 transition-colors">
                            View Properties
                        </Link>
                        <Link to="/demos/real-estate/contact" className="px-8 py-4 bg-white text-slate-900 rounded-full font-bold hover:bg-slate-100 transition-colors">
                            Contact Agent
                        </Link>
                    </motion.div>
                </div>
            </section>

            {/* Featured Section */}
            <section className="py-24 px-6 bg-slate-50">
                <div className="container mx-auto">
                    <div className="flex justify-between items-end mb-12">
                        <div>
                            <h2 className="text-3xl md:text-4xl font-bold text-slate-900 mb-4">Featured Listings</h2>
                            <p className="text-slate-500">Explore our latest and most exclusive properties.</p>
                        </div>
                        <Link to="/demos/real-estate/properties" className="hidden md:flex items-center gap-2 text-blue-600 font-semibold hover:text-blue-700">
                            View All <ArrowRight size={18} />
                        </Link>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                        {featuredProperties.map((p, i) => (
                            <DemoPropertyCard key={p.id} property={p} index={i} />
                        ))}
                    </div>
                </div>
            </section>

            {/* Why Choose Us */}
            <section className="py-24 px-6">
                <div className="container mx-auto text-center">
                    <h2 className="text-3xl md:text-4xl font-bold text-slate-900 mb-16">Why Choose LuxeEstate</h2>
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-12">
                        <div className="p-8 rounded-2xl bg-white border border-slate-100 shadow-sm hover:shadow-md transition-shadow">
                            <div className="w-16 h-16 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center mx-auto mb-6">
                                <Star size={24} />
                            </div>
                            <h3 className="text-xl font-bold text-slate-900 mb-4">Premium Listings</h3>
                            <p className="text-slate-500">Access to exclusive off-market properties and luxury estates.</p>
                        </div>
                        <div className="p-8 rounded-2xl bg-white border border-slate-100 shadow-sm hover:shadow-md transition-shadow">
                            <div className="w-16 h-16 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center mx-auto mb-6">
                                <Shield size={24} />
                            </div>
                            <h3 className="text-xl font-bold text-slate-900 mb-4">Secure Transactions</h3>
                            <p className="text-slate-500">Expert legal and financial guidance for peace of mind.</p>
                        </div>
                        <div className="p-8 rounded-2xl bg-white border border-slate-100 shadow-sm hover:shadow-md transition-shadow">
                            <div className="w-16 h-16 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center mx-auto mb-6">
                                <Zap size={24} />
                            </div>
                            <h3 className="text-xl font-bold text-slate-900 mb-4">Fast Process</h3>
                            <p className="text-slate-500">Streamlined digital paperwork to close deals faster.</p>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    );
};
