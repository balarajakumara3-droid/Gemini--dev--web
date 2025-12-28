import React from 'react';
import { TechItem } from './types';
import { ArrowRight } from 'lucide-react';

interface TechCardProps {
    item: TechItem;
    align: 'left' | 'right';
    delay?: number;
    onLearnMore?: (item: TechItem) => void;
}

const TechCard: React.FC<TechCardProps> = ({ item, align, delay = 0, onLearnMore }) => {
    const isLeft = align === 'left';
    const brandColor = item.color || '#3b82f6';

    // Specific animations
    const isSpinning = ['react', 'react-native'].includes(item.id);
    const animationClass = isSpinning
        ? 'group-hover:animate-[spin_4s_linear_infinite]'
        : 'group-hover:scale-110 duration-300';

    return (
        <div
            className={`
        group flex items-center gap-3 md:gap-6 w-full transition-all duration-300 ease-out
        p-2.5 md:p-4 rounded-xl md:rounded-2xl border border-transparent hover:border-white/10 hover:bg-white/[0.02] hover:-translate-y-2 hover:shadow-lg hover:shadow-black/20
        ${isLeft ? 'flex-row md:flex-row-reverse text-left md:text-right' : 'flex-row text-left'}
      `}
            style={{ animationDelay: `${delay}ms` }}
        >
            {/* Icon Section */}
            <div className="flex-shrink-0 relative">
                {/* Glow Container (Behind) */}
                <div
                    className="absolute inset-0 rounded-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-500 blur-xl md:blur-2xl"
                    style={{ backgroundColor: `${brandColor}40` }} // 25% opacity
                />

                {/* Icon Base */}
                <div
                    className="relative z-10 w-12 h-12 md:w-20 md:h-20 rounded-xl md:rounded-2xl bg-white/5 border border-white/10 flex items-center justify-center backdrop-blur-sm shadow-xl transition-all duration-300 group-hover:bg-white/10 group-hover:border-white/30"
                    style={{
                        borderColor: 'rgba(255,255,255,0.1)'
                    }}
                >
                    {/* Active Border Overlay that appears on hover */}
                    <div
                        className="absolute inset-0 rounded-xl md:rounded-2xl border-2 opacity-0 group-hover:opacity-100 transition-opacity duration-300"
                        style={{ borderColor: brandColor }}
                    />

                    <div className={`transition-transform transform ${animationClass}`}>
                        <item.icon
                            className="w-6 h-6 md:w-10 md:h-10 transition-all duration-300 text-white group-hover:text-[var(--brand-color)]"
                            style={{
                                '--brand-color': brandColor,
                                color: 'currentColor'
                            } as React.CSSProperties}
                        />
                    </div>
                </div>
            </div>

            {/* Content Section */}
            <div className={`
        flex flex-col space-y-0.5 md:space-y-2 flex-1 min-w-0
        ${isLeft ? 'items-start md:items-end' : 'items-start'}
      `}>
                <h3
                    className="text-xs md:text-2xl font-extrabold md:font-bold text-white transition-colors duration-300 group-hover:text-[var(--brand-color)] truncate w-full"
                    style={{ '--brand-color': brandColor } as React.CSSProperties}
                >
                    {item.name}
                </h3>

                <p className="hidden md:block text-gray-400 text-xs md:text-sm leading-relaxed w-full md:max-w-[280px] font-medium group-hover:text-gray-300 transition-colors">
                    {item.description}
                </p>

                <button
                    onClick={() => onLearnMore?.(item)}
                    className={`
            group/btn hidden md:flex items-center gap-2 text-[10px] md:text-xs font-bold tracking-widest mt-1 md:mt-2 uppercase opacity-60 group-hover:opacity-100 transition-all duration-300
            ${isLeft ? 'flex-row' : 'flex-row md:flex-row-reverse'}
          `}
                    style={{ color: brandColor }}
                >
                    <span>Learn More</span>
                    <ArrowRight className={`w-3 h-3 md:w-3.5 md:h-3.5 transition-transform duration-300 ${isLeft ? 'group-hover/btn:translate-x-1' : 'group-hover/btn:-translate-x-1 rotate-180'}`} />
                </button>
            </div>
        </div>
    );
};

export default TechCard;

