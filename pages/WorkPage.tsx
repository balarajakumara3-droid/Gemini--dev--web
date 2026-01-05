import React, { useState } from 'react';
import { Helmet } from 'react-helmet-async';
import { motion } from 'framer-motion';
import {
    ExternalLink, Sparkles, MapPin, Smartphone, TrendingUp, ShoppingCart, Heart,
    Monitor, Code, Server, Zap, CheckCircle, Globe, PlayCircle, Home
} from 'lucide-react';
import { Link } from 'react-router-dom';

type ProjectCategory = 'All' | 'Websites' | 'Mobile Apps' | 'Web Apps';

interface Project {
    id: string;
    title: string;
    category: 'Websites' | 'Mobile Apps' | 'Web Apps';
    description: string;
    challenge: string;
    solution: string;
    results: string;
    tech: string[];
    liveUrl?: string;
    appStoreUrl?: string;
    isExternal: boolean;
    icon: React.ElementType;
    accentColor: string;
    metrics?: { label: string; value: string }[];
}

const projects: Project[] = [
    {
        id: 'summarizer',
        title: 'AI Summarizer',
        category: 'Web Apps',
        description: 'An AI-powered tool that transforms long-form content into concise, digestible summaries. Perfect for researchers, students, and professionals.',
        challenge: 'Processing lengthy documents while maintaining context and key information accuracy.',
        solution: 'Leveraged OpenAI\'s GPT models with custom prompt engineering to extract and condense essential information while preserving meaning.',
        results: 'Users save an average of 70% of their reading time. Processes documents up to 10,000 words in under 5 seconds.',
        tech: ['React', 'Next.js', 'TypeScript', 'OpenAI API', 'Tailwind CSS'],
        liveUrl: 'https://summarizer.ideamanifest.com',
        isExternal: true,
        icon: Sparkles,
        accentColor: '#6366f1',
        metrics: [
            { label: 'Time Saved', value: '70%' },
            { label: 'Processing Speed', value: '<5s' },
            { label: 'Max Words', value: '10K' }
        ]
    },
    {
        id: 'namma-ooru',
        title: 'Namma Ooru Special',
        category: 'Web Apps',
        description: 'A community-focused platform connecting users with local businesses, specialties, and cultural experiences. Supports local economy and heritage.',
        challenge: 'Creating a user-friendly directory that effectively showcases local vendors while being accessible to non-technical business owners.',
        solution: 'Built an intuitive CMS with location-based search, allowing vendors to easily manage listings. Integrated Google Maps for navigation.',
        results: 'Connected 100+ local vendors with their community. 5,000+ monthly active users discovering local businesses.',
        tech: ['React', 'Node.js', 'MongoDB', 'Express', 'Google Maps API'],
        liveUrl: 'https://nammaooruspl.com',
        isExternal: true,
        icon: MapPin,
        accentColor: '#10b981',
        metrics: [
            { label: 'Vendors', value: '100+' },
            { label: 'Monthly Users', value: '5K+' },
            { label: 'Coverage', value: '10 Cities' }
        ]
    },
    {
        id: 'real-estate',
        title: 'True Estate',
        category: 'Mobile Apps',
        description: 'A comprehensive real estate platform enabling users to browse, search, and connect with agents for buying, selling, or renting properties.',
        challenge: 'Delivering real-time property availability and high-quality images on mobile while maintaining smooth performance.',
        solution: 'Used Flutter for cross-platform development, Firebase for real-time updates, and implemented image optimization and lazy loading.',
        results: '50,000+ downloads on Play Store. 4.2★ rating. 90% user retention rate after first week.',
        tech: ['Flutter', 'Firebase', 'Google Maps API', 'Dart'],
        liveUrl: 'https://true-estate-ashen.vercel.app/',
        isExternal: true,
        icon: Smartphone,
        accentColor: '#3b82f6',
        metrics: [
            { label: 'Downloads', value: '50K+' },
            { label: 'Rating', value: '4.2★' },
            { label: 'Retention', value: '90%' }
        ]
    },
    {
        id: 'virtual-trader',
        title: 'Virtual Trader',
        category: 'Mobile Apps',
        description: 'A stock market simulator providing risk-free trading practice with ₹10 lakh virtual cash and real-time market data integration.',
        challenge: 'Integrating real-time stock market data while ensuring accurate trade execution simulation without actual financial transactions.',
        solution: 'Connected with market data APIs, built a sophisticated trade simulation engine, and created an intuitive dashboard for portfolio tracking.',
        results: '1,000+ active traders practicing daily. Zero financial risk with 100% realistic trading experience.',
        tech: ['React', 'TypeScript', 'Node.js', 'WebSocket', 'Redis'],
        liveUrl: '/virtual-trader',
        isExternal: false,
        icon: TrendingUp,
        accentColor: '#06b6d4',
        metrics: [
            { label: 'Active Users', value: '1K+' },
            { label: 'Virtual Capital', value: '₹10L' },
            { label: 'Data Updates', value: 'Real-time' }
        ]
    },

    {
        id: 'thamizh-veedu',
        title: 'Thamizh Veedu Homes',
        category: 'Web Apps',
        description: 'A comprehensive heritage real estate platform specializing in traditional Tamil architecture, connecting buyers with historical properties and modern homes across Tamil Nadu.',
        challenge: 'Managing complex property listings with high-resolution imagery while ensuring fast load times and reliable database management for diverse property types.',
        solution: 'Developed a robust Full-stack application using React for the frontend, Node.js/Express for the backend, and PostgreSQL for structured data management.',
        results: 'Streamlined property discovery for niche heritage buyers, resulting in a 40% increase in lead generation and improved platform reliability.',
        tech: ['React', 'Node.js', 'PostgreSQL', 'Tailwind CSS', 'Express'],
        liveUrl: 'https://thamizh-veedu-homes.ideamanifest.com/',
        isExternal: true,
        icon: Home,
        accentColor: '#C2410C',
        metrics: [
            { label: 'Leads Generated', value: '40%+' },
            { label: 'Page Load', value: '<2s' },
            { label: 'Properties', value: '50+' }
        ]
    },
    // {
    //     id: 'luxe-estate',
    //     title: 'LuxeEstate Demo',
    //     category: 'Websites',
    //     description: 'A premium real estate platform featuring immersive property listings, agent profiles, and a sophisticated design system.',
    //     challenge: 'Creating a high-end visual experience that feels both luxurious and user-friendly, with smooth transitions and responsive layouts.',
    //     solution: 'Built a standalone React sub-application with Framer Motion animations and a custom design system isolated from the main app.',
    //     results: 'Demonstrates capability to build complex, brand-specific vertical applications within a larger ecosystem.',
    //     tech: ['React', 'Framer Motion', 'Tailwind CSS', 'TypeScript'],
    //     liveUrl: '/demos/real-estate',
    //     isExternal: false,
    //     icon: Home,
    //     accentColor: '#2563eb',
    //     metrics: [
    //         { label: 'Properties', value: '10+' },
    //         { label: 'Performance', value: '100%' },
    //         { label: 'Design', value: 'Custom' }
    //     ]
    // }
];

