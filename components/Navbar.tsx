import React, { useState, useEffect } from 'react';
import { Menu, X } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

const navItems = [
  { label: 'Home', path: '/', section: 'home' },
  { label: 'About', path: '/about/', section: 'about' },
  { label: 'Services', path: '/services/', section: 'services' },
  { label: 'Technology', path: '/technology/', section: 'technology' },
  { label: 'FAQ', path: '/faq/', section: 'faq' },
  { label: 'Contact', path: '/contact/', section: 'contact' },
];

export const Navbar: React.FC = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 50);
    };

    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  return (
    <>
      <motion.nav
        initial={{ y: -100 }}
        animate={{ y: 0 }}
        transition={{ duration: 0.8 }}
        className={`fixed top-0 w-full z-50 px-6 md:px-12 py-4 flex justify-between items-center transition-all ${scrolled
          ? "bg-background/80 backdrop-blur-md border-b border-white/5"
          : "bg-transparent"
          }`}
      >
        {/* Logo */}
        <a
          href="/"
          className="flex items-center gap-2"
        >
          <img src="/logo.png" alt="Idea Manifest" className="h-20 w-auto max-md:h-10" />
        </a>

        {/* Desktop Nav */}
        <nav className="hidden md:flex gap-10 items-center">
          <ul className="flex gap-10 items-center list-none m-0 p-0">
            {navItems.map((item) => (
              <li key={item.label}>
                <a
                  href={item.path}
                  className="text-sm font-medium text-white/80 hover:text-accent transition"
                >
                  {item.label}
                </a>
              </li>
            ))}
          </ul>
        </nav>

        {/* Mobile button */}
        <button
          className="md:hidden text-white"
          onClick={() => setIsOpen(!isOpen)}
          aria-label="Toggle menu"
        >
          {isOpen ? <X size={24} /> : <Menu size={24} />}
        </button>
      </motion.nav>

      {/* Mobile Menu */}
      <AnimatePresence>
        {isOpen && (
          <motion.div
            className="fixed inset-0 bg-background/95 z-40 flex items-center justify-center"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
          >
            <nav className="flex flex-col gap-8 text-center">
              <ul className="flex flex-col gap-8 list-none m-0 p-0">
                {navItems.map((item) => (
                  <li key={item.label}>
                    <a
                      href={item.path}
                      onClick={() => setIsOpen(false)}
                      className="text-3xl text-white hover:text-accent"
                    >
                      {item.label}
                    </a>
                  </li>
                ))}
              </ul>
            </nav>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
};
