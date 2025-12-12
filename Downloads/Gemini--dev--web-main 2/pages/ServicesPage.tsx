import React from 'react';
import { Helmet } from 'react-helmet-async';
import { ServiceCard } from '../components/services/ServiceCard';
import { ParticleBackground } from '../components/ParticleBackground';
import { SectionHeading } from '../components/ui/SectionHeading';
import { Monitor, Smartphone, Server, Zap, Settings, ArrowRight } from 'lucide-react';

export const ServicesPage: React.FC = () => {
    return (
        <div className="bg-background text-primary min-h-screen selection:bg-accent selection:text-white overflow-x-hidden font-sans">
            <Helmet>
                <title>Services | Idea Manifest – Web, Mobile, & AI Development</title>
                <meta name="description" content="Explore our services: Custom Web Development, Mobile Apps, AI Integration, and Enterprise Software. We build scalable solutions for modern businesses." />
                <link rel="canonical" href="https://www.ideamanifest.com/services" />

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
                                name: 'Services',
                                item: 'https://www.ideamanifest.com/services',
                            },
                        ],
                    })}
                </script>
            </Helmet>

            <section className="relative pt-32 pb-20 px-6 md:px-12 overflow-hidden">
                <ParticleBackground />
                <div className="max-w-7xl mx-auto relative z-10">
                    <div className="text-center mb-16">
                        <SectionHeading title="Core Capabilities" highlight="Capabilities" />
                        <p className="text-secondary max-w-2xl mx-auto text-lg mt-6">
                            End-to-end development from architecture to deployment. We build scalable, high-performance digital solutions tailored to your business needs.
                        </p>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <ServiceCard
                            title="Custom Websites"
                            description="High-performance, SEO-optimized websites tailored to your brand. We use Next.js and React to build blazing fast platforms that convert visitors into customers."
                            Icon={Monitor}
                        />
                        <ServiceCard
                            title="Mobile Applications"
                            description="Native-quality iOS and Android apps built with Flutter and React Native. Launch on both platforms simultaneously with a single, maintainable codebase."
                            Icon={Smartphone}
                        />
                        <ServiceCard
                            title="Backend Development"
                            description="Robust, secure, and scalable server-side solutions. We architect APIs and databases that can handle complex logic and high traffic loads with ease."
                            Icon={Server}
                        />
                        <ServiceCard
                            title="UI/UX Design"
                            description="User-centric interfaces that are as beautiful as they are functional. We create intuitive journeys that delight users and drive engagement."
                            Icon={Zap}
                        />
                        <ServiceCard
                            title="Tech Consulting"
                            description="Strategic guidance to navigate the digital landscape. We help you choose the right stack, plan your roadmap, and leverage AI for business growth."
                            Icon={Settings}
                        />
                    </div>
                </div>
            </section>
        </div>
    );
};
