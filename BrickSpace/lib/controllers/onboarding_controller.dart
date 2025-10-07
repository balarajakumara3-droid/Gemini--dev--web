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

  void skipToEnd() {
    _currentStep = 2;
    notifyListeners();
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 2) {
      _currentStep = step;
      notifyListeners();
    }
  }

  // Location data
  void setLocation(LocationData location) {
    _onboardingData = _onboardingData.copyWith(location: location);
    _clearError();
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
    _setLoading(true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      _onboardingData = _onboardingData.copyWith(isCompleted: true);
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to complete onboarding: $e');
      _setLoading(false);
    }
  }

  // Validation
  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _onboardingData.location != null;
      case 1:
        return _onboardingData.location != null;
      case 2:
        return _onboardingData.selectedPropertyTypes.isNotEmpty;
      default:
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
