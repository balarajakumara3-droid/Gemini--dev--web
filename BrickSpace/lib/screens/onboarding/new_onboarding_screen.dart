import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewOnboardingScreen extends StatefulWidget {
  const NewOnboardingScreen({super.key});

  @override
  State<NewOnboardingScreen> createState() => _NewOnboardingScreenState();
}

class _NewOnboardingScreenState extends State<NewOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: "Find Your Dream Home",
      description: "Discover the perfect property that matches your lifestyle and budget with our advanced search filters.",
      imageUrl: "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=400&h=300&fit=crop",
      bgColor: const Color(0xFFE3F2FD),
    ),
    OnboardingPage(
      title: "Connect with Agents",
      description: "Get in touch with top real estate professionals who can guide you through every step of your journey.",
      imageUrl: "https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=400&h=300&fit=crop",
      bgColor: const Color(0xFFF1F8E9),
    ),
    OnboardingPage(
      title: "Manage Your Property",
      description: "Easily list, track, and manage all your real estate investments in one convenient place.",
      imageUrl: "https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=400&h=300&fit=crop",
      bgColor: const Color(0xFFFFF3E0),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to login after completing onboarding
      context.go('/auth/login');
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    context.go('/auth/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with skip button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: _pages.map((page) => _buildOnboardingPage(page)).toList(),
              ),
            ),
            
            // Navigation controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: _currentPage == index 
                              ? const Color(0xFF4CAF50)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Navigation buttons
                  Row(
                    children: [
                      // Back button
                      if (_currentPage > 0)
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: OutlinedButton(
                              onPressed: _previousPage,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF4CAF50)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Back',
                                style: TextStyle(
                                  color: Color(0xFF4CAF50),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        const Expanded(child: SizedBox()),
                      
                      // Spacing between buttons
                      if (_currentPage > 0) const SizedBox(width: 15),
                      
                      // Next/Get Started button
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: page.bgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                page.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: page.bgColor,
                    child: const Center(
                      child: Icon(
                        Icons.home,
                        size: 80,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String imageUrl;
  final Color bgColor;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.bgColor,
  });
}