import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  int _currentStep = 0;
  String? _selectedLocation;
  List<String> _selectedPropertyTypes = [];
  bool _isOnboardingComplete = false;

  int get currentStep => _currentStep;
  String? get selectedLocation => _selectedLocation;
  List<String> get selectedPropertyTypes => _selectedPropertyTypes;
  bool get isOnboardingComplete => _isOnboardingComplete;

  void setLocation(String location) {
    _selectedLocation = location;
    notifyListeners();
  }

  void setPropertyTypes(List<String> propertyTypes) {
    _selectedPropertyTypes = propertyTypes;
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < 2) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void completeOnboarding() {
    _isOnboardingComplete = true;
    notifyListeners();
  }

  void resetOnboarding() {
    _currentStep = 0;
    _selectedLocation = null;
    _selectedPropertyTypes = [];
    _isOnboardingComplete = false;
    notifyListeners();
  }
}
