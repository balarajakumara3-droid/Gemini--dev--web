import React from 'react';
import { ServiceCard } from './services/ServiceCard';
import { ParticleBackground } from './ParticleBackground';
import { SectionHeading } from './ui/SectionHeading';
import { Monitor, Smartphone, Server, Zap, Settings, ChevronLeft, ChevronRight } from 'lucide-react';
import { useLockedHorizontalCarousel } from './useLockedHorizontalCarousel';

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
    const {
        sectionRef,
        containerRef,
        isLocked,
        currentIndex,
        translateX,
        setCurrentIndex,
        goToPrevious,
        goToNext,
    } = useLockedHorizontalCarousel(services.length);

    return (
        <section
            id="services"
            ref={sectionRef}
            className="relative pt-12 pb-12 px-6 md:px-12 overflow-hidden bg-background"
            style={{ touchAction: isLocked ? 'none' : 'pan-y' }}
        >
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
                    <div className="relative w-full overflow-visible px-4 md:px-8">
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
                                        className={`flex-shrink-0 w-[80vw] md:w-[35vw] max-md:w-[70vw] h-auto md:h-auto min-h-[200px] md:min-h-[280px] max-w-[min(80vw,350px)] md:max-w-[400px] transition-all duration-500 ${isCenter ? 'scale-105' : 'opacity-70'
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
