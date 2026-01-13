import React from 'react';
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
                    {[
                        {
                            title: "Extreme Accountability",
                            description: "You speak directly to the engineer writing your code. No middlemen. No game of telephone. We take full responsibility for every deploy.",
                            aiNote: "AI writes the boilerplate; We own the architecture."
                        },
                        {
                            title: "Radical Transparency",
                            description: "We share our screen. We share our git repo. We share our challenges. You see the work happening in real-time, not just at 'demo day'.",
                            aiNote: "Real-time updates, no black boxes."
                        },
                        {
                            title: "100% Code Ownership",
                            description: "You own the IP from day one. No vendor lock-in. We build in your repository, so you can walk away with your asset at any time.",
                            aiNote: "Clean, documented code that AI helps us document."
                        }
                    ].map((val, idx) => (
                        <div
                            key={idx}
                            className="glass-card p-8 rounded-2xl border border-white/5 hover:border-blue-500/30 transition-all duration-300 group"
                        >
                            <div className="w-12 h-12 rounded-lg bg-blue-500/10 flex items-center justify-center mb-6 group-hover:bg-blue-600 transition-colors">
                                {/* Using simple generic icons or logic here involves imports, let's keep it simple or re-import icons if needed. 
                                    However, the original code used val.icon. I will remove the icon for simplicity or add standard ones if I import them.
                                    Actually, I should import CheckCircle or similar from lucide-react. 
                                    I will check imports first. The file originally didn't import icons, it used CORE_VALUES.
                                    I will import 'Shield', 'Eye', 'Lock' from lucide-react.
                                */}
                                <div className="text-blue-500 group-hover:text-white font-bold text-xl">
                                    0{idx + 1}
                                </div>
                            </div>
                            <h3 className="text-xl font-bold text-white mb-3">{val.title}</h3>
                            <p className="text-gray-400 leading-relaxed mb-4">
                                {val.description}
                            </p>
                            <div className="text-xs text-blue-400/80 border-t border-blue-500/10 pt-3 flex items-start gap-2">
                                <span className="font-semibold uppercase tracking-wider text-[10px] mt-0.5">AI Integ:</span>
                                <span>{val.aiNote}</span>
                            </div>
                        </div>
                    ))}
                </div>
            </div>
        </section>
    );
};
