import React from 'react';
import { SERVICES } from '../../constants';
import { ArrowRight } from 'lucide-react';

export const CapabilitiesSection: React.FC = () => {
    return (
        <section id="services" className="py-24 bg-[#050A14]">
            <div className="max-w-7xl mx-auto px-6">
                <div className="flex flex-col md:flex-row md:items-end justify-between mb-12">
                    <div className="max-w-2xl">
                        <h2 className="text-4xl md:text-5xl font-bold text-white mb-4">
                            Core <span className="font-serif italic text-blue-500">Capabilities</span>
                        </h2>
                        <p className="text-gray-400 text-lg">
                            End-to-end development from architecture to deployment.
                        </p>
                    </div>
                    <a href="/services" className="hidden md:flex items-center gap-2 text-white font-medium hover:text-blue-400 transition-colors mt-6 md:mt-0">
                        View Technical Docs <ArrowRight className="w-4 h-4" />
                    </a>
                </div>

                <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                    {SERVICES.map((service, idx) => (
                        <div
                            key={idx}
                            className="glass-card p-8 rounded-xl hover:bg-white/[0.02] transition-colors group"
                        >
                            <div className="w-10 h-10 rounded border border-blue-500/20 bg-blue-500/5 flex items-center justify-center mb-6 text-blue-400">
                                <service.icon className="w-5 h-5" />
                            </div>
                            <h3 className="text-xl font-bold text-white mb-3">{service.title}</h3>
                            <p className="text-sm text-gray-400 mb-6 leading-relaxed">
                                {service.description}
                            </p>
                            <a href="/services" className="flex items-center text-blue-500 text-xs font-bold tracking-wider uppercase gap-2 group-hover:gap-3 transition-all cursor-pointer">
                                Technical Details <ArrowRight className="w-3 h-3" />
                            </a>
                        </div>
                    ))}
                </div>
            </div>
        </section>
    );
};
