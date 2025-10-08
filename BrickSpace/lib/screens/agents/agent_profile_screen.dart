import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/property.dart';
import '../../widgets/property_card.dart';

class AgentProfileScreen extends StatefulWidget {
  final String agentId;

  const AgentProfileScreen({
    super.key,
    required this.agentId,
  });

  @override
  State<AgentProfileScreen> createState() => _AgentProfileScreenState();
}

class _AgentProfileScreenState extends State<AgentProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final agent = _getAgentById(widget.agentId);
    final properties = _getAgentProperties(widget.agentId);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
        title: const Text(
          'Featured List / Top Agents - Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(agent.profileImage),
                        backgroundColor: Colors.grey[300],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2E7D32),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              '#1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    agent.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    agent.email,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF757575),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard('5.0', 'Reviews', Icons.star),
                      _buildStatCard('235', 'Reviews', Icons.rate_review),
                      _buildStatCard('112', 'Sold', Icons.home),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Tabs
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF2E7D32),
                unselectedLabelColor: const Color(0xFF757575),
                indicatorColor: const Color(0xFF2E7D32),
                tabs: const [
                  Tab(text: 'Listings'),
                  Tab(text: 'Sold'),
                ],
              ),
            ),
            // Content
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${properties.length} listings',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212121),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.grid_view,
                              color: _isGridView ? const Color(0xFF2E7D32) : const Color(0xFF757575),
                            ),
                            onPressed: () => setState(() => _isGridView = true),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.list,
                              color: !_isGridView ? const Color(0xFF2E7D32) : const Color(0xFF757575),
                            ),
                            onPressed: () => setState(() => _isGridView = false),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _isGridView
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: properties.length,
                          itemBuilder: (context, index) {
                            return PropertyCard(
                              property: properties[index],
                              isFavorite: false,
                              onFavoriteToggle: () {},
                              onTap: () => context.push('/properties/${properties[index].id}'),
                            );
                          },
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: properties.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: PropertyCard(
                                property: properties[index],
                                isFavorite: false,
                                onFavoriteToggle: () {},
                                onTap: () => context.push('/properties/${properties[index].id}'),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              context.push('/chat?agentName=${agent.name}&agentImage=${agent.profileImage}');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Start Chat',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 8),
          Icon(
            icon,
            color: const Color(0xFF2E7D32),
            size: 20,
          ),
        ],
      ),
    );
  }

  Agent _getAgentById(String id) {
    return Agent(
      id: id,
      name: 'Amanda',
      email: 'amanda.trust@email.com',
      phone: '+1234567890',
      profileImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      company: 'Premium Real Estate',
      rating: 5.0,
      totalListings: 112,
    );
  }

  List<Property> _getAgentProperties(String agentId) {
    return [
      Property(
        id: '1',
        title: 'Brookvale Villa',
        description: 'Beautiful villa with pool',
        price: 320,
        location: 'Jakarta, Indonesia',
        address: 'Jakarta, Indonesia',
        latitude: -6.2088,
        longitude: 106.8456,
        images: [
          'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=400&h=300&fit=crop',
        ],
        bedrooms: 3,
        bathrooms: 2,
        area: 1500,
        propertyType: 'villa',
        listingType: 'rent',
        amenities: ['Pool', 'Garden', 'Parking'],
        agent: _getAgentById(widget.agentId),
        createdAt: DateTime.now(),
        isFeatured: true,
      ),
      Property(
        id: '2',
        title: 'The Overdale Apartment',
        description: 'Modern apartment in city center',
        price: 290,
        location: 'Jakarta, Indonesia',
        address: 'Jakarta, Indonesia',
        latitude: -6.2088,
        longitude: 106.8456,
        images: [
          'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=400&h=300&fit=crop',
        ],
        bedrooms: 2,
        bathrooms: 1,
        area: 800,
        propertyType: 'apartment',
        listingType: 'rent',
        amenities: ['Gym', 'Parking', 'Air Conditioning'],
        agent: _getAgentById(widget.agentId),
        createdAt: DateTime.now(),
        isFeatured: false,
      ),
    ];
  }
}
