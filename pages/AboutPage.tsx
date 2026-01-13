import React from 'react';
import { Helmet } from 'react-helmet-async';
import { HeroSection } from '../components/about/HeroSection';
import { StorySection } from '../components/about/StorySection';
import { ValuesSection } from '../components/about/ValuesSection';
import { TeamSection } from '../components/TeamSection';

export const AboutPage: React.FC = () => {
    return (
        <div className="min-h-screen bg-[#050A14] text-slate-200 font-sans selection:bg-blue-500/30">
            <Helmet>
                <title>About Us | Democratizing Premium Engineering - Idea Manifest</title>
                <meta name="description" content="Learn about Idea Manifest's mission to democratize premium software engineering. We combine AI efficiency with human expertise to build faster, better, and smarter." />
                <link rel="canonical" href="https://www.ideamanifest.com/about" />

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
                                name: 'About',
                                item: 'https://www.ideamanifest.com/about',
                            },
                        ],
                    })}
                </script>
            </Helmet>
            <main>
                <HeroSection />
                <StorySection />
                <TeamSection />
                <ValuesSection />
            </main>
        </div >
    );
};
