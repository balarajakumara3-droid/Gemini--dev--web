import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/onboarding/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/properties/property_list_screen.dart';
import '../screens/properties/property_detail_screen.dart';
import '../screens/properties/search_screen.dart';
import '../screens/properties/filters_screen.dart';
import '../screens/onboarding/location_setup_screen.dart';
import '../screens/map/map_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/settings_screen.dart';
import '../screens/agents/top_agents_screen.dart';
import '../screens/agents/agent_profile_screen.dart';
import '../screens/onboarding/location_setup_screen.dart';
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
import '../screens/chat/chat_screen.dart';
import '../screens/chat/chat_history_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
            redirect: (context, state) {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              final isAuthenticated = authProvider.isAuthenticated;
              final isOnAuthScreen = state.uri.toString().startsWith('/auth');
              final isOnOnboardingScreen = state.uri.toString().startsWith('/onboarding');
              final isOnSplashScreen = state.uri.toString() == '/splash';
              final isOnOTPScreen = state.uri.toString().startsWith('/auth/otp');

              print('Router redirect: uri=${state.uri}, isAuthenticated=$isAuthenticated, isOnAuthScreen=$isOnAuthScreen, isOnOnboardingScreen=$isOnOnboardingScreen, isOnSplashScreen=$isOnSplashScreen, isOnOTPScreen=$isOnOTPScreen');

              // Allow splash and onboarding screens without authentication
              if (isOnSplashScreen || isOnOnboardingScreen) {
                print('Router redirect: Allowing splash/onboarding, returning null');
                return null;
              }

              // Allow OTP screen even when authenticated (for email verification)
              if (isOnOTPScreen) {
                print('Router redirect: Allowing OTP screen, returning null');
                return null;
              }

              // If user is not authenticated and not on auth screen, redirect to login
              if (!isAuthenticated && !isOnAuthScreen) {
                print('Router redirect: Not authenticated, redirecting to login');
                return '/auth/login';
              }

              // If user is authenticated and on auth screen (but not OTP), redirect to account setup
              if (isAuthenticated && isOnAuthScreen && !isOnOTPScreen) {
                print('Router redirect: Authenticated on auth screen, redirecting to account setup');
                return '/onboarding/location-setup';
              }

              print('Router redirect: No redirect needed');
              return null;
            },
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
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
        builder: (context, state) => const HomeScreen(),
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
        builder: (context, state) => const PromotionDetailScreen(),
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
            agentName: agentName,
            agentImage: agentImage,
          );
        },
      ),
      GoRoute(
        path: '/chat-history',
        builder: (context, state) => const ChatHistoryScreen(),
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
