import React, { useRef, useEffect, useState } from 'react';
import { ServiceCard } from './services/ServiceCard';
import { ParticleBackground } from './ParticleBackground';
import { SectionHeading } from './ui/SectionHeading';
import { Monitor, Smartphone, Server, Zap, Settings, ChevronLeft, ChevronRight } from 'lucide-react';

const services = [
    {
        title: "Custom Websites",
        description: "High-performance, SEO-optimized websites tailored to your brand.",
        Icon: Monitor,
        link: "/services#websites"
    },
    {
        title: "Mobile Applications",
        description: "Native-quality iOS and Android apps built with Flutter and React Native.",
        Icon: Smartphone,
        link: "/services#mobile"
    },
    {
        title: "Backend Development",
        description: "Robust, secure, and scalable server-side solutions with complex logic.",
        Icon: Server,
        link: "/services#backend"
    },
    {
        title: "UI/UX Design",
        description: "User-centric interfaces that are as beautiful as they are functional.",
        Icon: Zap,
        link: "/services#uiux"
    },
    {
        title: "Tech Consulting",
        description: "Strategic guidance to navigate the digital landscape and leverage AI.",
        Icon: Settings,
        link: "/services#consulting"
    }
];

export const ServicesSection: React.FC = () => {
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
        if (currentIndex < services.length - 1) {
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
            if (currentIndex < services.length - 1) {
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
        <section id="services" ref={sectionRef} className="relative pt-12 pb-12 px-6 md:px-12 overflow-hidden bg-background">
            <ParticleBackground />
            <div className="max-w-7xl mx-auto relative z-10">
                <div className="text-center mb-16">
                    <SectionHeading title="Core Capabilities" highlight="Capabilities" />
                    <p className="text-secondary max-w-2xl mx-auto text-lg mt-6">
                        End-to-end development from architecture to deployment. We build scalable, high-performance digital solutions tailored to your business needs.
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
                        aria-label="Previous service"
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
                            {services.map((service, index) => {
                                const isCenter = index === currentIndex;

                                return (
                                    <div
                                        key={service.title}
                                        className={`flex-shrink-0 w-[85vw] md:w-[30vw] min-w-[280px] transition-all duration-500 ${isCenter ? 'scale-105' : 'opacity-70'
                                            }`}
                                    >
                                        <div className={`${isCenter ? 'border-2 border-accent shadow-[0_0_30px_rgba(129,140,248,0.3)]' : ''} rounded-xl`}>
                                            <ServiceCard
                                                title={service.title}
                                                description={service.description}
                                                Icon={service.Icon}
                                                link={service.link}
                                            />
                                        </div>
                                    </div>
                                );
                            })}
                        </div>
                    </div>

                    {/* Right Arrow */}
                    <button
                        onClick={goToNext}
                        disabled={currentIndex === services.length - 1}
                        className={`absolute right-0 top-1/2 -translate-y-1/2 z-20 w-12 h-12 rounded-full bg-surface border border-white/10 flex items-center justify-center transition-all ${currentIndex === services.length - 1
                            ? 'opacity-30 cursor-not-allowed'
                            : 'hover:bg-accent hover:border-accent hover:scale-110'
                            }`}
                        aria-label="Next service"
                    >
                        <ChevronRight className="w-6 h-6 text-primary" />
                    </button>
                </div>

                {/* Progress indicator */}
                <div className="flex justify-center gap-2 mt-8">
                    {services.map((_, index) => (
                        <button
                            key={index}
                            onClick={() => setCurrentIndex(index)}
                            className={`h-1 rounded-full transition-all duration-300 cursor-pointer ${index === currentIndex
                                ? 'w-8 bg-accent'
                                : 'w-2 bg-white/20 hover:bg-white/40'
                                }`}
                            aria-label={`Go to service ${index + 1}`}
                        />
                    ))}
                </div>
            </div>
        </section>
    );
};
