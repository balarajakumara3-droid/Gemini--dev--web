import '../models/property.dart';

class PropertyService {
  // In a real app, this would make HTTP requests to your backend
  // For now, we'll return mock data

  Future<List<Property>> getProperties() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      Property(
        id: '1',
        title: 'Modern Apartment in Downtown',
        description: 'Beautiful modern apartment with stunning city views. Features include hardwood floors, granite countertops, and a private balcony.',
        price: 2500,
        location: 'Downtown',
        address: '123 Main St, Downtown',
        latitude: 40.7128,
        longitude: -74.0060,
        images: [
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
          'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?w=800',
          'https://images.unsplash.com/photo-1560448204-5e3c3c0c0c0c?w=800',
        ],
        bedrooms: 2,
        bathrooms: 2,
        area: 1200,
        propertyType: 'apartment',
        listingType: 'rent',
        amenities: ['Parking', 'Gym', 'Pool', 'Balcony', 'Air Conditioning'],
        agent: Agent(
          id: '1',
          name: 'Sarah Johnson',
          email: 'sarah@realestate.com',
          phone: '+1234567890',
          profileImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
          company: 'Premium Real Estate',
          rating: 4.8,
          totalListings: 45,
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        isFeatured: true,
      ),
      Property(
        id: '2',
        title: 'Luxury Villa with Pool',
        description: 'Stunning luxury villa with private pool, garden, and modern amenities. Perfect for families looking for space and comfort.',
        price: 850000,
        location: 'Beverly Hills',
        address: '456 Oak Ave, Beverly Hills',
        latitude: 34.0736,
        longitude: -118.4004,
        images: [
          'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
          'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
        ],
        bedrooms: 4,
        bathrooms: 3,
        area: 2500,
        propertyType: 'villa',
        listingType: 'sale',
        amenities: ['Pool', 'Garden', 'Parking', 'Security', 'Air Conditioning', 'Fireplace'],
        agent: Agent(
          id: '2',
          name: 'Michael Chen',
          email: 'michael@luxuryhomes.com',
          phone: '+1234567891',
          profileImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
          company: 'Luxury Homes Group',
          rating: 4.9,
          totalListings: 32,
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        isFeatured: true,
      ),
      Property(
        id: '3',
        title: 'Cozy Family House',
        description: 'Charming family house in a quiet neighborhood. Features a large backyard, updated kitchen, and plenty of storage space.',
        price: 1800,
        location: 'Suburbs',
        address: '789 Pine St, Suburbs',
        latitude: 40.7589,
        longitude: -73.9851,
        images: [
          'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800',
          'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800',
        ],
        bedrooms: 3,
        bathrooms: 2,
        area: 1800,
        propertyType: 'house',
        listingType: 'rent',
        amenities: ['Backyard', 'Parking', 'Storage', 'Air Conditioning'],
        agent: Agent(
          id: '3',
          name: 'Emily Rodriguez',
          email: 'emily@familyhomes.com',
          phone: '+1234567892',
          profileImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
          company: 'Family Homes Realty',
          rating: 4.7,
          totalListings: 28,
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        isFeatured: false,
      ),
      Property(
        id: '4',
        title: 'Penthouse with City Views',
        description: 'Exclusive penthouse with panoramic city views. Features include floor-to-ceiling windows, private terrace, and premium finishes.',
        price: 1200000,
        location: 'Financial District',
        address: '321 High St, Financial District',
        latitude: 40.7074,
        longitude: -74.0113,
        images: [
          'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800',
          'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800',
        ],
        bedrooms: 3,
        bathrooms: 3,
        area: 2000,
        propertyType: 'penthouse',
        listingType: 'sale',
        amenities: ['City Views', 'Terrace', 'Parking', 'Concierge', 'Gym', 'Pool'],
        agent: Agent(
          id: '4',
          name: 'David Kim',
          email: 'david@premiumproperties.com',
          phone: '+1234567893',
          profileImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
          company: 'Premium Properties',
          rating: 4.9,
          totalListings: 67,
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isFeatured: true,
      ),
      Property(
        id: '5',
        title: 'Studio Apartment Near University',
        description: 'Perfect studio apartment for students or young professionals. Close to university and public transportation.',
        price: 1200,
        location: 'University District',
        address: '654 College Ave, University District',
        latitude: 40.7505,
        longitude: -73.9934,
        images: [
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
        ],
        bedrooms: 1,
        bathrooms: 1,
        area: 500,
        propertyType: 'studio',
        listingType: 'rent',
        amenities: ['Near University', 'Public Transport', 'Air Conditioning'],
        agent: Agent(
          id: '5',
          name: 'Lisa Wang',
          email: 'lisa@studenthousing.com',
          phone: '+1234567894',
          profileImage: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face',
          company: 'Student Housing Solutions',
          rating: 4.5,
          totalListings: 89,
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        isFeatured: false,
      ),
    ];
  }

  Future<Property?> getPropertyById(String id) async {
    final properties = await getProperties();
    try {
      return properties.firstWhere((property) => property.id == id);
    } catch (e) {
      return null;
    }
  }
}
