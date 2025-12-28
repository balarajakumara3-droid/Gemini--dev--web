import React from 'react';
import { motion } from 'framer-motion';
import { Link } from 'react-router-dom';
import { DEMO_PROPERTIES } from '../../../data/demos/real-estate/mockData';

const DemoPropertyCard: React.FC<{ property: any, index: number }> = ({ property, index }) => {
    return (
        <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
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

export const RealEstateListing: React.FC = () => {
    return (
        <div className="min-h-screen bg-slate-50 pt-20 pb-20 px-6">
            <div className="container mx-auto">
                <div className="mb-12 text-center">
                    <h1 className="text-4xl font-bold text-slate-900 mb-4">Properties for Sale & Rent</h1>
                    <p className="text-slate-500 max-w-2xl mx-auto">Browse our complete inventory of luxury homes and apartments.</p>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    {DEMO_PROPERTIES.map((p, i) => (
                        <DemoPropertyCard key={p.id} property={p} index={i} />
                    ))}
                </div>
            </div>
        </div>
    );
};
