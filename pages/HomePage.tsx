import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Helmet } from 'react-helmet-async';
import {
    ArrowRight,
    ArrowUpRight,
} from 'lucide-react';
import { ParticleBackground } from '../components/ParticleBackground';
import OurProducts from "@/components/OurProducts";
import { WhyChooseUs } from '../components/WhyChooseUs';
import { FaqSection } from '../components/FaqSection';
import { ServicesSection } from '../components/ServicesSection';
import { TechnologySection } from '../components/TechnologySection';

// --- Helper Components ---

const RevealText = ({ children, delay = 0, className = "" }: { children?: React.ReactNode, delay?: number, className?: string }) => {
    return (
        <div className={`overflow-hidden ${className}`}>
            <motion.div
                initial={{ y: "100%" }}
                whileInView={{ y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.8, delay, ease: [0.19, 1, 0.22, 1] }}
            >
                {children}
            </motion.div>
        </div>
    )
}

const StaggeredTitle = ({ text, className = "", delay = 0 }: { text: string, className?: string, delay?: number }) => {
    const words = text.split(" ");

    const letterVariants = {
        hidden: { y: "120%", opacity: 0, rotateZ: 5 },
        visible: {
            y: 0,
            opacity: 1,
            rotateZ: 0,
            transition: { duration: 0.6, ease: [0.16, 1, 0.3, 1] }
        }
    };

    return (
        <motion.span
            className={`inline-flex flex-wrap gap-x-[0.25em] ${className}`}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            transition={{ staggerChildren: 0.03, delayChildren: delay }}
        >
            {words.map((word, i) => (
                <span key={i} className="inline-flex overflow-hidden py-3">
                    {word.split("").map((char, j) => (
                        <motion.span key={j} variants={letterVariants} className="inline-block">
                            {char}
                        </motion.span>
                    ))}
                </span>
            ))}
        </motion.span>
    )
}

const CollaborateSection = ({ title, description, image, align = 'left' }: { title: string, description: string, image: string, align?: 'left' | 'right' }) => (
    <motion.div
        initial={{ opacity: 0, y: 40 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ duration: 0.6 }}
        className="relative mb-32 last:mb-0"
    >
        <div className={`flex flex-col md:flex-row items-center gap-8 ${align === 'right' ? 'md:flex-row-reverse' : ''}`}>
            {/* Image Container */}
            <div className="w-full md:w-3/5 relative aspect-[16/9] md:aspect-[4/3] rounded-2xl overflow-hidden shadow-2xl border border-white/10 group">
                <img
                    src={image}
                    alt={title}
                    className="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110 opacity-80 group-hover:opacity-100"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-background/90 via-transparent to-transparent"></div>
            </div>

            {/* Floating Content Card */}
            <div className={`w-full md:w-2/5 md:absolute ${align === 'left' ? 'right-0 md:mr-12 lg:mr-24' : 'left-0 md:ml-12 lg:ml-24'} -mt-12 md:mt-0 z-10`}>
                <div className="bg-surface/95 backdrop-blur-xl p-8 md:p-10 rounded-xl shadow-2xl shadow-black/50 border border-white/10 hover:border-accent/30 transition-colors duration-300">
                    <span className="inline-block py-1 px-3 rounded-full bg-accent/10 text-accent text-xs font-semibold tracking-wider uppercase mb-4 border border-accent/20">
                        {title.split(' ')[0]} Focus
                    </span>
                    <h3 className="font-serif text-3xl md:text-4xl text-primary mb-4 leading-tight">
                        {title}
                    </h3>
                    <p className="text-secondary leading-relaxed mb-6">
                        {description}
                    </p>
                    <button
                        onClick={() => {
                            const element = document.getElementById('technology');
                            if (element) {
                                element.scrollIntoView({ behavior: 'smooth', block: 'start' });
                            }
                        }}
                        className="flex items-center gap-2 bg-slate-800 text-white px-6 py-3 rounded-full text-sm font-bold hover:bg-slate-700 transition-colors group border border-white/5"
                    >
                        Explore Stack
                        <ArrowUpRight size={16} className="group-hover:translate-x-0.5 group-hover:-translate-y-0.5 transition-transform" />
                    </button>
                </div>
            </div>
        </div>
    </motion.div>
);

