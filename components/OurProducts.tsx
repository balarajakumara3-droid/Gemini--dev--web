// components/OurProducts.tsx
import React, { useRef, useEffect, useState } from 'react';
import { ExternalLink, Sparkles, MapPin, Smartphone, TrendingUp, ChevronLeft, ChevronRight } from 'lucide-react';

const products = [
  {
    title: "Summarizer",
    description: "An AI-based tool that turns long content into short summaries. Save time and understand faster.",
    url: "summarizer",
    icon: Sparkles,
    accentColor: "indigo",
    isExternal: true,
  },
  {
    title: "Namma Ooru Special",
    description: "Discover local food, shops, and specialties. Built to support local businesses and culture.",
    url: "nammaooruspl",
    icon: MapPin,
    accentColor: "emerald",
    isExternal: true,
  },
  {
    title: "Real Estate App",
    description: "Buy, sell, and rent properties easily. Search listings and connect with agents seamlessly.",
    url: "https://play.google.com/store/apps/details?id=com.brickspace",
    icon: Smartphone,
    accentColor: "blue",
    isExternal: true,
  },
  {
    title: "Virtual Trader",
    description: "Practice stock trading risk-free with ₹10L virtual cash and real-time market insights.",
    url: "/virtual-trader",
    icon: TrendingUp,
    accentColor: "cyan",
    isExternal: false,
  },
];

