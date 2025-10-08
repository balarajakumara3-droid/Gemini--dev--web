import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image - Luxury staircase with chandelier
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&h=600&fit=crop',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF0D47A1), // Dark blue
                        Color(0xFF1976D2), // Lighter blue
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Dark overlay for better text visibility
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Header spacing
                const SizedBox(height: 40),
                
                // Main content
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo container with house icon
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50), // Green color
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.home_outlined,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Decorative elements (wavy lines)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 12,
                              height: 3,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 20,
                              height: 3,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 12,
                              height: 3,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Brand name
                        const Text(
                          'BrickSpace',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        
                        const SizedBox(height: 10),
                        
                        // Tagline
                        const Text(
                          'Find Your Perfect Home',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70,
                          ),
                        ),
                        
                        const SizedBox(height: 80),
                        
                        // Get Started button
                        SizedBox(
                          width: 280,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () => context.go('/onboarding'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 10,
                              shadowColor: const Color(0xFF4CAF50).withOpacity(0.4),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text(
                              "Let's Start",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Footer
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      Text(
                        'Made with ❤️ for Real Estate Lovers',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Version 1.0',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}