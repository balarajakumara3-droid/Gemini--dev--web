import React, { useState, useRef, useEffect } from 'react';
import { Sparkles, Send, Bot, User } from 'lucide-react';
import { ChatMessage } from '../../types/virtualTrader';

// Static mock responses for demo
const mockResponses = [
  "Great question! In virtual trading, you can practice buying and selling stocks without risking real money. It's the perfect way to learn!",
  "Your virtual portfolio is performing well! You're up 2.3% this week. Consider diversifying into different sectors for better risk management.",
  "NIFTY 50 is currently at ₹22,450. The market opened higher today with IT and Banking sectors leading the gains.",
  "To place a virtual order: Go to the Market tab → Select a stock → Enter quantity → Click Buy or Sell. Your virtual balance will update instantly!",
  "A P/E ratio (Price-to-Earnings) helps you understand if a stock is overvalued or undervalued. Lower P/E might indicate a bargain, but always research further!",
  "Risk management tip: Never put more than 10% of your virtual portfolio in a single stock. Diversification is key to long-term success!",
  "Your top performing stock today is Reliance (+3.2%). Would you like to know more about its recent performance?",
];

const AiAssistantDemo: React.FC = () => {
  const [messages, setMessages] = useState<ChatMessage[]>([
    { role: 'model', text: 'Hello! I am your personal trading assistant. Ask me about your portfolio, market trends, or how to place a virtual order!' }
  ]);
  const [input, setInput] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const scrollToBottom = () => {
    if (messagesEndRef.current) {
      messagesEndRef.current.scrollTo({
        top: messagesEndRef.current.scrollHeight,
        behavior: 'smooth'
      });
    }
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const handleSend = async () => {
    if (!input.trim()) return;

    const userMsg: ChatMessage = { role: 'user', text: input };
    setMessages(prev => [...prev, userMsg]);
    setInput('');
    setIsLoading(true);

    // Simulate API delay
    await new Promise(resolve => setTimeout(resolve, 1000 + Math.random() * 1000));

    // Get random mock response
    const responseText = mockResponses[Math.floor(Math.random() * mockResponses.length)];

    setMessages(prev => [...prev, { role: 'model', text: responseText }]);
    setIsLoading(false);
  };

  return (
    <div className="bg-slate-900 border border-slate-800 rounded-2xl overflow-hidden shadow-2xl max-w-md w-full mx-auto h-[500px] flex flex-col">
      <div className="bg-indigo-600 p-4 flex items-center gap-3">
        <div className="bg-white/20 p-2 rounded-lg">
          <Sparkles className="text-white w-6 h-6" />
        </div>
        <div>
          <h3 className="text-white font-bold">Virtual Trader</h3>
          <p className="text-indigo-200 text-xs">Built-in Portfolio Assistant (Demo)</p>
        </div>
      </div>

      <div ref={messagesEndRef} className="flex-1 overflow-y-auto p-4 space-y-4 bg-slate-900">
        {messages.map((msg, idx) => (
          <div key={idx} className={`flex gap-3 ${msg.role === 'user' ? 'flex-row-reverse' : ''}`}>
            <div className={`w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 ${msg.role === 'model' ? 'bg-indigo-600' : 'bg-slate-600'}`}>
              {msg.role === 'model' ? <Bot size={16} /> : <User size={16} />}
            </div>
            <div className={`p-3 rounded-2xl max-w-[80%] text-sm ${msg.role === 'model'
              ? 'bg-slate-800 text-slate-100 rounded-tl-none'
              : 'bg-indigo-600 text-white rounded-tr-none'
              }`}>
              {msg.text}
            </div>
          </div>
        ))}
        {isLoading && (
          <div className="flex gap-3">
            <div className="w-8 h-8 rounded-full bg-indigo-600 flex items-center justify-center">
              <Bot size={16} />
            </div>
            <div className="bg-slate-800 p-3 rounded-2xl rounded-tl-none">
              <div className="flex space-x-1">
                <div className="w-2 h-2 bg-slate-400 rounded-full animate-bounce"></div>
                <div className="w-2 h-2 bg-slate-400 rounded-full animate-bounce delay-75"></div>
                <div className="w-2 h-2 bg-slate-400 rounded-full animate-bounce delay-150"></div>
              </div>
            </div>
          </div>
        )}
      </div>

      <div className="p-4 bg-slate-800 border-t border-slate-700">
        <div className="flex gap-2">
          <input
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && handleSend()}
            placeholder="Ask about markets..."
            className="flex-1 bg-slate-900 border border-slate-700 rounded-xl px-4 py-2 text-white focus:outline-none focus:border-indigo-500"
          />
          <button
            onClick={handleSend}
            disabled={isLoading}
            className="bg-indigo-600 hover:bg-indigo-700 text-white p-2 rounded-xl transition-colors disabled:opacity-50"
          >
            <Send size={20} />
          </button>
        </div>
      </div>
    </div>
  );
};

export default AiAssistantDemo;