// components/OurProducts.tsx
import React from 'react';
import { ExternalLink, Sparkles, MapPin, Smartphone, TrendingUp } from 'lucide-react';

const products = [
  {
    title: "AI Text Summarizer",
    description: "Instantly summarize long articles, PDFs, or YouTube videos using advanced LLMs and RAG pipelines.",
    url: "summarizer",
    icon: Sparkles,
    accentColor: "indigo",
    isExternal: true,
  },
  {
    title: "Namma Ooru SPL",
    description: "Local discovery platform for Tamil Nadu — events, offers, hidden gems, all in one beautiful app.",
    url: "nammaooruspl",
    icon: MapPin,
    accentColor: "emerald",
    isExternal: true,
  },
  {
    title: "BrickSpace Mobile App",
    description: "AR LEGO® brick scanner, puzzle games, and Shopify store builder — all in one powerful mobile app.",
    url: "https://play.google.com/store/apps/details?id=com.brickspace",
    icon: Smartphone,
    accentColor: "blue",
    isExternal: true,
  },
  {
    title: "Virtual Trader",
    description: "Master the stock market risk-free. Practice trading with ₹10L virtual cash, real-time data, and AI-powered insights.",
    url: "/virtual-trader",
    icon: TrendingUp,
    accentColor: "cyan",
    isExternal: false,
  },
];

const OurProducts = () => {
  return (
    <section className="py-20 px-6 bg-background">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-16">
          <h2 className="text-5xl md:text-6xl font-bold text-primary mb-4">
            Our Products
          </h2>
          <p className="text-xl text-secondary">
            Real-world apps powered by cutting-edge AI & design
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {products.map((product) => {
            const CardContent = (
              <>
                {/* Gradient overlay on hover */}
                <div className="absolute inset-0 bg-gradient-to-br from-accent/5 to-transparent 
                              opacity-0 group-hover:opacity-100 transition-opacity duration-500" />

                {/* Icon */}
                <div className="w-12 h-12 bg-white/5 rounded-lg flex items-center justify-center 
                              text-accent mb-6 group-hover:scale-110 
                              group-hover:bg-accent group-hover:text-background 
                              transition-all duration-300">
                  <product.icon className="w-6 h-6" />
                </div>

                {/* Title & Description */}
                <h3 className="font-serif text-2xl text-primary font-medium mb-3 relative z-10">
                  {product.title}
                </h3>
                <p className="text-secondary text-sm leading-relaxed mb-6 relative z-10">
                  {product.description}
                </p>

                {/* CTA */}
                <div className="inline-flex items-center gap-2 text-accent text-xs font-bold 
                              uppercase tracking-widest hover:gap-3 transition-all relative z-10">
                  {product.isExternal ? 'Visit Live Site' : 'Explore App'}
                  <ExternalLink className="w-4 h-4" strokeWidth={2} />
                </div>
              </>
            );

            const cardClass = `group p-8 bg-surface border border-white/5 hover:border-accent/30 
                       shadow-lg hover:shadow-indigo-500/10 
                       transition-all duration-300 rounded-xl relative overflow-hidden`;

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

            // Internal link - use window.location for simplicity (since this component may not be wrapped in Router)
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
    </section>
  );
};

export default OurProducts;