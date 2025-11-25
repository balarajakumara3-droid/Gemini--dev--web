import React, { useState, useEffect } from 'react';
import { Menu, X } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { Link, useLocation } from 'react-router-dom';

const navItems = [
  { label: 'Home', path: '/', section: 'home' },
  { label: 'Services', path: '/services', section: 'services' },
  { label: 'Technology', path: '/technology', section: 'technology' },
  { label: 'FAQ', path: '/faq', section: 'faq' },
  { label: 'Contact', path: '/contact', section: 'contact' },
];

export const Navbar: React.FC = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);

  const location = useLocation();

  const scrollToSection = (id?: string) => {
    if (!id) return;

    setTimeout(() => {
      const section = document.getElementById(id);
      if (section) {
        section.scrollIntoView({ behavior: 'smooth' });
      }
    }, 200);
  };

  // ✅ Auto scroll when URL changes (ex: /services -> services section)
  useEffect(() => {
    const path = location.pathname.replace("/", "");

    if (path === "") {
      scrollToSection("home");
      return;
    }

    const matched = navItems.find((item) => item.section === path);
    if (matched) {
      scrollToSection(matched.section);
    }
  }, [location.pathname]);

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
        <Link
          to="/"
          onClick={() => {
            scrollToSection("home");
            setIsOpen(false);
          }}
          className="flex items-center gap-2"
        >
          <img src="/logo.png" alt="Idea Manifest" className="h-20 w-auto" />
        </Link>

        {/* Desktop Nav */}
        <div className="hidden md:flex gap-10 items-center">
          {navItems.map((item) => (
            <Link
              key={item.label}
              to={item.path}
              onClick={() => {
                scrollToSection(item.section);
                setIsOpen(false);
              }}
              className="text-sm font-medium text-white/80 hover:text-accent transition"
            >
              {item.label}
            </Link>
          ))}
        </div>

        {/* Mobile button */}
        <button
          className="md:hidden text-white"
          onClick={() => setIsOpen(!isOpen)}
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
            <div className="flex flex-col gap-8 text-center">
              {navItems.map((item) => (
                <Link
                  key={item.label}
                  to={item.path}
                  onClick={() => {
                    scrollToSection(item.section);
                    setIsOpen(false);
                  }}
                  className="text-3xl text-white hover:text-accent"
                >
                  {item.label}
                </Link>
              ))}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
};
