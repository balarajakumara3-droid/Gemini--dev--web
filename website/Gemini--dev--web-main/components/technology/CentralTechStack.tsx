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
        description: 'A JavaScript library for building user interfaces with component-based architecture.',
        icon: ReactIcon,
        category: 'Frontend',
        color: '#61dafb' // React Blue
    },
    {
        id: 'nextjs',
        name: 'Next.js',
        description: 'The React Framework for the web, enabling server-side rendering and static site generation.',
        icon: NextJsIcon,
        category: 'Frontend',
        color: '#ffffff' // White
    },
    {
        id: 'nodejs',
        name: 'Node.js',
        description: 'JavaScript runtime built on Chrome\'s V8 engine for building scalable network applications.',
        icon: NodeJsIcon,
        category: 'Backend',
        color: '#339933' // Node Green
    },
    {
        id: 'flutter',
        name: 'Flutter',
        description: 'Google\'s UI toolkit for building natively compiled applications for mobile, web, and desktop.',
        icon: FlutterIcon,
        category: 'Mobile',
        color: '#47C5FB' // Flutter Blue
    },
    {
        id: 'swift',
        name: 'Swift',
        description: 'A powerful and intuitive programming language for iOS, iPadOS, macOS, tvOS, and watchOS.',
        icon: SwiftIcon,
        category: 'Mobile',
        color: '#F05138' // Swift Orange
    },

    // Right Column (5 items)
    {
        id: 'python',
        name: 'Python',
        description: 'A versatile programming language known for its readability and vast ecosystem of libraries.',
        icon: PythonIcon,
        category: 'Backend',
        color: '#FFD43B' // Python Yellow/Blue
    },
    {
        id: 'kotlin',
        name: 'Kotlin',
        description: 'A modern, concise, and safe programming language for Android development.',
        icon: KotlinIcon,
        category: 'Mobile',
        color: '#7f52ff' // Kotlin Purple
    },
    {
        id: 'react-native',
        name: 'React Native',
        description: 'Create native apps for Android and iOS using React\'s framework.',
        icon: ReactIcon,
        category: 'Mobile',
        color: '#61dafb' // React Blue
    },
    {
        id: 'fastapi',
        name: 'FastAPI',
        description: 'Modern, high-performance web framework for building APIs with Python 3.8+.',
        icon: FastApiIcon,
        category: 'Backend',
        color: '#009688' // FastAPI Teal
    },
    {
        id: 'supabase',
        name: 'Supabase',
        description: 'The open source Firebase alternative. Instantly scalable backend.',
        icon: SupabaseIcon,
        category: 'Backend',
        color: '#3ecf8e' // Supabase Green
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
                    <div className="w-5/12 flex flex-col justify-center gap-2 md:gap-6 lg:gap-10 py-2 lg:py-6">
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
                    <motion.div className="w-2/12 flex justify-center items-center my-0 relative" variants={centerVariants}>
                        <CenterBulb />
                    </motion.div>

                    {/* Right Column */}
                    <div className="w-5/12 flex flex-col justify-center gap-2 md:gap-6 lg:gap-10 py-2 lg:py-6">
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
