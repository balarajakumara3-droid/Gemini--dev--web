
export interface StockData {
  symbol: string;
  price: string;
  change: string;
  isPositive: boolean;
  name?: string;
}

export interface NavItem {
  label: string;
  icon: React.ReactNode;
  id: AppScreen;
}

export interface ChatMessage {
  role: 'user' | 'model';
  text: string;
}

export type AppScreen = 'home' | 'market' | 'portfolio' | 'orders' | 'watchlist' | 'ai';
