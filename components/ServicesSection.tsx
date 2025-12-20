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

    // Calculate translateX to show 3 cards with center one highlighted
    useEffect(() => {
        if (!containerRef.current) return;

        const viewportWidth = window.innerWidth;
        const cardWidth = viewportWidth * 0.35; // 35vw
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

    // Scroll lock and horizontal scroll logic + Touch support
    useEffect(() => {
        const section = sectionRef.current;
        if (!section) return;

        let scrollAccumulator = 0;
        const SCROLL_THRESHOLD = 200;

        // Touch handling variables
        let touchStartX = 0;
        let touchEndX = 0;
        const SWIPE_THRESHOLD = 50;

        const handleWheel = (e: WheelEvent) => {
            if (!isLocked || isTransitioningRef.current) return;

            e.preventDefault();
            e.stopPropagation();

            scrollAccumulator += e.deltaY;

            // Move to next card
            if (scrollAccumulator > SCROLL_THRESHOLD) {
                if (currentIndex < services.length - 1) {
                    setCurrentIndex(prev => prev + 1);
                    scrollAccumulator = 0;
                } else {
                    // Last card reached - exit
                    isTransitioningRef.current = true;
                    scrollAccumulator = 0;

                    setTimeout(() => {
                        setIsLocked(false);
                        document.body.style.overflow = '';
                        document.documentElement.style.overflow = '';

                        setTimeout(() => {
                            isTransitioningRef.current = false;
                        }, 100);
                    }, 200);
                }
            }
            // Move to previous card
            else if (scrollAccumulator < -SCROLL_THRESHOLD) {
                if (currentIndex > 0) {
                    setCurrentIndex(prev => prev - 1);
                    scrollAccumulator = 0;
                } else {
                    // First card - upward exit
                    isTransitioningRef.current = true;
                    scrollAccumulator = 0;

                    setTimeout(() => {
                        setIsLocked(false);
                        document.body.style.overflow = '';
                        document.documentElement.style.overflow = '';

                        setTimeout(() => {
                            isTransitioningRef.current = false;
                        }, 100);
                    }, 200);
                }
            }
        };

        // Touch event handlers for mobile
        const handleTouchStart = (e: TouchEvent) => {
            touchStartX = e.touches[0].clientX;
        };

        const handleTouchMove = (e: TouchEvent) => {
            if (!isLocked) return;
            touchEndX = e.touches[0].clientX;
        };

        const handleTouchEnd = () => {
            if (!isLocked || isTransitioningRef.current) return;

            const swipeDistance = touchStartX - touchEndX;

            // Swipe left (next card)
            if (swipeDistance > SWIPE_THRESHOLD) {
                if (currentIndex < services.length - 1) {
                    setCurrentIndex(prev => prev + 1);
                } else {
                    // Last card - exit
                    isTransitioningRef.current = true;
                    setTimeout(() => {
                        setIsLocked(false);
                        document.body.style.overflow = '';
                        document.documentElement.style.overflow = '';
                        setTimeout(() => {
                            isTransitioningRef.current = false;
                        }, 100);
                    }, 200);
                }
            }
            // Swipe right (previous card)
            else if (swipeDistance < -SWIPE_THRESHOLD) {
                if (currentIndex > 0) {
                    setCurrentIndex(prev => prev - 1);
                } else {
                    // First card - exit
                    isTransitioningRef.current = true;
                    setTimeout(() => {
                        setIsLocked(false);
                        document.body.style.overflow = '';
                        document.documentElement.style.overflow = '';
                        setTimeout(() => {
                            isTransitioningRef.current = false;
                        }, 100);
                    }, 200);
                }
            }

            // Reset touch coordinates
            touchStartX = 0;
            touchEndX = 0;
        };

        // IntersectionObserver to detect when section is visible
        const observer = new IntersectionObserver(
            (entries) => {
                entries.forEach((entry) => {
                    if (isTransitioningRef.current) return;

                    // Lock when section is visible (more lenient than requiring exact center)
                    if (entry.isIntersecting && entry.intersectionRatio > 0.3 && !isLocked) {
                        setIsLocked(true);
                        document.body.style.overflow = 'hidden';
                        document.documentElement.style.overflow = 'hidden';
                    }
                });
            },
            { threshold: [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1] }
        );

        observer.observe(section);

        if (isLocked) {
            window.addEventListener('wheel', handleWheel, { passive: false });
            window.addEventListener('touchstart', handleTouchStart, { passive: false });
            window.addEventListener('touchmove', handleTouchMove, { passive: false });
            window.addEventListener('touchend', handleTouchEnd);
        }

        return () => {
            observer.disconnect();
            window.removeEventListener('wheel', handleWheel);
            window.removeEventListener('touchstart', handleTouchStart);
            window.removeEventListener('touchmove', handleTouchMove);
            window.removeEventListener('touchend', handleTouchEnd);
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
                                        className={`flex-shrink-0 w-[85vw] md:w-[35vw] min-w-[280px] transition-all duration-500 ${isCenter ? 'scale-105' : 'opacity-70'
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
