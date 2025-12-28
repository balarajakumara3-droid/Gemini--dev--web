import React from 'react';

export const Footer: React.FC = () => {
    return (
        <footer className="bg-background text-white py-16 px-6 md:px-12 border-t border-white/5">
            <div className="max-w-7xl mx-auto flex flex-col md:flex-row justify-between items-center gap-12">
                <div className="text-center md:text-left">
                    <h3 className="font-sans font-bold text-2xl mb-2 text-primary">Idea Manifest</h3>
                    <p className="text-secondary text-sm">Full-Stack AI Engineering</p>
                </div>

                <div className="flex flex-wrap justify-center md:justify-end gap-x-8 gap-y-4 items-center">
                    <a href="https://x.com/IdeaManifest" target="_blank" rel="noopener noreferrer" className="flex items-center gap-2 text-secondary hover:text-accent transition-all duration-300 group">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 512 462.799" fill="currentColor">
                            <path d="M403.229 0h78.506L310.219 196.04 512 462.799H354.002L230.261 301.007 88.669 462.799h-78.56l183.455-209.683L0 0h161.999l111.856 147.88L403.229 0zm-27.556 415.805h43.505L138.363 44.527h-46.68l283.99 371.278z" />
                        </svg>
                        <span className="text-sm font-medium">(Twitter)</span>
                    </a>

                    <a href="https://www.linkedin.com/company/ideamanifest/" target="_blank" rel="noopener noreferrer" className="flex items-center gap-2 text-secondary hover:text-accent transition-all duration-300 group">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M6.5 8C7.32843 8 8 7.32843 8 6.5C8 5.67157 7.32843 5 6.5 5C5.67157 5 5 5.67157 5 6.5C5 7.32843 5.67157 8 6.5 8Z" />
                            <path d="M5 10C5 9.44772 5.44772 9 6 9H7C7.55228 9 8 9.44771 8 10V18C8 18.5523 7.55228 19 7 19H6C5.44772 19 5 18.5523 5 18V10Z" />
                            <path d="M11 19H12C12.5523 19 13 18.5523 13 18V13.5C13 12 16 11 16 13V18.0004C16 18.5527 16.4477 19 17 19H18C18.5523 19 19 18.5523 19 18V12C19 10 17.5 9 15.5 9C13.5 9 13 10.5 13 10.5V10C13 9.44771 12.5523 9 12 9H11C10.4477 9 10 9.44772 10 10V18C10 18.5523 10.4477 19 11 19Z" />
                            <path fill-rule="evenodd" clip-rule="evenodd" d="M20 1C21.6569 1 23 2.34315 23 4V20C23 21.6569 21.6569 23 20 23H4C2.34315 23 1 21.6569 1 20V4C1 2.34315 2.34315 1 4 1H20ZM20 3C20.5523 3 21 3.44772 21 4V20C21 20.5523 20.5523 21 20 21H4C3.44772 21 3 20.5523 3 20V4C3 3.44772 3.44772 3 4 3H20Z" />
                        </svg>
                        <span className="text-sm font-medium">LinkedIn</span>
                    </a>

                    <a href="https://www.instagram.com/ideamanifest_official/" target="_blank" rel="noopener noreferrer" className="flex items-center gap-2 text-secondary hover:text-accent transition-all duration-300 group">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="2" y="2" width="20" height="20" rx="5" ry="5"></rect>
                            <path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"></path>
                            <line x1="17.5" y1="6.5" x2="17.51" y2="6.5"></line>
                        </svg>
                        <span className="text-sm font-medium">Instagram</span>
                    </a>


                </div>
            </div>

            <div className="max-w-7xl mx-auto mt-12 pt-8 border-t border-white/5 flex flex-col md:flex-row justify-between items-center gap-4">
                <p className="text-gray-500 text-xs tracking-wider uppercase font-semibold">
                    © {new Date().getFullYear()} Idea Manifest. All rights reserved.
                </p>
                <p className="text-gray-600 text-[10px] uppercase tracking-[0.2em]">
                    Delivering Future with AI
                </p>
            </div>
        </footer>
    );
};
