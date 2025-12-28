
import React, { useState } from 'react';
import PhoneMockup from '../components/virtualTrader/PhoneMockup';
import AiAssistantDemo from '../components/virtualTrader/AiAssistantDemo';
import { Smartphone, Shield, Zap, TrendingUp, Layers, CheckCircle, Download, ChevronRight, PieChart, ClipboardList, BookOpen } from 'lucide-react';
import { AppScreen } from '../types/virtualTrader';

const FeatureCard: React.FC<{ icon: React.ReactNode; title: string; description: string }> = ({ icon, title, description }) => (
  <div className="bg-slate-900/50 p-6 rounded-2xl border border-slate-800 hover:border-indigo-500/50 transition-all group hover:bg-slate-800/50">
    <div className="w-12 h-12 bg-slate-800 rounded-xl flex items-center justify-center text-indigo-400 mb-4 group-hover:scale-110 transition-transform shadow-lg shadow-black/20">
      {icon}
    </div>
    <h3 className="text-xl font-bold text-white mb-2">{title}</h3>
    <p className="text-slate-400 leading-relaxed text-sm">{description}</p>
  </div>
);

import { Helmet } from 'react-helmet-async';

function VirtualTraderPage() {
  const [activeScreen, setActiveScreen] = useState<AppScreen>('market');

  const interactiveFeatures = [
    {
      id: 'market',
      title: "Real-time Market Data",
      description: "Experience the pulse of the market with live NIFTY 50 and SENSEX updates. Track top gainers, losers, and sector-wise performance instantly.",
      icon: <TrendingUp size={20} />,
    },
    {
      id: 'portfolio',
      title: "Virtual Portfolio Tracking",
      description: "Monitor your simulated investments with professional-grade analytics. Visualize your allocation, check total returns, and see your daily P&L.",
      icon: <PieChart size={20} />,
    },
    {
      id: 'orders',
      title: "Order Management",
      description: "Place simulated Buy and Sell orders. Track your order history, view open positions, and understand how order execution works in the real world.",
      icon: <ClipboardList size={20} />,
    },
    {
      id: 'watchlist',
      title: "Smart Watchlists",
      description: "Build your personal watchlist of favorite stocks. Keep an eye on potential opportunities without cluttering your main feed.",
      icon: <BookOpen size={20} />,
    },
  ];

  return (
    <div className="min-h-screen bg-[#020617] text-slate-50 selection:bg-indigo-500/30 overflow-x-hidden font-sans">
      <Helmet>
        <title>Virtual Trader | Master the Markets with Zero Risk - Idea Manifest</title>
        <meta name="description" content="The ultimate virtual trading simulator. Start with ₹10 Lakh virtual cash. Practice strategies, track portfolios, and learn with our AI assistant before you spend a real rupee." />
      </Helmet>

      {/* Navigation */}
      <nav className="fixed w-full z-50 bg-[#020617]/80 backdrop-blur-xl border-b border-white/5">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-20 items-center">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-gradient-to-tr from-indigo-600 to-violet-600 rounded-xl flex items-center justify-center shadow-lg shadow-indigo-500/20">
                <TrendingUp size={24} className="text-white" />
              </div>
              <span className="text-2xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-white to-slate-400 tracking-tight">
                Virtual Trader
              </span>
            </div>
            <div className="hidden md:flex items-center gap-8">
              <a href="#demo" className="text-sm font-medium text-slate-300 hover:text-white transition-colors">How it Works</a>
              <a href="#features" className="text-sm font-medium text-slate-300 hover:text-white transition-colors">Features</a>
              <a href="#ai-demo" className="text-sm font-medium text-slate-300 hover:text-white transition-colors">AI Assistant</a>
              <a href="#download" className="bg-white text-slate-900 px-5 py-2.5 rounded-full text-sm font-bold hover:bg-indigo-50 transition-colors shadow-[0_0_20px_rgba(255,255,255,0.3)]">
                Get Early Access
              </a>
            </div>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="pt-40 pb-20 relative overflow-hidden">
        {/* Background Effects */}
        <div className="absolute top-0 left-0 w-full h-full overflow-hidden z-0 pointer-events-none">
          <div className="absolute top-[-20%] right-[-10%] w-[800px] h-[800px] bg-indigo-600/10 rounded-full blur-[120px] mix-blend-screen"></div>
          <div className="absolute bottom-0 left-[-20%] w-[800px] h-[800px] bg-blue-600/10 rounded-full blur-[120px] mix-blend-screen"></div>
        </div>

        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
          <div className="grid lg:grid-cols-2 gap-16 items-center">
            <div className="animate-in slide-in-from-bottom-10 fade-in duration-700">
              <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-slate-900 border border-slate-800 text-indigo-400 text-xs font-semibold mb-8 shadow-xl">
                <span className="relative flex h-2 w-2">
                  <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-indigo-400 opacity-75"></span>
                  <span className="relative inline-flex rounded-full h-2 w-2 bg-indigo-500"></span>
                </span>
                Now available on Flutter (iOS & Android)
              </div>
              <h1 className="text-5xl md:text-7xl font-bold tracking-tight mb-8 text-white leading-[1.1]">
                Master the Markets. <br />
                <span className="text-transparent bg-clip-text bg-gradient-to-r from-indigo-400 to-cyan-400">
                  Zero Risk.
                </span>
              </h1>
              <p className="text-lg text-slate-400 mb-10 max-w-xl leading-relaxed">
                The ultimate virtual trading simulator. Start with <span className="text-white font-semibold">₹10 Lakh virtual cash</span>. Practice strategies, track portfolios, and learn with our AI assistant before you spend a real rupee.
              </p>

              <div className="flex flex-wrap gap-4">
                <button className="flex items-center gap-3 bg-indigo-600 text-white px-8 py-4 rounded-2xl font-semibold hover:bg-indigo-500 transition-all shadow-lg shadow-indigo-600/25 hover:scale-105 active:scale-95">
                  <Download size={20} />
                  Download App
                </button>
                <button className="flex items-center gap-3 bg-slate-900/50 text-white px-8 py-4 rounded-2xl font-semibold hover:bg-slate-800 transition-all border border-slate-700 hover:border-slate-600">
                  View Features
                </button>
              </div>

              <div className="mt-12 flex items-center gap-8 text-slate-500 text-sm font-medium">
                <div className="flex items-center gap-2">
                  <div className="w-1.5 h-1.5 rounded-full bg-emerald-500"></div> Real-time Data
                </div>
                <div className="flex items-center gap-2">
                  <div className="w-1.5 h-1.5 rounded-full bg-emerald-500"></div> AI Assistant
                </div>
                <div className="flex items-center gap-2">
                  <div className="w-1.5 h-1.5 rounded-full bg-emerald-500"></div> 100% Free
                </div>
              </div>
            </div>

            <div className="flex justify-center lg:justify-end relative">
              {/* Decorative background circle behind phone */}
              <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-[500px] h-[500px] bg-gradient-to-b from-indigo-500/20 to-transparent rounded-full blur-3xl -z-10"></div>
              <div className="transform rotate-[-6deg] hover:rotate-0 transition-transform duration-700 ease-out z-10">
                <PhoneMockup currentScreen={activeScreen} onScreenChange={(s) => setActiveScreen(s)} />
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Interactive Demo Section */}
      <section id="demo" className="py-32 bg-slate-900/30 border-y border-white/5">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-white mb-4">Experience the App</h2>
            <p className="text-slate-400 max-w-2xl mx-auto">
              Click the features below to interact with the virtual phone. See exactly how Virtual Trader helps you learn.
            </p>
          </div>

          <div className="grid lg:grid-cols-2 gap-12 items-center">
            {/* Interactive List */}
            <div className="space-y-4">
              {interactiveFeatures.map((feature) => (
                <div
                  key={feature.id}
                  onClick={() => setActiveScreen(feature.id as AppScreen)}
                  className={`p-6 rounded-2xl cursor-pointer transition-all border ${activeScreen === feature.id
                    ? 'bg-slate-800 border-indigo-500 shadow-lg shadow-indigo-900/20'
                    : 'bg-transparent border-transparent hover:bg-slate-800/50 hover:border-slate-700'
                    }`}
                >
                  <div className="flex items-start gap-4">
                    <div className={`mt-1 w-10 h-10 rounded-lg flex items-center justify-center transition-colors ${activeScreen === feature.id ? 'bg-indigo-600 text-white' : 'bg-slate-800 text-slate-400'
                      }`}>
                      {feature.icon}
                    </div>
                    <div>
                      <h3 className={`text-lg font-bold mb-2 ${activeScreen === feature.id ? 'text-white' : 'text-slate-300'
                        }`}>
                        {feature.title}
                      </h3>
                      <p className="text-slate-400 text-sm leading-relaxed">
                        {feature.description}
                      </p>
                    </div>
                    {activeScreen === feature.id && (
                      <div className="ml-auto self-center">
                        <ChevronRight className="text-indigo-400 animate-pulse" />
                      </div>
                    )}
                  </div>
                </div>
              ))}
            </div>

            {/* Sticky Phone Display */}
            <div className="flex justify-center h-[800px] sticky top-20">
              <div className="scale-95 transform transition-all duration-500">
                <PhoneMockup currentScreen={activeScreen} onScreenChange={(s) => setActiveScreen(s)} />
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Grid Features */}
      <section id="features" className="py-24 relative">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-3 gap-8">
            <FeatureCard
              icon={<Shield size={24} />}
              title="Zero Risk Trading"
              description="Start with ₹10L in virtual cash. Make mistakes, learn lessons, and refine your strategy without losing a single rupee."
            />
            <FeatureCard
              icon={<Smartphone size={24} />}
              title="Native Performance"
              description="Built with Flutter for silky-smooth 120Hz scrolling and native gestures on both iOS and Android devices."
            />
            <FeatureCard
              icon={<Layers size={24} />}
              title="Real-Time Data"
              description="Data streams directly from market APIs. The simulation reflects actual market volatility and liquidity."
            />
          </div>
        </div>
      </section>

      {/* AI Assistant Section */}
      <section id="ai-demo" className="py-24 bg-gradient-to-b from-indigo-950/20 to-[#020617] border-t border-white/5">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid lg:grid-cols-2 gap-16 items-start">
            <div className="order-2 lg:order-1 sticky top-24">
              <AiAssistantDemo />
              <p className="text-center text-slate-500 text-xs mt-4">
                * Actual AI model running live via Google Gemini API
              </p>
            </div>
            <div className="order-1 lg:order-2 pt-10">
              <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-indigo-500/10 border border-indigo-500/20 text-indigo-400 text-xs font-semibold mb-6">
                <Zap size={14} />
                Powered by Gemini 2.5
              </div>
              <h2 className="text-4xl md:text-5xl font-bold text-white mb-6 leading-tight">
                Your Personal <br />
                <span className="text-transparent bg-clip-text bg-gradient-to-r from-indigo-400 to-purple-400">Trading Mentor</span>
              </h2>
              <p className="text-lg text-slate-400 mb-8 leading-relaxed">
                Trading can be intimidating. That's why we built an AI assistant directly into the app. It's not just a chatbot; it's a context-aware mentor that helps you understand *why* markets are moving.
              </p>

              <div className="space-y-6">
                <div className="flex gap-4">
                  <div className="w-12 h-12 rounded-full bg-slate-800 flex items-center justify-center flex-shrink-0 text-indigo-400 border border-slate-700">
                    <BookOpen size={20} />
                  </div>
                  <div>
                    <h4 className="text-white font-bold mb-1">Learn Concepts</h4>
                    <p className="text-slate-400 text-sm">Ask "What is a P/E ratio?" or "Explain short selling" and get simple, jargon-free answers.</p>
                  </div>
                </div>
                <div className="flex gap-4">
                  <div className="w-12 h-12 rounded-full bg-slate-800 flex items-center justify-center flex-shrink-0 text-indigo-400 border border-slate-700">
                    <PieChart size={20} />
                  </div>
                  <div>
                    <h4 className="text-white font-bold mb-1">Portfolio Analysis</h4>
                    <p className="text-slate-400 text-sm">Get insights on your diversification and risk exposure based on your virtual holdings.</p>
                  </div>
                </div>
                <div className="flex gap-4">
                  <div className="w-12 h-12 rounded-full bg-slate-800 flex items-center justify-center flex-shrink-0 text-indigo-400 border border-slate-700">
                    <Shield size={20} />
                  </div>
                  <div>
                    <h4 className="text-white font-bold mb-1">Risk Management</h4>
                    <p className="text-slate-400 text-sm">Learn how to set stop-losses and manage your virtual capital effectively.</p>
                  </div>
                </div>
              </div>

              <div className="mt-10 pt-10 border-t border-slate-800">
                <button onClick={() => {
                  document.getElementById('ai-demo')?.scrollIntoView({ behavior: 'smooth' });
                  setActiveScreen('ai');
                }} className="text-indigo-400 font-semibold hover:text-indigo-300 flex items-center gap-2">
                  Try asking the AI a question <ChevronRight size={16} />
                </button>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Footer */}
      <section id="download" className="py-20 relative overflow-hidden">
        <div className="absolute inset-0 bg-indigo-600/10"></div>
        <div className="max-w-4xl mx-auto px-4 text-center relative z-10">
          <h2 className="text-4xl font-bold text-white mb-6">Ready to start your journey?</h2>
          <p className="text-slate-300 text-lg mb-8">Join thousands of students and beginners mastering the stock market risk-free.</p>
          <button className="bg-white text-indigo-900 px-10 py-4 rounded-2xl font-bold text-lg hover:bg-slate-100 transition-colors shadow-2xl shadow-white/10">
            Download Virtual Trader Now
          </button>
          <p className="mt-4 text-slate-500 text-sm">Available on iOS & Android</p>
        </div>
      </section>

      <footer className="bg-[#020617] border-t border-slate-900 py-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col md:flex-row justify-between items-center gap-6">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 bg-slate-800 rounded-lg flex items-center justify-center">
              <TrendingUp size={20} className="text-white" />
            </div>
            <span className="text-xl font-bold text-white">Virtual Trader</span>
          </div>
          <div className="text-slate-500 text-sm">
            © {new Date().getFullYear()} Virtual Trader. All rights reserved.
          </div>
          <div className="flex gap-4">
            <a href="#" className="text-slate-500 hover:text-white transition-colors text-sm">Privacy Policy</a>
            <a href="#" className="text-slate-500 hover:text-white transition-colors text-sm">Terms of Service</a>
          </div>
        </div>
      </footer>

    </div>
  );
}

export default VirtualTraderPage;
