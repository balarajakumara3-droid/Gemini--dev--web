import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { CheckCircle2, X } from 'lucide-react';

export const ContactForm: React.FC = () => {
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [projectType, setProjectType] = useState("");
    const [showSuccess, setShowSuccess] = useState(false);
    const [error, setError] = useState<string | null>(null);

    const onSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
        event.preventDefault();
        setIsSubmitting(true);
        setError(null);

        const form = event.currentTarget;
        const formData = new FormData(form);

        try {
            const response = await fetch("https://formspree.io/f/xwvkqknw", {
                method: "POST",
                body: formData,
                headers: {
                    'Accept': 'application/json'
                }
            });

            if (response.ok) {
                setShowSuccess(true);
                form.reset();
                setProjectType("");
            } else {
                const data = await response.json();
                setError(data.errors?.[0]?.message || "Something went wrong. Please try again.");
            }
        } catch (err) {
            setError("Unable to connect. Please check your internet connection.");
        } finally {
            setIsSubmitting(false);
        }
    };

    return (
        <div className="relative">
            <form onSubmit={onSubmit} className="space-y-4">
                <div className="grid grid-cols-2 gap-4">
                    <input
                        type="text"
                        name="name"
                        placeholder="Name"
                        required
                        className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg focus:outline-none focus:border-accent text-white"
                    />

                    <input
                        type="email"
                        name="email"
                        placeholder="Email Address"
                        required
                        className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg focus:outline-none focus:border-accent text-white"
                    />
                </div>

                <select
                    name="projectType"
                    value={projectType}
                    onChange={(e) => setProjectType(e.target.value)}
                    required
                    className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg focus:outline-none focus:border-accent text-white"
                >
                    <option value="" disabled className="bg-[#020617] text-gray-400">
                        Project Type
                    </option>
                    <option value="website" className="bg-[#020617] text-white">
                        Website
                    </option>
                    <option value="mobile" className="bg-[#020617] text-white">
                        Mobile App
                    </option>
                    <option value="backend" className="bg-[#020617] text-white">
                        Backend
                    </option>
                    <option value="custom" className="bg-[#020617] text-white">
                        Custom Solution
                    </option>
                </select>

                <textarea
                    name="message"
                    rows={4}
                    placeholder="Message"
                    required
                    className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg focus:outline-none focus:border-accent text-white resize-none"
                ></textarea>

                <button
                    type="submit"
                    disabled={isSubmitting}
                    className="w-full py-4 bg-slate-800 text-white rounded-lg font-bold hover:bg-slate-700 transition-colors border border-white/5 disabled:opacity-50 disabled:cursor-not-allowed group"
                >
                    {isSubmitting ? (
                        <span className="flex items-center justify-center gap-2">
                            <motion.div
                                animate={{ rotate: 360 }}
                                transition={{ duration: 1, repeat: Infinity, ease: "linear" }}
                                className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full"
                            />
                            Sending...
                        </span>
                    ) : (
                        "Book Free Consultation"
                    )}
                </button>

                {error && (
                    <p className="text-center text-rose-400 text-sm mt-2">{error}</p>
                )}
            </form>

            {/* Success Popup */}
            <AnimatePresence>
                {showSuccess && (
                    <motion.div
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        className="fixed inset-0 z-[100] flex items-center justify-center px-4 bg-background/80 backdrop-blur-sm"
                    >
                        <motion.div
                            initial={{ scale: 0.9, opacity: 0, y: 20 }}
                            animate={{ scale: 1, opacity: 1, y: 0 }}
                            exit={{ scale: 0.9, opacity: 0, y: 20 }}
                            className="bg-[#050A14] border border-white/10 p-8 rounded-2xl max-w-md w-full relative overflow-hidden group shadow-2xl"
                        >
                            {/* Gradient Background Decoration */}
                            <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-blue-400 via-violet-400 to-rose-400" />

                            <button
                                onClick={() => setShowSuccess(false)}
                                className="absolute top-4 right-4 text-white/40 hover:text-white transition-colors"
                            >
                                <X size={20} />
                            </button>

                            <div className="text-center">
                                <motion.div
                                    initial={{ scale: 0 }}
                                    animate={{ scale: 1 }}
                                    transition={{ type: "spring", damping: 12, stiffness: 200, delay: 0.2 }}
                                    className="w-16 h-16 bg-blue-500/10 rounded-full flex items-center justify-center mx-auto mb-6"
                                >
                                    <CheckCircle2 size={32} className="text-blue-400" />
                                </motion.div>

                                <h3 className="text-2xl font-bold text-white mb-2">Message Sent!</h3>
                                <p className="text-slate-400 leading-relaxed mb-8">
                                    Thanks, we'll connect with you soon. Our team is reviewing your project details.
                                </p>

                                <button
                                    onClick={() => setShowSuccess(false)}
                                    className="w-full py-3 bg-white text-black rounded-lg font-semibold hover:bg-slate-100 transition-colors"
                                >
                                    Dismiss
                                </button>
                            </div>
                        </motion.div>
                    </motion.div>
                )}
            </AnimatePresence>
        </div>
    );
};
