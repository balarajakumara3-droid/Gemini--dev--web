import React from 'react';
import { STATS } from '../../constants';

export const StorySection: React.FC = () => {
    return (
        <section className="py-24 bg-[#050A14] relative">
            <div className="max-w-7xl mx-auto px-6">
                <div className="grid md:grid-cols-2 gap-16 items-center">

                    {/* Content */}
                    <div>
                        <h2 className="text-4xl font-bold text-white mb-6">
                            A Note From <span className="font-serif italic text-blue-500">The Team</span>
                        </h2>
                        <div className="space-y-6 text-gray-400 text-lg leading-relaxed">
                            <p>
                                We are builders, not salespeople. We don't have account managers. We don't have a ping-pong table. We definitely don't have a "sales pipeline."
                            </p>
                            <p>
                                <strong className="text-white">We just build software.</strong>
                            </p>
                            <p>
                                We rely on seniority and AI to move fast. Seniority means we don't make rookie mistakes. AI means we don't waste time on boilerplate.
                                This combination allows us to deliver enterprise-grade quality at startup speed.
                            </p>
                            <p>
                                When you hire us, you're not hiring a "vendor." You're hiring a dedicated engineering team that cares about your product as much as you do.
                            </p>
                        </div>
                    </div>

                    {/* Visual/Image Placeholder */}
                    <div className="relative">
                        <div className="aspect-[4/5] md:aspect-square rounded-2xl overflow-hidden border border-white/10 relative group">
                            {/* Using a placeholder that fits the 'office' 'tech' vibe */}
                            <img
                                src="https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&q=80"
                                alt="Our Team Working"
                                className="w-full h-full object-cover opacity-60 group-hover:opacity-80 transition-opacity duration-500"
                            />
                            <div className="absolute inset-0 bg-gradient-to-t from-[#050A14] via-transparent to-transparent" />

                            <div className="absolute bottom-8 left-8 right-8">
                                <div className="glass-card p-6 rounded-xl border border-white/10">
                                    <p className="text-white font-medium italic">
                                        "They didn't just take requirements; they challenged our assumptions and built something better than we imagined."
                                    </p>
                                    <div className="mt-4 flex items-center gap-3">
                                        <div className="w-8 h-8 rounded-full bg-blue-600 flex items-center justify-center text-xs font-bold">OC</div>
                                        <div className="text-sm">
                                            <div className="text-white font-bold">Confidential Client</div>
                                            <div className="text-gray-500 text-xs">Healthcare Startup Founder</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        {/* Decorative element */}
                        <div className="absolute -z-10 -top-10 -right-10 w-full h-full border border-blue-500/20 rounded-2xl" />
                    </div>

                </div>
            </div>
        </section>
    );
};
