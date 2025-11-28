import React from 'react';
import { motion } from 'framer-motion';
import { ArrowRight } from 'lucide-react';

interface ServiceCardProps {
    title: string;
    description: string;
    Icon: any;
}

export const ServiceCard: React.FC<ServiceCardProps> = ({ title, description, Icon }) => (
    <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        whileHover={{ y: -8, scale: 1.02 }}
        transition={{ duration: 0.3 }}
        className="group p-8 bg-surface border border-white/5 hover:border-accent/30 shadow-lg hover:shadow-indigo-500/10 transition-all duration-300 rounded-xl relative overflow-hidden"
    >
        <div className="absolute inset-0 bg-gradient-to-br from-accent/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
        <div className="w-12 h-12 bg-white/5 rounded-lg flex items-center justify-center text-accent mb-6 group-hover:scale-110 group-hover:bg-accent group-hover:text-background transition-all duration-300">
            <Icon size={24} strokeWidth={1.5} />
        </div>
        <h3 className="font-serif text-2xl text-primary font-medium mb-3 relative z-10">{title}</h3>
        <p className="text-secondary text-sm leading-relaxed mb-6 relative z-10">{description}</p>
        <a href="/services/" className="inline-flex items-center gap-2 text-accent text-xs font-bold uppercase tracking-widest hover:gap-3 transition-all relative z-10">
            Technical Details <ArrowRight size={14} />
        </a>
    </motion.div>
);
