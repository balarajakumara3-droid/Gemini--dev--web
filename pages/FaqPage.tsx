import React, { useState } from 'react';
import { Helmet } from 'react-helmet-async';
import { AccordionItem } from '../components/faq/AccordionItem';
import { ParticleBackground } from '../components/ParticleBackground';
import { SectionHeading } from '../components/ui/SectionHeading';

export const FaqPage: React.FC = () => {
    const [openFaq, setOpenFaq] = useState<number | null>(0);

    return (
        <div className="bg-background text-primary min-h-screen selection:bg-accent selection:text-white overflow-x-hidden font-sans">
            <Helmet>
                <title>FAQ | Idea Manifest – Common Questions Answered</title>
                <meta name="description" content="Find answers to common questions about our services, pricing, development process, and how we use AI to accelerate your project." />
                <link rel="canonical" href="https://www.ideamanifest.com/faq" />

                <script type="application/ld+json">
                    {JSON.stringify({
                        '@context': 'https://schema.org',
                        '@type': 'BreadcrumbList',
                        itemListElement: [
                            {
                                '@type': 'ListItem',
                                position: 1,
                                name: 'Home',
                                item: 'https://www.ideamanifest.com/',
                            },
                            {
                                '@type': 'ListItem',
                                position: 2,
                                name: 'FAQ',
                                item: 'https://www.ideamanifest.com/faq',
                            },
                        ],
                    })}
                </script>

                <script type="application/ld+json">
                    {JSON.stringify({
                        '@context': 'https://schema.org',
                        '@type': 'FAQPage',
                        mainEntity: [
                            {
                                '@type': 'Question',
                                name: 'What is your typical tech stack?',
                                acceptedAnswer: {
                                    '@type': 'Answer',
                                    text: 'We are stack-agnostic but prefer modern, typed ecosystems. Our go-to stack typically involves React/Next.js for frontend, Python (FastAPI/Django) or Node.js for backend, and PostgreSQL for database, deployed on AWS or Azure.',
                                },
                            },
                            {
                                '@type': 'Question',
                                name: 'How fast can you deliver an MVP?',
                                acceptedAnswer: {
                                    '@type': 'Answer',
                                    text: 'By leveraging AI code generation and pre-built modules, we can often ship a functional MVP in 4-6 weeks. This includes core feature development, testing, and deployment setup.',
                                },
                            },
                            {
                                '@type': 'Question',
                                name: 'Do you handle mobile app deployment?',
                                acceptedAnswer: {
                                    '@type': 'Answer',
                                    text: 'Yes, we handle the entire submission process for both the Apple App Store and Google Play Store, ensuring compliance with their review guidelines.',
                                },
                            },
                            {
                                '@type': 'Question',
                                name: 'How do you handle source code ownership?',
                                acceptedAnswer: {
                                    '@type': 'Answer',
                                    text: 'You own 100% of the code we write. Upon project completion and final payment, we transfer all repositories and IP rights directly to your organization.',
                                },
                            },
                        ],
                    })}
                </script>
            </Helmet>

            <section className="relative pt-32 pb-20 px-6 md:px-12 overflow-hidden">
                <ParticleBackground />
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
        </div>
    );
};
