import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/onboarding_controller.dart';
import 'step1_location_screen.dart';
import 'step2_location_detail_screen.dart';
import 'step3_property_types_screen.dart';

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _previousStep = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    
    print('OnboardingFlowScreen: Initialized');
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('OnboardingFlowScreen: Building widget');
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Consumer<OnboardingController>(
          builder: (context, controller, child) {
            print('OnboardingFlowScreen: Current step is ${controller.currentStep}, previous was $_previousStep');
            
            // Only animate if the step has actually changed
            if (controller.currentStep != _previousStep) {
              print('OnboardingFlowScreen: Step changed, animating to page ${controller.currentStep}');
              _previousStep = controller.currentStep;
              
              // Use addPostFrameCallback to ensure the widget is properly built
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_pageController.hasClients) {
                  _pageController.animateToPage(
                    controller.currentStep,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              });
            }
            
            return PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe gestures
              onPageChanged: (page) {
                // This ensures the controller stays in sync with the PageView
                if (page != controller.currentStep) {
                  print('OnboardingFlowScreen: PageView changed to page $page');
                  // Update the controller to match the PageView position
                  controller.goToStep(page);
                }
              },
              children: [
                const Step1LocationScreen(),
                const Step2LocationDetailScreen(),
                const Step3PropertyTypesScreen(),
              ],
            );
          },
        ),
      ),
    );
  }
}