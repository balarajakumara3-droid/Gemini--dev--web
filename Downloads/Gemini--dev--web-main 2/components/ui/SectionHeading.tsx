import React from 'react';

interface Props {
    title: string;
    subtitle?: string;
    align?: 'left' | 'center';
    highlightWord?: string;
}

export const SectionHeading: React.FC<Props> = ({ title, subtitle, align = 'center', highlightWord }) => {
    // Simple helper to split text and highlight the word
    const renderTitle = () => {
        if (!highlightWord) return title;
        const parts = title.split(highlightWord);
        return (
            <>
                {parts[0]}
                <span className="font-serif italic text-blue-500">{highlightWord}</span>
                {parts[1]}
            </>
        );
    };

    return (
        <div className={`mb-16 ${align === 'center' ? 'text-center' : 'text-left'} max-w-3xl mx-auto`}>
            <h2 className="text-3xl md:text-5xl font-bold text-white mb-6 leading-tight">
                {renderTitle()}
            </h2>
            {subtitle && (
                <p className="text-gray-400 text-lg leading-relaxed">
                    {subtitle}
                </p>
            )}
        </div>
    );
};
