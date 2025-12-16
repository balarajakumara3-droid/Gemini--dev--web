import React from 'react';
import { CentralTechStack } from './technology/CentralTechStack';
import { SectionHeading } from './ui/SectionHeading';

export const TechnologySection: React.FC = () => {
    return (
        <section id="technology" className="relative py-32 px-6 md:px-12 bg-surface overflow-hidden">
            <div className="max-w-7xl mx-auto relative z-10">
                <div className="text-center mb-16">
                    <SectionHeading title="Technology Stack" highlight="Stack" />
                    <p className="text-secondary max-w-2xl mx-auto text-lg mt-6">
                        Engineered with the world's most robust frameworks. We choose the right tools to build scalable, secure, and future-proof solutions.
                    </p>
                </div>

                <div className="w-full flex justify-center">
                    <CentralTechStack />
                </div>
            </div>
        </section>
    );
};
