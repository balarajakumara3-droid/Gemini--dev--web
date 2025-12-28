import React, { useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { motion } from 'framer-motion';
import { MapPin, ArrowLeft, Check, Phone, Mail } from 'lucide-react';
import { DEMO_PROPERTIES } from '../../../data/demos/real-estate/mockData';

export const RealEstateDetails: React.FC = () => {
    const { id } = useParams<{ id: string }>();
    const property = DEMO_PROPERTIES.find(p => p.id === id);

    useEffect(() => {
        window.scrollTo(0, 0);
    }, [id]);

    if (!property) {
        return (
            <div className="min-h-screen flex flex-col items-center justify-center text-center p-6 text-slate-900">
                <h1 className="text-3xl font-bold mb-4">Property Not Found</h1>
                <Link to="/demos/real-estate/properties" className="text-blue-600 underline">Back to Listings</Link>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-white pb-20">
            {/* Hero Image */}
            <div className="relative h-[60vh] md:h-[70vh]">
                <img
                    src={property.images[0]}
                    alt={property.title}
                    className="w-full h-full object-cover"
                />
                <div className="absolute inset-0 bg-black/20" />
                <Link to="/demos/real-estate/properties" className="absolute top-24 left-6 z-20 flex items-center gap-2 px-4 py-2 bg-white/90 backdrop-blur-md rounded-full text-sm font-medium hover:bg-white transition-colors">
                    <ArrowLeft size={16} /> Back
                </Link>

                <div className="absolute bottom-0 left-0 w-full p-6 md:p-12 bg-gradient-to-t from-black/80 to-transparent text-white">
                    <div className="container mx-auto">
                        <span className="inline-block px-3 py-1 bg-blue-600 rounded-md text-xs font-bold uppercase mb-4">{property.type}</span>
                        <h1 className="text-3xl md:text-5xl font-bold mb-2">{property.title}</h1>
                        <div className="flex items-center gap-2 text-white/80">
                            <MapPin size={18} /> {property.location}
                        </div>
                    </div>
                </div>
            </div>

            <div className="container mx-auto px-6 mt-12">
                <div className="grid grid-cols-1 lg:grid-cols-3 gap-12">
                    <div className="lg:col-span-2">
                        <div className="flex justify-between items-center py-6 border-b border-slate-100 mb-8">
                            <div className="text-center">
                                <div className="text-2xl font-bold text-slate-900">{property.specs.bedrooms}</div>
                                <div className="text-sm text-slate-500">Bedrooms</div>
                            </div>
                            <div className="text-center border-l border-slate-100 pl-8">
                                <div className="text-2xl font-bold text-slate-900">{property.specs.bathrooms}</div>
                                <div className="text-sm text-slate-500">Bathrooms</div>
                            </div>
                            <div className="text-center border-l border-slate-100 pl-8">
                                <div className="text-2xl font-bold text-slate-900">{property.specs.sqft}</div>
                                <div className="text-sm text-slate-500">Square Ft</div>
                            </div>
                        </div>

                        <div className="mb-12">
                            <h2 className="text-2xl font-bold text-slate-900 mb-4">Description</h2>
                            <p className="text-slate-600 leading-relaxed text-lg">{property.description}</p>
                        </div>

                        <div className="mb-12">
                            <h2 className="text-2xl font-bold text-slate-900 mb-6">Features</h2>
                            <div className="grid grid-cols-2 gap-4">
                                {property.features.map(f => (
                                    <div key={f} className="flex items-center gap-3 text-slate-700 bg-slate-50 p-3 rounded-lg">
                                        <Check size={18} className="text-blue-600" /> {f}
                                    </div>
                                ))}
                            </div>
                        </div>

                        {/* Gallery Grid */}
                        <div className="grid grid-cols-2 gap-4">
                            {property.images.slice(1).map((img, i) => (
                                <img key={i} src={img} alt="Gallery" className="w-full h-64 object-cover rounded-xl" />
                            ))}
                        </div>
                    </div>

                    {/* Agent Sidebar */}
                    <div>
                        <div className="bg-white border border-slate-200 rounded-2xl p-6 shadow-sm sticky top-28">
                            <div className="text-2xl font-bold text-slate-900 mb-6">${property.price.toLocaleString()}</div>
                            <div className="flex items-center gap-4 mb-6">
                                <img src={property.agent.image} alt={property.agent.name} className="w-16 h-16 rounded-full object-cover" />
                                <div>
                                    <div className="font-bold text-slate-900">{property.agent.name}</div>
                                    <div className="text-sm text-slate-500">Listing Agent</div>
                                </div>
                            </div>

                            <div className="space-y-4">
                                <button className="w-full py-3 bg-blue-600 text-white rounded-lg font-bold hover:bg-blue-700 transition-colors flex items-center justify-center gap-2">
                                    <Phone size={18} /> {property.agent.phone}
                                </button>
                                <button className="w-full py-3 bg-white border border-slate-300 text-slate-700 rounded-lg font-bold hover:bg-slate-50 transition-colors flex items-center justify-center gap-2">
                                    <Mail size={18} /> Email Agent
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};
