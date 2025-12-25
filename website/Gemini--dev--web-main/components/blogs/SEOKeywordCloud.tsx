import React from 'react';
import { Search, Tag } from 'lucide-react';
import { SEO_KEYWORDS } from './BlogData';

export const SEOKeywordCloud: React.FC = () => {
    // Number of keywords to show visually
    const VISIBLE_COUNT = 18;

    const visibleKeywords = SEO_KEYWORDS.slice(0, VISIBLE_COUNT);
    const hiddenKeywords = SEO_KEYWORDS.slice(VISIBLE_COUNT);

    // Helper to capitalize first letter of each word
    const toTitleCase = (str: string) => {
        return str.replace(/\w\S*/g, (txt) => {
            return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
        });
    };

    const bottomTags = [
        "AI Development", "Bangalore Tech", "Chennai SaaS", "Kerala Startup",
        "Hyderabad IT", "Mobile Apps", "Web Development", "Full Stack",
        "Native iOS", "React Native"
    ];

    return (
        <div className="bg-background border-t border-white/5 py-12 px-4 mt-12">
            <div className="max-w-7xl mx-auto">
                <div className="flex items-center gap-3 mb-8">
                    <div className="p-2 rounded-lg bg-surface border border-white/10">
                        <Search className="text-accent w-4 h-4" />
                    </div>
                    <h4 className="text-primary font-bold uppercase tracking-wider text-sm font-sans">
                        Popular Search Topics
                    </h4>
                </div>

                {/* Visible Keywords - Clean UI */}
                <div className="flex flex-wrap gap-3">
                    {visibleKeywords.map((keyword, index) => (
                        <span
                            key={`visible-${index}`}
                            className="px-4 py-2 rounded-full bg-surface border border-white/5 text-xs text-secondary hover:text-white hover:border-accent/50 hover:bg-brand-dark hover:shadow-[0_0_15px_rgba(var(--accent-rgb),0.3)] transition-all duration-300 cursor-pointer font-sans capitalize group flex items-center gap-2"
                        >
                            <span className="w-1.5 h-1.5 rounded-full bg-accent/50 group-hover:bg-accent transition-colors"></span>
                            {keyword}
                        </span>
                    ))}
                </div>

                {/* Hidden Keywords - SEO Only (Visually Hidden but Crawlable) */}
                <div className="sr-only">
                    {hiddenKeywords.map((keyword, index) => (
                        <span key={`hidden-${index}`}>{keyword}</span>
                    ))}
                </div>

                {/* Bottom Tags - Redesigned */}
                <div className="mt-10 pt-8 border-t border-white/5">
                    <div className="flex items-center gap-2 mb-4 text-xs font-bold text-accent/80 uppercase tracking-wider">
                        <Tag className="w-3 h-3" />
                        <span>Regional Focus & Tech Stacks</span>
                    </div>
                    <div className="flex flex-wrap gap-x-6 gap-y-3">
                        {bottomTags.map((tag, index) => (
                            <span
                                key={`tag-${index}`}
                                className="text-xs text-secondary/60 hover:text-accent transition-colors cursor-pointer font-mono flex items-center gap-1.5 group"
                            >
                                <span className="text-accent/30 group-hover:text-accent transition-colors">#</span>
                                {tag}
                            </span>
                        ))}
                    </div>
                </div>
            </div>
        </div>
    )
}
