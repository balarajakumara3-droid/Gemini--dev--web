import React, { useEffect } from 'react';
import { Helmet } from 'react-helmet-async';
import { motion } from 'framer-motion';
import {
    Monitor, Smartphone, Server, Zap, Settings, CheckCircle, ArrowRight,
    Code, TrendingUp, Shield, Rocket, Users, Target, Clock,
    Sparkles, Brain, LineChart, Palette, Lightbulb, Layers
} from 'lucide-react';
import { Link, useLocation } from 'react-router-dom';

interface ServiceBenefit {
    icon: React.ElementType;
    title: string;
    description: string;
}

interface ProcessStep {
    step: number;
    title: string;
    description: string;
}

interface Service {
    id: string;
    title: string;
    tagline: string;
    icon: React.ElementType;
    description: string;
    extendedDescription: string;
    color: string;
    features: string[];
    tech: string[];
    benefits: ServiceBenefit[];
    process: ProcessStep[];
    aiAdvantage: string;
    pricingIndicator: string;
}

const services: Service[] = [
    {
        id: 'websites',
        title: 'Custom Websites',
        tagline: 'High-performance digital experiences tailored to your brand',
        icon: Monitor,
        description: 'We build blazing-fast, SEO-optimized websites that drive growth.',
        extendedDescription: `Your website is your most powerful digital asset—it works for you 24/7, converting visitors into customers. At Idea Manifest, we don't just build websites; we engineer high-performance digital experiences that rank on Google, load in milliseconds, and convert at industry-leading rates.

Using modern frameworks like Next.js and React, we create websites that are not only visually stunning but technically superior. Our AI-assisted development workflow allows us to prototype and iterate 50% faster than traditional agencies, meaning you get to market quicker without sacrificing quality.

Every site we build is mobile-first, accessibility-compliant, and optimized for Core Web Vitals. We integrate seamlessly with your preferred CMS—whether it's Sanity, Contentful, or a custom headless solution—giving you full control over your content while we handle the technical complexity.`,
        color: '#3b82f6',
        features: [
            'SEO-Optimized Next.js Architecture',
            'Responsive & Interactive UI',
            'CMS Integration (Sanity, Contentful)',
            'Performance Tuning (Core Web Vitals)',
            'E-commerce & Payment Integration',
            'Analytics & Conversion Tracking'
        ],
        tech: ['React', 'Next.js', 'Tailwind CSS', 'TypeScript', 'Vercel'],
        benefits: [
            { icon: TrendingUp, title: 'Higher Rankings', description: 'SEO-first architecture that ranks on Google' },
            { icon: Rocket, title: 'Fast Load Times', description: 'Sub-second page loads for better UX' },
            { icon: Target, title: 'More Conversions', description: 'Design optimized for user action' }
        ],
        process: [
            { step: 1, title: 'Discovery', description: 'Understand your goals, audience, and competitors' },
            { step: 2, title: 'Design', description: 'Create wireframes and high-fidelity mockups' },
            { step: 3, title: 'Development', description: 'Build with modern tech stack and best practices' },
            { step: 4, title: 'Launch', description: 'Deploy, optimize, and go live with confidence' }
        ],
        aiAdvantage: '50% faster prototyping with AI-assisted design and code generation',
        pricingIndicator: 'Starting from $5,000'
    },
    {
        id: 'mobile',
        title: 'Mobile Applications',
        tagline: 'Native-quality apps for iOS and Android from a single codebase',
        icon: Smartphone,
        description: 'Cross-platform mobile apps that feel native and perform flawlessly.',
        extendedDescription: `In today's mobile-first world, your app needs to be where your customers are—on both iOS and Android. Our cross-platform development expertise using Flutter and React Native allows us to deliver stunning, high-performance apps for both platforms simultaneously, cutting your development time and budget in half.

We understand that mobile users demand perfection. That's why every app we build features buttery-smooth animations, offline capabilities, and native-level performance. Our AI-powered testing framework catches bugs before they reach your users, reducing post-launch issues by 40%.

From concept to App Store deployment, we handle the entire lifecycle. Our team navigates the complex submission processes for both Apple and Google, ensuring your app gets approved on the first try. Post-launch, we provide ongoing support, performance monitoring, and feature updates to keep your app competitive.`,
        color: '#8b5cf6',
        features: [
            'Cross-Platform Development (Flutter/React Native)',
            'Native Performance & Smoothness',
            'App Store & Play Store Deployment',
            'Offline Capabilities & Sync',
            'Push Notifications & Deep Linking',
            'In-App Purchases & Subscriptions'
        ],
        tech: ['Flutter', 'React Native', 'Swift', 'Kotlin', 'Firebase'],
        benefits: [
            { icon: Users, title: 'Reach Everyone', description: 'iOS and Android from one codebase' },
            { icon: Clock, title: 'Faster Launch', description: '40% faster development time' },
            { icon: Shield, title: 'Reliable Quality', description: 'AI-powered testing reduces bugs' }
        ],
        process: [
            { step: 1, title: 'Research', description: 'Define user personas and core features' },
            { step: 2, title: 'Prototype', description: 'Interactive prototypes for early validation' },
            { step: 3, title: 'Build', description: 'Agile development with regular demos' },
            { step: 4, title: 'Deploy', description: 'App Store optimization and launch' }
        ],
        aiAdvantage: 'AI-powered testing reduces bugs by 40% and accelerates QA cycles',
        pricingIndicator: 'Starting from $15,000'
    },
    {
        id: 'backend',
        title: 'Backend Development',
        tagline: 'Robust, secure, and scalable server-side implementation',
        icon: Server,
        description: 'The engine of your application—built to handle anything.',
        extendedDescription: `The backend is the heart of your application. It needs to be bulletproof, scalable, and secure. Our backend engineering team designs systems that can handle millions of requests, protect sensitive data, and integrate seamlessly with any third-party service.

We specialize in both REST and GraphQL API architectures, choosing the right approach based on your specific needs. Whether you need a real-time system with WebSockets, a microservices architecture for complex enterprise needs, or a simple but powerful monolith for your MVP, we've got you covered.

Security isn't an afterthought—it's built into every layer. We implement OAuth 2.0, JWT authentication, rate limiting, and encryption at rest and in transit. Our AI-powered code review tools analyze every commit for vulnerabilities, ensuring your system maintains 99.9% uptime and passes the strictest security audits.`,
        color: '#10b981',
        features: [
            'Scalable API Design (REST/GraphQL)',
            'Database Modeling (SQL/NoSQL)',
            'Auth & Security Best Practices',
            'Cloud Infrastructure (AWS/GCP)',
            'Real-time Systems (WebSockets)',
            'Microservices Architecture'
        ],
        tech: ['Node.js', 'Python', 'PostgreSQL', 'Supabase', 'AWS'],
        benefits: [
            { icon: TrendingUp, title: 'Infinite Scale', description: 'Handle millions of users effortlessly' },
            { icon: Shield, title: 'Enterprise Security', description: 'Bank-level data protection' },
            { icon: Layers, title: 'Easy Integration', description: 'Connect with any third-party service' }
        ],
        process: [
            { step: 1, title: 'Architecture', description: 'Design scalable system architecture' },
            { step: 2, title: 'API Design', description: 'Define endpoints and data contracts' },
            { step: 3, title: 'Implementation', description: 'Build with security-first approach' },
            { step: 4, title: 'Audit', description: 'Security review and performance testing' }
        ],
        aiAdvantage: 'AI code review ensures 99.9% uptime and catches vulnerabilities early',
        pricingIndicator: 'Starting from $8,000'
    },
    {
        id: 'uiux',
        title: 'UI/UX Design',
        tagline: 'User-centric interfaces that convert and delight',
        icon: Zap,
        description: 'Design that works as beautifully as it looks.',
        extendedDescription: `Great design is invisible—it guides users effortlessly toward their goals. Our UI/UX team combines behavioral psychology, data-driven insights, and artistic excellence to create interfaces that don't just look stunning but convert at significantly higher rates.

We start every project with deep user research. Understanding your customers' needs, pain points, and behaviors allows us to design experiences that feel intuitive from the first interaction. Our AI-assisted user behavior analysis identifies friction points and optimization opportunities that traditional research might miss.

From initial wireframes to pixel-perfect prototypes in Figma, we iterate rapidly with your feedback. We build comprehensive design systems and style guides that ensure consistency across all touchpoints—whether it's your website, mobile app, or internal tools. Every component is designed for accessibility, meeting WCAG 2.1 standards.`,
        color: '#f43f5e',
        features: [
            'User Journey Mapping',
            'High-Fidelity Prototyping (Figma)',
            'Design Systems & Style Guides',
            'Usability Testing',
            'Accessibility Compliance (WCAG)',
            'Interaction Design & Animation'
        ],
        tech: ['Figma', 'Adobe XD', 'Framer', 'Principle', 'Lottie'],
        benefits: [
            { icon: Target, title: 'Higher Conversions', description: 'Design optimized for user action' },
            { icon: Users, title: 'Happy Users', description: 'Intuitive experiences users love' },
            { icon: Palette, title: 'Brand Consistency', description: 'Unified look across all platforms' }
        ],
        process: [
            { step: 1, title: 'Research', description: 'User interviews and competitive analysis' },
            { step: 2, title: 'Wireframe', description: 'Low-fidelity layouts and user flows' },
            { step: 3, title: 'Prototype', description: 'Interactive high-fidelity designs' },
            { step: 4, title: 'Test & Handoff', description: 'Usability testing and dev-ready specs' }
        ],
        aiAdvantage: 'AI-driven user behavior analysis identifies hidden optimization opportunities',
        pricingIndicator: 'Starting from $4,000'
    },
    {
        id: 'consulting',
        title: 'Tech Consulting',
        tagline: 'Strategic guidance to navigate the complex digital landscape',
        icon: Settings,
        description: 'Your fractional CTO for critical technical decisions.',
        extendedDescription: `Technology decisions can make or break your business. Choosing the wrong stack, underestimating scale requirements, or ignoring security can cost millions. Our tech consulting services provide the strategic clarity you need to make informed decisions with confidence.

Whether you're a startup looking for an MVP roadmap, a scale-up preparing for growth, or an enterprise seeking digital transformation, we bring decades of combined experience to your challenges. We conduct thorough technical audits, evaluate build-vs-buy decisions, and create actionable roadmaps aligned with your business goals.

Our AI-powered recommendation engine analyzes your specific requirements against thousands of technology combinations to suggest the optimal stack for your use case. We don't just give you a report—we partner with you through implementation, providing ongoing guidance as your needs evolve.`,
        color: '#f59e0b',
        features: [
            'Digital Transformation Strategy',
            'Tech Stack Selection & Architecture',
            'AI Integration Opportunities',
            'Code Reviews & Optimization',
            'Team Training & Mentorship',
            'Vendor Evaluation & Selection'
        ],
        tech: ['Architecture', 'Strategy', 'AI/ML', 'Cloud', 'DevOps'],
        benefits: [
            { icon: Lightbulb, title: 'Informed Decisions', description: 'Data-driven technology choices' },
            { icon: Shield, title: 'Risk Reduction', description: 'Avoid costly technical mistakes' },
            { icon: TrendingUp, title: 'Future-Proofing', description: 'Build for scale from day one' }
        ],
        process: [
            { step: 1, title: 'Audit', description: 'Assess current state and challenges' },
            { step: 2, title: 'Strategy', description: 'Define goals and success metrics' },
            { step: 3, title: 'Roadmap', description: 'Create actionable implementation plan' },
            { step: 4, title: 'Support', description: 'Ongoing guidance through execution' }
        ],
        aiAdvantage: 'AI-powered tech stack recommendations based on your specific needs',
        pricingIndicator: 'Custom Quote'
    }
];

