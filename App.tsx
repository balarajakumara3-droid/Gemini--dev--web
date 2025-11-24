import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import {
    ArrowRight,
    ArrowUpRight,
    Monitor,
    Smartphone,
    Settings,
    Code,
    Target,
    Cloud,
    Database,
    Server,
    Zap,
    CheckCircle2,
    Cpu,
    Globe,
    MessageSquare,
    Bot
} from 'lucide-react';
import { CustomCursor } from './components/CustomCursor';
import { Navbar } from './components/Navbar';
import { ParticleBackground } from './components/ParticleBackground';
import OurProducts from "@/components/OurProducts";

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

const ServiceCard = ({ title, description, Icon, number }: { title: string, description: string, Icon: any, number: string }) => (
    <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        whileHover={{ y: -8, scale: 1.02 }}
        transition={{ duration: 0.3 }}
        className="group p-8 bg-surface border border-white/5 hover:border-accent/30 shadow-lg hover:shadow-indigo-500/10 transition-all duration-300 rounded-xl relative overflow-hidden"
    >
        <div className="absolute inset-0 bg-gradient-to-br from-accent/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
        <div className="absolute top-0 right-0 p-6 opacity-10 font-serif text-6xl text-white group-hover:opacity-20 transition-opacity">
            {number}
        </div>
        <div className="w-12 h-12 bg-white/5 rounded-lg flex items-center justify-center text-accent mb-6 group-hover:scale-110 group-hover:bg-accent group-hover:text-background transition-all duration-300">
            <Icon size={24} strokeWidth={1.5} />
        </div>
        <h3 className="font-serif text-2xl text-primary font-medium mb-3 relative z-10">{title}</h3>
        <p className="text-secondary text-sm leading-relaxed mb-6 relative z-10">{description}</p>
        <a href="#" className="inline-flex items-center gap-2 text-accent text-xs font-bold uppercase tracking-widest hover:gap-3 transition-all relative z-10">
            Technical Details <ArrowRight size={14} />
        </a>
    </motion.div>
);

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
                    <button className="flex items-center gap-2 bg-slate-800 text-white px-6 py-3 rounded-full text-sm font-bold hover:bg-slate-700 transition-colors group border border-white/5">
                        Explore Stack
                        <ArrowUpRight size={16} className="group-hover:translate-x-0.5 group-hover:-translate-y-0.5 transition-transform" />
                    </button>
                </div>
            </div>
        </div>
    </motion.div>
);

const TechBadge = ({ name, Icon }: { name: string, Icon: any }) => (
    <div className="flex flex-row items-center gap-4 p-5 bg-surface rounded-xl border border-white/5 hover:border-accent/50 hover:shadow-[0_0_20px_rgba(129,140,248,0.15)] hover:-translate-y-1 transition-all duration-300 cursor-default group w-full">
        <Icon size={24} className="text-secondary group-hover:text-accent transition-colors shrink-0" strokeWidth={1.5} />
        <span className="font-medium text-sm md:text-base text-primary group-hover:text-white transition-colors">{name}</span>
    </div>
);

const AccordionItem = ({ question, answer, isOpen, onClick }: { question: string, answer: string, isOpen: boolean, onClick: () => void }) => (
    <div className="border-b border-white/10 last:border-0">
        <button
            className="w-full py-6 flex justify-between items-center text-left hover:text-accent transition-colors group"
            onClick={onClick}
        >
            <span className={`font-serif text-xl md:text-2xl transition-colors duration-300 ${isOpen ? 'text-accent italic' : 'text-primary group-hover:text-white'}`}>{question}</span>
            <div className={`w-8 h-8 rounded-full flex items-center justify-center border transition-all duration-300 ${isOpen ? 'bg-accent border-accent text-background rotate-45' : 'border-white/20 text-white/50 group-hover:border-accent group-hover:text-accent'}`}>
                <ArrowRight size={16} className={`${isOpen ? '-rotate-45' : ''}`} />
            </div>
        </button>
        <AnimatePresence>
            {isOpen && (
                <motion.div
                    initial={{ height: 0, opacity: 0 }}
                    animate={{ height: 'auto', opacity: 1 }}
                    exit={{ height: 0, opacity: 0 }}
                    transition={{ duration: 0.3 }}
                >
                    <div className="pb-8 pt-2 text-secondary leading-relaxed max-w-2xl">
                        {answer}
                    </div>
                </motion.div>
            )}
        </AnimatePresence>
    </div>
);