const categories: ProjectCategory[] = ['All', 'Websites', 'Mobile Apps', 'Web Apps'];

const ProjectCard: React.FC<{ project: Project }> = ({ project }) => {
    return (
        <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5 }}
            whileHover={{ y: -8 }}
            className="group bg-surface border border-white/10 rounded-2xl overflow-hidden hover:border-white/20 transition-all duration-500 hover:shadow-[0_0_30px_rgba(99,102,241,0.2)]"
        >
            {/* Project Header */}
            <div className="p-6 md:p-8">
                <div className="flex items-start justify-between mb-4">
                    <div
                        className="w-14 h-14 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform duration-500"
                        style={{ backgroundColor: `${project.accentColor}20`, color: project.accentColor }}
                    >
                        <project.icon className="w-7 h-7" />
                    </div>
                    <span
                        className="px-3 py-1 rounded-full text-xs font-medium border"
                        style={{ borderColor: `${project.accentColor}40`, backgroundColor: `${project.accentColor}15`, color: project.accentColor }}
                    >
                        {project.category}
                    </span>
                </div>

                <h3 className="text-2xl font-bold text-white mb-3 group-hover:text-transparent group-hover:bg-clip-text group-hover:bg-gradient-to-r group-hover:from-blue-400 group-hover:to-violet-400 transition-all duration-300">
                    {project.title}
                </h3>
                <p className="text-slate-400 leading-relaxed mb-6">
                    {project.description}
                </p>

                {/* Metrics */}
                {project.metrics && (
                    <div className="grid grid-cols-3 gap-3 mb-6">
                        {project.metrics.map((metric, idx) => (
                            <div key={idx} className="text-center p-3 rounded-lg bg-white/5">
                                <div className="text-lg font-bold text-white mb-1">{metric.value}</div>
                                <div className="text-xs text-slate-500">{metric.label}</div>
                            </div>
                        ))}
                    </div>
                )}

                {/* Challenge & Solution */}
                <div className="space-y-4 mb-6">
                    <div>
                        <h4 className="text-sm font-semibold text-white mb-2 flex items-center gap-2">
                            <Zap className="w-4 h-4" style={{ color: project.accentColor }} />
                            Challenge
                        </h4>
                        <p className="text-sm text-slate-400 leading-relaxed">{project.challenge}</p>
                    </div>
                    <div>
                        <h4 className="text-sm font-semibold text-white mb-2 flex items-center gap-2">
                            <CheckCircle className="w-4 h-4" style={{ color: project.accentColor }} />
                            Solution
                        </h4>
                        <p className="text-sm text-slate-400 leading-relaxed">{project.solution}</p>
                    </div>
                    <div className="p-4 rounded-lg bg-gradient-to-r from-blue-500/10 to-violet-500/10 border border-blue-500/20">
                        <h4 className="text-sm font-semibold text-white mb-2 flex items-center gap-2">
                            <Sparkles className="w-4 h-4 text-blue-400" />
                            Results
                        </h4>
                        <p className="text-sm text-slate-300 leading-relaxed">{project.results}</p>
                    </div>
                </div>

                {/* Tech Stack */}
                <div className="mb-6">
                    <h4 className="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-3">Tech Stack</h4>
                    <div className="flex flex-wrap gap-2">
                        {project.tech.map((tech) => (
                            <span
                                key={tech}
                                className="px-3 py-1 rounded-full text-xs font-mono border border-white/10 bg-white/5 text-slate-300"
                            >
                                {tech}
                            </span>
                        ))}
                    </div>
                </div>

                {/* CTA Button */}
                {(project.liveUrl || project.appStoreUrl) && (
                    <div>
                        {project.isExternal ? (
                            <a
                                href={project.liveUrl || project.appStoreUrl}
                                target="_blank"
                                rel="noopener noreferrer"
                                className="inline-flex items-center gap-2 px-6 py-3 rounded-full font-semibold transition-all duration-300 border border-white/20 text-white hover:bg-white hover:text-black"
                            >
                                {project.appStoreUrl ? 'View on Play Store' : 'View Live Site'}
                                <ExternalLink className="w-4 h-4" />
                            </a>
                        ) : (
                            <Link
                                to={project.liveUrl!}
                                className="inline-flex items-center gap-2 px-6 py-3 rounded-full font-semibold transition-all duration-300 border border-white/20 text-white hover:bg-white hover:text-black"
                            >
                                Explore App
                                <PlayCircle className="w-4 h-4" />
                            </Link>
                        )}
                    </div>
                )}
            </div>
        </motion.div>
    );
};

