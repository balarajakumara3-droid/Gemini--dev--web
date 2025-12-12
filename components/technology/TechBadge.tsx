import React from 'react';

interface TechBadgeProps {
    name: string;
    Icon: any;
}

export const TechBadge: React.FC<TechBadgeProps> = ({ name, Icon }) => (
    <div className="flex flex-row items-center gap-4 p-5 bg-surface rounded-xl border border-white/5 hover:border-accent/50 hover:shadow-[0_0_20px_rgba(129,140,248,0.15)] hover:-translate-y-1 transition-all duration-300 cursor-default group w-full">
        <Icon size={24} className="text-secondary group-hover:text-accent transition-colors shrink-0" strokeWidth={1.5} />
        <span className="font-medium text-sm md:text-base text-primary group-hover:text-white transition-colors">{name}</span>
    </div>
);
