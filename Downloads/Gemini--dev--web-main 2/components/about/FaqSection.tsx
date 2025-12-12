import React, { useState } from 'react';
import { FAQS } from '../../constants';
import { ArrowRight } from 'lucide-react';

export const FaqSection: React.FC = () => {
    const [openIndex, setOpenIndex] = useState<number | null>(0);

    return (
        <section id="faq" className="py-24 bg-[#080d19]">
            <div className="max-w-7xl mx-auto px-6 grid md:grid-cols-12 gap-12">
                <div className="md:col-span-4">
                    <h2 className="text-4xl font-bold text-white mb-6">
                        Technical <span className="font-serif italic text-blue-500">FAQ</span>
                    </h2>
                    <a href="/faq" className="inline-flex items-center gap-2 text-gray-300 hover:text-white transition-colors text-sm font-medium">
                        View All FAQs <ArrowRight className="w-4 h-4" />
                    </a>
                </div>

                <div className="md:col-span-8 space-y-4">
                    {FAQS.map((faq, idx) => {
                        const isOpen = openIndex === idx;
                        return (
                            <div
                                key={idx}
                                className="border-b border-white/10 pb-4"
                            >
                                <button
                                    className="w-full flex items-center justify-between py-4 text-left group"
                                    onClick={() => setOpenIndex(isOpen ? null : idx)}
                                >
                                    <span className={`text-xl font-serif ${isOpen ? 'text-blue-400 italic' : 'text-gray-200'}`}>
                                        {faq.question}
                                    </span>
                                    <div className={`w-8 h-8 rounded-full flex items-center justify-center border transition-all ${isOpen ? 'bg-blue-600 border-blue-600 text-white rotate-0' : 'border-white/20 text-gray-400 group-hover:border-white/40 -rotate-90'}`}>
                                        <ArrowRight className="w-4 h-4" />
                                    </div>
                                </button>
                                <div
                                    className={`overflow-hidden transition-all duration-300 ${isOpen ? 'max-h-48 opacity-100' : 'max-h-0 opacity-0'}`}
                                >
                                    <p className="text-gray-400 pb-6 pr-12 leading-relaxed">
                                        {faq.answer}
                                    </p>
                                </div>
                            </div>
                        );
                    })}
                </div>
            </div>
        </section>
    );
};
