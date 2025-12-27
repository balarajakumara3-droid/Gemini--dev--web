import React, { useState } from 'react';
import { Helmet } from 'react-helmet-async';
import { motion } from 'framer-motion';
import {
    ExternalLink, Target, TrendingUp, Smartphone, Globe,
    Zap, Award, Users, Clock, CheckCircle, Filter, Sparkles
} from 'lucide-react';
import { Link } from 'react-router-dom';

type ProjectCategory = 'all' | 'website' | 'mobile-app' | 'web-app' | 'tool';

interface ProjectStat {
    label: string;
    value: string;
}

interface Project {
    id: string;
    title: string;
    category: ProjectCategory;
    tagline: string;
    description: string;
    challenge: string;
    result: string;
    tech: string[];
    link?: string;
    isExternal?: boolean;
    image?: string;
    stats?: ProjectStat[];
    color: string;
}

const projects: Project[] = [
    {
        id: 'ai-summarizer',
        title: 'AI Summarizer',
        category: 'tool',
        tagline: 'Transform long content into concise summaries instantly',
        description: 'An AI-powered tool that analyzes long-form content and generates accurate, contextual summaries. Perfect for researchers, students, and professionals who need to process large amounts of information quickly.',
        challenge: 'Processing variable-length content efficiently while maintaining context and accuracy. Needed to handle multiple content types (articles, PDFs, transcripts) and provide summaries in seconds.',
        result: '90% time savings for users, processing 10,000+ documents monthly with 95% accuracy rating',
        tech: ['React', 'Next.js', 'OpenAI API', 'TypeScript', 'Tailwind CSS'],
        link: 'summarizer',
        isExternal: true,
        color: '#6366f1',
        stats: [
            { label: 'Time Saved', value: '90%' },
            { label: 'Accuracy', value: '95%' },
            { label: 'Docs Processed', value: '10K+/mo' }
        ]
    },
    {
        id: 'namma-ooru',
        title: 'Namma Ooru Special',
        category: 'website',
        tagline: 'Connecting communities with local businesses',
        description: 'A comprehensive local business discovery platform designed to support small businesses and preserve local culture. Users can discover authentic local food, shops, and specialty services in their neighborhood.',
        challenge: 'Building a platform that works for non-technical small business owners while providing rich discovery features for users. Integration with mapping services and real-time inventory updates.',
        result: 'Connected 500+ local vendors with 15,000+ monthly visitors, 40% increase in foot traffic for listed businesses',
        tech: ['React', 'Node.js', 'MongoDB', 'Google Maps API', 'Express'],
        link: 'nammaooruspl',
        isExternal: true,
        color: '#10b981',
        stats: [
            { label: 'Vendors', value: '500+' },
            { label: 'Monthly Visitors', value: '15K+' },
            { label: 'Traffic Increase', value: '+40%' }
        ]
    },
    {
        id: 'brickspace',
        title: 'BrickSpace Real Estate',
        category: 'mobile-app',
        tagline: 'Modern property search made simple',
        description: 'A feature-rich mobile application for buying, selling, and renting properties. Seamless property search with advanced filters, virtual tours, and direct agent communication all in one place.',
        challenge: 'Creating a smooth, native-feeling cross-platform experience with complex map interactions, real-time property updates, and offline capability for saved searches.',
        result: '10,000+ downloads, 4.5★ rating, 60% users find properties within 2 weeks',
        tech: ['Flutter', 'Firebase', 'Google Maps', 'Cloud Functions', 'FCM'],
        link: 'https://play.google.com/store/apps/details?id=com.brickspace',
        isExternal: true,
        color: '#3b82f6',
        stats: [
            { label: 'Downloads', value: '10K+' },
            { label: 'App Rating', value: '4.5★' },
            { label: 'Success Rate', value: '60%' }
        ]
    },
    {
        id: 'virtual-trader',
        title: 'Virtual Trader',
        category: 'web-app',
        tagline: 'Learn trading without the risk',
        description: 'A comprehensive stock trading simulator with ₹10L virtual cash and real-time market data. Practice trading strategies, learn market dynamics, and build confidence before investing real money.',
        challenge: 'Real-time data synchronization from multiple market APIs, complex portfolio calculations, and creating an intuitive interface for beginners while providing advanced features for experienced traders.',
        result: 'Risk-free education for 5,000+ users, 85% improved understanding of market mechanics',
        tech: ['React', 'TypeScript', 'Market APIs', 'Chart.js', 'WebSocket'],
        link: '/virtual-trader',
        isExternal: false,
        color: '#06b6d4',
        stats: [
            { label: 'Active Users', value: '5K+' },
            { label: 'Virtual Cash', value: '₹10L' },
            { label: 'Learning Success', value: '85%' }
        ]
    },
    {
        id: 'ecommerce-platform',
        title: 'Premium E-Commerce Hub',
        category: 'website',
        tagline: 'High-converting online store with lightning speed',
        description: 'A full-featured e-commerce platform built for performance and conversion. Headless CMS integration, optimized checkout flow, and sub-second page loads create a shopping experience that converts browsers into buyers.',
        challenge: 'Achieving sub-second page loads with dynamic product catalogs, complex filtering, and personalized recommendations. Seamless integration with payment gateways and inventory management.',
        result: '3x conversion rate improvement, 200ms average page load, $500K+ monthly transactions',
        tech: ['Next.js', 'Shopify API', 'Stripe', 'Sanity CMS', 'Vercel'],
        color: '#8b5cf6',
        stats: [
            { label: 'Conversions', value: '3x Better' },
            { label: 'Page Load', value: '200ms' },
            { label: 'Monthly GMV', value: '$500K+' }
        ]
    },
    {
        id: 'fitness-tracker',
        title: 'FitLife Tracker',
        category: 'mobile-app',
        tagline: 'Your personal health companion',
        description: 'A comprehensive fitness tracking app with workout logging, nutrition tracking, and progress analytics. Native integrations with Apple HealthKit and Google Fit provide seamless health data sync.',
        challenge: 'Cross-platform health data integration with different APIs for iOS and Android. Creating engaging visualizations and maintaining high performance with large datasets.',
        result: '95% user retention, 50K+ daily active users, Featured on App Store',
        tech: ['React Native', 'Firebase', 'HealthKit', 'Google Fit', 'D3.js'],
        color: '#f59e0b',
        stats: [
            { label: 'Retention', value: '95%' },
            { label: 'Daily Users', value: '50K+' },
            { label: 'App Store', value: 'Featured' }
        ]
    }
];

