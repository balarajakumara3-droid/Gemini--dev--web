import React, { useState } from 'react';
import { motion } from 'framer-motion';

type TeamProfile = {
    name: string;
    title: string;
    location: string;
    linkedInUrl: string;
    imageSrc?: string;
    coverImageSrc?: string;
    skills: string[];
    coverGradient: string;
};

const teamProfiles: TeamProfile[] = [
    {
        name: 'Pravin Kumar',
        title: 'Co-Founder & CEO · Full-Stack Mobile Engineer',
        location: 'Chennai, Tamil Nadu, India',
        linkedInUrl: 'https://www.linkedin.com/in/pravin-kumar-39b89222b/?skipRedirect=true',
        imageSrc: '/team/pravin.jpg',
        coverImageSrc: '/team/pravin-cover.jpg',
        skills: ['Swift', 'iOS', 'React Native', 'Flutter', 'Firebase', 'App Store'],
        coverGradient: 'from-[#1d4f91] via-[#1a6aa8] to-[#0a3d6e]',
    },
    {
        name: 'Shankara Perumal Arunachalam',
        title: 'Co-Founder · Full-Stack Developer',
        location: 'Chennai, Tamil Nadu, India',
        linkedInUrl: 'https://www.linkedin.com/in/shankara-perumal-arunachalam-1b40b6187/',
        imageSrc: '/team/shankara.jpg',
        coverImageSrc: '/team/shankara-cover.jpg',
        skills: ['Next.js', 'Node.js', 'React', 'PostgreSQL', 'GraphQL', 'REST APIs'],
        coverGradient: 'from-[#5a3b2e] via-[#8a644f] to-[#2b1d16]',
    },
    {
        name: 'Narayanasamy Amirthalingam',
        title: 'Co-Founder · Full-Stack & Mobile Developer',
        location: 'Chennai, Tamil Nadu, India',
        linkedInUrl: 'https://www.linkedin.com/in/narayana-samy-9423611b3/',
        imageSrc: '/team/narayanasamy-profile.jpg',
        coverImageSrc: '/team/narayanasamy-cover.jpg',
        skills: ['React', 'Tailwind CSS', 'React Native', 'Kotlin', 'Supabase', 'Figma'],
        coverGradient: 'from-[#2a6496] via-[#3a7fc1] to-[#1a4f7a]',
    },
];

const LinkedInIcon = () => (
    <svg viewBox="0 0 24 24" className="h-full w-full fill-current" aria-hidden="true">
        <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433a2.062 2.062 0 01-2.063-2.065 2.064 2.064 0 112.063 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z" />
    </svg>
);

