import React from 'react';
import { Helmet } from 'react-helmet-async';
import { ContactForm } from '../components/contact/ContactForm';
import { ParticleBackground } from '../components/ParticleBackground';
import { SectionHeading } from '../components/ui/SectionHeading';

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
                            <SectionHeading title="Ready to Scale Your Vision?" highlight="Vision?" />
                            <p className="text-secondary text-lg mb-8 mt-6">
                                Let's build something extraordinary together. Book your free consultation today.
                            </p>

                            <div className="flex flex-col gap-4 text-secondary">
                                <div className="flex items-center gap-3">
                                    <div className="w-8 h-8 rounded-full bg-white/5 flex items-center justify-center border border-white/10">
                                        <span className="text-sm">✉️</span>
                                    </div>
                                    support@ideamanifest.com
                                </div>
                            </div>
                        </div>

                        <div className="md:w-1/2 w-full bg-surface p-8 rounded-2xl shadow-2xl border border-white/5">
                            <ContactForm />
                        </div>
                    </div>
                </div>
            </section>
        </div>
    );
};
