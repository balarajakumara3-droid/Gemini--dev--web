import React, { useState } from 'react';
import { AccordionItem } from './faq/AccordionItem';

export const WhyChooseUs: React.FC = () => {
    const [openFaq, setOpenFaq] = useState<number | null>(0);

    return (
        <section id="faq" className="py-32 max-md:pt-[5rem] px-6 md:px-12 bg-surface relative z-10">
            <div className="max-w-7xl mx-auto">
                <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
                    <div className="lg:col-span-2">
                        <span className="block w-12 h-1 bg-accent mb-6 shadow-[0_0_10px_#818cf8]"></span>
                        <h4 className="text-secondary uppercase tracking-widest text-xs font-bold">Why Choose Us</h4>
                    </div>
                    <div className="lg:col-span-10">
                        <h2 className="text-3xl md:text-5xl leading-tight font-sans font-light text-primary mb-12">
                            Our <span className="font-serif italic text-accent">AI-powered</span> development process cuts build time in half while maintaining <span className="font-serif italic text-accent">enterprise-grade quality</span>. You get modern design, robust engineering, and transparent communication—built around your goals.
                        </h2>
                        <div className="grid grid-cols-2 md:grid-cols-4 gap-8 border-t border-white/10 pt-12 mb-20">
                            <div className="group">
                                <div className="font-serif text-4xl text-white mb-2 group-hover:text-accent transition-colors">2x</div>
                                <div className="text-xs text-secondary uppercase tracking-wide">Faster Delivery</div>
                            </div>
                            <div className="group">
                                <div className="font-serif text-4xl text-white mb-2 group-hover:text-accent transition-colors">50+</div>
                                <div className="text-xs text-secondary uppercase tracking-wide">Products Shipped</div>
                            </div>
                            <div className="group">
                                <div className="font-serif text-4xl text-white mb-2 group-hover:text-accent transition-colors">CI/CD</div>
                                <div className="text-xs text-secondary uppercase tracking-wide">Automated Pipelines</div>
                            </div>
                            <div className="group">
                                <div className="font-serif text-4xl text-white mb-2 group-hover:text-accent transition-colors">100%</div>
                                <div className="text-xs text-secondary uppercase tracking-wide">Code Ownership</div>
                            </div>
                        </div>

                        {/* FAQ Section */}
                        <div className="max-w-3xl border-t border-white/10 pt-16">
                            <h3 className="text-2xl md:text-4xl font-serif text-primary mb-8">Technical FAQ</h3>
                            <div className="space-y-4">
                                <AccordionItem
                                    question="What is your typical tech stack?"
                                    answer="We are stack-agnostic but prefer modern, typed ecosystems. Our go-to stack typically involves React/Next.js for frontend, Python (FastAPI/Django) or Node.js for backend, and PostgreSQL for database, deployed on AWS or Azure."
                                    isOpen={openFaq === 0}
                                    onClick={() => setOpenFaq(openFaq === 0 ? null : 0)}
                                />
                                <AccordionItem
                                    question="How fast can you deliver an MVP?"
                                    answer="By leveraging AI code generation and pre-built modules, we can often ship a functional MVP in 4-6 weeks. This includes core feature development, testing, and deployment setup."
                                    isOpen={openFaq === 1}
                                    onClick={() => setOpenFaq(openFaq === 1 ? null : 1)}
                                />
                                <AccordionItem
                                    question="Do you handle mobile app deployment?"
                                    answer="Yes, we handle the entire submission process for both the Apple App Store and Google Play Store, ensuring compliance with their review guidelines."
                                    isOpen={openFaq === 2}
                                    onClick={() => setOpenFaq(openFaq === 2 ? null : 2)}
                                />
                                <AccordionItem
                                    question="How do you handle source code ownership?"
                                    answer="You own 100% of the code we write. Upon project completion and final payment, we transfer all repositories and IP rights directly to your organization."
                                    isOpen={openFaq === 3}
                                    onClick={() => setOpenFaq(openFaq === 3 ? null : 3)}
                                />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    );
};
