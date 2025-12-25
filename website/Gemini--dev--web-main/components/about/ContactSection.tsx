import React from 'react';

export const ContactSection: React.FC = () => {
    return (
        <section id="contact" className="py-24 bg-[#050A14] relative overflow-hidden">
            {/* Background grid accent */}
            <div className="absolute top-0 right-0 w-1/2 h-full bg-grid-pattern opacity-10 pointer-events-none" />

            <div className="max-w-6xl mx-auto px-6 relative z-10">
                <div className="bg-[#0F1623] border border-white/10 rounded-3xl p-8 md:p-16 flex flex-col md:flex-row gap-12 items-center">

                    <div className="flex-1">
                        <h2 className="text-4xl md:text-5xl font-bold text-white mb-6">
                            Ready to <span className="font-serif italic text-blue-500">Scale</span> <br />
                            <span className="font-serif italic text-blue-500">Your Vision?</span>
                        </h2>
                        <p className="text-gray-400 mb-8 text-lg">
                            Let's build something extraordinary together. Book your free consultation today or visit our contact page.
                        </p>
                        <div className="flex items-center gap-3 text-gray-300">
                            <div className="w-2 h-2 rounded-full bg-green-500 animate-pulse" />
                            <a href="mailto:hello@ideamanifest.com" className="hover:text-blue-400 transition-colors">hello@ideamanifest.com</a>
                        </div>
                    </div>

                    <div className="flex-1 w-full max-w-md">
                        <form className="space-y-4" onSubmit={(e) => e.preventDefault()}>
                            <div className="grid grid-cols-2 gap-4">
                                <input
                                    type="text"
                                    placeholder="Name"
                                    className="w-full bg-[#050A14] border border-white/10 rounded-lg px-4 py-3 text-white focus:outline-none focus:border-blue-500 transition-colors placeholder:text-gray-600"
                                />
                                <input
                                    type="email"
                                    placeholder="Email Address"
                                    className="w-full bg-[#050A14] border border-white/10 rounded-lg px-4 py-3 text-white focus:outline-none focus:border-blue-500 transition-colors placeholder:text-gray-600"
                                />
                            </div>
                            <select className="w-full bg-[#050A14] border border-white/10 rounded-lg px-4 py-3 text-gray-400 focus:outline-none focus:border-blue-500 transition-colors appearance-none">
                                <option>Project Type</option>
                                <option>Web Development</option>
                                <option>Mobile App</option>
                                <option>AI Consulting</option>
                            </select>
                            <textarea
                                placeholder="Message"
                                rows={4}
                                className="w-full bg-[#050A14] border border-white/10 rounded-lg px-4 py-3 text-white focus:outline-none focus:border-blue-500 transition-colors placeholder:text-gray-600 resize-none"
                            />
                            <button className="w-full bg-gradient-to-r from-slate-700 to-slate-800 hover:from-slate-600 hover:to-slate-700 border border-white/10 text-white font-medium py-4 rounded-lg transition-all shadow-lg hover:shadow-blue-900/20">
                                Book Free Consultation
                            </button>
                        </form>
                    </div>

                </div>
            </div>
        </section>
    );
};
