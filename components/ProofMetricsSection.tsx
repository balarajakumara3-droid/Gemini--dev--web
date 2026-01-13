import React from 'react';
import { motion } from 'framer-motion';
import { ShieldCheck, TrendingUp, Zap, Code2 } from 'lucide-react';

const MetricCard = ({ icon: Icon, value, label }: { icon: any, value: string, label: string }) => (
    <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ duration: 0.5 }}
        className="bg-surface/50 backdrop-blur-sm border border-white/5 rounded-xl p-6 flex flex-col items-center text-center hover:border-accent/30 transition-colors"
    >
        <div className="bg-accent/10 p-3 rounded-full mb-4">
            <Icon className="w-6 h-6 text-accent" />
        </div>
        <h3 className="text-3xl font-bold text-white mb-2">{value}</h3>
        <p className="text-secondary text-sm font-medium">{label}</p>
    </motion.div>
);

export const ProofMetricsSection: React.FC = () => {
    return (
        <section className="py-12 bg-background border-b border-white/5">
            <div className="max-w-7xl mx-auto px-6 md:px-12">
                <div className="text-center mb-10">
                    <h2 className="text-2xl md:text-3xl font-bold text-white mb-2">Trusted By Startups, Built For Scale</h2>
                    <p className="text-secondary">Delivering measurable impact, not just code.</p>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <MetricCard
                        icon={TrendingUp}
                        value="40%"
                        label="Increase in User Engagement"
                    />
                    <MetricCard
                        icon={Zap}
                        value="2X"
                        label="Faster Time-to-Market"
                    />
                    <MetricCard
                        icon={ShieldCheck}
                        value="50k+"
                        label="App Downloads Generated"
                    />
                    <MetricCard
                        icon={Code2}
                        value="100%"
                        label="Code Ownership"
                    />
                </div>
            </div>
        </section>
    );
};