const ProcessTimeline: React.FC<{ steps: ProcessStep[]; color: string }> = ({ steps, color }) => (
    <div className="mt-8">
        <h4 className="text-lg font-semibold text-white mb-6 flex items-center gap-2">
            <Sparkles className="w-5 h-5" style={{ color }} />
            Our Process
        </h4>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            {steps.map((step, index) => (
                <div key={step.step} className="relative">
                    <div className="flex flex-col items-center text-center">
                        <div
                            className="w-12 h-12 rounded-full flex items-center justify-center text-lg font-bold mb-3 border-2"
                            style={{ borderColor: color, color: color, backgroundColor: `${color}15` }}
                        >
                            {step.step}
                        </div>
                        <h5 className="font-semibold text-white text-sm mb-1">{step.title}</h5>
                        <p className="text-slate-500 text-xs leading-relaxed">{step.description}</p>
                    </div>
                    {index < steps.length - 1 && (
                        <div className="hidden md:block absolute top-6 left-[calc(50%+24px)] w-[calc(100%-48px)] h-[2px] bg-gradient-to-r from-white/20 to-transparent" />
                    )}
                </div>
            ))}
        </div>
    </div>
);

const BenefitCard: React.FC<{ benefit: ServiceBenefit; color: string }> = ({ benefit, color }) => (
    <motion.div
        whileHover={{ y: -4 }}
        className="bg-white/5 border border-white/10 rounded-xl p-5 hover:border-white/20 transition-colors"
    >
        <div
            className="w-10 h-10 rounded-lg flex items-center justify-center mb-3"
            style={{ backgroundColor: `${color}20`, color }}
        >
            <benefit.icon className="w-5 h-5" />
        </div>
        <h5 className="font-semibold text-white text-sm mb-1">{benefit.title}</h5>
        <p className="text-slate-400 text-xs leading-relaxed">{benefit.description}</p>
    </motion.div>
);