const OurProducts = () => {
  const sectionRef = useRef<HTMLElement>(null);
  const containerRef = useRef<HTMLDivElement>(null);
  const [isLocked, setIsLocked] = useState(false);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [translateX, setTranslateX] = useState(0);
  const isTransitioningRef = useRef(false);
  const lastLockChangeRef = useRef(0);

  const lastScrollYRef = useRef(0);
  const hasExitedZoneRef = useRef(false);

  // Calculate translateX based on currentIndex with smooth automatic animation
  useEffect(() => {
    if (!containerRef.current) return;

    const updateTransform = () => {
      const viewportWidth = window.innerWidth;
      // Mobile: calc based on available space, Desktop: 35vw max
      // Account for container padding to prevent overflow
      const containerPadding = viewportWidth < 768 ? 32 : 64; // px-4 md:px-8 total (both sides)
      const availableWidth = viewportWidth - containerPadding;

      // More conservative card widths to prevent overflow
      const cardWidth = viewportWidth < 768
        ? Math.min(availableWidth * 0.80, 320) // 80% of available width, max 320px
        : Math.min(viewportWidth * 0.35, 400); // 35vw, max 400px

      // Responsive gap: 16px on mobile, 32px on desktop
      const gap = viewportWidth < 768 ? 16 : 32;

      // Center position for the active card
      const centerOffset = (viewportWidth - cardWidth) / 2;
      // Calculate offset to center the current card
      const offset = centerOffset - (currentIndex * (cardWidth + gap));
      setTranslateX(offset);
    };

    updateTransform();

    // Recalculate on window resize for responsive behavior
    window.addEventListener('resize', updateTransform);
    return () => window.removeEventListener('resize', updateTransform);
  }, [currentIndex]);

  // Manual navigation functions
  const goToPrevious = () => {
    if (currentIndex > 0) {
      setCurrentIndex(prev => prev - 1);
    }
  };

  const goToNext = () => {
    if (currentIndex < products.length - 1) {
      setCurrentIndex(prev => prev + 1);
    }
  };

  // IntersectionObserver for scroll lock detection - Auto-centers section
  useEffect(() => {
    const section = sectionRef.current;
    if (!section) return;

    const exitCarousel = () => {
      const now = Date.now();
      if (now - lastLockChangeRef.current < 500) return; // Cooldown 500ms

      isTransitioningRef.current = true;
      lastLockChangeRef.current = now;
      hasExitedZoneRef.current = true;

      setIsLocked(false);
      document.body.style.overflow = '';
      document.documentElement.style.overflow = '';

      setTimeout(() => {
        isTransitioningRef.current = false;
      }, 300);
    };

    // Scroll-based detection for better reliability
    const checkPosition = () => {
      if (isTransitioningRef.current) return;

      const rect = section.getBoundingClientRect();
      const viewportHeight = window.innerHeight;
      const elementCenter = rect.top + rect.height / 2;
      const viewportCenter = viewportHeight / 2;

      // Calculate distance from center
      const distanceFromCenter = Math.abs(elementCenter - viewportCenter);
      const isInActiveZone = distanceFromCenter < 300;
      const isVisible = rect.top < viewportHeight && rect.bottom > 0;

      if (!isInActiveZone) {
        hasExitedZoneRef.current = false;
      }

      const now = Date.now();
      const cooldownPassed = now - lastLockChangeRef.current > 500;

      const currentScrollY = window.scrollY;
      const isScrollingDown = currentScrollY > (lastScrollYRef.current || 0);

      // Lock when section is in the active zone
      if (isVisible && isInActiveZone && !isLocked && cooldownPassed && !hasExitedZoneRef.current) {
        lastLockChangeRef.current = now;
        setIsLocked(true);

        // If scrolling down (from top), start at index 0
        // If scrolling up (from bottom), start at last index
        setCurrentIndex(isScrollingDown ? 0 : products.length - 1);

        document.body.style.overflow = 'hidden';
        document.documentElement.style.overflow = 'hidden';

        // Smooth scroll to center the section perfectly
        section.scrollIntoView({ behavior: 'smooth', block: 'center' });
      }
      // Unlock when section is far from viewport
      else if (isLocked && !isVisible) {
        exitCarousel();
      }

      lastScrollYRef.current = currentScrollY;
    };

    // Use both IntersectionObserver and scroll listener for reliability
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            checkPosition();
          } else if (isLocked) {
            exitCarousel();
          }
        });
      },
      {
        threshold: [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1],
        rootMargin: '-5% 0px -5% 0px'
      }
    );

    observer.observe(section);

    // Add scroll listener for continuous position checking
    const scrollHandler = () => {
      if (!isLocked) {
        checkPosition();
      }
    };

    window.addEventListener('scroll', scrollHandler, { passive: true });

    return () => {
      observer.disconnect();
      window.removeEventListener('scroll', scrollHandler);
      document.body.style.overflow = '';
      document.documentElement.style.overflow = '';
    };
  }, [isLocked]);

  // Separate effect for event listeners to avoid recreation issues
  useEffect(() => {
    const section = sectionRef.current;
    if (!section || !isLocked) return;

    let scrollAccumulator = 0;
    const SCROLL_THRESHOLD = 150;

    // Touch handling for mobile
    let touchStartX = 0;
    let touchStartY = 0;
    let touchEndX = 0;
    let touchEndY = 0;
    const SWIPE_THRESHOLD = 50;

    const exitCarousel = () => {
      const now = Date.now();
      if (now - lastLockChangeRef.current < 500) return;

      isTransitioningRef.current = true;
      lastLockChangeRef.current = now;
      hasExitedZoneRef.current = true; // Added this line

      setIsLocked(false);
      document.body.style.overflow = '';
      document.documentElement.style.overflow = '';

      setTimeout(() => {
        isTransitioningRef.current = false;
      }, 300);
    };

    // Wheel event handler (desktop)
    const handleWheel = (e: WheelEvent) => {
      e.preventDefault();
      e.stopPropagation();

      scrollAccumulator += e.deltaY;

      // Scrolling down (positive deltaY)
      if (scrollAccumulator > SCROLL_THRESHOLD) {
        if (currentIndex < products.length - 1) {
          // Go to next card
          setCurrentIndex(prev => prev + 1);
          scrollAccumulator = 0;
        } else {
          // At last card, exit carousel on continued scroll down
          exitCarousel();
        }
      }
      // Scrolling up (negative deltaY)
      else if (scrollAccumulator < -SCROLL_THRESHOLD) {
        if (currentIndex > 0) {
          // Go to previous card
          setCurrentIndex(prev => prev - 1);
          scrollAccumulator = 0;
        } else {
          // At first card, exit carousel on continued scroll up
          exitCarousel();
        }
      }
    };

    // Touch handlers (mobile) - Vertical swipe controls horizontal navigation
    const handleTouchStart = (e: TouchEvent) => {
      touchStartX = e.touches[0].clientX;
      touchStartY = e.touches[0].clientY;
    };

    const handleTouchMove = (e: TouchEvent) => {
      touchEndX = e.touches[0].clientX;
      touchEndY = e.touches[0].clientY;

      // Always prevent default scroll when locked
      e.preventDefault();
    };

    const handleTouchEnd = () => {
      const swipeDistanceX = Math.abs(touchStartX - touchEndX);
      const swipeDistanceY = touchStartY - touchEndY; // Positive = swipe up, Negative = swipe down

      // Only handle VERTICAL swipes to control HORIZONTAL navigation
      if (Math.abs(swipeDistanceY) > swipeDistanceX && Math.abs(swipeDistanceY) > SWIPE_THRESHOLD) {
        if (swipeDistanceY > 0) {
          // Swipe UP - next product (move horizontally right)
          if (currentIndex < products.length - 1) {
            setCurrentIndex(prev => prev + 1);
          } else {
            // At last card, exit carousel to continue normal scroll
            exitCarousel();
          }
        } else {
          // Swipe DOWN - previous product (move horizontally left)
          if (currentIndex > 0) {
            setCurrentIndex(prev => prev - 1);
          } else {
            // At first card, exit carousel to continue normal scroll
            exitCarousel();
          }
        }
      }

      touchStartX = 0;
      touchStartY = 0;
      touchEndX = 0;
      touchEndY = 0;
    };

    // Add event listeners
    window.addEventListener('wheel', handleWheel, { passive: false });
    section.addEventListener('touchstart', handleTouchStart, { passive: true });
    section.addEventListener('touchmove', handleTouchMove, { passive: false });
    section.addEventListener('touchend', handleTouchEnd, { passive: true });

    return () => {
      window.removeEventListener('wheel', handleWheel);
      section.removeEventListener('touchstart', handleTouchStart);
      section.removeEventListener('touchmove', handleTouchMove);
      section.removeEventListener('touchend', handleTouchEnd);
    };
  }, [isLocked, currentIndex]);

  return (
    <section id="products" ref={sectionRef} className="py-10 pb-10 px-4 md:px-6 bg-background overflow-hidden">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-12 md:mb-16">
          <h2 className="text-4xl md:text-5xl lg:text-6xl font-bold text-primary mb-4">
            Our Products
          </h2>
          <p className="text-lg md:text-xl text-secondary">
            Turning Ideas into Powerful Apps & Websites
          </p>
          {isLocked && (
            <div className="mt-4 inline-flex items-center gap-2 text-accent text-sm animate-pulse">
              <span className="inline-block w-2 h-2 bg-accent rounded-full"></span>
              Scroll to navigate through products
            </div>
          )}
        </div>

        {/* Carousel container with arrows */}
        <div className="relative">
          {/* Left Arrow */}
          <button
            onClick={goToPrevious}
            disabled={currentIndex === 0}
            className={`absolute left-0 top-1/2 -translate-y-1/2 z-20 w-12 h-12 rounded-full bg-surface border border-white/10 flex items-center justify-center transition-all ${currentIndex === 0
              ? 'opacity-30 cursor-not-allowed'
              : 'hover:bg-accent hover:border-accent hover:scale-110'
              }`}
            aria-label="Previous product"
          >
            <ChevronLeft className="w-6 h-6 text-primary" />
          </button>

          {/* Horizontal scroll container */}
          <div className="relative w-full overflow-visible px-4 md:px-8">
            <div
              ref={containerRef}
              className="flex gap-5 md:gap-8 transition-transform duration-700 ease-out"
              style={{ transform: `translateX(${translateX}px)` }}
            >
              {products.map((product, index) => {
                const isCenter = index === currentIndex;

                const CardContent = (
                  <>
                    <div className="absolute inset-0 bg-gradient-to-br from-accent/5 to-transparent 
                                opacity-0 group-hover:opacity-100 transition-opacity duration-500" />

                    <div className="w-10 h-10 md:w-12 md:h-12 bg-white/5 rounded-lg flex items-center justify-center 
                                text-accent mb-4 md:mb-6 group-hover:scale-110 
                                group-hover:bg-accent group-hover:text-background 
                                transition-all duration-300">
                      <product.icon className="w-5 h-5 md:w-6 md:h-6" />
                    </div>

                    <h3 className="font-serif text-lg md:text-2xl text-primary font-medium mb-2 md:mb-3 relative z-10 text-left">
                      {product.title}
                    </h3>
                    <p className="text-secondary text-xs md:text-sm leading-relaxed mb-4 md:mb-6 relative z-10 line-clamp-3 text-left">
                      {product.description}
                    </p>

                    <div className="inline-flex items-center gap-2 text-accent text-xs font-bold 
                                uppercase tracking-widest hover:gap-3 transition-all relative z-10">
                      {product.isExternal ? 'Visit Live Site' : 'Explore App'}
                      <ExternalLink className="w-3 h-3 md:w-4 md:h-4" strokeWidth={2} />
                    </div>
                  </>
                );

                const cardClass = `group p-4 md:p-8 bg-surface rounded-xl relative overflow-hidden
                         flex-shrink-0 w-[80vw] max-md:w-[70vw] md:w-[35vw] h-auto md:h-auto min-h-[200px] md:min-h-[280px] max-w-[min(80vw,350px)] md:max-w-[400px] transition-all duration-500 ${isCenter
                    ? 'border-2 border-accent shadow-[0_0_30px_rgba(129,140,248,0.3)] scale-105'
                    : 'border border-white/5 hover:border-accent/30 shadow-lg hover:shadow-indigo-500/10 opacity-70'
                  }`;

                if (product.isExternal) {
                  return (
                    <a
                      key={product.title}
                      href={product.url}
                      target="_blank"
                      rel="noopener noreferrer"
                      className={cardClass}
                    >
                      {CardContent}
                    </a>
                  );
                }

                return (
                  <a
                    key={product.title}
                    href={product.url}
                    className={cardClass}
                  >
                    {CardContent}
                  </a>
                );
              })}
            </div>
          </div>

          {/* Right Arrow */}
          <button
            onClick={goToNext}
            disabled={currentIndex === products.length - 1}
            className={`absolute right-0 top-1/2 -translate-y-1/2 z-20 w-12 h-12 rounded-full bg-surface border border-white/10 flex items-center justify-center transition-all ${currentIndex === products.length - 1
              ? 'opacity-30 cursor-not-allowed'
              : 'hover:bg-accent hover:border-accent hover:scale-110'
              }`}
            aria-label="Next product"
          >
            <ChevronRight className="w-6 h-6 text-primary" />
          </button>
        </div>

        {/* Progress indicator */}
        <div className="flex justify-center gap-2 mt-8">
          {products.map((_, index) => (
            <button
              key={index}
              onClick={() => setCurrentIndex(index)}
              className={`h-1 rounded-full transition-all duration-300 cursor-pointer ${index === currentIndex
                ? 'w-8 bg-accent'
                : 'w-2 bg-white/20 hover:bg-white/40'
                }`}
              aria-label={`Go to product ${index + 1}`}
            />
          ))}
        </div>
      </div>
    </section>
  );
};

export default OurProducts;