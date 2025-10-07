import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../providers/onboarding_provider.dart';
import 'location_setup_screen.dart';
import 'property_types_screen.dart';
import 'user_info_screen.dart';

class OnboardingFlowScreen extends StatelessWidget {
  const OnboardingFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(
      builder: (context, onboardingProvider, child) {
        return Scaffold(
          body: IndexedStack(
            index: onboardingProvider.currentStep,
            children: const [
              LocationSetupScreen(),
              PropertyTypesScreen(),
              UserInfoScreen(),
            ],
          ),
        );
      },
    );
  }
}
