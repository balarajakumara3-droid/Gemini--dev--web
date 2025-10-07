import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/property.dart';
import '../../widgets/agent_card.dart';

class TopAgentsScreen extends StatelessWidget {
  const TopAgentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Featured List / Top Agents',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Estate Agent',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Find the best recommendations place to live',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF757575),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _getTopAgents().length,
                itemBuilder: (context, index) {
                  final agent = _getTopAgents()[index];
                  return AgentCard(
                    agent: agent,
                    rank: index + 1,
                    onTap: () => context.push('/agents/${agent.id}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Agent> _getTopAgents() {
    return [
      Agent(
        id: '1',
        name: 'Amanda',
        email: 'amanda.trust@email.com',
        phone: '+1234567890',
        profileImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        company: 'Premium Real Estate',
        rating: 5.0,
        totalListings: 112,
      ),
      Agent(
        id: '2',
        name: 'Anderson',
        email: 'anderson@email.com',
        phone: '+1234567891',
        profileImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        company: 'Luxury Homes Group',
        rating: 4.9,
        totalListings: 112,
      ),
      Agent(
        id: '3',
        name: 'Samantha',
        email: 'samantha@email.com',
        phone: '+1234567892',
        profileImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        company: 'Family Homes Realty',
        rating: 4.9,
        totalListings: 112,
      ),
      Agent(
        id: '4',
        name: 'Andrew',
        email: 'andrew@email.com',
        phone: '+1234567893',
        profileImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        company: 'Premium Properties',
        rating: 4.9,
        totalListings: 112,
      ),
      Agent(
        id: '5',
        name: 'Michael',
        email: 'michael@email.com',
        phone: '+1234567894',
        profileImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        company: 'Student Housing Solutions',
        rating: 4.8,
        totalListings: 112,
      ),
      Agent(
        id: '6',
        name: 'Tobi',
        email: 'tobi@email.com',
        phone: '+1234567895',
        profileImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        company: 'Elite Real Estate',
        rating: 4.8,
        totalListings: 112,
      ),
    ];
  }
}
