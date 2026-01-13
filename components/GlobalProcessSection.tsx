import React from 'react';
import { Sparkles, CheckCircle } from 'lucide-react';

const steps = [
    {
        step: 1,
        title: "Discovery Call",
        subtitle: "15-Minute Strategy Session",
        description: "We learn your vision, goals, and timeline. No-pressure consultation. If we're not the right fit, we'll tell you upfront."
    },
    {
        step: 2,
        title: "Fit Assessment",
        subtitle: "Internal Review",
        description: "We evaluate scope, technical feasibility, and alignment. If your project isn't a match for our expertise, we'll recommend alternatives."
    },
    {
        step: 3,
        title: "Proposal & Scoping",
        subtitle: "Custom Roadmap",
        description: "Custom proposal with clear deliverables and pricing. Pricing is custom and discussion-based—no one-size-fits-all estimates."
    },
    {
        step: 4,
        title: "Design & Prototyping",
        subtitle: "Visualizing the Solution",
        description: "UI/UX design and technical architecture. AI-accelerated prototyping means you see designs 50% faster. Engineers review every screen."
    },
    {
        step: 5,
        title: "Development & Iteration",
        subtitle: "Agile Build",
        description: "Weekly check-ins and full transparency. AI handles boilerplate; engineers focus on business logic and edge cases."
    },
    {
        step: 6,
        title: "Testing & QA",
        subtitle: "Rigorous Validation",
        description: "Automated testing and manual QA. You own the code. We deliver the repository, documentation, and deployment guide."
    },
    {
        step: 7,
        title: "Launch & Handoff",
        subtitle: "Go Live",
        description: "Deployment and monitoring. We stick around for 30 days post-launch to ensure smooth operation."
    }
];

export const GlobalProcessSection: React.FC = () => {
    return (
        <section className="py-20 bg-background border-t border-white/5">
            <div className="max-w-7xl mx-auto px-6 md:px-12">
                <div className="text-center mb-16">
                    <span className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-blue-500/10 border border-blue-500/20 text-sm text-blue-400 mb-6">
                        <Sparkles className="w-4 h-4" />
                        Transparent Process
                    </span>
                    <h2 className="text-4xl md:text-5xl font-bold text-white mb-6">How We Build</h2>
                    <p className="text-secondary text-lg max-w-2xl mx-auto">
                        A clear, transparent path from idea to launch. No black boxes. No surprises.
                    </p>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
                    {steps.map((item, index) => (
                        <div key={index} className="relative group">
                            <div className="bg-surface hover:bg-white/5 border border-white/5 hover:border-accent/30 p-8 rounded-2xl transition-all duration-300 h-full flex flex-col">
                                <div className="text-5xl font-bold text-white/10 mb-4 group-hover:text-accent/20 transition-colors">
                                    0{item.step}
                                </div>
                                <h3 className="text-xl font-bold text-white mb-1">{item.title}</h3>
                                <p className="text-accent text-xs font-semibold uppercase tracking-wider mb-4">{item.subtitle}</p>
                                <p className="text-secondary text-sm leading-relaxed">{item.description}</p>
                            </div>
                        </div>
                    ))}
                </div>
            </div>
        </section>
    );
};
