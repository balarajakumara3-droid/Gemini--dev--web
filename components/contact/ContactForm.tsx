import React, { useState } from 'react';

export const ContactForm: React.FC = () => {
    const [result, setResult] = useState("");
    const [projectType, setProjectType] = useState("");

    const onSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
        event.preventDefault();
        setResult("Sending....");

        const form = event.currentTarget;
        const formData = new FormData(form);
        formData.append("access_key", "55579e15-9a8e-45a0-a6b7-26f2cddb193b");

        try {
            const response = await fetch("https://api.web3forms.com/submit", {
                method: "POST",
                body: formData,
            });

            const data = await response.json();

            if (data.success) {
                setResult("✅ Message Sent Successfully!");
                form.reset();
                setProjectType("");
                setTimeout(() => setResult(""), 4000);
            } else {
                setResult("❌ Something went wrong. Try again.");
            }
        } catch (err) {
            setResult("❌ Something went wrong. Try again.");
        }
    };

    return (
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
                className="w-full px-4 py-3 bg-[#020617] border border-white/10 rounded-lg focus:outline-none focus:border-accent text-white appearance-none"
            >
                <option value="" disabled className="bg-[#020617] text-gray-400">
                    Project Type
                </option>
                <option value="website" className="bg-[#020617] text-white hover:bg-[#1e293b]">
                    Website
                </option>
                <option value="mobile" className="bg-[#020617] text-white hover:bg-[#1e293b]">
                    Mobile App
                </option>
                <option value="backend" className="bg-[#020617] text-white hover:bg-[#1e293b]">
                    Backend
                </option>
                <option value="custom" className="bg-[#020617] text-white hover:bg-[#1e293b]">
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
                className="w-full py-4 bg-slate-800 text-white rounded-lg font-bold hover:bg-slate-700 transition-colors border border-white/5"
            >
                Book Free Consultation
            </button>

            {result && <p className="text-center text-secondary mt-2">{result}</p>}
        </form>
    );
};
