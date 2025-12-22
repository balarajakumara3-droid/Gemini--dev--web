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

    const lastScrollYRef = useRef(0);
    const hasExitedZoneRef = useRef(false);

    // Calculate translateX based on currentIndex with smooth automatic animation
    useEffect(() => {
        if (!containerRef.current) return;

        const updateTransform = () => {
            const viewportWidth = window.innerWidth;
            // Mobile: 70vw for better fit, Desktop: 35vw
            const cardWidth = viewportWidth < 768 ? viewportWidth * 0.70 : viewportWidth * 0.35;
            // Responsive gap: 20px (gap-5) on mobile, 32px (gap-8) on desktop
            const gap = viewportWidth < 768 ? 20 : 32;

            // On mobile, start from right edge for first card (no left empty space)
            // On desktop, center the cards
            if (viewportWidth < 768 && currentIndex === 0) {
                // Position first card to start from right edge
                const offset = viewportWidth - cardWidth - 40; // 40px for right padding
                setTranslateX(offset);
            } else {
                // Center position for the active card
                const centerOffset = (viewportWidth - cardWidth) / 2;
                // Calculate offset to center the current card
                const offset = centerOffset - (currentIndex * (cardWidth + gap));
                setTranslateX(offset);
            }
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
        if (currentIndex < services.length - 1) {
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
                setCurrentIndex(isScrollingDown ? 0 : services.length - 1);

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
                if (currentIndex < services.length - 1) {
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
                    // Swipe UP - next service (move horizontally right)
                    if (currentIndex < services.length - 1) {
                        setCurrentIndex(prev => prev + 1);
                    } else {
                        // At last card, exit carousel to continue normal scroll
                        exitCarousel();
                    }
                } else {
                    // Swipe DOWN - previous service (move horizontally left)
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
        <section id="services" ref={sectionRef} className="relative pt-12 pb-12 px-6 md:px-12 overflow-hidden bg-background">
            <ParticleBackground />
            <div className="max-w-7xl mx-auto relative z-10">
                <div className="text-center mb-12 md:mb-16">
                    <SectionHeading title="Core Capabilities" highlight="Capabilities" />
                    <p className="text-secondary max-w-2xl mx-auto text-base md:text-lg mt-6 px-4">
                        End-to-end development from architecture to deployment. We build scalable, high-performance digital solutions tailored to your business needs.
                    </p>
                    {isLocked && (
                        <div className="mt-4 inline-flex items-center gap-2 text-accent text-sm animate-pulse">
                            <span className="inline-block w-2 h-2 bg-accent rounded-full"></span>
                            Scroll to navigate through services
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
                        aria-label="Previous service"
                    >
                        <ChevronLeft className="w-6 h-6 text-primary" />
                    </button>

                    {/* Horizontal scroll container */}
                    <div className="relative w-full overflow-visible px-10 md:px-16">
                        <div
                            ref={containerRef}
                            className="flex gap-5 md:gap-8 transition-transform duration-700 ease-out"
                            style={{ transform: `translateX(${translateX}px)` }}
                        >
                            {services.map((service, index) => {
                                const isCenter = index === currentIndex;

                                return (
                                    <div
                                        key={service.title}
                                        className={`flex-shrink-0 w-[70vw] md:w-[35vw] h-auto md:h-auto min-h-[200px] md:min-h-[280px] min-w-[260px] max-w-[350px] transition-all duration-500 ${isCenter ? 'scale-105' : 'opacity-70'
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
