class ApiConfig {
  // Google Maps API Keys
  static const String API_KEY_ANDROID = 'AIzaSyBXOZnoWz3_ikmWdCkEDsQKRNGdGR5qceM';
  static const String API_KEY_IOS = 'AIzaSyC_ZOcnbekb5a5OEl-MBN8n070oaoFN4eA';
  
  // Platform-specific API key getter
  static String get googleMapsApiKey {
    // This will be used in your Dart code when needed
    // You might want to add platform-specific logic here
    return API_KEY_ANDROID.isNotEmpty ? API_KEY_ANDROID : API_KEY_IOS;
  }
  
  // Helper method to check if keys are properly set
  static bool get hasValidKeys {
    return API_KEY_ANDROID.isNotEmpty && API_KEY_IOS.isNotEmpty;
  }
  
  // Get Android API Key
  static String get androidApiKey => API_KEY_ANDROID;
  
  // Get iOS API Key
  static String get iosApiKey => API_KEY_IOS;
}