export const HomePage: React.FC = () => {
    return (
        <div className="bg-background text-primary min-h-screen selection:bg-accent selection:text-white overflow-x-hidden max-w-full font-sans">
            <Helmet>
                <title>Idea Manifest | AI-Powered Websites & Mobile Apps</title>
                <meta name="description" content="Idea Manifest builds AI-powered custom websites, mobile apps, and software for startups and enterprises. Fast delivery. Scalable architecture. Get a free quote." />
                <link rel="canonical" href="https://www.ideamanifest.com/" />

                <script type="application/ld+json">
                    {JSON.stringify({
                        '@context': 'https://schema.org',
                        '@type': 'WebSite',
                        name: 'Idea Manifest',
                        url: 'https://www.ideamanifest.com/',
                        potentialAction: {
                            '@type': 'SearchAction',
                            target: 'https://www.ideamanifest.com/?s={search_term_string}',
                            'query-input': 'required name=search_term_string',
                        },
                    })}
                </script>

                <script type="application/ld+json">
                    {JSON.stringify({
                        '@context': 'https://schema.org',
                        '@type': 'ItemList',
                        name: 'Main navigation',
                        itemListElement: [
                            {
                                '@type': 'SiteNavigationElement',
                                position: 1,
                                name: 'About',
                                url: 'https://www.ideamanifest.com/about',
                            },
                            {
                                '@type': 'SiteNavigationElement',
                                position: 2,
                                name: 'Services',
                                url: 'https://www.ideamanifest.com/services',
                            },
                            {
                                '@type': 'SiteNavigationElement',
                                position: 3,
                                name: 'Technology',
                                url: 'https://www.ideamanifest.com/technology',
                            },
                            {
                                '@type': 'SiteNavigationElement',
                                position: 4,
                                name: 'FAQ',
                                url: 'https://www.ideamanifest.com/faq',
                            },
                            {
                                '@type': 'SiteNavigationElement',
                                position: 5,
                                name: 'Contact',
                                url: 'https://www.ideamanifest.com/contact',
                            },
                        ],
                    })}
                </script>
            </Helmet>
            {/* HERO SECTION */}
            <section id="home" className="scroll-mt-[120px] relative min-h-[90vh] flex items-center justify-center overflow-hidden">
                {/* Background Image - Futuristic/AI */}
                <div className="absolute inset-0 z-0">
                    <img
                        src="https://images.unsplash.com/photo-1635070041078-e363dbe005cb?q=80&w=2500&auto=format&fit=crop"
                        alt="AI Abstract"
                        className="w-full h-full object-cover opacity-60"
                    />
                    <div className="absolute inset-0 bg-background/60 mix-blend-multiply"></div>
                    <div className="absolute inset-0 bg-gradient-to-t from-background via-transparent to-transparent"></div>
                </div>

                <ParticleBackground />

                <div className="relative z-10 max-w-7xl mx-auto px-6 md:px-12 w-full text-center md:text-left mt-20">
                    <RevealText>
                        <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-white/5 backdrop-blur-md border border-white/10 text-white text-xs font-medium uppercase tracking-widest mb-6 hover:bg-white/10 transition-colors cursor-default">
                            <span className="w-2 h-2 rounded-full bg-accent animate-pulse shadow-[0_0_10px_rgba(129,140,248,0.8)]"></span>
                            <StaggeredTitle text="Full-Stack AI Foundry" delay={0.1} />
                        </div>
                    </RevealText>

                    <div className="mb-8 max-w-5xl">
                        <h1 className="font-sans font-bold text-4xl md:text-7xl lg:text-8xl text-white leading-[1.1] tracking-tight">
                            <span className="text-accent">Your Ideas</span> <motion.span className="inline-block text-[#ffdc00]" animate={{ x: [0, 5, 0] }} transition={{ duration: 1.5, repeat: Infinity, ease: "easeInOut" }}>→</motion.span> Websites & Apps
                            <h1 className="block text-2xl md:text-4xl mt-4 text-white/80 font-normal">Idea Manifest</h1>
                        </h1>
                    </div>

                    <RevealText delay={0.6}>
                        <p className="text-secondary text-lg md:text-xl w-full md:max-w-[70%] leading-relaxed mb-10">
                            Tired of ideas stuck in slow-motion dev cycles? We turn your vision into stunning web and mobile apps 50% faster, blending top-tier engineering with cutting-edge AI. Whether you're a startup sparking innovation or an enterprise scaling big, we bring your ideas to life — launch-ready, faster, and smarter.
                        </p>
                    </RevealText>

                    <RevealText delay={0.8}>
                        <div className="flex flex-col sm:flex-row gap-4">
                            <button
                                onClick={() => window.location.href = '/contact'}
                                className="px-8 py-4 bg-slate-800 text-white rounded-full font-bold hover:bg-slate-700 transition-colors flex items-center justify-center gap-2 group shadow-[0_0_20px_rgba(30,41,59,0.5)] hover:shadow-[0_0_30px_rgba(30,41,59,0.7)] border border-white/5">
                                Get Free Estimate
                                <ArrowRight size={18} className="group-hover:translate-x-1 transition-transform" />
                            </button>
                            <button
                                onClick={() => window.location.href = '/portfolio'}
                                className="px-8 py-4 border border-white/10 text-white rounded-full font-semibold hover:bg-white/5 transition-colors backdrop-blur-sm hover:border-white/30">
                                View Our Work
                            </button>
                        </div>
                    </RevealText>
                </div>
            </section>

            <OurProducts />
            <TechnologySection />
            <ServicesSection />

            {/* COLLABORATE / CASE STUDIES SECTION */}
            <section className="py-16 px-6 md:px-12 bg-background overflow-hidden">
                <div className="max-w-7xl mx-auto">
                    <div className="text-center max-w-3xl mx-auto mb-12">
                        <h2 className="font-serif text-4xl md:text-6xl text-primary mb-6">Build <span className="italic">With Us</span></h2>
                        <p className="text-secondary text-lg">
                            We adapt our engineering velocity to match your stage of growth, from rapid MVP iteration to enterprise-grade stability.
                        </p>
                    </div>

                    <div className="space-y-24">
                        <CollaborateSection
                            title="Startup Launch App"
                            description="A fast, flexible MVP built for early-stage startups. We help founders validate ideas quickly with an AI-enhanced development workflow that accelerates design, builds core features faster, and reduces cost. From prototype to polished v1.0 — we help you launch with confidence and gather real user traction in weeks, not months. Delivered in 4 Weeks. Built for rapid iteration."
                            image="https://images.unsplash.com/photo-1522071820081-009f0129c71c?q=80&w=2340&auto=format&fit=crop"
                            align="left"
                        />
                        <CollaborateSection
                            title="Enterprise Digital Transformation Suite"
                            description="A secure, scalable platform designed for high-growth enterprises. We modernize legacy systems, automate workflows, and integrate AI-driven intelligence to improve operational efficiency at scale. Our architecture handles large user volumes, complex data flows, and mission-critical uptime — ensuring your business runs faster, smarter, and with enterprise-grade reliability. 50% Faster Delivery. Enterprise-Level Performance."
                            image="https://iili.io/ffts3q7.png"
                            align="right"
                        />
                        <CollaborateSection
                            title="SMB Operations & Growth Platform"
                            description="A clean, efficient web & mobile solution built to help SMBs streamline operations and increase customer engagement. We use AI to automate routine tasks, personalize user experiences, and give you tools that scale as you grow — all without enterprise-level complexity or cost. Affordable. Scalable. Built to Grow With Your Business."
                            image="https://iili.io/fftb6YP.png"
                            align="left"
                        />
                    </div>
                </div>
            </section>
            <WhyChooseUs />
        </div >
    );
};