import React from 'react';
import { Lightbulb } from 'lucide-react';

const CenterBulb: React.FC = () => {
    return (
        <div className="relative flex items-center justify-center z-20" style={{ transform: 'translateZ(0)' }}>
            {/* Container Size & Hover Group Trigger */}
            <div className="relative w-16 h-16 md:w-56 md:h-56 lg:w-64 lg:h-64 flex items-center justify-center group cursor-pointer">

                {/* Pulsing Outer Rings - Optimized with will-change */}
                <div
                    className="absolute inset-0 rounded-full border border-yellow-500/20 animate-[ping_3s_ease-in-out_infinite] group-hover:border-yellow-500/30 transition-colors duration-500"
                    style={{ willChange: 'transform, opacity' }}
                />
                <div
                    className="absolute inset-4 rounded-full border border-yellow-500/30 animate-[ping_3s_ease-in-out_infinite_0.5s] group-hover:border-yellow-500/40 transition-colors duration-500"
                    style={{ willChange: 'transform, opacity' }}
                />

                {/* Simplified Ambient Glow - Using box-shadow instead of blur for better performance */}
                <div
                    className="absolute inset-0 bg-yellow-600/10 rounded-full transition-all duration-500 ease-out group-hover:scale-105"
                    style={{
                        boxShadow: '0 0 60px rgba(234, 179, 8, 0.3)',
                        willChange: 'transform',
                        transform: 'translateZ(0)'
                    }}
                />

                {/* Main Circle Background - GPU accelerated */}
                <div
                    className="relative z-10 w-10 h-10 md:w-36 md:h-36 lg:w-40 lg:h-40 bg-gradient-to-br from-yellow-500 to-orange-600 rounded-full shadow-[0_0_20px_rgba(234,179,8,0.4)] md:shadow-[0_0_40px_rgba(234,179,8,0.4)] flex items-center justify-center transition-all duration-500 ease-out group-hover:scale-105 group-hover:shadow-[0_0_40px_rgba(234,179,8,0.5)] pointer-events-auto"
                    style={{ willChange: 'transform', transform: 'translateZ(0)' }}
                >

                    {/* Inner Glow Gradient */}
                    <div className="absolute inset-0 rounded-full bg-gradient-to-t from-black/20 to-transparent pointer-events-none" />

                    {/* Icon */}
                    <Lightbulb
                        className="w-5 h-5 md:w-16 md:h-16 lg:w-20 lg:h-20 text-white drop-shadow-md transition-transform duration-500 ease-out group-hover:scale-110"
                        strokeWidth={1.5}
                    />

                    {/* Internal Detail Ring (Expands from center) */}
                    <div className="absolute w-6 h-6 md:w-24 md:h-24 border border-white/20 rounded-full scale-0 opacity-0 group-hover:scale-100 group-hover:opacity-100 transition-all duration-500 ease-out" />
                </div>
            </div>
        </div>
    );
};

export default CenterBulb;
