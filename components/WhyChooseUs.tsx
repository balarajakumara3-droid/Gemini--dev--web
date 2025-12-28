import React from 'react';

export const WhyChooseUs: React.FC = () => {
    return (
        <section className="py-32 max-md:pt-[5rem] px-6 md:px-12 bg-surface relative z-10">
            <div className="max-w-7xl mx-auto">
                <div className="grid grid-cols-1 lg:grid-cols-12 gap-2 items-start">
                    <div className="lg:col-span-2">
                        <span className="block w-12 h-1 bg-accent mb-6 shadow-[0_0_10px_#818cf8]"></span>
                        <h4 className="text-secondary uppercase tracking-widest text-xs font-bold">Why Choose Us</h4>
                    </div>
                    <div className="lg:col-span-10">
                        <h2 className="text-3xl md:text-5xl leading-tight font-sans font-light text-primary mb-12">
                            Our <span className="font-serif italic text-accent">AI-powered</span> development process cuts build time in half while maintaining <span className="font-serif italic text-accent">enterprise-grade quality</span>. You get modern design, robust engineering, and transparent communication—built around your goals.
                        </h2>
                        <div className="grid grid-cols-2 md:grid-cols-4 gap-8 border-t border-white/10 pt-12">
                            <div className="group">
                                <div className="font-serif text-4xl text-white mb-2 group-hover:text-accent transition-colors">2x</div>
                                <div className="text-xs text-secondary uppercase tracking-wide">Faster Delivery</div>
                            </div>
                            <div className="group">
                                <div className="font-serif text-4xl text-white mb-2 group-hover:text-accent transition-colors">50+</div>
                                <div className="text-xs text-secondary uppercase tracking-wide">Products Shipped</div>
                            </div>
                            <div className="group">
                                <div className="font-serif text-4xl text-white mb-2 group-hover:text-accent transition-colors">CI/CD</div>
                                <div className="text-xs text-secondary uppercase tracking-wide">Automated Pipelines</div>
                            </div>
                            <div className="group">
                                <div className="font-serif text-4xl text-white mb-2 group-hover:text-accent transition-colors">100%</div>
                                <div className="text-xs text-secondary uppercase tracking-wide">Code Ownership</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    );
};
