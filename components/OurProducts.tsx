// components/OurProducts.tsx
import React from 'react';
import { ExternalLink, Sparkles, MapPin, Smartphone } from 'lucide-react';

const products = [
  {
    number: "01",
    title: "AI Text Summarizer",
    description: "Instantly summarize long articles, PDFs, or YouTube videos using advanced LLMs and RAG pipelines.",
    url: "https://summarizer-wheat-pi.vercel.app/",
    icon: Sparkles,
    accentColor: "indigo",
  },
  {
    number: "02",
    title: "Namma Ooru SPL",
    description: "Local discovery platform for Tamil Nadu — events, offers, hidden gems, all in one beautiful app.",
    url: "https://nammaooruspl.vercel.app/",
    icon: MapPin,
    accentColor: "emerald",
  },
  {
    number: "03",
    title: "BrickSpace Mobile App",
    description: "AR LEGO® brick scanner, puzzle games, and Shopify store builder — all in one powerful mobile app.",
    url: "https://play.google.com/store/apps/details?id=com.brickspace", // update when live
    icon: Smartphone,
    accentColor: "blue",
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

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {products.map((product) => (
            <a
              key={product.number}
              href={product.url}
              target="_blank"
              rel="noopener noreferrer"
              className="group p-8 bg-surface border border-white/5 hover:border-accent/30 
                       shadow-lg hover:shadow-indigo-500/10 
                       transition-all duration-300 rounded-xl relative overflow-hidden"
            >
              {/* Gradient overlay on hover */}
              <div className="absolute inset-0 bg-gradient-to-br from-accent/5 to-transparent 
                            opacity-0 group-hover:opacity-100 transition-opacity duration-500" />

              {/* Big number background */}
              <div className="absolute top-0 right-0 p-6 opacity-10 font-serif text-6xl text-white 
                            group-hover:opacity-20 transition-opacity">
                {product.number}
              </div>

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
                Visit Live Site
                <ExternalLink className="w-4 h-4" strokeWidth={2} />
              </div>
            </a>
          ))}
        </div>
      </div>
    </section>
  );
};

export default OurProducts;