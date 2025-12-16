import React from 'react';
import { ServiceCard } from './services/ServiceCard';
import { ParticleBackground } from './ParticleBackground';
import { SectionHeading } from './ui/SectionHeading';
import { Monitor, Smartphone, Server, Zap, Settings } from 'lucide-react';

export const ServicesSection: React.FC = () => {
    return (
        <section id="services" className="relative pt-32 pb-20 px-6 md:px-12 overflow-hidden bg-background">
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
    );
};
