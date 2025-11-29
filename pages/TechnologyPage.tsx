import React from 'react';
import { Helmet } from 'react-helmet-async';
import { TechBadge } from '../components/technology/TechBadge';
import { ParticleBackground } from '../components/ParticleBackground';
import { SectionHeading } from '../components/ui/SectionHeading';
import { Zap, Globe, Server, Database, Bot, Smartphone, Settings, Code } from 'lucide-react';

export const TechnologyPage: React.FC = () => {
    return (
        <div className="bg-background text-primary min-h-screen selection:bg-accent selection:text-white overflow-x-hidden font-sans">
            <Helmet>
                <title>Technology Stack | Idea Manifest – Modern Tech for Modern Apps</title>
                <meta name="description" content="We use the latest technology stack: React, Next.js, Node.js, Python, Flutter, and AI tools to build robust, scalable, and future-proof applications." />
                <link rel="canonical" href="https://www.ideamanifest.com/technology" />

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
                                name: 'Technology',
                                item: 'https://www.ideamanifest.com/technology',
                            },
                        ],
                    })}
                </script>
            </Helmet>

            <section className="relative pt-32 pb-20 px-6 md:px-12 overflow-hidden">
                <ParticleBackground />
                <div className="max-w-7xl mx-auto relative z-10">
                    <div className="text-center mb-16">
                        <SectionHeading title="Technology Stack" highlight="Stack" />
                        <p className="text-secondary max-w-2xl mx-auto text-lg mt-6">
                            Engineered with the world's most robust frameworks. We choose the right tools to build scalable, secure, and future-proof solutions.
                        </p>
                    </div>

                    <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
                        <TechBadge name="FastAPI" Icon={Zap} />
                        <TechBadge name="Next.js" Icon={Globe} />
                        <TechBadge name="AWS / Cloud" Icon={Server} />
                        <TechBadge name="PostgreSQL" Icon={Database} />
                        <TechBadge name="OpenAI / LLMs" Icon={Bot} />
                        <TechBadge name="Flutter" Icon={Smartphone} />
                        <TechBadge name="Docker" Icon={Settings} />
                        <TechBadge name="Python" Icon={Code} />
                    </div>
                </div>
            </section>
        </div>
    );
};
