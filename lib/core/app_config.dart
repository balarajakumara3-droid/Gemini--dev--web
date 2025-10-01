class AppConfig {
  static const String appName = 'Food Delivery';
  static const String appVersion = '1.0.0';
  
  // Feature Flags
  static const bool enableAppleSignIn = false; // Toggle when Apple Dev membership is available
  
  // API Configuration
  static const String baseUrl = 'https://your-api.com/api/v1';
  static const String imageBaseUrl = 'https://your-api.com/images';
  
  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String restaurantsEndpoint = '/restaurants';
  static const String menuEndpoint = '/restaurants/{id}/menu';
  static const String ordersEndpoint = '/orders';
  static const String searchEndpoint = '/search';
  
  // App Settings
  static const int requestTimeout = 30; // seconds
  static const int maxRetries = 3;
  static const double defaultLatitude = 12.9716; // Bangalore
  static const double defaultLongitude = 77.5946;
  static const double searchRadius = 10.0; // km
  
  // Firebase Configuration
  static const String fcmTopic = 'food_delivery';
  
  // Supabase Configuration
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://jndmejkpnefigtjpbzmn.supabase.co',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpuZG1lamtwbmVmaWd0anBiem1uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkxMjMzNTgsImV4cCI6MjA3NDY5OTM1OH0.u7cVWlEx8SKzNboAxDc7XPdV0XZ4YBwmWSQjSM_2Z1k',
  );
  
  // Payment Configuration
  static const String razorpayKey = 'your_razorpay_key';
  
  // Map Configuration
  static const String googleMapsApiKey = 'your_google_maps_api_key';
}

class AppStrings {
  // Common
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String retry = 'Retry';
  static const String noData = 'No data found';
  static const String noInternet = 'No internet connection';
  
  // Authentication
  static const String login = 'Login';
  static const String logout = 'Logout';
  static const String register = 'Register';
  static const String forgotPassword = 'Forgot Password?';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String phoneNumber = 'Phone Number';
  static const String createAccount = 'Create Account';
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String dontHaveAccount = "Don't have an account?";
  
  // Social Login
  static const String continueWithGoogle = 'Continue with Google';
  static const String continueWithApple = 'Continue with Apple';
  static const String continueWithFacebook = 'Continue with Facebook';
  
  // Validation Messages
  static const String emailRequired = 'Please enter your email';
  static const String emailInvalid = 'Please enter a valid email';
  static const String passwordRequired = 'Please enter your password';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String passwordsDontMatch = 'Passwords do not match';
  static const String nameRequired = 'Please enter your full name';
  static const String phoneRequired = 'Please enter your phone number';
  static const String phoneInvalid = 'Please enter a valid phone number';
  
  // Success Messages
  static const String accountCreated = 'Account created successfully!';
  static const String loginSuccessful = 'Login successful!';
  static const String logoutSuccessful = 'Logout successful!';
  
  // Error Messages
  static const String loginFailed = 'Login failed. Please try again.';
  static const String registrationFailed = 'Registration failed. Please try again.';
  static const String networkError = 'Network error. Please check your connection.';
  static const String somethingWentWrong = 'Something went wrong. Please try again.';
  
  // Home
  static const String searchRestaurants = 'Search restaurants, cuisines...';
  static const String categories = 'Categories';
  static const String restaurants = 'Restaurants';
  static const String offers = 'Offers';
  static const String viewAll = 'View All';
  
  // Restaurant
  static const String addToCart = 'Add to Cart';
  static const String removeFromCart = 'Remove from Cart';
  static const String viewCart = 'View Cart';
  static const String menu = 'Menu';
  static const String reviews = 'Reviews';
  static const String info = 'Info';
  
  // Cart
  static const String cart = 'Cart';
  static const String checkout = 'Checkout';
  static const String total = 'Total';
  static const String subtotal = 'Subtotal';
  static const String deliveryFee = 'Delivery Fee';
  static const String taxes = 'Taxes';
  
  // Orders
  static const String orders = 'Orders';
  static const String orderHistory = 'Order History';
  static const String trackOrder = 'Track Order';
  static const String orderPlaced = 'Order Placed';
  static const String orderConfirmed = 'Order Confirmed';
  static const String preparing = 'Preparing';
  static const String outForDelivery = 'Out for Delivery';
  static const String delivered = 'Delivered';
  
  // Profile
  static const String profile = 'Profile';
  static const String editProfile = 'Edit Profile';
  static const String addresses = 'Addresses';
  static const String paymentMethods = 'Payment Methods';
  static const String settings = 'Settings';
  static const String helpSupport = 'Help & Support';
  static const String aboutUs = 'About Us';
}

class AppAssets {
  // Images
  static const String logo = 'assets/images/logo.png';
  static const String splash = 'assets/images/splash.png';
  static const String placeholder = 'assets/images/placeholder.png';
  static const String emptyCart = 'assets/images/empty_cart.png';
  static const String noOrders = 'assets/images/no_orders.png';
  
  // Icons
  static const String home = 'assets/icons/home.png';
  static const String search = 'assets/icons/search.png';
  static const String cart = 'assets/icons/cart.png';
  static const String orders = 'assets/icons/orders.png';
  static const String profile = 'assets/icons/profile.png';
  static const String location = 'assets/icons/location.png';
  static const String star = 'assets/icons/star.png';
  static const String heart = 'assets/icons/heart.png';
  static const String filter = 'assets/icons/filter.png';
}