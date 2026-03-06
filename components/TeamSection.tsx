import React from 'react';
import { motion } from 'framer-motion';
import { ArrowUpRight } from 'lucide-react';

type ProfileTheme = {
    avatar: string;
    fallbackCover: string;
};

type TeamProfile = {
    name: string;
    linkedInUrl: string;
    theme: ProfileTheme;
    imageSrc?: string;
    coverImageSrc?: string;
};

const teamProfiles: TeamProfile[] = [
    {
        name: 'Pravin Kumar',
        linkedInUrl: 'https://www.linkedin.com/in/pravin-kumar-39b89222b/?skipRedirect=true',
        imageSrc: '/team/pravin.jpg',
        coverImageSrc: '/team/pravin-cover.jpg',
        theme: {
            avatar: 'from-[#1d4f91] to-[#002b5c]',
            fallbackCover: 'from-[#d9dee4] via-[#eef3f8] to-[#cbd3da]',
        },
    },
    {
        name: 'Shankara Perumal Arunachalam',
        linkedInUrl: 'https://www.linkedin.com/in/shankara-perumal-arunachalam-1b40b6187/',
        imageSrc: '/team/shankara.jpg',
        coverImageSrc: '/team/shankara-cover.jpg',
        theme: {
            avatar: 'from-[#1d4f91] to-[#002b5c]',
            fallbackCover: 'from-[#5a3b2e] via-[#8a644f] to-[#2b1d16]',
        },
    },
    {
        name: 'Narayana Samy',
        linkedInUrl: 'https://www.linkedin.com/in/narayana-samy-9423611b3/',
        imageSrc: '/team/narayana.jpg',
        coverImageSrc: '/team/narayana-cover.svg',
        theme: {
            avatar: 'from-[#1d4f91] to-[#002b5c]',
            fallbackCover: 'from-[#d6e0e5] via-[#c0d0d6] to-[#e7edf1]',
        },
    },
];

const getInitials = (name: string) =>
    name
        .split(' ')
        .map((part) => part[0])
        .join('')
        .slice(0, 2)
        .toUpperCase();

const LinkedInProfileCard = ({ profile, delay }: { profile: TeamProfile; delay: number }) => (
    <motion.a
        href={profile.linkedInUrl}
        target="_blank"
        rel="noopener noreferrer"
        initial={{ opacity: 0, y: 28 }}
        whileInView={{ opacity: 1, y: 0 }}
        whileHover={{ y: -4 }}
        viewport={{ once: true, amount: 0.2 }}
        transition={{ duration: 0.55, delay, ease: [0.22, 1, 0.36, 1] }}
        className="group block overflow-hidden rounded-[1.4rem] border border-[#d0d7de] bg-white text-[#191919] shadow-[0_18px_36px_rgba(15,23,42,0.14)]"
    >
        <div className={`relative h-32 overflow-hidden bg-gradient-to-r ${profile.theme.fallbackCover}`}>
            {profile.coverImageSrc ? (
                <img
                    src={profile.coverImageSrc}
                    alt={`${profile.name} cover`}
                    className="absolute inset-0 h-full w-full object-cover"
                />
            ) : (
                <div className="absolute inset-0 bg-[radial-gradient(circle_at_18%_20%,rgba(255,255,255,0.28),transparent_22%),radial-gradient(circle_at_78%_30%,rgba(255,255,255,0.16),transparent_18%),linear-gradient(135deg,rgba(255,255,255,0.08),transparent_45%,rgba(0,0,0,0.12))]" />
            )}
            <div className="absolute inset-0 bg-gradient-to-t from-white/10 via-transparent to-black/10" />
            <div className="absolute right-4 top-4 inline-flex h-9 w-9 items-center justify-center rounded-full bg-white/95 text-[#0A66C2] shadow-sm transition-transform duration-300 group-hover:scale-105">
                <ArrowUpRight className="h-4 w-4" />
            </div>
            <div className="absolute inset-x-0 bottom-0 h-12 bg-gradient-to-t from-white via-white/85 to-transparent" />
        </div>

        <div className="relative px-5 pb-5 pt-14 md:px-6">
            <div className={`absolute left-5 top-0 inline-flex h-24 w-24 -translate-y-1/2 items-center justify-center overflow-hidden rounded-full border-4 border-white bg-gradient-to-br ${profile.theme.avatar} text-2xl font-bold tracking-[0.18em] text-white shadow-[0_8px_24px_rgba(15,23,42,0.16)]`}>
                {profile.imageSrc ? (
                    <img src={profile.imageSrc} alt={profile.name} className="h-full w-full object-cover" />
                ) : (
                    getInitials(profile.name)
                )}
            </div>

            <div>
                <div className="flex flex-wrap items-center gap-x-2 gap-y-1">
                    <h3 className="text-[1.55rem] font-semibold leading-tight text-[#1d2226]">{profile.name}</h3>
                </div>

                <div className="mt-2 flex flex-wrap items-center gap-x-2 gap-y-2 text-[0.95rem] text-[#5e5e5e]">
                    <span className="font-semibold text-[#0A66C2]">View on LinkedIn</span>
                </div>
            </div>
        </div>
    </motion.a>
);

export const TeamSection: React.FC = () => {
    return (
        <section className="relative overflow-hidden bg-background py-24">
            <div className="pointer-events-none absolute left-1/2 top-0 h-64 w-[42rem] -translate-x-1/2 rounded-full bg-[#0A66C2]/10 blur-3xl" />

            <div className="relative z-10 mx-auto max-w-7xl px-6 md:px-12">
                <div className="mx-auto mb-14 max-w-3xl text-center">
                    <span className="inline-flex items-center rounded-full border border-[#0A66C2]/20 bg-[#0A66C2]/10 px-4 py-2 text-sm font-semibold text-[#7ec0ff]">
                        Public Profiles
                    </span>
                    <h2 className="mt-6 text-4xl font-bold text-white md:text-5xl">Meet The Engineering Team</h2>
                    <p className="mt-5 text-lg leading-relaxed text-slate-300">
                        Each profile below is structured to feel familiar to buyers doing due diligence. Click any card to open the real LinkedIn profile and verify the person directly.
                    </p>
                </div>

                <div className="grid grid-cols-1 gap-6 md:grid-cols-2 xl:grid-cols-3">
                    {teamProfiles.map((profile, index) => (
                        <LinkedInProfileCard key={profile.name} profile={profile} delay={index * 0.08} />
                    ))}
                </div>
            </div>
        </section>
    );
};
