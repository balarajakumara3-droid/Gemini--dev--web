import React, { useState, useEffect } from 'react';
import { Menu, X } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { Link, useLocation, useNavigate } from 'react-router-dom';

interface NavItem {
  label: string;
  path: string;
  section?: string;
  isAnchor?: boolean;
}

const navItems: NavItem[] = [
  { label: 'Home', path: '/', section: 'home', isAnchor: false },
  { label: 'Services', path: '/#services', section: 'services', isAnchor: true },
  { label: 'Products', path: '/#products', section: 'products', isAnchor: true },
  { label: 'Portfolio', path: '/portfolio', section: 'portfolio', isAnchor: false },
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
            {navItems.map((item) => (
              <li key={item.label}>
                <Link
                  to={item.path}
                  onClick={(e) => handleNavClick(item, e)}
                  className="text-sm font-medium text-white/80 hover:text-accent transition"
                >
                  {item.label}
                </Link>
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
            className="fixed inset-0 bg-background/95 z-40 flex items-center justify-center pt-24"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
          >
            <nav className="flex flex-col gap-8 text-center">
              <ul className="flex flex-col gap-8 list-none m-0 p-0">
                {navItems.map((item) => (
                  <li key={item.label}>
                    <Link
                      to={item.path}
                      onClick={(e) => handleNavClick(item, e)}
                      className="text-3xl text-white hover:text-accent transition"
                    >
                      {item.label}
                    </Link>
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
