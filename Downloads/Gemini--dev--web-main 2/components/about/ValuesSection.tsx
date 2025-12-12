import React from 'react';
import { CORE_VALUES } from '../../constants';
import { SectionHeading } from '../ui/SectionHeading';

export const ValuesSection: React.FC = () => {
    return (
        <section className="py-24 bg-[#080d19]">
            <div className="max-w-7xl mx-auto px-6">
                <SectionHeading
                    title="Our Core Values"
                    highlightWord="Values"
                    subtitle="We adapt our engineering velocity to match your stage of growth, from rapid MVP iteration to enterprise-grade stability."
                />

                <div className="grid md:grid-cols-3 gap-8">
                    {CORE_VALUES.map((val, idx) => (
                        <div
                            key={idx}
                            className="glass-card p-8 rounded-2xl border border-white/5 hover:border-blue-500/30 transition-all duration-300 group"
                        >
                            <div className="w-12 h-12 rounded-lg bg-blue-500/10 flex items-center justify-center mb-6 group-hover:bg-blue-600 transition-colors">
                                <val.icon className="w-6 h-6 text-blue-500 group-hover:text-white transition-colors" />
                            </div>
                            <h3 className="text-xl font-bold text-white mb-3">{val.title}</h3>
                            <p className="text-gray-400 leading-relaxed">
                                {val.description}
                            </p>
                        </div>
                    ))}
                </div>
            </div>
        </section>
    );
};
