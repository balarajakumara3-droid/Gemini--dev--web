import React, { useState } from 'react';
import CenterBulb from './CenterBulb';
import TechCard from './TechCard';
import TechModal from './TechModal';
import { TechItem } from './types';
import {
    ReactIcon,
    NextJsIcon,
    NodeJsIcon,
    FlutterIcon,
    SwiftIcon,
    PythonIcon,
    KotlinIcon,
    FastApiIcon,
    SupabaseIcon
} from './icons';

const TECH_STACK: TechItem[] = [
    // Left Column (5 items)
    {
        id: 'react',
        name: 'React',
        description: 'A component-based library for creating dynamic and interactive user interfaces using JavaScript.',
        icon: ReactIcon,
        category: 'Frontend',
        color: '#61dafb'
    },
    {
        id: 'nextjs',
        name: 'Next.js',
        description: 'A full-stack web development platform focused on performance, routing, and production-ready web applications.',
        icon: NextJsIcon,
        category: 'Frontend',
        color: '#ffffff'
    },
    {
        id: 'nodejs',
        name: 'Node.js',
        description: 'A server-side JavaScript runtime designed for building fast, scalable, and event-driven applications.',
        icon: NodeJsIcon,
        category: 'Backend',
        color: '#339933'
    },
    {
        id: 'flutter',
        name: 'Flutter',
        description: 'A cross-platform development toolkit for building visually rich applications from a single codebase.',
        icon: FlutterIcon,
        category: 'Mobile',
        color: '#47C5FB'
    },
    {
        id: 'swift',
        name: 'Swift',
        description: 'A modern programming language created by Apple for building high-performance native applications.',
        icon: SwiftIcon,
        category: 'Mobile',
        color: '#F05138'
    },

    // Right Column (5 items)
    {
        id: 'python',
        name: 'Python',
        description: 'A general-purpose programming language valued for its simplicity, readability, and broad ecosystem.',
        icon: PythonIcon,
        category: 'Backend',
        color: '#FFD43B'
    },
    {
        id: 'kotlin',
        name: 'Kotlin',
        description: 'A concise and type-safe programming language commonly used for modern Android application development.',
        icon: KotlinIcon,
        category: 'Mobile',
        color: '#7f52ff'
    },
    {
        id: 'react-native',
        name: 'React Native',
        description: 'A mobile development solution for creating native applications using shared JavaScript logic.',
        icon: ReactIcon,
        category: 'Mobile',
        color: '#61dafb'
    },
    {
        id: 'fastapi',
        name: 'FastAPI',
        description: 'A lightweight Python framework optimized for building fast, reliable, and scalable API services.',
        icon: FastApiIcon,
        category: 'Backend',
        color: '#009688'
    },
    {
        id: 'supabase',
        name: 'Supabase',
        description: 'An open-source backend platform offering databases, authentication, and real-time data services.',
        icon: SupabaseIcon,
        category: 'Backend',
        color: '#3ecf8e'
    },
];


import { motion } from 'framer-motion';

export const CentralTechStack: React.FC = () => {
    const [selectedTech, setSelectedTech] = useState<TechItem | null>(null);
    const [isModalOpen, setIsModalOpen] = useState(false);

    const handleLearnMore = (tech: TechItem) => {
        setSelectedTech(tech);
        setIsModalOpen(true);
    };

    const handleCloseModal = () => {
        setIsModalOpen(false);
        setSelectedTech(null);
    };

    const midPoint = Math.ceil(TECH_STACK.length / 2);
    const leftItems = TECH_STACK.slice(0, midPoint);
    const rightItems = TECH_STACK.slice(midPoint);

    const containerVariants = {
        hidden: { opacity: 0 },
        visible: {
            opacity: 1,
            transition: {
                staggerChildren: 0.1,
                delayChildren: 0.2
            }
        }
    };

    const itemVariants = {
        hidden: { opacity: 0, y: 20 },
        visible: {
            opacity: 1,
            y: 0,
            transition: { duration: 0.5, ease: "easeOut" }
        }
    };

    const centerVariants = {
        hidden: { opacity: 0, scale: 0.8 },
        visible: {
            opacity: 1,
            scale: 1,
            transition: { duration: 0.8, ease: "easeOut", delay: 0.4 }
        }
    };

    return (
        <>
            <div className="w-full max-w-[90rem] mx-auto px-1 sm:px-6 lg:px-8">
                <motion.div
                    className="flex flex-row items-center lg:items-stretch justify-center relative"
                    variants={containerVariants}
                    initial="hidden"
                    whileInView="visible"
                    viewport={{ once: true }}
                >

                    {/* Left Column */}
                    <div className="w-[38%] md:w-5/12 flex flex-col justify-center gap-4 md:gap-6 lg:gap-10 py-2 lg:py-6">
                        {leftItems.map((item, index) => (
                            <motion.div key={item.id} variants={itemVariants}>
                                <TechCard
                                    item={item}
                                    align="left"
                                    delay={index * 100}
                                    onLearnMore={handleLearnMore}
                                />
                            </motion.div>
                        ))}
                    </div>

                    {/* Center Column (Bulb) */}
                    <motion.div className="w-[24%] md:w-2/12 flex justify-center items-center my-0 relative" variants={centerVariants}>
                        <div className="scale-[0.6] md:scale-100">
                            <CenterBulb />
                        </div>
                    </motion.div>

                    {/* Right Column */}
                    <div className="w-[38%] md:w-5/12 flex flex-col justify-center gap-4 md:gap-6 lg:gap-10 py-2 lg:py-6">
                        {rightItems.map((item, index) => (
                            <motion.div key={item.id} variants={itemVariants}>
                                <TechCard
                                    item={item}
                                    align="right"
                                    delay={(index + midPoint) * 100}
                                    onLearnMore={handleLearnMore}
                                />
                            </motion.div>
                        ))}
                    </div>

                </motion.div>
            </div>

            {/* Tech Modal */}
            <TechModal
                isOpen={isModalOpen}
                onClose={handleCloseModal}
                tech={selectedTech}
            />
        </>
    );
};
