import React from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { X } from 'lucide-react';
import { TechItem } from './types';

interface TechModalProps {
    isOpen: boolean;
    onClose: () => void;
    tech: TechItem | null;
}

// Extended descriptions for modal popup
const techDescriptions: Record<string, string> = {
    'react': 'A modern JavaScript library used to build fast, interactive, and scalable user interfaces for web applications.',
    'nextjs': 'A React framework that helps build high-performance, SEO-friendly websites and scalable web applications.',
    'nodejs': 'A powerful JavaScript runtime for building fast, scalable server-side applications and APIs.',
    'flutter': 'A cross-platform framework used to build fast, beautiful mobile apps for both iOS and Android from a single codebase.',
    'swift': "Apple's official programming language for building secure and high-performance iOS, iPadOS, and macOS applications.",
    'python': 'A versatile programming language commonly used for backend development, APIs, automation, and data-driven applications.',
    'kotlin': 'A modern programming language used for building reliable and high-performance Android applications.',
    'react-native': 'A framework for building native mobile apps using React, enabling code sharing between iOS and Android platforms.',
    'fastapi': 'A modern, high-performance Python web framework for building APIs with automatic documentation and validation.',
    'supabase': 'An open-source backend platform that provides authentication, databases, and APIs to quickly build scalable applications.',
};

export const TechModal: React.FC<TechModalProps> = ({ isOpen, onClose, tech }) => {
    if (!tech) return null;

    const description = techDescriptions[tech.id] || tech.description;

    return (
        <AnimatePresence>
            {isOpen && (
                <>
                    {/* Backdrop */}
                    <motion.div
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        onClick={onClose}
                        className="fixed inset-0 bg-black/70 backdrop-blur-sm z-50"
                    />

                    {/* Modal */}
                    <motion.div
                        initial={{ opacity: 0, scale: 0.9, y: 20 }}
                        animate={{ opacity: 1, scale: 1, y: 0 }}
                        exit={{ opacity: 0, scale: 0.9, y: 20 }}
                        transition={{ type: 'spring', damping: 25, stiffness: 300 }}
                        className="fixed left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 z-50 w-[90%] max-w-md"
                    >
                        <div
                            className="bg-surface border border-white/10 rounded-2xl p-8 shadow-2xl"
                            style={{ boxShadow: `0 0 60px ${tech.color}20` }}
                        >
                            {/* Close Button */}
                            <button
                                onClick={onClose}
                                className="absolute top-4 right-4 p-2 rounded-full bg-white/5 hover:bg-white/10 transition-colors group"
                            >
                                <X className="w-5 h-5 text-gray-400 group-hover:text-white transition-colors" />
                            </button>

                            {/* Icon */}
                            <div
                                className="w-16 h-16 rounded-xl bg-white/5 border border-white/10 flex items-center justify-center mb-6"
                                style={{ borderColor: `${tech.color}40` }}
                            >
                                <tech.icon
                                    className="w-8 h-8"
                                    style={{ color: tech.color }}
                                />
                            </div>

                            {/* Category Badge */}
                            <span
                                className="inline-block px-3 py-1 rounded-full text-xs font-semibold uppercase tracking-wider mb-4"
                                style={{
                                    backgroundColor: `${tech.color}15`,
                                    color: tech.color
                                }}
                            >
                                {tech.category}
                            </span>

                            {/* Title */}
                            <h3
                                className="text-2xl font-bold text-white mb-4"
                                style={{ color: tech.color }}
                            >
                                {tech.name}
                            </h3>

                            {/* Description */}
                            <p className="text-gray-300 leading-relaxed text-base">
                                {description}
                            </p>
                        </div>
                    </motion.div>
                </>
            )}
        </AnimatePresence>
    );
};

export default TechModal;
