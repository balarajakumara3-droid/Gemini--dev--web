
import React from 'react';
import {
  Bell, Wallet, TrendingUp, Home, BarChart2, PieChart,
  ClipboardList, Bookmark, Sparkles, Search, ArrowDown,
  ArrowUp, Filter, Download
} from 'lucide-react';
import { APP_COLORS, INDICES, MOCK_STOCKS } from './constants';
import { AppScreen } from '../../types/virtualTrader';

interface PhoneMockupProps {
  currentScreen: AppScreen;
  onScreenChange?: (screen: AppScreen) => void;
}

const PhoneMockup: React.FC<PhoneMockupProps> = ({ currentScreen, onScreenChange }) => {

  const handleNavClick = (screen: AppScreen) => {
    if (onScreenChange) onScreenChange(screen);
  };

  const renderMarketScreen = () => (
    <div className="animate-in fade-in duration-500">
      <h1 className="text-3xl font-bold text-white mb-4">Market</h1>

      {/* Search Bar */}
      <div className="bg-[#1e293b] rounded-xl p-3 flex items-center gap-3 mb-4 border border-slate-700/50">
        <Search className="text-slate-400" size={20} />
        <span className="text-slate-500 text-sm">Search stocks by name or symbol</span>
      </div>

      {/* Filter Chips */}
      <div className="flex gap-2 overflow-x-auto pb-4 no-scrollbar">
        {['All', 'IT', 'Banking', 'Pharma', 'Auto'].map((chip, i) => (
          <span key={i} className={`px-4 py-1.5 rounded-full text-xs font-medium whitespace-nowrap ${i === 0 ? 'bg-indigo-600 text-white' : 'bg-slate-800 text-slate-400 border border-slate-700'}`}>
            {chip}
          </span>
        ))}
      </div>

      {/* Tabs */}
      <div className="flex border-b border-slate-800 mb-4">
        <div className="pb-2 border-b-2 border-indigo-500 text-indigo-400 font-medium px-4 text-sm">Trending</div>
        <div className="pb-2 text-slate-500 font-medium px-4 text-sm">Gainers</div>
        <div className="pb-2 text-slate-500 font-medium px-4 text-sm">Losers</div>
      </div>

      {/* Stock List */}
      <div className="space-y-3 pb-20">
        {[
          { sym: 'RELIANCE', name: 'Reliance Industries Limited', price: '₹2,544.40', chg: '0.14%', up: true },
          { sym: 'TCS', name: 'Tata Consultancy Services', price: '₹3,217.80', chg: '0.40%', up: true },
          { sym: 'HDFCBANK', name: 'HDFC Bank Limited', price: '₹984.00', chg: '1.04%', up: false },
          { sym: 'INFY', name: 'Infosys Limited', price: '₹1,602.00', chg: '0.57%', up: true },
          { sym: 'ICICIBANK', name: 'ICICI Bank Limited', price: '₹1,350.20', chg: '1.00%', up: false },
        ].map((stock, i) => (
          <div key={i} className="bg-[#1e293b] p-4 rounded-xl border border-slate-800 flex justify-between items-center">
            <div className="flex gap-3 items-center">
              <div className="w-10 h-10 rounded-lg bg-slate-800 flex items-center justify-center text-xs font-bold text-indigo-400 border border-slate-700">
                {stock.sym.substring(0, 2)}
              </div>
              <div>
                <div className="font-bold text-slate-200">{stock.sym}</div>
                <div className="text-[10px] text-slate-500 truncate w-32">{stock.name}</div>
              </div>
            </div>
            <div className="text-right">
              <div className="font-bold text-slate-200">{stock.price}</div>
              <div className={`text-xs flex items-center justify-end gap-1 ${stock.up ? 'text-emerald-500' : 'text-rose-500'}`}>
                {stock.up ? '▲' : '▼'} {stock.chg}
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  const renderPortfolioScreen = () => (
    <div className="animate-in fade-in duration-500">
      <h1 className="text-3xl font-bold text-white mb-6">Portfolio</h1>

      {/* Portfolio Card */}
      <div className="bg-gradient-to-br from-indigo-600 to-indigo-700 rounded-2xl p-6 mb-6 shadow-xl shadow-indigo-900/20">
        <div className="text-indigo-100 text-xs mb-1">Total Portfolio Value</div>
        <div className="text-3xl font-bold text-white mb-2">₹12,871.20</div>
        <div className="flex justify-between items-end">
          <div>
            <div className="text-indigo-200 text-xs">Invested</div>
            <div className="text-white font-medium">₹12,802.40</div>
          </div>
          <div className="text-right">
            <div className="text-indigo-200 text-xs">Returns</div>
            <div className="text-emerald-300 font-medium text-sm">+68.80 (0.54%)</div>
          </div>
        </div>
      </div>

      {/* Allocation */}
      <div className="bg-[#1e293b] rounded-2xl p-5 mb-6 border border-slate-800">
        <h3 className="text-slate-200 font-medium mb-4">Allocation</h3>
        <div className="flex items-center gap-8">
          <div className="relative w-32 h-32 rounded-full flex items-center justify-center"
            style={{ background: 'conic-gradient(#6366f1 100%, #1e293b 0)' }}>
            <div className="w-20 h-20 bg-[#1e293b] rounded-full"></div>
          </div>
          <div>
            <div className="flex items-center gap-2 mb-1">
              <div className="w-3 h-3 bg-indigo-500 rounded-sm"></div>
              <span className="text-slate-300 text-sm">TCS</span>
            </div>
            <div className="text-slate-500 text-xs pl-5">100.0%</div>
          </div>
        </div>
      </div>

      {/* Holdings */}
      <h3 className="text-xl font-bold text-white mb-4">Holdings</h3>
      <div className="bg-[#1e293b] p-4 rounded-xl border border-slate-800 flex justify-between items-center mb-20">
        <div className="flex gap-3 items-center">
          <div className="w-10 h-10 rounded-lg bg-slate-900 flex items-center justify-center text-xs font-bold text-emerald-400 border border-slate-700">
            TC
          </div>
          <div>
            <div className="font-bold text-slate-200">TCS</div>
            <div className="text-xs text-slate-500">4 shares</div>
          </div>
        </div>
        <div className="text-right">
          <div className="font-bold text-slate-200">₹12,871.20</div>
          <div className="text-xs text-emerald-500">+68.80 (0.54%)</div>
        </div>
      </div>
    </div>
  );

  const renderOrdersScreen = () => (
    <div className="animate-in fade-in duration-500">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold text-white">Orders</h1>
        <Download size={20} className="text-slate-400" />
      </div>

      {/* Stats Grid */}
      <div className="bg-[#1e293b] rounded-2xl p-4 grid grid-cols-3 gap-4 mb-6 border border-slate-800 relative overflow-hidden">
        <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-rose-500 via-transparent to-emerald-500 opacity-30"></div>
        <div className="text-center border-r border-slate-700">
          <ArrowDown className="mx-auto text-rose-400 mb-1" size={16} />
          <div className="text-rose-400 font-bold text-sm">₹12.80K</div>
          <div className="text-[10px] text-slate-500">Total Bought</div>
        </div>
        <div className="text-center border-r border-slate-700">
          <ArrowUp className="mx-auto text-emerald-400 mb-1" size={16} />
          <div className="text-emerald-400 font-bold text-sm">₹0.00</div>
          <div className="text-[10px] text-slate-500">Total Sold</div>
        </div>
        <div className="text-center">
          <ClipboardList className="mx-auto text-indigo-400 mb-1" size={16} />
          <div className="text-indigo-400 font-bold text-sm">1</div>
          <div className="text-[10px] text-slate-500">Total Orders</div>
        </div>
      </div>

      {/* Filters */}
      <div className="flex gap-2 mb-4">
        <button className="bg-indigo-600 text-white text-xs px-4 py-1.5 rounded-full">All</button>
        <button className="bg-slate-800 text-slate-400 border border-slate-700 text-xs px-4 py-1.5 rounded-full">Buy</button>
        <button className="bg-slate-800 text-slate-400 border border-slate-700 text-xs px-4 py-1.5 rounded-full">Sell</button>
      </div>

      <div className="flex gap-2 mb-6">
        <button className="bg-[#1e293b] text-indigo-400 border border-indigo-500/30 text-[10px] w-8 h-8 rounded-lg flex items-center justify-center"><Filter size={14} /></button>
        <button className="bg-indigo-600 text-white text-[10px] px-3 h-8 rounded-lg">All</button>
        <button className="bg-[#1e293b] text-slate-400 border border-slate-800 text-[10px] px-3 h-8 rounded-lg">Today</button>
        <button className="bg-[#1e293b] text-slate-400 border border-slate-800 text-[10px] px-3 h-8 rounded-lg">Week</button>
      </div>

      {/* Order List */}
      <div className="text-xs text-slate-500 mb-2">16 Dec 2025</div>
      <div className="bg-[#1e293b] p-4 rounded-xl border border-slate-800 flex justify-between items-center">
        <div className="flex gap-3 items-center">
          <div className="w-10 h-10 rounded-lg bg-emerald-900/20 flex items-center justify-center text-emerald-500">
            <ArrowDown size={18} />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <span className="font-bold text-white">TCS</span>
              <span className="bg-emerald-500/10 text-emerald-500 text-[9px] px-1.5 py-0.5 rounded">BUY</span>
            </div>
            <div className="text-xs text-slate-400 mt-0.5">4 shares @ ₹3,200.60</div>
            <div className="text-[10px] text-slate-600 mt-0.5">01:17 PM</div>
          </div>
        </div>
        <div className="text-rose-400 font-medium">
          ₹12,802.40
        </div>
      </div>
    </div>
  );

  const renderWatchlistScreen = () => (
    <div className="animate-in fade-in duration-500 h-full flex flex-col">
      <h1 className="text-3xl font-bold text-white mb-6">Watchlist</h1>

      <h3 className="text-sm text-slate-300 font-medium mb-3">Market Indices</h3>
      <div className="grid grid-cols-2 gap-3 mb-12">
        {INDICES.map((index, i) => (
          <div key={i} className="bg-[#1e293b] rounded-xl p-3 border border-slate-700/30">
            <div className="flex justify-between items-start mb-2">
              <span className="text-slate-500 text-[10px] font-bold uppercase">{index.name}</span>
              <span className={`text-[10px] px-1 py-0.5 rounded ${index.isPositive ? 'bg-emerald-500/10 text-emerald-400' : 'bg-rose-500/10 text-rose-400'}`}>
                {index.percent}
              </span>
            </div>
            <div className={`text-lg font-bold mb-0.5 ${index.isPositive ? 'text-emerald-400' : 'text-rose-400'}`}>
              {index.value}
            </div>
            <div className={`text-[10px] ${index.isPositive ? 'text-emerald-500' : 'text-rose-500'}`}>
              {index.change}
            </div>
          </div>
        ))}
      </div>

      <div className="flex-1 flex flex-col items-center justify-center opacity-80 pb-20">
        <div className="w-24 h-24 bg-slate-800 rounded-3xl flex items-center justify-center mb-6 text-slate-600">
          <Bookmark size={48} strokeWidth={1} />
        </div>
        <h3 className="text-white font-semibold text-lg mb-2">No Stocks in Watchlist</h3>
        <p className="text-slate-400 text-center text-sm px-6 mb-6">
          Tap + to add stocks you want to track
        </p>
        <button className="bg-indigo-600 hover:bg-indigo-700 text-white px-6 py-3 rounded-xl font-semibold text-sm transition-colors">
          + Browse Stocks
        </button>
      </div>
    </div>
  );

  const renderContent = () => {
    switch (currentScreen) {
      case 'portfolio': return renderPortfolioScreen();
      case 'orders': return renderOrdersScreen();
      case 'watchlist': return renderWatchlistScreen();
      case 'ai':
      case 'market':
      default: return renderMarketScreen();
    }
  };

  return (
    <div className="relative mx-auto border-gray-900 bg-black border-[14px] rounded-[2.5rem] h-[780px] w-[370px] shadow-2xl flex flex-col overflow-hidden ring-1 ring-white/10">
      {/* Notch / Status Bar Area */}
      <div className="h-[32px] w-full bg-[#020617] absolute top-0 left-0 z-20 flex items-center justify-between px-6 pt-3">
        <span className="text-xs font-semibold text-white">7:58</span>
        <div className="w-24 h-6 bg-black rounded-b-3xl absolute left-1/2 transform -translate-x-1/2 top-0 z-30"></div>
        <div className="flex space-x-1.5">
          <div className="w-4 h-3 bg-white rounded-[2px] opacity-90"></div>
          <div className="w-4 h-3 border border-white rounded-[2px] opacity-90"></div>
        </div>
      </div>

      {/* Main Content Scrollable Area */}
      <div className="flex-1 bg-[#020617] pt-12 pb-24 overflow-y-auto px-5 font-sans text-slate-50 no-scrollbar">
        {renderContent()}
      </div>

      {/* Floating Action Button (AI) - Shows on all screens except AI if we had a dedicated AI screen internal */}
      <div className="absolute bottom-[90px] right-4 z-30 animate-bounce-slow">
        <div
          className="w-14 h-14 rounded-2xl bg-[#6366f1] shadow-lg shadow-indigo-500/40 flex items-center justify-center text-white hover:scale-105 transition-transform cursor-pointer"
          onClick={() => handleNavClick('ai')}
        >
          <Sparkles size={24} fill="white" />
        </div>
      </div>

      {/* Bottom Navigation */}
      <div className="h-[85px] bg-[#020617]/95 backdrop-blur-md absolute bottom-0 left-0 w-full border-t border-slate-800/50 flex items-center justify-around px-2 z-20 pb-4">
        <div onClick={() => handleNavClick('market')} className={`flex flex-col items-center gap-1 p-2 rounded-xl w-16 cursor-pointer transition-all ${currentScreen === 'market' ? 'bg-slate-800/50' : 'opacity-50 hover:opacity-100'}`}>
          <Home size={22} className={currentScreen === 'market' ? 'text-[#6366f1]' : 'text-slate-400'} />
          <span className={`text-[10px] font-medium ${currentScreen === 'market' ? 'text-[#6366f1]' : 'text-slate-400'}`}>Home</span>
        </div>
        <div onClick={() => handleNavClick('market')} className={`flex flex-col items-center gap-1 cursor-pointer transition-all ${currentScreen === 'market' ? '' : 'opacity-50 hover:opacity-100'}`}>
          <TrendingUp size={22} className="text-slate-400" />
          <span className="text-[10px] text-slate-400">Markets</span>
        </div>
        <div onClick={() => handleNavClick('portfolio')} className={`flex flex-col items-center gap-1 p-2 rounded-xl w-16 cursor-pointer transition-all ${currentScreen === 'portfolio' ? 'bg-slate-800/50' : 'opacity-50 hover:opacity-100'}`}>
          <PieChart size={22} className={currentScreen === 'portfolio' ? 'text-[#6366f1]' : 'text-slate-400'} />
          <span className={`text-[10px] font-medium ${currentScreen === 'portfolio' ? 'text-[#6366f1]' : 'text-slate-400'}`}>Portfolio</span>
        </div>
        <div onClick={() => handleNavClick('orders')} className={`flex flex-col items-center gap-1 p-2 rounded-xl w-16 cursor-pointer transition-all ${currentScreen === 'orders' ? 'bg-slate-800/50' : 'opacity-50 hover:opacity-100'}`}>
          <ClipboardList size={22} className={currentScreen === 'orders' ? 'text-[#6366f1]' : 'text-slate-400'} />
          <span className={`text-[10px] font-medium ${currentScreen === 'orders' ? 'text-[#6366f1]' : 'text-slate-400'}`}>Orders</span>
        </div>
        <div onClick={() => handleNavClick('watchlist')} className={`flex flex-col items-center gap-1 p-2 rounded-xl w-16 cursor-pointer transition-all ${currentScreen === 'watchlist' ? 'bg-slate-800/50' : 'opacity-50 hover:opacity-100'}`}>
          <Bookmark size={22} className={currentScreen === 'watchlist' ? 'text-[#6366f1]' : 'text-slate-400'} />
          <span className={`text-[10px] font-medium ${currentScreen === 'watchlist' ? 'text-[#6366f1]' : 'text-slate-400'}`}>Watchlist</span>
        </div>
      </div>

      {/* Home Indicator */}
      <div className="absolute bottom-2 left-1/2 transform -translate-x-1/2 w-32 h-1 bg-white rounded-full z-30 opacity-30"></div>
    </div>
  );
};

export default PhoneMockup;