const App: React.FC = () => {
    const [openFaq, setOpenFaq] = useState<number | null>(0);

    return (
        <div className="bg-background text-primary min-h-screen selection:bg-accent selection:text-white overflow-x-hidden font-sans">
            <CustomCursor />
            <Navbar />

            {/* HERO SECTION */}
            <section id="home" className="relative min-h-[90vh] flex items-center justify-center overflow-hidden">
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
                            <StaggeredTitle text="Your Ideas → Websites & Apps. Faster With AI" delay={0.1} />
                        </h1>
                    </div>

                    <RevealText delay={0.6}>
                        <p className="text-secondary text-lg md:text-xl w-full md:max-w-[70%] leading-relaxed mb-10">
                            Tired of ideas stuck in slow-motion dev cycles? We turn your vision into stunning web and mobile apps 50% faster, blending top-tier engineering with cutting-edge AI. Whether you're a startup sparking innovation or an enterprise scaling big, we bring your ideas to life — launch-ready, faster, and smarter.
                        </p>
                    </RevealText>

                    <RevealText delay={0.8}>
                        <div className="flex flex-col sm:flex-row gap-4">
                            <button className="px-8 py-4 bg-slate-800 text-white rounded-full font-bold hover:bg-slate-700 transition-colors flex items-center justify-center gap-2 group shadow-[0_0_20px_rgba(30,41,59,0.5)] hover:shadow-[0_0_30px_rgba(30,41,59,0.7)] border border-white/5">
                                Get Free Estimate
                                <ArrowRight size={18} className="group-hover:translate-x-1 transition-transform" />
                            </button>
                            <button className="px-8 py-4 border border-white/10 text-white rounded-full font-semibold hover:bg-white/5 transition-colors backdrop-blur-sm hover:border-white/30">
                                View Our Work
                            </button>
                        </div>
                    </RevealText>
                </div>
            </section>

            {/* SEO CONTENT SECTION */}
            <section className="py-20 px-6 md:px-12 bg-surface border-b border-white/5">
                <div className="max-w-4xl mx-auto text-center">
                    <h2 className="font-serif text-3xl md:text-4xl text-primary mb-8">About Us</h2>
                    <div className="text-secondary text-lg leading-relaxed space-y-6 text-left">
                        <p>
                            <strong>Idea Manifest</strong> is on a mission to democratize access to premium software engineering. We believe every business deserves world-class digital tools, regardless of their size or budget. By leveraging <strong>AI-driven efficiency</strong>, we work smarter, not harder, to deliver superior results.
                        </p>
                        <p>
                            Our core values center on <strong>Client-Centricity</strong> and <strong>Transparent Quality</strong>. Your success is our obsession, and we ensure clean code, clear communication, and no surprises. We don't just write code; we build assets. Our agile, AI-powered process allows us to iterate fast, adapt to feedback, and deliver a polished product that scales with you.
                        </p>
                        <p>
                            Stay tuned for our upcoming suite of SaaS tools and AI plugins designed to further accelerate your business growth. Choose <strong>Idea Manifest</strong> for a development partner that values speed without compromising on quality.
                        </p>
                    </div>
                </div>
            </section>

            {/* INTRO SECTION */}
            < section className="py-32 px-6 md:px-12 bg-background relative z-10" >
                <div className="max-w-7xl mx-auto">
                    <div className="grid grid-cols-1 lg:grid-cols-12 gap-16 items-start">
                        <div className="lg:col-span-4">
                            <span className="block w-12 h-1 bg-accent mb-6 shadow-[0_0_10px_#818cf8]"></span>
                            <h4 className="text-secondary uppercase tracking-widest text-xs font-bold">Why Choose Us</h4>
                        </div>
                        <div className="lg:col-span-8">
                            <h2 className="text-3xl md:text-5xl leading-tight font-sans font-light text-primary mb-12">
                                We combine elite engineering with <span className="font-serif italic text-accent">AI acceleration</span> to build robust webapps and mobile experiences faster than traditional agencies. Affordable digital solutions with a <span className="font-serif italic text-accent">premium look</span> and scalable future.
                            </h2>
                            <div className="grid grid-cols-2 md:grid-cols-4 gap-8 border-t border-white/10 pt-12">
                                <div className="group">
                                    <div className="font-serif text-4xl text-white mb-2 group-hover:text-accent transition-colors">2x</div>
                                    <div className="text-xs text-secondary uppercase tracking-wide">Faster Delivery</div>
                                </div>
                                <div className="group">
                                    <div className="font-serif text-4xl text-white mb-2 group-hover:text-accent transition-colors">50+</div>
                                    <div className="text-xs text-secondary uppercase tracking-wide">Products Shipped</div>
                                </div>
                                <div className="group">
                                    <div className="font-serif text-4xl text-white mb-2 group-hover:text-accent transition-colors">CI/CD</div>
                                    <div className="text-xs text-secondary uppercase tracking-wide">Automated Pipelines</div>
                                </div>
                                <div className="group">
                                    <div className="font-serif text-4xl text-white mb-2 group-hover:text-accent transition-colors">100%</div>
                                    <div className="text-xs text-secondary uppercase tracking-wide">Code Ownership</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            {/* SERVICES SECTION */}
            < section id="services" className="py-32 px-6 md:px-12 bg-surface" >
                <div className="max-w-7xl mx-auto">
                    <div className="flex justify-between items-end mb-16">
                        <div>
                            <h2 className="font-serif text-4xl md:text-5xl text-primary mb-4">Core <span className="italic text-accent">Capabilities</span></h2>
                            <p className="text-secondary max-w-xl">End-to-end development from architecture to deployment.</p>
                        </div>
                        <a href="#" className="hidden md:flex items-center gap-2 text-white font-medium hover:text-accent transition-colors">
                            View Technical Docs <ArrowRight size={16} />
                        </a>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <ServiceCard
                            number="01"
                            title="Custom Websites"
                            description="High-performance, SEO-optimized websites tailored to your brand. We use Next.js and React to build blazing fast platforms that convert visitors into customers."
                            Icon={Monitor}
                        />
                        <ServiceCard
                            number="02"
                            title="Mobile Applications"
                            description="Native-quality iOS and Android apps built with Flutter and React Native. Launch on both platforms simultaneously with a single, maintainable codebase."
                            Icon={Smartphone}
                        />
                        <ServiceCard
                            number="03"
                            title="Backend Development"
                            description="Robust, secure, and scalable server-side solutions. We architect APIs and databases that can handle complex logic and high traffic loads with ease."
                            Icon={Server}
                        />
                        <ServiceCard
                            number="04"
                            title="UI/UX Design"
                            description="User-centric interfaces that are as beautiful as they are functional. We create intuitive journeys that delight users and drive engagement."
                            Icon={Zap}
                        />
                        <ServiceCard
                            number="05"
                            title="Tech Consulting"
                            description="Strategic guidance to navigate the digital landscape. We help you choose the right stack, plan your roadmap, and leverage AI for business growth."
                            Icon={Settings}
                        />
                    </div>
                </div>
            </section>
            <OurProducts />
            {/* COLLABORATE / CASE STUDIES SECTION */}
            <section className="py-32 px-6 md:px-12 bg-background overflow-hidden">
                <div className="max-w-7xl mx-auto">
                    <div className="text-center max-w-3xl mx-auto mb-24">
                        <span className="text-accent uppercase tracking-widest text-xs font-bold mb-4 block">Our Partners</span>
                        <h2 className="font-serif text-4xl md:text-6xl text-primary mb-6">Build <span className="italic">With Us</span></h2>
                        <p className="text-secondary text-lg">
                            We adapt our engineering velocity to match your stage of growth, from rapid MVP iteration to enterprise-grade stability.
                        </p>
                    </div>

                    <div className="space-y-24">
                        <CollaborateSection
                            title="Startup E-Commerce App"
                            description="A feature-rich shopping app for a fashion startup. We used AI to generate product descriptions and personalize recommendations, boosting sales by 30%. Delivered in 4 weeks."
                            image="https://images.unsplash.com/photo-1522071820081-009f0129c71c?q=80&w=2340&auto=format&fit=crop"
                            align="left"
                        />
                        <CollaborateSection
                            title="FinTech Dashboard"
                            description="A secure, real-time analytics dashboard for a financial services firm. Our scalable backend handles thousands of transactions per second with zero latency. 50% Cost Reduction."
                            image="https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=2340&auto=format&fit=crop"
                            align="right"
                        />
                        <CollaborateSection
                            title="Healthcare Telemedicine Platform"
                            description="A HIPAA-compliant video consultation platform. We prioritized user experience to make healthcare accessible and easy for patients of all ages. Launched in 6 Weeks."
                            image="https://images.unsplash.com/photo-1460925895917-afdab827c52f?q=80&w=2664&auto=format&fit=crop"
                            align="left"
                        />
                    </div>
                </div>
            </section>

            {/* TECHNOLOGY SECTION */}
            <section id="technology" className="py-24 px-6 md:px-12 bg-surface border-t border-white/5">
                <div className="max-w-7xl mx-auto">
                    <div className="mb-16 text-center">
                        <h2 className="font-serif text-3xl md:text-4xl text-primary mb-4">Technology Stack</h2>
                        <p className="text-secondary">Engineered with the world's most robust frameworks.</p>
                    </div>

                    <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
                        <TechBadge name="FastAPI" Icon={Zap} />
                        <TechBadge name="Next.js" Icon={Globe} />
                        <TechBadge name="AWS / Cloud" Icon={Server} />
                        <TechBadge name="PostgreSQL" Icon={Database} />
                        <TechBadge name="OpenAI / LLMs" Icon={Bot} />
                        <TechBadge name="Flutter" Icon={Smartphone} />
                        <TechBadge name="Docker" Icon={Settings} />
                        <TechBadge name="Python" Icon={Code} />
                    </div>
                </div>
            </section>

            {/* FAQ SECTION */}
            <section id="faq" className="py-32 px-6 md:px-12 bg-background">
                <div className="max-w-4xl mx-auto">
                    <div className="mb-16">
                        <h2 className="font-serif text-4xl md:text-5xl text-primary mb-6">Technical <span className="italic text-accent">FAQ</span></h2>
                    </div>

                    <div className="space-y-2">
                        <AccordionItem
                            question="What is your typical tech stack?"
                            answer="We are stack-agnostic but prefer modern, typed ecosystems. Our go-to stack typically involves React/Next.js for frontend, Python (FastAPI/Django) or Node.js for backend, and PostgreSQL for database, deployed on AWS or Azure."
                            isOpen={openFaq === 0}
                            onClick={() => setOpenFaq(openFaq === 0 ? null : 0)}
                        />
                        <AccordionItem
                            question="How fast can you deliver an MVP?"
                            answer="By leveraging AI code generation and pre-built modules, we can often ship a functional MVP in 4-6 weeks. This includes core feature development, testing, and deployment setup."
                            isOpen={openFaq === 1}
                            onClick={() => setOpenFaq(openFaq === 1 ? null : 1)}
                        />
                        <AccordionItem
                            question="Do you handle mobile app deployment?"
                            answer="Yes, we handle the entire submission process for both the Apple App Store and Google Play Store, ensuring compliance with their review guidelines."
                            isOpen={openFaq === 2}
                            onClick={() => setOpenFaq(openFaq === 2 ? null : 2)}
                        />
                        <AccordionItem
                            question="How do you handle source code ownership?"
                            answer="You own 100% of the code we write. Upon project completion and final payment, we transfer all repositories and IP rights directly to your organization."
                            isOpen={openFaq === 3}
                            onClick={() => setOpenFaq(openFaq === 3 ? null : 3)}
                        />
                    </div>
                </div>
            </section>

            {/* CONTACT CTA */}
            <section id="contact" className="py-20 px-6 md:px-12 bg-background relative overflow-hidden">
                <div className="absolute top-0 right-0 w-1/2 h-full bg-accent/5 blur-[120px] rounded-full"></div>

                <div className="max-w-7xl mx-auto bg-surface border border-white/10 rounded-[2rem] overflow-hidden relative shadow-2xl">
                    <div className="absolute inset-0 opacity-10 bg-[url('https://www.transparenttextures.com/patterns/cubes.png')]"></div>
                    <div className="relative z-10 px-8 py-20 md:p-24 flex flex-col md:flex-row items-center justify-between gap-12">
                        <div className="md:w-1/2">
                            <h2 className="font-serif text-4xl md:text-6xl text-white mb-6">Ready to <span className="italic text-accent">Scale Your Vision?</span></h2>
                            <p className="text-secondary text-lg mb-8">Let's build something extraordinary together. Book your free consultation today.</p>

                            <div className="flex flex-col gap-4 text-secondary">
                                <div className="flex items-center gap-3">
                                    <div className="w-8 h-8 rounded-full bg-white/5 flex items-center justify-center border border-white/10">
                                        <span className="text-sm">✉️</span>
                                    </div>
                                    hello@ideamanifest.com
                                </div>
                            </div>
                        </div>

                        <div className="md:w-1/2 w-full bg-surface p-8 rounded-2xl shadow-2xl border border-white/5">
                            <form className="space-y-4">
                                <div className="grid grid-cols-2 gap-4">
                                    <input type="text" placeholder="Name" className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg focus:outline-none focus:border-accent focus:bg-white/10 text-white placeholder-gray-500 transition-all" />
                                    <input type="email" placeholder="Email Address" className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg focus:outline-none focus:border-accent focus:bg-white/10 text-white placeholder-gray-500 transition-all" />
                                </div>
                                <select className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg focus:outline-none focus:border-accent focus:bg-white/10 text-white placeholder-gray-500 transition-all appearance-none">
                                    <option value="" disabled selected>Project Type</option>
                                    <option value="website" className="bg-surface">Website</option>
                                    <option value="mobile" className="bg-surface">Mobile App</option>
                                    <option value="backend" className="bg-surface">Backend</option>
                                    <option value="custom" className="bg-surface">Custom Solution</option>
                                </select>
                                <textarea rows={4} placeholder="Message" className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg focus:outline-none focus:border-accent focus:bg-white/10 text-white placeholder-gray-500 transition-all resize-none"></textarea>
                                <button className="w-full py-4 bg-slate-800 text-white rounded-lg font-bold hover:bg-slate-700 transition-colors shadow-[0_0_20px_rgba(30,41,59,0.3)] border border-white/5">Book Free Consultation</button>
                            </form>
                        </div>      </div>
                </div>
            </section>

            {/* FOOTER */}
            <footer className="bg-background text-white py-16 px-6 md:px-12 border-t border-white/5">
                <div className="max-w-7xl mx-auto flex flex-col md:flex-row justify-between items-center gap-8">
                    <div className="text-center md:text-left">
                        <h3 className="font-sans font-bold text-2xl mb-2">Idea Manifest</h3>
                        <p className="text-secondary text-sm">Full-Stack AI Engineering</p>
                    </div>
                    <div className="flex gap-6">
                        <a href="#" className="text-secondary hover:text-accent transition-colors">GitHub</a>
                        <a href="#" className="text-secondary hover:text-accent transition-colors">LinkedIn</a>
                        <a href="#" className="text-secondary hover:text-accent transition-colors">Twitter</a>
                    </div>
                    <p className="text-gray-600 text-sm">© 2025 Idea Manifest. All rights reserved.</p>
                </div>
            </footer>
        </div>
    );
};

// Helper icon component since ScanEye was imported but used as ScanEyeIcon in text
const ScanEyeIcon = ({ size, className, strokeWidth }: { size?: number, className?: string, strokeWidth?: number }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width={size || 24} height={size || 24} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={strokeWidth || 2} strokeLinecap="round" strokeLinejoin="round" className={className}>
        <path d="M3 7V5a2 2 0 0 1 2-2h2" />
        <path d="M17 3h2a2 2 0 0 1 2 2v2" />
        <path d="M21 17v2a2 2 0 0 1-2 2h-2" />
        <path d="M7 21H5a2 2 0 0 1-2-2v-2" />
        <circle cx="12" cy="12" r="3" />
        <path d="M12 16a9 9 0 0 0-9-5.658L2 10l1-2.906a9 9 0 0 1 18 0L22 10l-1 2.342A9 9 0 0 0 12 16Z" />
    </svg>
)

export default App;