import React, { useState } from 'react';
import { AccordionItem } from './faq/AccordionItem';
import { SectionHeading } from './ui/SectionHeading';

export const FaqSection: React.FC = () => {
    const [openFaq, setOpenFaq] = useState<number | null>(0);

    return (
        <section className="relative py-32 px-6 md:px-12 bg-background overflow-hidden relative z-10">
            <div className="max-w-4xl mx-auto relative z-10">
                <div className="text-center mb-16">
                    <SectionHeading title="Technical FAQ" highlight="FAQ" />
                    <p className="text-secondary max-w-2xl mx-auto text-lg mt-6">
                        Common questions about our process, technology, and delivery.
                    </p>
                </div>

                <div className="space-y-2">
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
        </section>
    );
};
