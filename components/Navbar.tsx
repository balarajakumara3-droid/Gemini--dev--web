import React, { useState, useEffect } from 'react';
import { Menu, X, Phone } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { Link, useLocation, useNavigate } from 'react-router-dom';

interface NavItem {
  label: string;
  path: string;
  section?: string;
  isAnchor?: boolean;
}

const navItems: NavItem[] = [
  { label: 'Our Services', path: '/services', section: 'services', isAnchor: false },
  { label: 'Our Works', path: '/work', section: 'work', isAnchor: false },
  { label: 'About', path: '/about', section: 'about', isAnchor: false },
  { label: 'Blogs', path: '/blogs', section: 'blogs', isAnchor: false },
  { label: 'Contact', path: '/contact', section: 'contact', isAnchor: false },
];

export const Navbar: React.FC = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);
  const location = useLocation();
  const navigate = useNavigate();

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 50);
    };

    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  // Handle hash scrolling after navigation
  useEffect(() => {
    if (location.hash) {
      const sectionId = location.hash.replace('#', '');
      setTimeout(() => {
        const element = document.getElementById(sectionId);
        if (element) {
          element.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      }, 100);
    }
  }, [location]);

  const handleNavClick = (item: NavItem, e: React.MouseEvent) => {
    if (item.isAnchor && item.section) {
      e.preventDefault();

      // If we're on the homepage, just scroll
      if (location.pathname === '/') {
        const element = document.getElementById(item.section);
        if (element) {
          element.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      } else {
        // Navigate to homepage with hash
        navigate(item.path);
      }
    } else if (item.path === '/' && item.section === 'home') {
      // Home link - scroll to top if on homepage
      if (location.pathname === '/') {
        e.preventDefault();
        window.scrollTo({ top: 0, behavior: 'smooth' });
      }
    }

    setIsOpen(false);
  };

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
          className="flex items-center gap-2"
        >
          <img src="/logo.png" alt="Idea Manifest" className="h-20 w-auto max-md:h-10" />
        </Link>

        {/* Desktop Nav */}
        <nav className="hidden md:flex gap-8 items-center">
          <ul className="flex gap-8 items-center list-none m-0 p-0">
            {navItems.map((item) => {
              const isActive = item.path === '/'
                ? location.pathname === '/'
                : location.pathname.startsWith(item.path);

              return (
                <li key={item.label}>
                  <Link
                    to={item.path}
                    onClick={(e) => handleNavClick(item, e)}
                    className={`text-sm font-medium transition relative group ${isActive
                      ? "text-transparent bg-clip-text bg-gradient-to-r from-accent via-blue-400 to-cyan-400"
                      : "text-white/80 hover:text-accent"
                      }`}
                  >
                    {item.label}
                  </Link>
                </li>
              );
            })}
          </ul>
        </nav>

        <div className="hidden md:flex items-center gap-4">
          <motion.div
            className="relative flex items-center bg-accent/90 hover:bg-accent text-white rounded-full overflow-hidden cursor-pointer shadow-lg shadow-accent/20"
            initial={{ width: "48px" }} // Compact initial state
            whileHover={{ width: "auto" }} // Expand on hover
            transition={{ duration: 0.4, ease: "easeInOut" }} // Calm ease-in-out
            onClick={() => window.open('https://calendly.com/ideamanifest-support/30min', '_blank')}
          >
            <div className="flex items-center justify-center min-w-[48px] h-10">
              <motion.div
                animate={{ rotate: [0, -10, 10, -10, 10, 0] }}
                transition={{
                  duration: 2.5,
                  repeat: Infinity,
                  repeatDelay: 3, // Pauses between vibrations
                  ease: "easeInOut"
                }}
              >
                <Phone size={20} className="fill-current" />
              </motion.div>
            </div>

            <motion.div
              className="whitespace-nowrap pr-6 pl-1 flex flex-col justify-center"
              initial={{ opacity: 0 }}
              whileHover={{ opacity: 1 }}
              transition={{ duration: 0.3, delay: 0.1 }}
            >
              <span className="font-medium text-sm">Let's Connect</span>
              <span className="text-[10px] text-white/70 uppercase tracking-wider leading-none">Schedule a short conversation</span>
            </motion.div>
          </motion.div>
        </div>

        {/* Mobile button */}
        <button
          className="md:hidden text-white ml-auto"
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
            className="fixed inset-0 bg-background/95 z-40 flex items-center justify-center pt-24"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
          >
            <nav className="flex flex-col gap-8 text-center px-6">
              <ul className="flex flex-col gap-6 list-none m-0 p-0">
                {navItems.map((item) => {
                  const isActive = item.path === '/'
                    ? location.pathname === '/'
                    : location.pathname.startsWith(item.path);

                  return (
                    <li key={item.label}>
                      <Link
                        to={item.path}
                        onClick={(e) => handleNavClick(item, e)}
                        className={`text-2xl transition ${isActive
                          ? "text-transparent bg-clip-text bg-gradient-to-r from-blue-400 via-violet-400 to-rose-400"
                          : "text-white hover:text-accent"
                          }`}
                      >
                        {item.label}
                      </Link>
                    </li>
                  );
                })}
              </ul>

              <button
                onClick={() => {
                  setIsOpen(false);
                  // REPLACE WITH REAL CALENDLY LINK
                  window.open('https://calendly.com/ideamanifest/strategy-call', '_blank');
                }}
                className="bg-accent hover:bg-blue-700 text-white px-8 py-3 rounded-full font-medium transition-all shadow-lg text-lg mt-4"
              >
                Book a 15-Minute Strategy Call
              </button>
            </nav>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
};
