export interface NavItem {
  label: string;
  href: string;
}

export interface Project {
  id: number;
  title: string;
  category: string;
  image: string;
  year: string;
}

export interface Service {
  id: number;
  number: string;
  title: string;
  description: string;
}

export interface SocialLink {
  platform: string;
  url: string;
}

import { LucideIcon } from 'lucide-react';

export interface ServiceItem {
  title: string;
  description: string;
  icon: LucideIcon;
  linkText?: string;
}

export interface ValueItem {
  title: string;
  description: string;
  icon: LucideIcon;
}

export interface StatItem {
  value: string;
  label: string;
}

export interface FAQItem {
  question: string;
  answer: string;
}

export interface PropertyAgent {
  name: string;
  phone: string;
  email: string;
  image: string;
}

export interface Property {
  id: string;
  title: string;
  price: number;
  location: string;
  description: string;
  specs: {
    bedrooms: number;
    bathrooms: number;
    sqft: number;
  };
  features: string[];
  images: string[];
  agent: PropertyAgent;
  type: 'Sale' | 'Rent';
}