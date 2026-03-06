// components/OurProducts.tsx
import React from 'react';
import { ExternalLink, Sparkles, MapPin, Smartphone, TrendingUp, ChevronLeft, ChevronRight, Home, Pizza } from 'lucide-react';
import { useLockedHorizontalCarousel } from './useLockedHorizontalCarousel';

const products = [
  {
    title: "Thamizh Veedu Homes",
    description: "Discover and buy Heritage Homes in Tamil Nadu. The trusted marketplace to buy, sell, or rent properties.",
    url: "https://thamizh-veedu-homes.vercel.app/",
    icon: Home,
    accentColor: "orange",
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
    title: "Summarizer",
    description: "An AI-based tool that turns long content into short summaries. Save time and understand faster.",
    url: "summarizer",
    icon: Sparkles,
    accentColor: "indigo",
    isExternal: true,
  },
  {
    title: "True Estate",
    description: "Buy, sell, and rent properties easily. Search listings and connect with agents seamlessly.",
    url: "https://true-estate-ashen.vercel.app/",
    icon: Smartphone,
    accentColor: "blue",
    isExternal: true,
  },
  {
    title: "Topping Tale Studio",
    description: "Build Your Perfect Slice. Fresh ingredients, endless customizations, and flavors that make every bite unforgettable. Craft your dream pizza today!",
    url: "https://topping-tale-studio-git-main-bala-rajas-projects-4cdcde3b.vercel.app/",
    icon: Pizza,
    accentColor: "orange",
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
  const {
    sectionRef,
    containerRef,
    isLocked,
    currentIndex,
    translateX,
    setCurrentIndex,
    goToPrevious,
    goToNext,
  } = useLockedHorizontalCarousel(products.length);

  return (
    <section
      id="products"
      ref={sectionRef}
      className="py-10 pb-10 px-4 md:px-6 bg-background overflow-hidden"
      style={{ touchAction: isLocked ? 'none' : 'pan-y' }}
    >
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
