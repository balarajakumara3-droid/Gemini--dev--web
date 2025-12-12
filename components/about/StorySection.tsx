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
                            Our <span className="font-serif italic text-blue-500">Philosophy</span>
                        </h2>
                        <div className="space-y-6 text-gray-400 text-lg leading-relaxed">
                            <p>
                                Idea Manifest started with a simple observation: dev cycles were too slow, and quality was often sacrificed for speed. We knew there had to be a better way.
                            </p>
                            <p>
                                Our core values center on <strong className="text-white">Client-Centricity</strong> and <strong className="text-white">Transparent Quality</strong>. We don't just write code; we build assets. Our agile, AI-powered process allows us to iterate fast, adapt to feedback, and deliver a polished product that scales with you.
                            </p>
                            <p>
                                Whether you're a startup sparking innovation or an enterprise scaling big, we bring your ideas to life — launch-ready, faster, and smarter.
                            </p>
                        </div>

                        <div className="mt-12 grid grid-cols-3 gap-6">
                            {STATS.map((stat, idx) => (
                                <div key={idx} className="border-l border-blue-500/30 pl-6">
                                    <div className="text-3xl font-bold text-white mb-1">{stat.value}</div>
                                    <div className="text-sm text-gray-500 uppercase tracking-wide">{stat.label}</div>
                                </div>
                            ))}
                        </div>
                    </div>

                    {/* Visual/Image Placeholder - Simulating the office/team vibe from reference */}
                    <div className="relative">
                        <div className="aspect-[4/5] md:aspect-square rounded-2xl overflow-hidden border border-white/10 relative group">
                            {/* Using a placeholder that fits the 'office' 'tech' vibe */}
                            <img
                                src="https://picsum.photos/800/800?grayscale"
                                alt="Our Team Working"
                                className="w-full h-full object-cover opacity-60 group-hover:opacity-80 transition-opacity duration-500"
                            />
                            <div className="absolute inset-0 bg-gradient-to-t from-[#050A14] via-transparent to-transparent" />

                            <div className="absolute bottom-8 left-8 right-8">
                                <div className="glass-card p-6 rounded-xl border border-white/10">
                                    <p className="text-white font-medium italic">
                                        "The team listened intently and understood the client's needs, enabling them to offer suggestions and complete tasks on time."
                                    </p>
                                    <div className="mt-4 flex items-center gap-3">
                                        <div className="w-8 h-8 rounded-full bg-blue-600 flex items-center justify-center text-xs font-bold">OC</div>
                                        <div className="text-sm">
                                            <div className="text-white font-bold">Obuli Chandran</div>
                                            <div className="text-gray-500 text-xs">Founder, Mango Education</div>
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
