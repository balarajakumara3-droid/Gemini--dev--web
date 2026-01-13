import React from 'react';

export const HeroSection: React.FC = () => {
    return (
        <section className="relative pt-32 pb-20 md:pt-48 md:pb-32 overflow-hidden">
            {/* Abstract Background Elements */}
            <div className="absolute inset-0 z-0 opacity-20 pointer-events-none">
                <div className="absolute top-0 left-0 w-full h-full bg-[size:40px_40px] bg-grid-pattern [mask-image:linear-gradient(to_bottom,white,transparent)]" />
                <div className="absolute top-20 right-20 w-96 h-96 bg-blue-600/20 rounded-full blur-[100px]" />
                <div className="absolute bottom-20 left-10 w-72 h-72 bg-indigo-500/10 rounded-full blur-[80px]" />
            </div>

            <div className="relative z-10 max-w-7xl mx-auto px-6 text-center">
                <div className="inline-block mb-4 px-4 py-1.5 rounded-full border border-blue-500/30 bg-blue-500/10 text-blue-400 text-sm font-medium">
                    About Idea Manifest
                </div>
                <h1 className="text-5xl md:text-7xl font-bold text-white mb-8 tracking-tight">
                    Democratizing <br className="hidden md:block" />
                    <span className="font-serif italic text-blue-500">Premium Engineering</span>
                </h1>
                <p className="text-xl text-gray-400 max-w-2xl mx-auto leading-relaxed">
                    We're not an agency. We're a senior engineering team that uses AI to build software 50% faster. No fluff. No overhead. just code that works.
                </p>
            </div>
        </section>
    );
};
