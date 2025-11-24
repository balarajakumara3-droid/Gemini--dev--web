import React, { useState, useEffect } from 'react';
import { Menu, X } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

const navItems = [
  { label: 'Home', path: '/' },
  { label: 'Services', path: '/services', section: 'services' },
  { label: 'Technology', path: '/technology', section: 'technology' },
  { label: 'FAQ', path: '/faq', section: 'faq' },
  { label: 'Contact', path: '/contact', section: 'contact' },
];

export const Navbar: React.FC = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);

  const scrollToSection = (id?: string) => {
    if (!id) return;

    const section = document.getElementById(id);
    if (section) {
      section.scrollIntoView({ behavior: 'smooth' });
    }
  };

  const handleNavClick = (
    e: React.MouseEvent<HTMLAnchorElement>,
    item: typeof navItems[0]
  ) => {
    e.preventDefault();

    window.history.pushState({}, '', item.path);

    scrollToSection(item.section);

    setIsOpen(false);
  };

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 50);
    };
    window.addEventListener('scroll', handleScroll);

    const handlePopState = () => {
      const path = window.location.pathname.replace('/', '');

      if (path) scrollToSection(path);
    };

    window.addEventListener('popstate', handlePopState);

    return () => {
      window.removeEventListener('scroll', handleScroll);
      window.removeEventListener('popstate', handlePopState);
    };
  }, []);

  return (
    <>
      <motion.nav
        initial={{ y: -100 }}
        animate={{ y: 0 }}
        transition={{ duration: 0.8 }}
        className={`fixed top-0 left-0 right-0 z-50 px-6 md:px-12 py-4 flex justify-between items-center transition-all duration-500 ${
          scrolled
            ? 'bg-background/80 backdrop-blur-md shadow-lg border-b border-white/5'
            : 'bg-transparent'
        }`}
      >
        <div className="flex items-center gap-3">
          <a
            href="/"
            onClick={(e) => handleNavClick(e, navItems[0])}
            className="font-bold text-xl text-white"
          >
            Idea Manifest
          </a>
        </div>

        {/* Desktop */}
        <div className="hidden md:flex gap-10 items-center">
          {navItems.map((item) => (
            <a
              key={item.label}
              href={item.path}
              onClick={(e) => handleNavClick(e, item)}
              className="text-sm font-medium text-white/80 hover:text-accent transition"
            >
              {item.label}
            </a>
          ))}
        </div>

        {/* Mobile */}
        <button className="md:hidden text-white" onClick={() => setIsOpen(!isOpen)}>
          {isOpen ? <X size={24} /> : <Menu size={24} />}
        </button>
      </motion.nav>

      {/* Mobile Menu */}
      <AnimatePresence>
        {isOpen && (
          <motion.div className="fixed inset-0 bg-background/95 z-40 flex justify-center items-center">
            <div className="flex flex-col gap-8 text-center">
              {navItems.map((item) => (
                <a
                  key={item.label}
                  href={item.path}
                  onClick={(e) => handleNavClick(e, item)}
                  className="text-3xl text-white hover:text-accent"
                >
                  {item.label}
                </a>
              ))}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
};
