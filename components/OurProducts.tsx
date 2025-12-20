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

  // Calculate translateX based on currentIndex
  useEffect(() => {
    if (!containerRef.current) return;

    const viewportWidth = window.innerWidth;
    // Mobile: larger cards (85vw), Desktop: 35vw
    const cardWidth = viewportWidth < 768 ? viewportWidth * 0.85 : viewportWidth * 0.35;
    const gap = 32; // 2rem

    // Center position for the active card
    const centerOffset = (viewportWidth - cardWidth) / 2;

    // Calculate offset to center the current card
    const offset = centerOffset - (currentIndex * (cardWidth + gap));

    setTranslateX(offset);
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

  // Position-based scroll lock (no pointer dependency)
  useEffect(() => {
    const section = sectionRef.current;
    if (!section) return;

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
      if (now - lastLockChangeRef.current < 500) return; // Cooldown 500ms

      isTransitioningRef.current = true;
      lastLockChangeRef.current = now;

      setIsLocked(false);
      document.body.style.overflow = '';
      document.documentElement.style.overflow = '';

      setTimeout(() => {
        isTransitioningRef.current = false;
      }, 300);
    };

    // Unified scroll handler for both wheel and touch
    const handleNext = () => {
      if (currentIndex < products.length - 1) {
        setCurrentIndex(prev => prev + 1);
        scrollAccumulator = 0;
      } else {
        exitCarousel();
      }
    };

    const handlePrevious = () => {
      if (currentIndex > 0) {
        setCurrentIndex(prev => prev - 1);
        scrollAccumulator = 0;
      } else {
        exitCarousel();
      }
    };

    // Wheel event handler (desktop)
    const handleWheel = (e: WheelEvent) => {
      if (!isLocked) return;

      e.preventDefault();
      e.stopPropagation();

      scrollAccumulator += e.deltaY;

      if (scrollAccumulator > SCROLL_THRESHOLD) {
        handleNext();
      } else if (scrollAccumulator < -SCROLL_THRESHOLD) {
        handlePrevious();
      }
    };

    // Touch handlers (mobile)
    const handleTouchStart = (e: TouchEvent) => {
      touchStartX = e.touches[0].clientX;
      touchStartY = e.touches[0].clientY;
    };

    const handleTouchMove = (e: TouchEvent) => {
      if (!isLocked) return;
      touchEndX = e.touches[0].clientX;
      touchEndY = e.touches[0].clientY;
    };

    const handleTouchEnd = () => {
      if (!isLocked) return;

      const swipeDistanceX = touchStartX - touchEndX;
      const swipeDistanceY = Math.abs(touchStartY - touchEndY);

      // Only handle horizontal swipes (not vertical scrolls)
      if (Math.abs(swipeDistanceX) > swipeDistanceY && Math.abs(swipeDistanceX) > SWIPE_THRESHOLD) {
        if (swipeDistanceX > 0) {
          handleNext();
        } else {
          handlePrevious();
        }
      }

      touchStartX = 0;
      touchStartY = 0;
      touchEndX = 0;
      touchEndY = 0;
    };

    // IntersectionObserver - position-based detection with debouncing
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (isTransitioningRef.current) return;

          const now = Date.now();
          if (now - lastLockChangeRef.current < 500) return; // Cooldown 500ms

          const rect = entry.boundingClientRect;
          const viewportHeight = window.innerHeight;
          const elementCenter = rect.top + rect.height / 2;
          const viewportCenter = viewportHeight / 2;

          // Lock when section center is near viewport center (±200px tolerance)
          const isInActiveZone = Math.abs(elementCenter - viewportCenter) < 200;

          if (entry.isIntersecting && isInActiveZone && !isLocked) {
            lastLockChangeRef.current = now;
            setIsLocked(true);
            setCurrentIndex(0);
            document.body.style.overflow = 'hidden';
            document.documentElement.style.overflow = 'hidden';
          } else if (!entry.isIntersecting && isLocked) {
            exitCarousel();
          }
        });
      },
      {
        threshold: Array.from({ length: 101 }, (_, i) => i / 100),
        rootMargin: '-10% 0px -10% 0px'
      }
    );

    observer.observe(section);

    // Add event listeners only when locked
    if (isLocked) {
      window.addEventListener('wheel', handleWheel, { passive: false });
      section.addEventListener('touchstart', handleTouchStart, { passive: true });
      section.addEventListener('touchmove', handleTouchMove, { passive: true });
      section.addEventListener('touchend', handleTouchEnd);
    }

    return () => {
      observer.disconnect();
      window.removeEventListener('wheel', handleWheel);
      section.removeEventListener('touchstart', handleTouchStart);
      section.removeEventListener('touchmove', handleTouchMove);
      section.removeEventListener('touchend', handleTouchEnd);
      document.body.style.overflow = '';
      document.documentElement.style.overflow = '';
    };
  }, [isLocked, currentIndex]);

  return (
    <section id="products" ref={sectionRef} className="py-10 pb-10 px-6 bg-background overflow-hidden">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-16">
          <h2 className="text-5xl md:text-6xl font-bold text-primary mb-4">
            Our Products
          </h2>
          <p className="text-xl text-secondary">
            Turning Ideas into Powerful Apps & Websites
          </p>
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
          <div className="relative w-full overflow-visible px-16">
            <div
              ref={containerRef}
              className="flex gap-8 transition-transform duration-700 ease-out"
              style={{ transform: `translateX(${translateX}px)` }}
            >
              {products.map((product, index) => {
                const isCenter = index === currentIndex;

                const CardContent = (
                  <>
                    <div className="absolute inset-0 bg-gradient-to-br from-accent/5 to-transparent 
                                opacity-0 group-hover:opacity-100 transition-opacity duration-500" />

                    <div className="w-12 h-12 bg-white/5 rounded-lg flex items-center justify-center 
                                text-accent mb-6 group-hover:scale-110 
                                group-hover:bg-accent group-hover:text-background 
                                transition-all duration-300">
                      <product.icon className="w-6 h-6" />
                    </div>

                    <h3 className="font-serif text-2xl text-primary font-medium mb-3 relative z-10">
                      {product.title}
                    </h3>
                    <p className="text-secondary text-sm leading-relaxed mb-6 relative z-10 line-clamp-3">
                      {product.description}
                    </p>

                    <div className="inline-flex items-center gap-2 text-accent text-xs font-bold 
                                uppercase tracking-widest hover:gap-3 transition-all relative z-10">
                      {product.isExternal ? 'Visit Live Site' : 'Explore App'}
                      <ExternalLink className="w-4 h-4" strokeWidth={2} />
                    </div>
                  </>
                );

                const cardClass = `group p-8 bg-surface rounded-xl relative overflow-hidden
                         flex-shrink-0 w-[85vw] md:w-[35vw] min-w-[280px] transition-all duration-500 ${isCenter
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