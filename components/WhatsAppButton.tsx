import React, { useState } from 'react';
import { MessageSquare, Mail } from 'lucide-react'; // Using lucid-react icons for cleaner look
import { FaWhatsapp } from 'react-icons/fa';
import { motion, AnimatePresence } from 'framer-motion';

export const WhatsAppButton: React.FC = () => {
  const [isHovered, setIsHovered] = useState(false);

  return (
    <motion.div
      className="fixed bottom-8 right-8 z-50 flex flex-col-reverse items-end gap-3"
      onHoverStart={() => setIsHovered(true)}
      onHoverEnd={() => setIsHovered(false)}
    >
      {/* Main Toggle Button */}
      <div className="relative flex items-center justify-center">
        {/* Ripple Effect - Double Layer for stronger visibility */}
        {!isHovered && (
          <>
            <motion.div
              className="absolute inset-0 rounded-full bg-accent/40"
              animate={{ scale: [1, 2], opacity: [0.7, 0] }}
              transition={{ duration: 2, repeat: Infinity, ease: "easeOut" }}
            />
            <motion.div
              className="absolute inset-0 rounded-full bg-accent/30"
              animate={{ scale: [1, 2], opacity: [0.5, 0] }}
              transition={{ duration: 2, repeat: Infinity, ease: "easeOut", delay: 1 }}
            />
          </>
        )}

        <div className={`
                    relative flex items-center justify-center w-12 h-12 rounded-full cursor-pointer transition-all duration-300 shadow-xl border border-white/10 z-10
                    ${isHovered ? 'bg-surface text-white' : 'bg-surface/90 text-white backdrop-blur-md'}
                `}>
          <MessageSquare size={20} />
        </div>
      </div>

      {/* Expanded Options */}
      <AnimatePresence>
        {isHovered && (
          <motion.div
            initial={{ opacity: 0, y: 10, scale: 0.95 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: 10, scale: 0.95 }}
            transition={{ duration: 0.2 }}
            className="flex flex-col gap-2 mb-2"
          >
            {/* WhatsApp Option */}
            <button
              onClick={() => {
                const message = encodeURIComponent("Hi, I came across Idea Manifest and wanted to discuss a project.");
                window.open(`https://wa.me/918760602348?text=${message}`, '_blank');
              }}
              className="flex items-center gap-3 px-4 py-3 bg-[#25D366] text-white rounded-xl shadow-lg hover:brightness-110 transition-all text-left"
            >
              <FaWhatsapp size={20} />
              <div className="flex flex-col">
                <span className="text-xs font-bold leading-tight">WhatsApp</span>
                <span className="text-[10px] opacity-90 leading-tight">Quick chat</span>
              </div>
            </button>

            {/* Email Option */}
            <button
              onClick={() => window.location.href = 'mailto:hello@ideamanifest.com'}
              className="flex items-center gap-3 px-4 py-3 bg-white text-black rounded-xl shadow-lg hover:bg-gray-100 transition-all text-left"
            >
              <Mail size={20} />
              <div className="flex flex-col">
                <span className="text-xs font-bold leading-tight">Email</span>
                <span className="text-[10px] opacity-70 leading-tight">Detailed inquiry</span>
              </div>
            </button>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  );
};
