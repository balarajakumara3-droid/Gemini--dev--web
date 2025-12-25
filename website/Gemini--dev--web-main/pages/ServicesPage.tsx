import React, { useEffect } from 'react';
import { Helmet } from 'react-helmet-async';
import { motion } from 'framer-motion';
import { Monitor, Smartphone, Server, Zap, Settings, CheckCircle, ArrowRight, Code, Layers, Database, Cpu, Globe } from 'lucide-react';
import { Link, useLocation } from 'react-router-dom';

export const ServicesPage: React.FC = () => {
    const { hash } = useLocation();

    // Scroll to top or hash on mount
    useEffect(() => {
        if (hash) {
            // Small delay to ensure render
            setTimeout(() => {
                const element = document.getElementById(hash.replace('#', ''));
                if (element) {
                    element.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }
            }, 100);
        } else {
            window.scrollTo(0, 0);
        }
    }, [hash]);

    const services = [
        {
            id: 'websites',
            title: 'Custom Websites',
            icon: Monitor,
            description: 'High-performance digital experiences tailored to your brand.',
            color: '#3b82f6', // blue
            features: [
                'SEO-Optimized Next.js Architecture',
                'Responsive & Interactive UI',
                'CMS Integration (Sanity, Contentful)',
                'Performance Tuning (Core Web Vitals)'
            ],
            tech: ['React', 'Next.js', 'Tailwind CSS', 'TypeScript'],
            details: "We don't just build websites; we build digital assets that drive growth. using modern frameworks like Next.js, we ensure your site is blazing fast, google-friendly, and ready to scale. Our approach combines aesthetic excellence with engineering rigor."
        },
        {
            id: 'mobile',
            title: 'Mobile Applications',
            icon: Smartphone,
            description: 'Native-quality apps for iOS and Android from a single codebase.',
            color: '#8b5cf6', // violet
            features: [
                'Cross-Platform Development (Flutter/React Native)',
                'Native Performance & smoothness',
                'App Store & Play Store Deployment',
                'Offline Capabilities & Sync'
            ],
            tech: ['Flutter', 'React Native', 'Swift', 'Kotlin'],
            details: "Reach customers on every device without doubling your budget. Our cross-platform expertise allows us to ship stunning, high-performance apps for both iOS and Android simultaneously, ensuring a consistent brand experience everywhere."
        },
        {
            id: 'backend',
            title: 'Backend Development',
            icon: Server,
            description: 'Robust, secure, and scalable server-side implementation.',
            color: '#10b981', // emerald
            features: [
                'Scalable API Design (REST/GraphQL)',
                'Database Modeling (SQL/NoSQL)',
                'Auth & Security Best Practices',
                'Cloud Infrastructure (AWS/Google Cloud)'
            ],
            tech: ['Node.js', 'Python', 'Supabase', 'PostgreSQL'],
            details: "The engine of your application needs to be bulletproof. We architect scalable backends that can handle high traffic, secure sensitive data, and integrate seamlessly with third-party services. Future-proof your business with our robust engineering."
        },
        {
            id: 'uiux',
            title: 'UI/UX Design',
            icon: Zap,
            description: 'User-centric interfaces that convert and delight.',
            color: '#f43f5e', // rose
            features: [
                'User Journey Mapping',
                'High-Fidelity Prototyping (Figma)',
                'Design Systems & Style Guides',
                'Usability Testing'
            ],
            tech: ['Figma', 'Adobe XD', 'Prototyping', 'Accessibility'],
            details: "Design is not just how it looks, but how it works. We create intuitive, accessible, and beautiful interfaces that guide users effortlessly toward their goals. Our design process ensures that every pixel serves a purpose."
        },
        {
            id: 'consulting',
            title: 'Tech Consulting',
            icon: Settings,
            description: 'Strategic guidance to navigate the complex digital landscape.',
            color: '#f59e0b', // amber
            features: [
                'Digital Transformation Strategy',
                'Tech Stack Selection & Architecture',
                'AI Integration Opportunities',
                'Code Reviews & Optimization'
            ],
            tech: ['Architecture', 'Strategy', 'AI/ML', 'Cloud'],
            details: "Make informed decisions with our expert guidance. Whether you're a startup looking for an MVP roadmap or an enterprise seeking modernization, we provide the technical clarity you need to succeed. We act as your fractional CTO partner."
        }
    ];

    return (
        <div className="min-h-screen bg-[#050A14] text-slate-200 font-sans selection:bg-blue-500/30 pt-32">
            <Helmet>
                <title>Our Services | Idea Manifest – Engineering Excellence</title>
                <meta name="description" content="Explore our technical capabilities: Custom Websites, Mobile Apps, Backend Systems, UI/UX Design, and strategic Tech Consulting." />
            </Helmet>

            {/* Hero Section */}
            <section className="relative py-20 px-6 text-center">
                <div className="absolute inset-0 bg-blue-500/5 blur-[100px] rounded-full pointer-events-none" />
                <motion.h1
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.6 }}
                    className="text-5xl md:text-7xl font-bold text-white mb-6 tracking-tight"
                >
                    Engineering <span className="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 to-violet-400">Excellence</span>
                </motion.h1>
                <motion.p
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.6, delay: 0.2 }}
                    className="text-xl text-slate-400 max-w-2xl mx-auto leading-relaxed"
                >
                    We don't just write code; we solve complex business problems with cutting-edge technology. Explore our core capabilities below.
                </motion.p>
            </section>

            {/* Services Sections */}
            <div className="max-w-7xl mx-auto px-6 pb-32 space-y-32">
                {services.map((service, index) => {
                    const isEven = index % 2 === 0;
                    return (
                        <motion.section
                            key={service.id}
                            id={service.id}
                            initial={{ opacity: 0, y: 40 }}
                            whileInView={{ opacity: 1, y: 0 }}
                            viewport={{ once: true, margin: "-100px" }}
                            transition={{ duration: 0.7 }}
                            className={`flex flex-col ${isEven ? 'lg:flex-row' : 'lg:flex-row-reverse'} items-center gap-12 lg:gap-24 scroll-mt-40
                                ${hash === `#${service.id}` ? 'ring-2 ring-blue-500/50 rounded-3xl p-4 -m-4 bg-white/5' : ''}`}
                        >
                            {/* Visual Side */}
                            <div className="w-full lg:w-1/2">
                                <div className="relative group">
                                    <div
                                        className="absolute inset-0 blur-3xl opacity-20 group-hover:opacity-30 transition-opacity duration-700"
                                        style={{ backgroundColor: service.color }}
                                    />
                                    <div className="relative bg-surface border border-white/10 rounded-2xl p-8 md:p-12 overflow-hidden hover:border-white/20 transition-colors duration-500">
                                        <div
                                            className="w-20 h-20 rounded-2xl flex items-center justify-center mb-8"
                                            style={{ backgroundColor: `${service.color}15`, color: service.color }}
                                        >
                                            <service.icon className="w-10 h-10" />
                                        </div>
                                        <div className="flex flex-wrap gap-3">
                                            {service.tech.map(t => (
                                                <span
                                                    key={t}
                                                    className="px-3 py-1 rounded-full text-xs font-mono border border-white/10 bg-white/5 text-slate-300"
                                                >
                                                    {t}
                                                </span>
                                            ))}
                                        </div>

                                        {/* Decorative Abstract Code/UI Pattern */}
                                        <div className="absolute -right-10 -bottom-10 opacity-5">
                                            <Code size={200} />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            {/* Text Side */}
                            <div className="w-full lg:w-1/2">
                                <div className="flex items-center gap-3 mb-4">
                                    <span
                                        className="h-px w-12"
                                        style={{ backgroundColor: service.color }}
                                    />
                                    {/* Numbering removed per user request */}
                                </div>
                                <h2 className="text-3xl md:text-5xl font-bold text-white mb-6">
                                    {service.title}
                                </h2>
                                <p className="text-lg text-slate-400 mb-8 leading-relaxed">
                                    {service.details}
                                </p>

                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-8">
                                    {service.features.map((feature) => (
                                        <div key={feature} className="flex items-start gap-3">
                                            <CheckCircle className="w-5 h-5 mt-0.5 text-blue-500 flex-shrink-0" />
                                            <span className="text-slate-300 text-sm">{feature}</span>
                                        </div>
                                    ))}
                                </div>

                                <Link
                                    to="/contact"
                                    className="inline-flex items-center gap-2 text-white font-semibold border-b border-white/20 pb-1 hover:border-white hover:gap-4 transition-all duration-300"
                                >
                                    Get started with {service.title} <ArrowRight className="w-4 h-4" />
                                </Link>
                            </div>
                        </motion.section>
                    );
                })}
            </div>

            {/* CTA Footer */}
            <section className="py-20 bg-gradient-to-t from-blue-900/10 to-transparent text-center border-t border-white/5">
                <h2 className="text-3xl font-bold text-white mb-6">Ready to build something extraordinary?</h2>
                <Link
                    to="/contact"
                    className="inline-block bg-white text-black px-8 py-4 rounded-full font-bold hover:bg-slate-200 transition-colors"
                >
                    Start Your Project
                </Link>
            </section>
        </div>
    );
};

export default ServicesPage;
