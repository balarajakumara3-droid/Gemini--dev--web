import React from 'react';
import { Mail, Phone, Instagram, Linkedin, Twitter } from 'lucide-react';

const agents = [
    {
        name: 'Sarah Anderson',
        role: 'Senior Luxury Agent',
        image: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=2576&auto=format&fit=crop',
        phone: '+1 (555) 123-4567',
        email: 'sarah.anderson@luxeestate.demo',
        bio: 'With over 15 years of experience in the luxury market, Sarah has a reputation for closing record-breaking deals in Beverly Hills.',
    },
    {
        name: 'Michael Roberts',
        role: 'Penthouse Specialist',
        image: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=2574&auto=format&fit=crop',
        phone: '+1 (555) 987-6543',
        email: 'michael.roberts@luxeestate.demo',
        bio: 'Michael specializes in high-rise luxury living, offering clients exclusive access to the most sought-after penthouses in Manhattan.',
    },
    {
        name: 'Emily Chen',
        role: 'Coastal Property Expert',
        image: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?q=80&w=2561&auto=format&fit=crop',
        phone: '+1 (555) 234-5678',
        email: 'emily.chen@luxeestate.demo',
        bio: 'Emily brings a deep love for the ocean and unparalleled knowledge of the Malibu coastline to help you find your perfect beach home.',
    },
    {
        name: 'David Wilson',
        role: 'Historic Homes Specialist',
        image: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=2670&auto=format&fit=crop',
        phone: '+1 (555) 876-5432',
        email: 'david.wilson@luxeestate.demo',
        bio: 'Passionate about architectural history, David is the go-to expert for restoring and acquiring historic brownstones in Boston.',
    },
];

export const RealEstateAgents: React.FC = () => {
    return (
        <div className="bg-white min-h-screen py-20 px-6">
            <div className="container mx-auto">
                <div className="text-center mb-16">
                    <h1 className="text-4xl font-bold text-slate-900 mb-4">Meet Our Agents</h1>
                    <p className="text-slate-500 max-w-2xl mx-auto">
                        Our team of dedicated professionals is here to guide you through every step of your real estate journey.
                    </p>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
                    {agents.map((agent) => (
                        <div key={agent.name} className="group bg-slate-50 rounded-2xl overflow-hidden hover:shadow-lg transition-shadow duration-300">
                            <div className="aspect-[3/4] overflow-hidden">
                                <img
                                    src={agent.image}
                                    alt={agent.name}
                                    className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
                                />
                            </div>
                            <div className="p-6">
                                <h3 className="text-xl font-bold text-slate-900 mb-1">{agent.name}</h3>
                                <p className="text-blue-600 text-sm font-medium mb-4">{agent.role}</p>
                                <p className="text-slate-500 text-sm mb-6 line-clamp-3">{agent.bio}</p>

                                <div className="flex items-center gap-3 text-slate-400">
                                    <button className="hover:text-blue-600 transition-colors"><Mail size={18} /></button>
                                    <button className="hover:text-blue-600 transition-colors"><Phone size={18} /></button>
                                    <div className="flex-1" />
                                    <button className="hover:text-blue-600 transition-colors"><Linkedin size={18} /></button>
                                </div>
                            </div>
                        </div>
                    ))}
                </div>
            </div>
        </div>
    );
};