export const ServicesPage: React.FC = () => {
    const { hash } = useLocation();

    useEffect(() => {
        if (hash) {
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

    return (
        <div className="min-h-screen bg-[#050A14] text-slate-200 font-sans selection:bg-blue-500/30 pt-32">
            <Helmet>
                <title>Our Services | AI-Powered Web & Mobile Development - Idea Manifest</title>
                <meta name="description" content="Custom websites, mobile apps, backend systems, UI/UX design, and tech consulting. AI-powered development delivers 50% faster results. Get a free quote today." />
                <link rel="canonical" href="https://www.ideamanifest.com/services" />

                {/* Structured Data for Services */}
                <script type="application/ld+json">
                    {JSON.stringify({
                        "@context": "https://schema.org",
                        "@type": "ItemList",
                        "name": "Our Services",
                        "itemListElement": services.map((service, index) => ({
                            "@type": "Service",
                            "position": index + 1,
                            "name": service.title,
                            "description": service.description,
                            "url": `https://www.ideamanifest.com/services#${service.id}`,
                            "provider": {
                                "@type": "Organization",
                                "name": "Idea Manifest"
                            }
                        }))
                    })}
                </script>
            </Helmet>

            {/* Hero Section */}
            <section className="relative py-20 px-6 text-center overflow-hidden">
                <div className="absolute inset-0 bg-gradient-to-b from-blue-500/10 via-violet-500/5 to-transparent blur-[100px] pointer-events-none" />
                <motion.div
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.6 }}
                    className="relative z-10"
                >
                    <span className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-white/5 border border-white/10 text-sm text-slate-400 mb-6">
                        <Brain className="w-4 h-4 text-blue-400" />
                        AI-Powered Development
                    </span>
                    <h1 className="text-5xl md:text-7xl font-bold text-white mb-6 tracking-tight">
                        Engineering{' '}
                        <span className="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 via-violet-400 to-rose-400">
                            Excellence
                        </span>
                    </h1>
                    <p className="text-xl text-slate-400 max-w-3xl mx-auto leading-relaxed mb-8">
                        We don't just write code; we solve complex business problems with cutting-edge technology.
                        Our AI-enhanced workflow delivers results <strong className="text-white">50% faster</strong> than traditional agencies.
                    </p>
                    <div className="flex flex-col sm:flex-row gap-4 justify-center">
                        <Link
                            to="/contact"
                            className="inline-flex items-center justify-center gap-2 bg-white text-black px-8 py-4 rounded-full font-bold hover:bg-slate-200 transition-colors"
                        >
                            Get a Free Quote
                            <ArrowRight className="w-4 h-4" />
                        </Link>
                        <a
                            href="#websites"
                            className="inline-flex items-center justify-center gap-2 border border-white/20 text-white px-8 py-4 rounded-full font-semibold hover:bg-white/5 transition-colors"
                        >
                            Explore Services
                        </a>
                    </div>
                </motion.div>
            </section>

            {/* Quick Jump Navigation */}
            <section className="py-8 px-6 border-y border-white/5 bg-white/[0.02] sticky top-20 z-30 backdrop-blur-md">
                <div className="max-w-7xl mx-auto">
                    <nav className="flex flex-wrap justify-center gap-2 md:gap-4">
                        {services.map((service) => (
                            <a
                                key={service.id}
                                href={`#${service.id}`}
                                className="flex items-center gap-2 px-4 py-2 rounded-full text-sm text-slate-400 hover:text-white hover:bg-white/10 transition-colors border border-transparent hover:border-white/10"
                            >
                                <service.icon className="w-4 h-4" style={{ color: service.color }} />
                                <span className="hidden sm:inline">{service.title}</span>
                                <span className="sm:hidden">{service.title.split(' ')[0]}</span>
                            </a>
                        ))}
                    </nav>
                </div>
            </section>

            {/* Services Sections */}
            <div className="max-w-7xl mx-auto px-6 py-20 space-y-32">
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
                            className={`scroll-mt-48 ${hash === `#${service.id}` ? 'ring-2 ring-blue-500/30 rounded-3xl p-6 -m-6 bg-blue-500/5' : ''}`}
                        >
                            {/* Service Header */}
                            <div className={`flex flex-col ${isEven ? 'lg:flex-row' : 'lg:flex-row-reverse'} gap-12 lg:gap-20 items-start`}>
                                {/* Visual Side */}
                                <div className="w-full lg:w-2/5">
                                    <div className="sticky top-48">
                                        <div className="relative group">
                                            <div
                                                className="absolute inset-0 blur-3xl opacity-20 group-hover:opacity-30 transition-opacity duration-700 rounded-3xl"
                                                style={{ backgroundColor: service.color }}
                                            />
                                            <div className="relative bg-surface border border-white/10 rounded-2xl p-8 md:p-10 overflow-hidden hover:border-white/20 transition-colors duration-500">
                                                <div
                                                    className="w-20 h-20 rounded-2xl flex items-center justify-center mb-6"
                                                    style={{ backgroundColor: `${service.color}15`, color: service.color }}
                                                >
                                                    <service.icon className="w-10 h-10" />
                                                </div>

                                                <div className="flex flex-wrap gap-2 mb-6">
                                                    {service.tech.map(t => (
                                                        <span
                                                            key={t}
                                                            className="px-3 py-1 rounded-full text-xs font-mono border border-white/10 bg-white/5 text-slate-300"
                                                        >
                                                            {t}
                                                        </span>
                                                    ))}
                                                </div>

                                                {/* AI Advantage Badge */}
                                                <div className="flex items-start gap-3 p-4 rounded-xl bg-gradient-to-r from-blue-500/10 to-violet-500/10 border border-blue-500/20">
                                                    <Sparkles className="w-5 h-5 text-blue-400 flex-shrink-0 mt-0.5" />
                                                    <p className="text-sm text-slate-300 leading-relaxed">
                                                        <span className="text-white font-semibold">AI Advantage:</span>{' '}
                                                        {service.aiAdvantage}
                                                    </p>
                                                </div>

                                                {/* Decorative */}
                                                <div className="absolute -right-10 -bottom-10 opacity-5">
                                                    <Code size={200} />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                {/* Text Side */}
                                <div className="w-full lg:w-3/5">
                                    <div className="flex items-center gap-3 mb-4">
                                        <span className="h-px w-12" style={{ backgroundColor: service.color }} />
                                        <span className="text-xs font-mono uppercase tracking-wider" style={{ color: service.color }}>
                                            Service 0{index + 1}
                                        </span>
                                    </div>

                                    <h2 className="text-4xl md:text-5xl font-bold text-white mb-3">
                                        {service.title}
                                    </h2>
                                    <p className="text-xl text-slate-400 mb-8" style={{ color: service.color }}>
                                        {service.tagline}
                                    </p>

                                    {/* Extended Description */}
                                    <div className="prose prose-invert prose-slate max-w-none mb-10">
                                        {service.extendedDescription.split('\n\n').map((paragraph, i) => (
                                            <p key={i} className="text-slate-400 leading-relaxed mb-4">
                                                {paragraph}
                                            </p>
                                        ))}
                                    </div>

                                    {/* Benefits Grid */}
                                    <div className="mb-10">
                                        <h4 className="text-lg font-semibold text-white mb-4">Key Benefits</h4>
                                        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                                            {service.benefits.map((benefit, i) => (
                                                <BenefitCard key={i} benefit={benefit} color={service.color} />
                                            ))}
                                        </div>
                                    </div>

                                    {/* Features List */}
                                    <div className="mb-10">
                                        <h4 className="text-lg font-semibold text-white mb-4">What's Included</h4>
                                        <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                                            {service.features.map((feature) => (
                                                <div key={feature} className="flex items-start gap-3">
                                                    <CheckCircle className="w-5 h-5 mt-0.5 flex-shrink-0" style={{ color: service.color }} />
                                                    <span className="text-slate-300 text-sm">{feature}</span>
                                                </div>
                                            ))}
                                        </div>
                                    </div>

                                    {/* Process Timeline */}
                                    <ProcessTimeline steps={service.process} color={service.color} />

                                    {/* CTA Section */}
                                    {/* <div className="mt-10 flex flex-col sm:flex-row items-start sm:items-center gap-6 p-6 rounded-2xl bg-white/5 border border-white/10">
                                        <div className="flex-1">
                                            <p className="text-slate-400 text-sm mb-1">Investment starts at</p>
                                            <p className="text-2xl font-bold text-white">{service.pricingIndicator}</p>
                                        </div>
                                        <Link
                                            to="/contact"
                                            className="inline-flex items-center gap-2 bg-white text-black px-6 py-3 rounded-full font-bold hover:bg-slate-200 transition-colors"
                                        >
                                            Get a Free Quote
                                            <ArrowRight className="w-4 h-4" />
                                        </Link>
                                    </div> */}
                                </div>
                            </div>
                        </motion.section>
                    );
                })}
            </div>

            {/* Final CTA */}
            <section className="py-24 bg-gradient-to-t from-blue-900/20 via-violet-900/10 to-transparent text-center border-t border-white/5">
                <div className="max-w-3xl mx-auto px-6">
                    <motion.div
                        initial={{ opacity: 0, y: 20 }}
                        whileInView={{ opacity: 1, y: 0 }}
                        viewport={{ once: true }}
                        transition={{ duration: 0.6 }}
                    >
                        <h2 className="text-4xl md:text-5xl font-bold text-white mb-6">
                            Ready to build something{' '}
                            <span className="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 to-violet-400">
                                extraordinary
                            </span>?
                        </h2>
                        <p className="text-xl text-slate-400 mb-10">
                            Let's discuss your project and explore how our AI-powered development can bring your vision to life—faster and better.
                        </p>
                        <div className="flex flex-col sm:flex-row gap-4 justify-center">
                            <Link
                                to="/contact"
                                className="inline-flex items-center justify-center gap-2 bg-white text-black px-10 py-5 rounded-full text-lg font-bold hover:bg-slate-200 transition-colors shadow-[0_0_40px_rgba(255,255,255,0.1)]"
                            >
                                Start Your Project
                                <ArrowRight className="w-5 h-5" />
                            </Link>
                        </div>
                    </motion.div>
                </div>
            </section>
        </div>
    );
};

export default ServicesPage;
