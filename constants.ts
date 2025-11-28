import { Monitor, Smartphone, Database, PenTool, Lightbulb, Zap, ShieldCheck, Cpu } from 'lucide-react';
import { ServiceItem, ValueItem, FAQItem, StatItem } from './types';

export const NAV_LINKS = [
    { label: 'Home', href: '/' },
    { label: 'Services', href: '/services' },
    { label: 'Technology', href: '/technology' },
    { label: 'FAQ', href: '/faq' },
    { label: 'Contact', href: '/contact' },
];

export const CORE_VALUES: ValueItem[] = [
    {
        title: 'Client-Centricity',
        description: 'Your success is our obsession. We ensure clean code, clear communication, and no surprises.',
        icon: ShieldCheck,
    },
    {
        title: 'Transparent Quality',
        description: 'We prioritize honesty and transparency in all our projects, building trust through tangible results.',
        icon: Monitor,
    },
    {
        title: 'AI-Driven Efficiency',
        description: 'Leveraging advanced LLMs and RAG pipelines to cut build times in half without compromising quality.',
        icon: Zap,
    },
];

export const SERVICES: ServiceItem[] = [
    {
        title: 'Custom Websites',
        description: 'High-performance, SEO-optimized websites tailored to your brand. We use Next.js and React to build blazing fast platforms.',
        icon: Monitor,
    },
    {
        title: 'Mobile Applications',
        description: 'Native-quality iOS and Android apps built with Flutter and React Native from a single, maintainable codebase.',
        icon: Smartphone,
    },
    {
        title: 'Backend Development',
        description: 'Robust, secure, and scalable server-side solutions. We architect APIs and databases that handle high traffic.',
        icon: Database,
    },
    {
        title: 'UI/UX Design',
        description: 'User-centric interfaces that are as beautiful as they are functional. Intuitive journeys that delight users.',
        icon: PenTool,
    },
    {
        title: 'Tech Consulting',
        description: 'Strategic guidance to navigate the digital landscape. We help you choose the right stack and plan your roadmap.',
        icon: Lightbulb,
    },
];

export const STATS: StatItem[] = [
    { value: '2X', label: 'Faster Delivery' },
    { value: '50+', label: 'Products Shipped' },
    { value: '100%', label: 'Code Ownership' },
];

export const FAQS: FAQItem[] = [
    {
        question: "What is your typical tech stack?",
        answer: "We are stack-agnostic but prefer modern, typed ecosystems. Our go-to stack typically involves React/Next.js for frontend, Python (FastAPI/Django) or Node.js for backend, and PostgreSQL for database, deployed on AWS or Azure."
    },
    {
        question: "How fast can you deliver an MVP?",
        answer: "By leveraging our AI-powered development process and pre-built modules, we can often deliver a polished MVP in as little as 4-6 weeks, allowing you to validate ideas quickly."
    },
    {
        question: "Do you handle mobile app deployment?",
        answer: "Yes, we handle the end-to-end process, including setting up developer accounts, configuring certificates, and submitting your apps to both the Apple App Store and Google Play Store."
    },
    {
        question: "How do you handle source code ownership?",
        answer: "You own 100% of the code. Once the project is complete and payment is settled, we transfer all repositories and intellectual property rights directly to you."
    }
];
