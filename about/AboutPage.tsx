import React from 'react';
import { Navbar } from '../components/Navbar';
import { Footer } from '../components/Footer';
// Wait, App.tsx has the Footer inline? Or imported?
// In App.tsx: <footer ...> ... </footer>. It is inline.
// I should extract Footer to a separate component to reuse it.
// Or I can copy the footer code to AboutPage for now if I want to be quick, but extraction is better.
// Let's check App.tsx again.
// App.tsx has a lot of code.
// I will extract Footer to components/Footer.tsx first.

import { HeroSection } from '../components/about/HeroSection';
import { StorySection } from '../components/about/StorySection';
import { ValuesSection } from '../components/about/ValuesSection';
import { CapabilitiesSection } from '../components/about/CapabilitiesSection';
import { FaqSection } from '../components/about/FaqSection';
import { ContactSection } from '../components/about/ContactSection';

export const AboutPage: React.FC = () => {
    return (
        <div className="min-h-screen bg-[#050A14] text-slate-200 font-sans selection:bg-blue-500/30">
            <Navbar />
            <main>
                <HeroSection />
                <StorySection />
                <ValuesSection />
                <CapabilitiesSection />
                <FaqSection />
                <ContactSection />
            </main>
            {/* Footer will be added here after extraction */}
        </div>
    );
};
