import React from 'react';
import { Helmet } from 'react-helmet-async';
import { ContactForm } from '../components/contact/ContactForm';
import { ParticleBackground } from '../components/ParticleBackground';
import { SectionHeading } from '../components/ui/SectionHeading';
import { motion } from 'framer-motion';
import { ArrowRight } from 'lucide-react';

export const ContactPage: React.FC = () => {
    return (
        <div className="bg-background text-primary min-h-screen selection:bg-accent selection:text-white overflow-x-hidden font-sans">
            <Helmet>
                <title>Contact Us | Start Your Project - Idea Manifest</title>
                <meta name="description" content="Ready to build something amazing? Contact Idea Manifest for a free consultation. Let's discuss your project and how we can help you succeed." />
                <link rel="canonical" href="https://www.ideamanifest.com/contact" />

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
                                name: 'Contact',
                                item: 'https://www.ideamanifest.com/contact',
                            },
                        ],
                    })}
                </script>
            </Helmet>

            <section className="relative pt-32 pb-20 px-6 md:px-12 overflow-hidden">
                <ParticleBackground />
                <div className="absolute top-0 right-0 w-1/2 h-full bg-accent/5 blur-[120px] rounded-full"></div>

                <div className="max-w-7xl mx-auto bg-surface border border-white/10 rounded-[2rem] overflow-hidden relative shadow-2xl">
                    <div className="absolute inset-0 opacity-10 bg-[url('https://www.transparenttextures.com/patterns/cubes.png')]"></div>
                    <div className="relative z-10 px-8 py-20 md:p-24 flex flex-col md:flex-row items-center justify-between gap-12">
                        <div className="md:w-1/2">
                            <SectionHeading title="Let's See If We're a Good Fit" highlight="Good Fit" />
                            <p className="text-secondary text-lg mb-8 mt-6">
                                No sales pressure. Just a conversation to see if we can help you build faster and better.
                            </p>

                            <div className="mb-8">
                                <motion.button
                                    whileHover={{ scale: 1.05 }}
                                    whileTap={{ scale: 0.95 }}
                                    onClick={() => window.open('https://calendly.com/ideamanifest-support/30min', '_blank')}
                                    className="w-full sm:w-auto px-8 py-4 bg-gradient-to-r from-accent to-blue-600 text-white rounded-full font-bold text-lg shadow-[0_0_20px_rgba(37,99,235,0.4)] hover:shadow-[0_0_30px_rgba(37,99,235,0.6)] transition-all flex items-center justify-center gap-3 border border-white/10"
                                >
                                    <span>Book a 30-Min Strategy Call</span>
                                    <ArrowRight className="w-5 h-5" />
                                </motion.button>
                                <p className="text-sm text-slate-500 mt-3 ml-1">
                                    Prefer to skip the form? Schedule directly.
                                </p>
                            </div>

                            <div className="flex flex-col gap-4 text-secondary border-t border-white/5 pt-8">
                                <h4 className="text-white font-semibold mb-2">Our Promise:</h4>
                                <ul className="space-y-3">
                                    <li className="flex items-center gap-3 text-sm text-slate-400">
                                        <div className="w-5 h-5 rounded-full bg-green-500/10 flex items-center justify-center text-green-500">✓</div>
                                        We usually respond within 24 hours.
                                    </li>
                                    <li className="flex items-center gap-3 text-sm text-slate-400">
                                        <div className="w-5 h-5 rounded-full bg-green-500/10 flex items-center justify-center text-green-500">✓</div>
                                        No pushy sales calls. You talk to engineers.
                                    </li>
                                    <li className="flex items-center gap-3 text-sm text-slate-400">
                                        <div className="w-5 h-5 rounded-full bg-green-500/10 flex items-center justify-center text-green-500">✓</div>
                                        Strict NDA available upon request.
                                    </li>
                                    <li className="flex items-center gap-3 text-sm text-slate-400">
                                        <div className="w-5 h-5 rounded-full bg-green-500/10 flex items-center justify-center text-green-500">✓</div>
                                        100% Confidential.
                                    </li>
                                </ul>

                                <div className="flex items-center gap-3 mt-6 pt-6 border-t border-white/5">
                                    <div className="w-8 h-8 rounded-full bg-white/5 flex items-center justify-center border border-white/10">
                                        <span className="text-sm">✉️</span>
                                    </div>
                                    support@ideamanifest.com
                                </div>
                            </div>
                        </div>

                        <div className="md:w-1/2 w-full bg-surface p-8 max-md:p-[0px] rounded-2xl shadow-2xl border border-white/5">
                            <ContactForm />
                        </div>
                    </div>
                </div>
            </section>
        </div>
    );
};
