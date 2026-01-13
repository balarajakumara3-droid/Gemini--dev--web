import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Send, Loader2, CheckCircle2, X, ChevronDown, Check } from 'lucide-react';

const PROJECT_TYPES = [
    { value: 'website', label: 'Website' },
    { value: 'mobile', label: 'Mobile App' },
    { value: 'backend', label: 'Backend' },
    { value: 'ai-integration', label: 'AI Integration' },
    { value: 'custom', label: 'Custom Solution' },
];

export const ContactForm: React.FC = () => {
    const [formData, setFormData] = useState({
        name: '',
        email: '',
        whatsapp: '',
        projectType: '',
        message: ''
    });

    const [isSubmitting, setIsSubmitting] = useState(false);
    const [isDropdownOpen, setIsDropdownOpen] = useState(false);
    const [showSuccess, setShowSuccess] = useState(false);
    const [error, setError] = useState<string | null>(null);

    const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
        setFormData(prev => ({ ...prev, [e.target.name]: e.target.value }));
    };

    const handleProjectTypeSelect = (value: string) => {
        setFormData(prev => ({ ...prev, projectType: value }));
        setIsDropdownOpen(false);
    };

    const onSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
        event.preventDefault();
        setIsSubmitting(true);
        setError(null);

        // Create a new FormData object for submission (if using Formspree or similar)
        // Or just use the state if sending JSON. 
        // Preserving the original logic of creating FormData from event.currentTarget if needed, but here we have controlled state.
        // Let's use the controlled state to ensure everything is captured.

        const submissionData = new FormData();
        submissionData.append('name', formData.name);
        submissionData.append('email', formData.email);
        submissionData.append('whatsapp', formData.whatsapp);
        submissionData.append('projectType', formData.projectType);
        submissionData.append('message', formData.message);

        try {
            const response = await fetch("https://formspree.io/f/xwvkqknw", {
                method: "POST",
                body: submissionData,
                headers: {
                    'Accept': 'application/json'
                }
            });

            if (response.ok) {
                setShowSuccess(true);
                setFormData({
                    name: '',
                    email: '',
                    whatsapp: '',
                    projectType: '',
                    message: ''
                });
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

    const selectedLabel = PROJECT_TYPES.find(t => t.value === formData.projectType)?.label || "Project Type";

    return (
        <div className="relative">
            <form onSubmit={onSubmit} className="space-y-4">
                <div className="grid grid-cols-2 max-md:grid-cols-1 gap-4">
                    <input
                        type="text"
                        name="name"
                        placeholder="Name"
                        required
                        value={formData.name}
                        onChange={handleChange}
                        className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg focus:outline-none focus:border-accent text-white placeholder:text-slate-500"
                    />

                    <input
                        type="email"
                        name="email"
                        placeholder="Email Address"
                        required
                        value={formData.email}
                        onChange={handleChange}
                        className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg focus:outline-none focus:border-accent text-white placeholder:text-slate-500"
                    />
                </div>

                <div>
                    <input
                        type="tel"
                        name="whatsapp"
                        placeholder="WhatsApp (Optional)"
                        value={formData.whatsapp}
                        onChange={handleChange}
                        className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg focus:outline-none focus:border-accent text-white placeholder:text-slate-500"
                    />
                </div>

                <div className="relative">
                    <button
                        type="button"
                        onClick={() => setIsDropdownOpen(!isDropdownOpen)}
                        className={`w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg flex items-center justify-between transition-all duration-300 ${isDropdownOpen ? 'border-accent' : 'hover:border-white/20'}`}
                    >
                        <span className={`${formData.projectType ? 'text-white' : 'text-gray-400'}`}>
                            {selectedLabel}
                        </span>
                        <motion.div
                            animate={{ rotate: isDropdownOpen ? 180 : 0 }}
                            transition={{ duration: 0.3 }}
                            className="text-white/50"
                        >
                            <ChevronDown size={20} />
                        </motion.div>
                    </button>

                    <AnimatePresence>
                        {isDropdownOpen && (
                            <>
                                <div
                                    className="fixed inset-0 z-10"
                                    onClick={() => setIsDropdownOpen(false)}
                                />

                                <motion.ul
                                    initial={{ opacity: 0, y: 10, scale: 0.95 }}
                                    animate={{ opacity: 1, y: 5, scale: 1 }}
                                    exit={{ opacity: 0, y: 10, scale: 0.95 }}
                                    className="absolute left-0 right-0 z-20 bg-[#0A0F1E] border border-white/10 rounded-xl shadow-2xl overflow-hidden backdrop-blur-xl mt-2"
                                >
                                    {PROJECT_TYPES.map((type) => (
                                        <li key={type.value}>
                                            <button
                                                type="button"
                                                onClick={() => handleProjectTypeSelect(type.value)}
                                                className={`w-full px-4 py-3 text-left flex items-center justify-between transition-colors hover:bg-white/5 font-medium ${formData.projectType === type.value ? 'text-accent' : 'text-slate-300'}`}
                                            >
                                                {type.label}
                                                {formData.projectType === type.value && <Check size={16} className="text-accent" />}
                                            </button>
                                        </li>
                                    ))}
                                </motion.ul>
                            </>
                        )}
                    </AnimatePresence>
                </div>

                <textarea
                    name="message"
                    rows={4}
                    placeholder="Tell us a bit about your project..."
                    required
                    value={formData.message}
                    onChange={handleChange}
                    className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg focus:outline-none focus:border-accent text-white resize-none placeholder:text-slate-500"
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
                            Starting Conversation...
                        </span>
                    ) : (
                        <span className="flex items-center justify-center gap-2">
                            Start Conversation
                            <Send className="w-5 h-5" />
                        </span>
                    )}
                </button>

                {error && (
                    <p className="text-center text-rose-400 text-sm mt-2">{error}</p>
                )}

                <p className="text-center text-xs text-slate-500 mt-4">
                    By sending this, you agree to our privacy policy. Your idea is safe with us.
                </p>
            </form>

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
                                    Thanks for reaching out. An engineer (not a bot) will review your message and get back to you within 24 hours.
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
