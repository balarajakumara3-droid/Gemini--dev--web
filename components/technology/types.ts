import { ComponentType, SVGProps } from 'react';

export interface TechItem {
    id: string;
    name: string;
    description: string;
    icon: ComponentType<SVGProps<SVGSVGElement>>;
    category: 'Frontend' | 'Backend' | 'AI' | 'DevOps' | 'Mobile' | 'Database';
    color?: string; // Hex code for brand color
}
