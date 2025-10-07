import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/featured/featured_estates_screen.dart';
import 'screens/onboarding/user_info_screen.dart';
import 'screens/onboarding/property_types_screen.dart';

void main() {
  runApp(const RealEstateApp());
}

class RealEstateApp extends StatelessWidget {
  const RealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real Estate App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF5F7F9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      home: const UserInfoScreen(),
      routes: {
        '/home': (context) => const Scaffold(
          body: Center(
            child: Text(
              'Home Screen - Onboarding Complete!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        '/featured': (context) => const FeaturedEstatesScreen(),
        '/onboarding/user-info': (context) => const UserInfoScreen(),
        '/onboarding/property-types': (context) => const PropertyTypesScreen(),
      },
    );
  }
}