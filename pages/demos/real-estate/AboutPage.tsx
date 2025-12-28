import React from 'react';
import { motion } from 'framer-motion';
import { Award, Users, Globe, Building } from 'lucide-react';

export const RealEstateAbout: React.FC = () => {
    return (
        <div className="bg-white min-h-screen">
            {/* Hero */}
            <section className="relative h-[60vh] flex items-center justify-center text-center px-6">
                <div className="absolute inset-0">
                    <img
                        src="https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?q=80&w=2670&auto=format&fit=crop"
                        alt="Corporate HQ"
                        className="w-full h-full object-cover grayscale opacity-20"
                    />
                </div>
                <div className="relative z-10 max-w-3xl mx-auto">
                    <motion.h1
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        className="text-4xl md:text-6xl font-bold text-slate-900 mb-6"
                    >
                        Redefining Luxury Real Estate
                    </motion.h1>
                    <motion.p
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: 0.2 }}
                        className="text-xl text-slate-600"
                    >
                        LuxeEstate is more than a brokerage; we are a lifestyle company committed to informing and connecting global communities.
                    </motion.p>
                </div>
            </section>

            {/* Stats */}
            <section className="py-20 bg-slate-900 text-white">
                <div className="container mx-auto px-6">
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-8 text-center">
                        <div>
                            <div className="text-4xl font-bold text-blue-500 mb-2">$5B+</div>
                            <div className="text-sm text-slate-400 uppercase tracking-widest">Sales Volume</div>
                        </div>
                        <div>
                            <div className="text-4xl font-bold text-blue-500 mb-2">15+</div>
                            <div className="text-sm text-slate-400 uppercase tracking-widest">Years Experience</div>
                        </div>
                        <div>
                            <div className="text-4xl font-bold text-blue-500 mb-2">500+</div>
                            <div className="text-sm text-slate-400 uppercase tracking-widest">Agents</div>
                        </div>
                        <div>
                            <div className="text-4xl font-bold text-blue-500 mb-2">12</div>
                            <div className="text-sm text-slate-400 uppercase tracking-widest">Global Offices</div>
                        </div>
                    </div>
                </div>
            </section>

            {/* Mission */}
            <section className="py-24 px-6">
                <div className="container mx-auto max-w-6xl">
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-16 items-center">
                        <div>
                            <img
                                src="https://images.unsplash.com/photo-1600880292203-757bb62b4baf?q=80&w=2670&auto=format&fit=crop"
                                alt="Meeting"
                                className="rounded-2xl shadow-xl"
                            />
                        </div>
                        <div>
                            <h2 className="text-3xl font-bold text-slate-900 mb-6">Our Mission</h2>
                            <p className="text-slate-600 text-lg leading-relaxed mb-6">
                                To dominate the luxury real estate market by providing unparalleled service, innovative technology, and a global network of buyers and sellers. We believe every home has a story, and we are here to tell it.
                            </p>
                            <ul className="space-y-4">
                                <li className="flex items-center gap-3 text-slate-700">
                                    <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center text-blue-600"><Award size={20} /></div>
                                    <span className="font-medium">Award-winning service</span>
                                </li>
                                <li className="flex items-center gap-3 text-slate-700">
                                    <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center text-blue-600"><Users size={20} /></div>
                                    <span className="font-medium">Client-centric approach</span>
                                </li>
                                <li className="flex items-center gap-3 text-slate-700">
                                    <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center text-blue-600"><Globe size={20} /></div>
                                    <span className="font-medium">Global reach</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    );
};
