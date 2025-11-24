import React, { useState, useEffect } from 'react';
import { Menu, X } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

const navItems = [
  { label: 'Home', href: '#home' },
  { label: 'Services', href: '#services' },
  { label: 'Technology', href: '#technology' },
  { label: 'FAQ', href: '#faq' },
];

export const Navbar: React.FC = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 50);
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <>
      <motion.nav
        initial={{ y: -100 }}
        animate={{ y: 0 }}
        transition={{ duration: 0.8, ease: [0.19, 1, 0.22, 1] }}
        className={`fixed top-0 left-0 right-0 z-50 px-6 md:px-12 py-4 flex justify-between items-center transition-all duration-500 ${scrolled ? 'bg-background/80 backdrop-blur-md shadow-lg shadow-indigo-500/5 border-b border-white/5 py-4' : 'bg-transparent py-6'
          }`}
      >
        <div className="flex items-center gap-3">
          {/* Professional Logo */}
          <div className={`w-10 h-10 rounded-lg flex items-center justify-center transition-colors bg-black text-white`}>
            <span className="font-serif font-bold text-xl">IM</span>
          </div>
          <a href="#" className={`font-sans font-bold text-xl tracking-tight transition-colors text-white`}>
            Idea Manifest
          </a>
        </div>

        {/* Desktop Menu */}
        <div className="hidden md:flex gap-10 items-center">
          {navItems.map((item) => (
            <a
              key={item.label}
              href={item.href}
              className={`text-sm font-medium transition-colors relative group text-white/80 hover:text-accent`}
            >
              {item.label}
              <span className="absolute -bottom-1 left-0 w-0 h-px bg-accent transition-all group-hover:w-full"></span>
            </a>
          ))}
          <a
            href="#contact"
            className={`px-6 py-2.5 rounded-full text-sm font-semibold transition-all duration-300 ${scrolled
                ? 'bg-white text-background hover:bg-white/90'
                : 'bg-white text-background hover:bg-white/90'
              }`}
          >
            Contact Us
          </a>
        </div>

        {/* Mobile Toggle */}
        <button
          className={`md:hidden z-50 relative text-white`}
          onClick={() => setIsOpen(!isOpen)}
        >
          {isOpen ? <X size={24} /> : <Menu size={24} />}
        </button>
      </motion.nav>

      {/* Mobile Menu Overlay */}
      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-background/95 backdrop-blur-xl z-40 flex items-center justify-center"
          >
            <div className="flex flex-col items-center gap-8">
              {navItems.map((item, index) => (
                <motion.a
                  key={item.label}
                  href={item.href}
                  initial={{ y: 50, opacity: 0 }}
                  animate={{ y: 0, opacity: 1 }}
                  transition={{ delay: index * 0.1, duration: 0.5 }}
                  className="font-serif italic text-4xl md:text-5xl text-white hover:text-accent transition-colors"
                  onClick={() => setIsOpen(false)}
                >
                  {item.label}
                </motion.a>
              ))}
              <motion.a
                href="#contact"
                initial={{ y: 50, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                transition={{ delay: 0.4, duration: 0.5 }}
                className="mt-4 px-8 py-3 bg-accent text-background rounded-full text-lg font-medium"
                onClick={() => setIsOpen(false)}
              >
                Contact Us
              </motion.a>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
};