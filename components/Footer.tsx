import React from 'react';

export const Footer: React.FC = () => {
    return (
        <footer className="bg-background text-white py-16 px-6 md:px-12 border-t border-white/5">
            <div className="max-w-7xl mx-auto flex flex-col md:flex-row justify-between items-center gap-8">
                <div className="text-center md:text-left">
                    <h3 className="font-sans font-bold text-2xl mb-2">Idea Manifest</h3>
                    <p className="text-secondary text-sm">Full-Stack AI Engineering</p>
                </div>
                <div className="flex gap-6">
                    <a href="https://x.com/IdeaManifest" target="_blank" rel="noopener noreferrer" className="text-secondary hover:text-accent transition-colors">X (Twitter)</a>
                    <a href="https://www.linkedin.com/company/ideamanifest/" target="_blank" rel="noopener noreferrer" className="text-secondary hover:text-accent transition-colors">LinkedIn</a>
                    <a href="https://www.instagram.com/ideamanifest_official/" target="_blank" rel="noopener noreferrer" className="text-secondary hover:text-accent transition-colors">Instagram</a>
                </div>
                <p className="text-gray-600 text-sm">© 2025 Idea Manifest. All rights reserved.</p>
            </div>
        </footer>
    );
};