const LinkedInProfileCard = ({ profile, delay }: { profile: TeamProfile; delay: number }) => {
    const [imgError, setImgError] = useState(false);
    const [coverError, setCoverError] = useState(false);

    const getInitials = (name: string) =>
        name.split(' ').map((p) => p[0]).join('').slice(0, 2).toUpperCase();

    return (
        <motion.div
            initial={{ opacity: 0, y: 32 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, amount: 0.15 }}
            transition={{ duration: 0.6, delay, ease: [0.22, 1, 0.36, 1] }}
            className="group relative flex flex-col overflow-hidden rounded-2xl bg-white shadow-[0_4px_24px_rgba(0,0,0,0.12)] ring-1 ring-black/[0.08] transition-all duration-300 hover:-translate-y-1 hover:shadow-[0_12px_40px_rgba(0,0,0,0.18)]"
            style={{ fontFamily: '-apple-system, "system-ui", Roboto, "Helvetica Neue", sans-serif' }}
        >
            {/* ── Cover Photo ── */}
            <div className={`relative h-[100px] overflow-hidden bg-gradient-to-br ${profile.coverGradient}`}>
                {profile.coverImageSrc && !coverError ? (
                    <img
                        src={profile.coverImageSrc}
                        alt=""
                        className="h-full w-full object-cover"
                        onError={() => setCoverError(true)}
                    />
                ) : (
                    <div
                        className={`absolute inset-0 bg-gradient-to-br ${profile.coverGradient}`}
                        style={{
                            backgroundImage:
                                'radial-gradient(circle at 20% 50%, rgba(255,255,255,0.15) 0%, transparent 50%), radial-gradient(circle at 80% 20%, rgba(255,255,255,0.1) 0%, transparent 40%)',
                        }}
                    />
                )}
                {/* Subtle overlay for depth */}
                <div className="absolute inset-0 bg-gradient-to-b from-transparent to-black/10" />
            </div>

            {/* ── Avatar ── */}
            <div className="relative px-4">
                <div
                    className="absolute -top-10 left-4 h-[76px] w-[76px] overflow-hidden rounded-full border-[3px] border-white bg-gradient-to-br from-[#1d4f91] to-[#002b5c] shadow-sm"
                    style={{ zIndex: 1 }}
                >
                    {profile.imageSrc && !imgError ? (
                        <img
                            src={profile.imageSrc}
                            alt={profile.name}
                            className="h-full w-full object-cover"
                            onError={() => setImgError(true)}
                        />
                    ) : (
                        <div className="flex h-full w-full items-center justify-center text-xl font-bold text-white">
                            {getInitials(profile.name)}
                        </div>
                    )}
                </div>
            </div>

            {/* ── Body ── */}
            <div className="px-4 pb-4 pt-12">
                {/* Name */}
                <div className="flex items-start justify-between gap-2">
                    <div className="min-w-0">
                        <h3 className="truncate text-[1.05rem] font-semibold leading-snug text-[#191919]">
                            {profile.name}
                        </h3>
                        <p className="mt-0.5 text-[0.82rem] leading-snug text-[#434343]">
                            {profile.title}
                        </p>
                    </div>
                    {/* LinkedIn logo pill (top-right) */}
                    <a
                        href={profile.linkedInUrl}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="shrink-0 flex h-8 w-8 items-center justify-center rounded-full text-[#0A66C2] transition-colors hover:bg-[#0A66C2]/10"
                        title="View on LinkedIn"
                        onClick={(e) => e.stopPropagation()}
                    >
                        <span className="h-[18px] w-[18px]">
                            <LinkedInIcon />
                        </span>
                    </a>
                </div>

                {/* Location only */}
                <div className="mt-2 text-[0.8rem] text-[#5e5e5e]">
                    <p className="flex items-center gap-1.5">
                        <svg className="h-3.5 w-3.5 shrink-0 text-[#5e5e5e]" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                            <path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z" />
                            <circle cx="12" cy="10" r="3" />
                        </svg>
                        <span>{profile.location}</span>
                    </p>
                </div>

                {/* Divider */}
                <div className="my-3 border-t border-[#e8e8e8]" />

                {/* Skills */}
                <div className="flex flex-wrap gap-1.5">
                    {profile.skills.map((skill) => (
                        <span
                            key={skill}
                            className="rounded-full bg-[#EEF3FB] px-2.5 py-0.5 text-[0.75rem] font-medium text-[#0A66C2]"
                        >
                            {skill}
                        </span>
                    ))}
                </div>

                {/* Divider */}
                <div className="my-3 border-t border-[#e8e8e8]" />

                {/* CTA Button */}
                <a
                    href={profile.linkedInUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="flex w-full items-center justify-center gap-2 rounded-full border border-[#0A66C2] px-4 py-1.5 text-[0.85rem] font-semibold text-[#0A66C2] transition-all duration-200 hover:bg-[#0A66C2] hover:text-white"
                    onClick={(e) => e.stopPropagation()}
                >
                    <span className="h-4 w-4">
                        <LinkedInIcon />
                    </span>
                    View Profile
                </a>
            </div>
        </motion.div>
    );
};

export const TeamSection: React.FC = () => {
    return (
        <section className="relative overflow-hidden bg-background py-24">
            {/* Background glow */}
            <div className="pointer-events-none absolute left-1/2 top-0 h-64 w-[42rem] -translate-x-1/2 rounded-full bg-[#0A66C2]/10 blur-3xl" />

            <div className="relative z-10 mx-auto max-w-7xl px-6 md:px-12">
                {/* Section header */}
                <div className="mx-auto mb-14 max-w-3xl text-center">
                    <span className="inline-flex items-center gap-2 rounded-full border border-[#0A66C2]/25 bg-[#0A66C2]/10 px-4 py-2 text-sm font-semibold text-[#7ec0ff]">
                        <span className="h-4 w-4 text-[#0A66C2]">
                            <LinkedInIcon />
                        </span>
                        LinkedIn Verified
                    </span>
                    <h2 className="mt-6 text-4xl font-bold text-white md:text-5xl">
                        Meet The Engineering Team
                    </h2>
                    <p className="mt-5 text-lg leading-relaxed text-slate-300">
                        Each profile below is structured to feel familiar to buyers doing due diligence.
                        Click any card to open the real LinkedIn profile and verify the person directly.
                    </p>
                </div>

                {/* Cards grid */}
                <div className="grid grid-cols-1 gap-5 sm:grid-cols-2 xl:grid-cols-3">
                    {teamProfiles.map((profile, index) => (
                        <LinkedInProfileCard
                            key={profile.name}
                            profile={profile}
                            delay={index * 0.1}
                        />
                    ))}
                </div>
            </div>
        </section>
    );
};
