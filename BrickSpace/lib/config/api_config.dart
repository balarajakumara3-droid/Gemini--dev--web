class ApiConfig {
  static const String androidKey = String.fromEnvironment('API_KEY_ANDROID');
  static const String iosKey = String.fromEnvironment('API_KEY_IOS');
  
  // You can also add validation or fallback logic here
  static String get googleMapsApiKey {
    // This will be used in your Dart code when needed
    // You might want to add platform-specific logic here
    return androidKey.isNotEmpty ? androidKey : iosKey;
  }
  
  // Helper method to check if keys are properly set
  static bool get hasValidKeys {
    return androidKey.isNotEmpty && iosKey.isNotEmpty;
  }
}
