import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/landing_screen.dart';
import '../screens/onboarding/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/onboarding/new_onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/new_home_screen.dart';
import '../screens/properties/property_list_screen.dart';
import '../screens/properties/property_detail_screen.dart';
import '../screens/properties/schedule_visit_screen.dart';
import '../screens/properties/search_screen.dart';
import '../screens/properties/filters_screen.dart';
import '../screens/onboarding/location_setup_screen.dart';
import '../screens/map/map_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/favorites/wishlist_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/settings_screen.dart';
import '../screens/agents/top_agents_screen.dart';
import '../screens/agents/agent_profile_screen.dart';
import '../screens/onboarding/property_types_screen.dart';
import '../screens/onboarding/user_info_screen.dart';
import '../screens/onboarding/onboarding_flow_screen.dart';
import '../screens/onboarding/location_search_screen.dart';
import '../screens/onboarding/location_confirmation_screen.dart';
import '../screens/onboarding/property_types_selection_screen.dart';
import '../screens/auth/otp_verification_screen.dart';
import '../screens/support/faq_support_screen.dart';
import '../screens/location/location_selection_screen.dart';
import '../screens/onboarding/location_selection_screen.dart' as onboarding;
import '../screens/promotion/promotion_detail_screen.dart';
import '../screens/featured/featured_estates_screen.dart';
import '../screens/featured/top_locations_screen.dart';
import '../screens/featured/top_agents_screen.dart' as featured;
import '../screens/properties/property_comparison_screen.dart';
import '../screens/properties/property_comparison_results_screen.dart';
import '../screens/properties/property_booking_screen.dart';
import '../screens/properties/property_sharing_screen.dart';
import '../screens/properties/property_alerts_screen.dart';
import '../screens/properties/property_reviews_screen.dart';
import '../screens/properties/property_report_screen.dart';
import '../screens/calculators/mortgage_calculator_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/chat/chat_history_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/properties/recently_viewed_screen.dart';
import '../screens/properties/property_categories_screen.dart';
import '../screens/map/map_filter_screen.dart';
import '../models/property.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isAuthenticated = authProvider.isAuthenticated;
      final currentPath = state.uri.toString();

      print('Router redirect: path=$currentPath, isAuthenticated=$isAuthenticated');

      // Allow access to landing, splash, onboarding, and auth screens without authentication
      if (currentPath == '/' || 
          currentPath == '/splash' || 
          currentPath.startsWith('/onboarding') || 
          currentPath.startsWith('/auth')) {
        print('Router redirect: Allowing access to public screens');
        return null;
      }

      // If user is authenticated, allow access to all screens
      if (isAuthenticated) {
        print('Router redirect: User authenticated, allowing access');
        return null;
      }

      // If user is not authenticated and trying to access protected routes, redirect to landing
      print('Router redirect: Not authenticated, redirecting to landing');
      return '/';
    },
    routes: [
      // Landing Screen
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingScreen(),
      ),
      
      // Splash Screen
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const NewOnboardingScreen(),
      ),
      GoRoute(
        path: '/onboarding-flow',
        builder: (context, state) => const OnboardingFlowScreen(),
      ),

      // Authentication Routes
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Main App Routes
      GoRoute(
        path: '/home',
        builder: (context, state) => const NewHomeScreen(),
      ),
      GoRoute(
        path: '/properties',
        builder: (context, state) => const PropertyListScreen(),
      ),
      GoRoute(
        path: '/properties/:id',
        builder: (context, state) {
          final propertyId = state.pathParameters['id']!;
          return PropertyDetailScreen(propertyId: propertyId);
        },
      ),
      GoRoute(
        path: '/schedule-visit/:propertyId',
        builder: (context, state) {
          final propertyId = state.pathParameters['propertyId']!;
          // You would typically fetch the property here
          final property = Property(
            id: propertyId,
            title: 'Modern Apartment in Downtown',
            description: 'Beautiful modern apartment with stunning city views.',
            price: 2500,
            location: 'Downtown',
            address: '123 Main Street, Downtown',
            latitude: 37.7749,
            longitude: -122.4194,
            images: ['https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800'],
            bedrooms: 2,
            bathrooms: 2,
            area: 1200,
            areaUnit: 'sq ft',
            propertyType: 'Apartment',
            listingType: 'rent',
            amenities: ['Parking', 'Gym', 'Pool', 'Balcony', 'Air Conditioning'],
            agent: Agent(
              id: 'agent1',
              name: 'Sarah Johnson',
              email: 'sarah@premiumrealestate.com',
              phone: '+1 (555) 123-4567',
              profileImage: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
              company: 'Premium Real Estate',
              rating: 4.8,
              totalListings: 45,
            ),
            createdAt: DateTime.now(),
          );
          return ScheduleVisitScreen(property: property);
        },
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/filters',
        builder: (context, state) => const FiltersScreen(),
      ),
      GoRoute(
        path: '/map',
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      // New Feature Routes
      GoRoute(
        path: '/properties/compare',
        builder: (context, state) => const PropertyComparisonScreen(),
      ),
      GoRoute(
        path: '/properties/compare-results',
        builder: (context, state) {
          final propertyIds = state.extra as List<String>? ?? [];
          return PropertyComparisonResultsScreen(propertyIds: propertyIds);
        },
      ),
      GoRoute(
        path: '/properties/booking/:propertyId',
        builder: (context, state) {
          final propertyId = state.pathParameters['propertyId']!;
          return PropertyBookingScreen(propertyId: propertyId);
        },
      ),
      GoRoute(
        path: '/properties/sharing/:propertyId',
        builder: (context, state) {
          final propertyId = state.pathParameters['propertyId']!;
          return PropertySharingScreen(propertyId: propertyId);
        },
      ),
      GoRoute(
        path: '/properties/alerts',
        builder: (context, state) => const PropertyAlertsScreen(),
      ),
      GoRoute(
        path: '/properties/reviews/:propertyId',
        builder: (context, state) {
          final propertyId = state.pathParameters['propertyId']!;
          return PropertyReviewsScreen(propertyId: propertyId);
        },
      ),
      GoRoute(
        path: '/properties/report/:propertyId',
        builder: (context, state) {
          final propertyId = state.pathParameters['propertyId']!;
          return PropertyReportScreen(propertyId: propertyId);
        },
      ),
      GoRoute(
        path: '/calculators/mortgage',
        builder: (context, state) => const MortgageCalculatorScreen(),
      ),
      GoRoute(
        path: '/chat/:agentId',
        builder: (context, state) {
          final agentId = state.pathParameters['agentId']!;
          // You would typically fetch agent and property data here
          return ChatScreen(
            property: Property(
              id: '1',
              title: 'Sample Property',
              description: 'A beautiful sample property for testing',
              price: 500000,
              location: 'Sample Location',
              address: '123 Sample Street, Sample City',
              latitude: 37.7749,
              longitude: -122.4194,
              images: [],
              bedrooms: 3,
              bathrooms: 2,
              area: 1500,
              areaUnit: 'sq ft',
              propertyType: 'House',
              listingType: 'sale',
              amenities: [],
              agent: Agent(
                id: 'agent1',
                name: 'John Doe',
                email: 'john@example.com',
                phone: '+1234567890',
                profileImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
                company: 'Sample Real Estate',
                rating: 4.8,
                totalListings: 25,
              ),
              createdAt: DateTime.now(),
            ),
            agentId: agentId,
            agentName: 'John Doe',
            agentImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
          );
        },
      ),

      // Agent Routes
      GoRoute(
        path: '/agents',
        builder: (context, state) => const TopAgentsScreen(),
      ),
      GoRoute(
        path: '/agents/:id',
        builder: (context, state) {
          final agentId = state.pathParameters['id']!;
          return AgentProfileScreen(agentId: agentId);
        },
      ),

      // Onboarding Routes
      GoRoute(
        path: '/onboarding/location',
        builder: (context, state) => const LocationSetupScreen(),
      ),
      GoRoute(
        path: '/onboarding/location-setup',
        builder: (context, state) => const LocationSetupScreen(),
      ),
      GoRoute(
        path: '/onboarding/property-types',
        builder: (context, state) => const PropertyTypesScreen(),
      ),
      GoRoute(
        path: '/onboarding/user-info',
        builder: (context, state) => const UserInfoScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: '/auth/otp',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? 'user@example.com';
          return OTPVerificationScreen(email: email);
        },
      ),

      // Support Routes
      GoRoute(
        path: '/support/faq',
        builder: (context, state) => const FAQSupportScreen(),
      ),

      // Location Routes
      GoRoute(
        path: '/location-selection',
        builder: (context, state) => const LocationSelectionScreen(),
      ),
      GoRoute(
        path: '/onboarding/location-selection',
        builder: (context, state) => const onboarding.LocationSelectionScreen(),
      ),
      
              // Account Setup Screens (removed - going directly to home)

      // Promotion Routes
      GoRoute(
        path: '/promotion-detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return PromotionDetailScreen(
            title: extra?['title'] as String?,
            subtitle: extra?['subtitle'] as String?,
            image: extra?['image'] as String?,
          );
        },
      ),

      // Featured Routes
      GoRoute(
        path: '/featured-estates',
        builder: (context, state) => const FeaturedEstatesScreen(),
      ),
      GoRoute(
        path: '/top-locations',
        builder: (context, state) => const TopLocationsScreen(),
      ),
      GoRoute(
        path: '/top-agents',
        builder: (context, state) => const TopAgentsScreen(),
      ),

      // Chat Routes
      GoRoute(
        path: '/chat',
        builder: (context, state) {
          final agentName = state.uri.queryParameters['agentName'] ?? 'Agent';
          final agentImage = state.uri.queryParameters['agentImage'] ?? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face';
          return ChatScreen(
            property: Property(
              id: '1',
              title: 'Sample Property',
              description: 'A beautiful sample property for testing',
              price: 500000,
              location: 'Sample Location',
              address: '123 Sample Street, Sample City',
              latitude: 37.7749,
              longitude: -122.4194,
              images: [],
              bedrooms: 3,
              bathrooms: 2,
              area: 1500,
              areaUnit: 'sq ft',
              propertyType: 'House',
              listingType: 'sale',
              amenities: [],
              agent: Agent(
                id: 'agent1',
                name: agentName,
                email: 'agent@example.com',
                phone: '+1234567890',
                profileImage: agentImage,
                company: 'Sample Real Estate',
                rating: 4.8,
                totalListings: 25,
              ),
              createdAt: DateTime.now(),
            ),
            agentId: 'agent1',
            agentName: agentName,
            agentImage: agentImage,
          );
        },
      ),
      GoRoute(
        path: '/chat-history',
        builder: (context, state) => const ChatHistoryScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/recently-viewed',
        builder: (context, state) => const RecentlyViewedScreen(),
      ),
      GoRoute(
        path: '/property-categories',
        builder: (context, state) => const PropertyCategoriesScreen(),
      ),
      GoRoute(
        path: '/map-filter',
        builder: (context, state) => const MapFilterScreen(),
      ),
      GoRoute(
        path: '/wishlist',
        builder: (context, state) => const WishlistScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}