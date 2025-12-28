import { Property } from '../../../types';

export const DEMO_PROPERTIES: Property[] = [
    {
        id: '1',
        title: 'Modern minimalist Villa',
        price: 4500000,
        location: 'Beverly Hills, CA',
        description: 'A stunning modern masterpiece featuring open-concept living, floor-to-ceiling windows, and a private infinity pool with city views.',
        specs: {
            bedrooms: 5,
            bathrooms: 6,
            sqft: 6500
        },
        features: ['Smart Home System', 'Infinity Pool', 'Home Theater', 'Wine Cellar', 'Gated Community'],
        images: [
            'https://images.unsplash.com/photo-1613490493576-7fde63acd811?q=80&w=2671&auto=format&fit=crop',
            'https://images.unsplash.com/photo-1613977257363-707ba9348227?q=80&w=2670&auto=format&fit=crop',
            'https://images.unsplash.com/photo-1613545325278-f24b0cae1224?q=80&w=2670&auto=format&fit=crop'
        ],
        agent: {
            name: 'Sarah Anderson',
            phone: '+1 (555) 123-4567',
            email: 'sarah.anderson@example.com',
            image: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=2576&auto=format&fit=crop'
        },
        type: 'Sale'
    },
    {
        id: '2',
        title: 'Luxury Downtown Penthouse',
        price: 2800000,
        location: 'Manhattan, NY',
        description: 'Exclusive penthouse suite with panoramic skyline views, private elevator access, and designer interiors.',
        specs: {
            bedrooms: 3,
            bathrooms: 3.5,
            sqft: 3200
        },
        features: ['Private Elevator', 'Roof Terrace', 'Concierge Service', 'Gym', 'Parking'],
        images: [
            'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?q=80&w=2670&auto=format&fit=crop',
            'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?q=80&w=2653&auto=format&fit=crop'
        ],
        agent: {
            name: 'Michael Roberts',
            phone: '+1 (555) 987-6543',
            email: 'michael.roberts@example.com',
            image: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=2574&auto=format&fit=crop'
        },
        type: 'Sale'
    },
    {
        id: '3',
        title: 'Seaside Contemporary Home',
        price: 3200000,
        location: 'Malibu, CA',
        description: 'Direct beach access with this contemporary gem. Enjoy waking up to the sound of waves and sunset dinners on your private deck.',
        specs: {
            bedrooms: 4,
            bathrooms: 4,
            sqft: 4100
        },
        features: ['Beach Access', 'Ocean View', 'Gourmet Kitchen', 'Master Suite', 'Outdoor Shower'],
        images: [
            'https://images.unsplash.com/photo-1600596542815-37a9a5db2816?q=80&w=2670&auto=format&fit=crop',
            'https://images.unsplash.com/photo-1512915922610-182dd0748925?q=80&w=2670&auto=format&fit=crop'
        ],
        agent: {
            name: 'Emily Chen',
            phone: '+1 (555) 234-5678',
            email: 'emily.chen@example.com',
            image: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?q=80&w=2561&auto=format&fit=crop'
        },
        type: 'Sale'
    },
    {
        id: '4',
        title: 'Historic Brownstone',
        price: 15000,
        location: 'Boston, MA',
        description: 'Beautifully restored historic brownstone in the heart of Back Bay. classic architecture meets modern luxury.',
        specs: {
            bedrooms: 2,
            bathrooms: 2,
            sqft: 1800
        },
        features: ['Fireplace', 'Hardwood Floors', 'High Ceilings', 'Updated Kitchen', 'Garden'],
        images: [
            'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=2670&auto=format&fit=crop',
            'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?q=80&w=2684&auto=format&fit=crop'
        ],
        agent: {
            name: 'David Wilson',
            phone: '+1 (555) 876-5432',
            email: 'david.wilson@example.com',
            image: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=2670&auto=format&fit=crop'
        },
        type: 'Rent'
    },
    {
        id: '5',
        title: 'Alpine Ski Chalet',
        price: 5500000,
        location: 'Aspen, CO',
        description: 'The ultimate winter retreat. Ski-in/ski-out access with luxurious amenities including a hot tub, sauna, and heated floors.',
        specs: {
            bedrooms: 6,
            bathrooms: 7,
            sqft: 7200
        },
        features: ['Ski-in/Ski-out', 'Hot Tub', 'Sauna', 'Heated Floors', 'Mountain View'],
        images: [
            'https://images.unsplash.com/photo-1518780664697-55e3ad937233?q=80&w=2565&auto=format&fit=crop',
            'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?q=80&w=2574&auto=format&fit=crop'
        ],
        agent: {
            name: 'Jessica Taylor',
            phone: '+1 (555) 432-1098',
            email: 'jessica.taylor@example.com',
            image: 'https://images.unsplash.com/photo-1594744803329-e58b31de8bf5?q=80&w=2574&auto=format&fit=crop'
        },
        type: 'Sale'
    },
    {
        id: '6',
        title: 'Urban Industrial Loft',
        price: 9500,
        location: 'Chicago, IL',
        description: 'Spacious industrial loft with exposed brick walls, high ceilings, and massive windows. Perfect for creative professionals.',
        specs: {
            bedrooms: 1,
            bathrooms: 1.5,
            sqft: 1500
        },
        features: ['Exposed Brick', 'High Ceilings', 'Open Plan', 'Freight Elevator', 'Rooftop Access'],
        images: [
            'https://images.unsplash.com/photo-1600607686527-6fb886090705?q=80&w=2532&auto=format&fit=crop',
            'https://images.unsplash.com/photo-1600566752355-35792bedcfe1?q=80&w=2568&auto=format&fit=crop'
        ],
        agent: {
            name: 'Daniel Lee',
            phone: '+1 (555) 345-6789',
            email: 'daniel.lee@example.com',
            image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=2574&auto=format&fit=crop'
        },
        type: 'Rent'
    }
];
