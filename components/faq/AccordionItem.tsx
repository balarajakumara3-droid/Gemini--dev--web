import React from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { ChevronDown } from 'lucide-react';

interface AccordionItemProps {
    question: string;
    answer: string;
    isOpen: boolean;
    onClick: () => void;
}

export const AccordionItem: React.FC<AccordionItemProps> = ({ question, answer, isOpen, onClick }) => (
    <div className="border-b border-white/10 last:border-0">
        <button
            className="w-full py-6 flex justify-between items-center text-left hover:text-accent transition-colors group"
            onClick={onClick}
        >
            <span className={`font-serif text-xl md:text-2xl transition-colors duration-300 ${isOpen ? 'text-accent italic' : 'text-primary group-hover:text-white'}`}>{question}</span>
            <div className={`w-8 h-8 rounded-full flex items-center justify-center border transition-all duration-300 ${isOpen ? 'bg-accent border-accent text-background' : 'border-white/20 text-white/50 group-hover:border-accent group-hover:text-accent'}`}>
                <ChevronDown size={16} className={`transition-transform duration-300 ${isOpen ? 'rotate-180' : 'rotate-0'}`} />
            </div>
        </button>
        <AnimatePresence>
            {isOpen && (
                <motion.div
                    initial={{ height: 0, opacity: 0 }}
                    animate={{ height: 'auto', opacity: 1 }}
                    exit={{ height: 0, opacity: 0 }}
                    transition={{ duration: 0.3 }}
                >
                    <div className="pb-8 pt-2 text-secondary leading-relaxed max-w-2xl">
                        {answer}
                    </div>
                </motion.div>
            )}
        </AnimatePresence>
    </div>
);
