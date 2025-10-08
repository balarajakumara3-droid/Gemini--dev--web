import 'package:flutter/material.dart';
import '../models/onboarding_models.dart';

class OnboardingController extends ChangeNotifier {
  int _currentStep = 0;
  OnboardingData _onboardingData = OnboardingData();
  bool _isLoading = false;
  String? _error;

  // Getters
  int get currentStep => _currentStep;
  OnboardingData get onboardingData => _onboardingData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get canProceed => _validateCurrentStep();

  // Step navigation
  void nextStep() {
    print('OnboardingController: nextStep called, currentStep=$_currentStep');
    if (_currentStep < 2) {
      _currentStep++;
      print('OnboardingController: Step changed to $_currentStep');
      notifyListeners();
    } else {
      print('OnboardingController: Already at last step');
    }
  }

  void previousStep() {
    print('OnboardingController: previousStep called, currentStep=$_currentStep');
    if (_currentStep > 0) {
      _currentStep--;
      print('OnboardingController: Step changed to $_currentStep');
      notifyListeners();
    } else {
      print('OnboardingController: Already at first step');
    }
  }

  void skipToEnd() {
    print('OnboardingController: skipToEnd called');
    _currentStep = 2;
    _onboardingData = _onboardingData.copyWith(isCompleted: true);
    print('OnboardingController: Step changed to $_currentStep');
    notifyListeners();
  }

  void goToStep(int step) {
    print('OnboardingController: goToStep called with step=$step, currentStep=$_currentStep');
    if (step >= 0 && step <= 2 && step != _currentStep) {
      _currentStep = step;
      print('OnboardingController: Step changed to $_currentStep');
      notifyListeners();
    } else {
      print('OnboardingController: goToStep ignored (step=$step, currentStep=$_currentStep)');
    }
  }

  // Location data
  void setLocation(LocationData location) {
    print('OnboardingController: setLocation called with location: ${location.fullAddress}');
    _onboardingData = _onboardingData.copyWith(location: location);
    _clearError();
    print('OnboardingController: Location set successfully');
    notifyListeners();
  }

  // Property types
  void togglePropertyType(PropertyType propertyType) {
    final currentTypes = List<PropertyType>.from(_onboardingData.selectedPropertyTypes);
    final existingIndex = currentTypes.indexWhere((type) => type.id == propertyType.id);
    
    if (existingIndex != -1) {
      // Remove if already selected
      currentTypes.removeAt(existingIndex);
    } else {
      // Add if not selected
      currentTypes.add(propertyType.copyWith(isSelected: true));
    }
    
    _onboardingData = _onboardingData.copyWith(selectedPropertyTypes: currentTypes);
    _clearError();
    notifyListeners();
  }

  // Completion
  Future<void> completeOnboarding() async {
    print('OnboardingController: completeOnboarding called');
    _setLoading(true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      _onboardingData = _onboardingData.copyWith(isCompleted: true);
      _setLoading(false);
      print('OnboardingController: Onboarding completed successfully');
      notifyListeners();
    } catch (e) {
      print('OnboardingController: Error completing onboarding: $e');
      _setError('Failed to complete onboarding: $e');
      _setLoading(false);
    }
  }

  // Validation
  bool _validateCurrentStep() {
    print('OnboardingController: _validateCurrentStep called for step $_currentStep');
    switch (_currentStep) {
      case 0:
        final result = _onboardingData.location != null;
        print('OnboardingController: Step 0 validation result: $result');
        return result;
      case 1:
        final result = _onboardingData.location != null;
        print('OnboardingController: Step 1 validation result: $result');
        return result;
      case 2:
        final result = _onboardingData.selectedPropertyTypes.isNotEmpty;
        print('OnboardingController: Step 2 validation result: $result');
        return result;
      default:
        print('OnboardingController: Unknown step $_currentStep, returning false');
        return false;
    }
  }

  // Error handling
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Reset
  void reset() {
    _currentStep = 0;
    _onboardingData = OnboardingData();
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  // Get progress percentage
  double get progressPercentage {
    switch (_currentStep) {
      case 0:
        return _onboardingData.location != null ? 0.33 : 0.0;
      case 1:
        return _onboardingData.location != null ? 0.66 : 0.33;
      case 2:
        return _onboardingData.selectedPropertyTypes.isNotEmpty ? 1.0 : 0.66;
      default:
        return 0.0;
    }
  }
}