export const WorkPage: React.FC = () => {
    const [activeCategory, setActiveCategory] = useState<ProjectCategory>('All');

    const filteredProjects = activeCategory === 'All'
        ? projects
        : projects.filter(p => p.category === activeCategory);

    return (
        <div className="min-h-screen bg-[#050A14] text-slate-200 font-sans selection:bg-blue-500/30 pt-32">
            <Helmet>
                <title>Our Works | AI-Powered Projects Portfolio - Idea Manifest</title>
                <meta name="description" content="Explore our portfolio of AI-powered websites, mobile apps, and web applications. See how we've helped businesses achieve 50% faster development with cutting-edge technology." />
                <link rel="canonical" href="https://www.ideamanifest.com/work" />
            </Helmet>

            {/* Hero Section */}
            <section className="relative py-20 px-6 pb-0 text-center overflow-hidden">
                <div className="absolute inset-0 bg-gradient-to-b from-blue-500/10 via-violet-500/5 to-transparent blur-[100px] pointer-events-none" />
                <motion.div
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.6 }}
                    className="relative z-10"
                >
                    <span className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-white/5 border border-white/10 text-sm text-slate-400 mb-6">
                        <Code className="w-4 h-4 text-blue-400" />
                        Real Projects, Real Results
                    </span>
                    <h1 className="text-5xl md:text-7xl font-bold text-white mb-6 tracking-tight">
                        Our{' '}
                        <span className="text-transparent bg-clip-text bg-gradient-to-r from-accent via-blue-400 to-cyan-400">
                            Works
                        </span>
                    </h1>
                    <p className="text-xl text-slate-400 max-w-3xl mx-auto leading-relaxed mb-8">
                        Showcasing projects that push boundaries, solve complex problems, and deliver measurable impact.
                        Each built with cutting-edge technology and AI-enhanced workflows.
                    </p>
                </motion.div>
            </section>

            {/* Category Filter */}
            <section className="sticky top-20 z-30 py-6 px-6 pb-0 border-y border-white/5 bg-[#050A14]/80 backdrop-blur-md">
                <div className="max-w-7xl mx-auto">
                    <div className="flex flex-wrap justify-center gap-3">
                        {categories.map((category) => (
                            <></>
                            // <button
                            //     key={category}
                            //     onClick={() => setActiveCategory(category)}
                            //     className={`px-6 py-2.5 rounded-full text-sm font-semibold transition-all duration-300 ${activeCategory === category
                            //         ? 'bg-blue-500 text-white shadow-[0_0_20px_rgba(59,130,246,0.5)]'
                            //         : 'bg-white/5 text-slate-400 hover:bg-white/10 hover:text-white border border-white/10'
                            //         }`}
                            // >
                            //     {category}
                            // </button>
                        ))}
                    </div>
                    {/* <div className="text-center mt-4">
                        <p className="text-sm text-slate-500">
                            Showing <span className="text-white font-semibold">{filteredProjects.length}</span> {activeCategory === 'All' ? 'projects' : activeCategory.toLowerCase()}
                        </p>
                    </div> */}
                </div>
            </section>

            {/* Projects Grid */}
            <section className="py-20 px-6">
                <div className="max-w-7xl mx-auto">
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-2 gap-8">
                        {filteredProjects.map((project) => (
                            <ProjectCard key={project.id} project={project} />
                        ))}
                    </div>

                    {filteredProjects.length === 0 && (
                        <div className="text-center py-20">
                            <p className="text-slate-500 text-lg">No projects found in this category.</p>
                        </div>
                    )}
                </div>
            </section>

            {/* CTA Section */}
            <section className="py-24 bg-gradient-to-t from-blue-900/20 via-violet-900/10 to-transparent text-center border-t border-white/5">
                <div className="max-w-3xl mx-auto px-6">
                    <motion.div
                        initial={{ opacity: 0, y: 20 }}
                        whileInView={{ opacity: 1, y: 0 }}
                        viewport={{ once: true }}
                        transition={{ duration: 0.6 }}
                    >
                        <h2 className="text-4xl md:text-5xl font-bold text-white mb-6">
                            Ready to start your{' '}
                            <span className="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 to-violet-400">
                                project
                            </span>?
                        </h2>
                        <p className="text-xl text-slate-400 mb-10">
                            Let's discuss how our AI-powered development can bring your vision to life—faster and better.
                        </p>
                        <Link
                            to="/contact"
                            className="inline-flex items-center justify-center gap-2 bg-white text-black px-10 py-5 rounded-full text-lg font-bold hover:bg-slate-200 transition-colors shadow-[0_0_40px_rgba(255,255,255,0.1)]"
                        >
                            Get a Free Quote
                            <ExternalLink className="w-5 h-5" />
                        </Link>
                    </motion.div>
                </div>
            </section>
        </div>
    );
};

export default WorkPage;
