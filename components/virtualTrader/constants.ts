export const APP_COLORS = {
  background: '#0f172a', // slate-900
  card: '#1e293b',       // slate-800
  primary: '#6366f1',    // indigo-500
  success: '#10b981',    // emerald-500
  danger: '#ef4444',     // red-500
  text: '#f8fafc',       // slate-50
  textMuted: '#94a3b8',  // slate-400
};

export const MOCK_STOCKS = [
  { symbol: 'SBIN', price: '₹975.85', change: '1.53%', isPositive: true },
  { symbol: 'INFY', price: '₹1,602.00', change: '0.57%', isPositive: true },
  { symbol: 'TCS', price: '₹3,217.80', change: '0.40%', isPositive: true },
  { symbol: 'HDFCBANK', price: '₹1,450.20', change: '0.12%', isPositive: false },
  { symbol: 'ICICIBANK', price: '₹980.50', change: '0.30%', isPositive: false },
];

export const INDICES = [
  { name: 'NIFTY 50', value: '24,015.48', change: '+125.35', percent: '+0.52%', isPositive: true },
  { name: 'SENSEX', value: '79,966.37', change: '-45.20', percent: '-0.06%', isPositive: false },
];