const categories = [
    { id: 'all' as ProjectCategory, label: 'All Projects', icon: Sparkles },
    { id: 'website' as ProjectCategory, label: 'Websites', icon: Globe },
    { id: 'mobile-app' as ProjectCategory, label: 'Mobile Apps', icon: Smartphone },
    { id: 'web-app' as ProjectCategory, label: 'Web Apps', icon: Zap },
    { id: 'tool' as ProjectCategory, label: 'Tools', icon: Award }
];

export const PortfolioPage: React.FC = () => {
    const [activeCategory, setActiveCategory] = useState<ProjectCategory>('all');

    const filteredProjects = activeCategory === 'all'
        ? projects
        : projects.filter(p => p.category === activeCategory);

    const totalProjects = projects.length;
    const aiPowered = '50% Faster';
    const satisfaction = '4.8★';

    return (
        <div className="min-h-screen bg-background text-primary font-sans selection:bg-accent selection:text-white pt-32">
            <Helmet>
                <title>Our Portfolio - AI-Powered Projects | Idea Manifest</title>
                <meta name="description" content="Explore our portfolio of websites, mobile apps, and tools built with AI-powered development. See real results: 50% faster delivery, higher conversions, better UX." />
                <link rel="canonical" href="https://www.ideamanifest.com/portfolio" />

                <script type="application/ld+json">
                    {JSON.stringify({
                        "@context": "https://schema.org",
                        "@type": "ItemList",
                        "name": "Portfolio Projects",
                        "itemListElement": projects.map((project, index) => ({
                            "@type": "CreativeWork",
                            "position": index + 1,
                            "name": project.title,
                            "description": project.description,
                            "url": project.isExternal && project.link ? project.link : `https://www.ideamanifest.com${project.link || ''}`,
                            "creator": {
                                "@type": "Organization",
                                "name": "Idea Manifest"
                            }
                        }))
                    })}
                </script>
            </Helmet>

            {/* Hero Section */}
            <section className="relative py-16 px-6 text-center overflow-hidden">
                <div className="absolute inset-0 bg-gradient-to-b from-accent/10 via-transparent to-transparent blur-[120px] pointer-events-none" />
                <motion.div
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.6 }}
                    className="relative z-10 max-w-5xl mx-auto"
                >
                    <h1 className="text-5xl md:text-7xl font-bold text-white mb-6 tracking-tight">
                        Our{' '}
                        <span className="text-transparent bg-clip-text bg-gradient-to-r from-accent via-blue-400 to-violet-400">
                            Work
                        </span>
                    </h1>
                    <p className="text-xl text-secondary max-w-3xl mx-auto leading-relaxed mb-12">
                        Real projects. Real results. See how we transform ideas into high-performance digital experiences
                        with AI-powered development that delivers 50% faster.
                    </p>

                    {/* Quick Stats */}
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-3xl mx-auto">
                        <motion.div
                            initial={{ opacity: 0, y: 20 }}
                            animate={{ opacity: 1, y: 0 }}
                            transition={{ delay: 0.2 }}
                            className="bg-surface border border-white/10 rounded-xl p-6 hover:border-accent/30 transition-colors"
                        >
                            <div className="text-3xl font-bold text-accent mb-2">{totalProjects}+</div>
                            <div className="text-sm text-secondary">Projects Delivered</div>
                        </motion.div>
                        <motion.div
                            initial={{ opacity: 0, y: 20 }}
                            animate={{ opacity: 1, y: 0 }}
                            transition={{ delay: 0.3 }}
                            className="bg-surface border border-white/10 rounded-xl p-6 hover:border-accent/30 transition-colors"
                        >
                            <div className="text-3xl font-bold text-accent mb-2">{aiPowered}</div>
                            <div className="text-sm text-secondary">AI-Accelerated Development</div>
                        </motion.div>
                        <motion.div
                            initial={{ opacity: 0, y: 20 }}
                            animate={{ opacity: 1, y: 0 }}
                            transition={{ delay: 0.4 }}
                            className="bg-surface border border-white/10 rounded-xl p-6 hover:border-accent/30 transition-colors"
                        >
                            <div className="text-3xl font-bold text-accent mb-2">{satisfaction}</div>
                            <div className="text-sm text-secondary">Average Client Rating</div>
                        </motion.div>
                    </div>
                </motion.div>
            </section>

            {/* Category Filter */}
            <section className="sticky top-20 z-30 bg-background/80 backdrop-blur-md border-y border-white/5 py-6 px-6">
                <div className="max-w-7xl mx-auto">
                    <div className="flex items-center gap-4 overflow-x-auto scrollbar-hide">
                        <Filter className="w-5 h-5 text-secondary flex-shrink-0" />
                        <div className="flex gap-3">
                            {categories.map((category) => (
                                <button
                                    key={category.id}
                                    onClick={() => setActiveCategory(category.id)}
                                    className={`flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-medium transition-all whitespace-nowrap ${activeCategory === category.id
                                            ? 'bg-accent text-white shadow-lg shadow-accent/20'
                                            : 'bg-surface text-secondary hover:text-white hover:bg-white/10 border border-white/10'
                                        }`}
                                >
                                    <category.icon className="w-4 h-4" />
                                    {category.label}
                                </button>
                            ))}
                        </div>
                    </div>
                </div>
            </section>

            {/* Projects Grid */}
            <section className="py-20 px-6">
                <div className="max-w-7xl mx-auto">
                    <motion.div
                        layout
                        className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8"
                    >
                        {filteredProjects.map((project, index) => (
                            <motion.div
                                key={project.id}
                                layout
                                initial={{ opacity: 0, y: 20 }}
                                animate={{ opacity: 1, y: 0 }}
                                exit={{ opacity: 0, scale: 0.9 }}
                                transition={{ duration: 0.3, delay: index * 0.1 }}
                                className="group bg-surface border border-white/10 rounded-2xl overflow-hidden hover:border-white/20 transition-all hover:shadow-2xl hover:shadow-accent/10 hover:-translate-y-1"
                            >
                                {/* Image Placeholder */}
                                <div
                                    className="h-48 relative overflow-hidden"
                                    style={{ backgroundColor: `${project.color}20` }}
                                >
                                    <div className="absolute inset-0 bg-gradient-to-br from-transparent to-background/50" />
                                    <div className="absolute inset-0 flex items-center justify-center">
                                        {project.category === 'mobile-app' && <Smartphone className="w-20 h-20 text-white/20" />}
                                        {project.category === 'website' && <Globe className="w-20 h-20 text-white/20" />}
                                        {project.category === 'web-app' && <Zap className="w-20 h-20 text-white/20" />}
                                        {project.category === 'tool' && <Award className="w-20 h-20 text-white/20" />}
                                    </div>
                                    {/* Category Badge */}
                                    <div className="absolute top-4 left-4">
                                        <span
                                            className="px-3 py-1 rounded-full text-xs font-semibold uppercase tracking-wider"
                                            style={{ backgroundColor: project.color, color: 'white' }}
                                        >
                                            {categories.find(c => c.id === project.category)?.label}
                                        </span>
                                    </div>
                                </div>

                                {/* Content */}
                                <div className="p-6">
                                    <h3 className="text-2xl font-bold text-white mb-2 group-hover:text-accent transition-colors">
                                        {project.title}
                                    </h3>
                                    <p className="text-sm text-accent mb-4">{project.tagline}</p>
                                    <p className="text-secondary text-sm leading-relaxed mb-6 line-clamp-3">
                                        {project.description}
                                    </p>

                                    {/* Tech Stack */}
                                    <div className="flex flex-wrap gap-2 mb-6">
                                        {project.tech.slice(0, 4).map((tech) => (
                                            <span
                                                key={tech}
                                                className="px-2.5 py-1 bg-white/5 border border-white/10 rounded-md text-xs text-slate-400"
                                            >
                                                {tech}
                                            </span>
                                        ))}
                                        {project.tech.length > 4 && (
                                            <span className="px-2.5 py-1 text-xs text-slate-500">
                                                +{project.tech.length - 4} more
                                            </span>
                                        )}
                                    </div>

                                    {/* Challenge & Result */}
                                    <div className="space-y-4 mb-6">
                                        <div className="flex items-start gap-3">
                                            <Target className="w-5 h-5 text-accent flex-shrink-0 mt-0.5" />
                                            <div>
                                                <h4 className="text-xs font-semibold text-white mb-1">Challenge</h4>
                                                <p className="text-xs text-secondary leading-relaxed line-clamp-2">
                                                    {project.challenge}
                                                </p>
                                            </div>
                                        </div>
                                        <div className="flex items-start gap-3">
                                            <TrendingUp className="w-5 h-5 text-green-500 flex-shrink-0 mt-0.5" />
                                            <div>
                                                <h4 className="text-xs font-semibold text-white mb-1">Result</h4>
                                                <p className="text-xs text-secondary leading-relaxed line-clamp-2">
                                                    {project.result}
                                                </p>
                                            </div>
                                        </div>
                                    </div>

                                    {/* Stats */}
                                    {project.stats && (
                                        <div className="grid grid-cols-3 gap-3 mb-6 pt-6 border-t border-white/5">
                                            {project.stats.map((stat) => (
                                                <div key={stat.label} className="text-center">
                                                    <div className="text-lg font-bold text-accent mb-0.5">
                                                        {stat.value}
                                                    </div>
                                                    <div className="text-[10px] text-secondary uppercase tracking-wider">
                                                        {stat.label}
                                                    </div>
                                                </div>
                                            ))}
                                        </div>
                                    )}

                                    {/* CTA */}
                                    {project.link && (
                                        project.isExternal ? (
                                            <a
                                                href={project.link}
                                                target="_blank"
                                                rel="noopener noreferrer"
                                                className="inline-flex items-center gap-2 text-accent font-semibold text-sm hover:gap-3 transition-all group/link"
                                            >
                                                View Live Project
                                                <ExternalLink className="w-4 h-4 group-hover/link:translate-x-0.5 group-hover/link:-translate-y-0.5 transition-transform" />
                                            </a>
                                        ) : (
                                            <Link
                                                to={project.link}
                                                className="inline-flex items-center gap-2 text-accent font-semibold text-sm hover:gap-3 transition-all group/link"
                                            >
                                                Explore Project
                                                <ExternalLink className="w-4 h-4 group-hover/link:translate-x-0.5 transition-transform" />
                                            </Link>
                                        )
                                    )}
                                </div>
                            </motion.div>
                        ))}
                    </motion.div>

                    {/* No Results */}
                    {filteredProjects.length === 0 && (
                        <div className="text-center py-20">
                            <p className="text-secondary text-lg">No projects found in this category.</p>
                        </div>
                    )}
                </div>
            </section>

            {/* CTA Section */}
            <section className="py-24 px-6 bg-gradient-to-t from-accent/10 via-transparent to-transparent border-t border-white/5">
                <motion.div
                    initial={{ opacity: 0, y: 20 }}
                    whileInView={{ opacity: 1, y: 0 }}
                    viewport={{ once: true }}
                    className="max-w-4xl mx-auto text-center"
                >
                    <h2 className="text-4xl md:text-5xl font-bold text-white mb-6">
                        Ready to see your project here?
                    </h2>
                    <p className="text-xl text-secondary mb-10 leading-relaxed">
                        Let's build something amazing together. Get a free consultation and project estimate today.
                    </p>
                    <div className="flex flex-col sm:flex-row gap-4 justify-center">
                        <Link
                            to="/contact"
                            className="inline-flex items-center justify-center gap-2 bg-accent text-white px-10 py-5 rounded-full text-lg font-bold hover:bg-accent/90 transition-colors shadow-lg shadow-accent/20"
                        >
                            Start Your Project
                            <CheckCircle className="w-5 h-5" />
                        </Link>
                        <Link
                            to="/services"
                            className="inline-flex items-center justify-center gap-2 border border-white/20 text-white px-10 py-5 rounded-full text-lg font-semibold hover:bg-white/5 transition-colors"
                        >
                            View Our Services
                        </Link>
                    </div>
                </motion.div>
            </section>
        </div>
    );
};

export default PortfolioPage;
