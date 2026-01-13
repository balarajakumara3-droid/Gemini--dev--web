import React from 'react';
import { motion } from 'framer-motion';
import { Github, Linkedin, Terminal, Cpu, Database } from 'lucide-react';

const TeamMember = ({ name, role, exp, skills, bio, delay }: { name: string, role: string, exp: string, skills: string[], bio: string, delay: number }) => (
    <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ duration: 0.5, delay }}
        className="bg-surface/50 border border-white/5 rounded-2xl p-8 hover:border-accent/30 transition-all group"
    >
        <div className="flex items-start justify-between mb-6">
            <div>
                <h3 className="text-2xl font-bold text-white mb-1 group-hover:text-accent transition-colors">{name}</h3>
                <p className="text-secondary font-medium">{role}</p>
                <p className="text-xs text-slate-500 mt-1 uppercase tracking-wider">{exp}</p>
            </div>
            <div className="bg-white/5 p-3 rounded-xl group-hover:bg-accent/10 transition-colors">
                <Terminal className="w-6 h-6 text-slate-400 group-hover:text-accent" />
            </div>
        </div>

        <p className="text-slate-400 text-sm leading-relaxed mb-6 border-l-2 border-white/10 pl-4">
            {bio}
        </p>

        <div className="flex flex-wrap gap-2 mb-6">
            {skills.map((skill) => (
                <span key={skill} className="px-2 py-1 rounded-md bg-white/5 border border-white/5 text-[10px] text-slate-300 font-mono">
                    {skill}
                </span>
            ))}
        </div>

        {/* Placeholder Socials - Logic to serve as visual cue only as per constraints */}
        <div className="flex gap-3 text-slate-500">
            <Github className="w-5 h-5 hover:text-white cursor-pointer transition-colors" />
            <Linkedin className="w-5 h-5 hover:text-white cursor-pointer transition-colors" />
        </div>
    </motion.div>
);

export const TeamSection: React.FC = () => {
    return (
        <section className="py-24 bg-background relative overflow-hidden">
            <div className="absolute top-1/4 left-0 w-1/2 h-1/2 bg-blue-500/5 rounded-full blur-[120px] pointer-events-none" />

            <div className="max-w-7xl mx-auto px-6 md:px-12 relative z-10">
                <div className="text-center mb-16 max-w-3xl mx-auto">
                    <h2 className="text-4xl md:text-5xl font-bold text-white mb-6">Our Core Engineering Team</h2>
                    <p className="text-secondary text-lg">
                        We are a 5-member senior engineering team. No junior devs "learning on the job." No hidden offshore teams. You work directly with the people building your product.
                    </p>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-12">
                    <TeamMember
                        name="Narayana"
                        role="Lead Software Engineer"
                        exp="12+ Years Experience"
                        skills={["System Architecture", "AI Integration", "Python", "Cloud Infrastructure"]}
                        bio="Specialist in scalable backend systems and AI implementation. Previously led engineering teams for high-growth SaaS platforms."
                        delay={0}
                    />
                    <TeamMember
                        name="Pravin"
                        role="Full-Stack Developer"
                        exp="8+ Years Experience"
                        skills={["React / Next.js", "Node.js", "Performance Optimization", "UI/UX"]}
                        bio="Obsessed with frontend performance and user experience. Ensures pixel-perfect implementation of complex designs."
                        delay={0.1}
                    />
                    <TeamMember
                        name="Shankar"
                        role="Senior Engineer"
                        exp="10+ Years Experience"
                        skills={["Mobile Dev", "Flutter", "DevOps", "Database Design"]}
                        bio="Mobile application expert with a focus on cross-platform efficiency and native module integration."
                        delay={0.2}
                    />
                </div>

                <div className="text-center p-6 bg-white/5 rounded-xl border border-white/5 max-w-2xl mx-auto">
                    <div className="flex items-center justify-center gap-2 text-slate-400 text-sm">
                        <Cpu className="w-4 h-4" />
                        <span>Plus 2 senior engineers focused on QA and Data Integration.</span>
                    </div>
                </div>
            </div>
        </section>
    );
};
