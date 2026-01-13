import React from 'react';
import { XCircle } from 'lucide-react';

export const NotGoodFitSection: React.FC = () => {
    return (
        <section className="py-20 bg-background/50 border-t border-white/5">
            <div className="max-w-4xl mx-auto px-6 md:px-12">
                <div className="text-center mb-12">
                    <h2 className="text-2xl md:text-3xl font-bold text-white mb-4">We're Probably Not the Right Fit If...</h2>
                    <p className="text-secondary text-lg">
                        We value transparency. To save your time and ours, here are a few scenarios where we likely aren't the best match for your needs.
                    </p>
                </div>

                <div className="grid gap-6 md:grid-cols-2">
                    {[
                        {
                            title: "You need a website in 48 hours",
                            desc: "Our process prioritizes quality over speed. Typical projects take 4-8 weeks minimum."
                        },
                        {
                            title: "You're looking for the cheapest option",
                            desc: "We're not a budget agency. Our rates reflect senior-level engineering, not offshore outsourcing."
                        },
                        {
                            title: "You want a 'set it and forget it' solution",
                            desc: "We collaborate closely with clients. If you're not available for discovery calls and feedback cycles, we'll struggle to deliver."
                        },
                        {
                            title: "You need ongoing staff augmentation",
                            desc: "We build and ship complete products. We're not a staff augmentation service."
                        },
                        {
                            title: "You're exploring 10 agencies based on price",
                            desc: "We focus on fit, not competition. If price is your only decision factor, we're likely not aligned."
                        },
                        {
                            title: "You're not comfortable with AI",
                            desc: "AI is core to how we deliver speed. If you need every line hand-written from scratch, we're not the best match."
                        }
                    ].map((item, index) => (
                        <div key={index} className="flex items-start gap-4 p-6 rounded-xl bg-surface border border-white/5 hover:border-red-500/20 transition-colors group">
                            <div className="mt-1">
                                <XCircle className="w-5 h-5 text-red-500/70 group-hover:text-red-500 transition-colors" />
                            </div>
                            <div>
                                <h3 className="text-white font-semibold mb-2 group-hover:text-red-200 transition-colors">{item.title}</h3>
                                <p className="text-secondary text-sm leading-relaxed">{item.desc}</p>
                            </div>
                        </div>
                    ))}
                </div>
            </div>
        </section>
    );
};
