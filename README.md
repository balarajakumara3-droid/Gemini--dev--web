<<<<<<< HEAD
# Scaffold
=======
# Flutter Food Delivery App - Swiggy Clone

A comprehensive **Swiggy-inspired food delivery application** built with Flutter for both iOS and Android platforms. This app provides a complete food ordering experience with modern UI/UX, robust architecture, and scalable features.

## 🚀 Project Overview

This is a full-featured food delivery application that replicates the core functionality of Swiggy, including restaurant discovery, menu browsing, cart management, order tracking, and user account management. The app is designed with a clean, scalable architecture suitable for real-world deployment.

## ✨ Key Features

### 🏠 Core Functionality
- **Restaurant Discovery**: Browse restaurants by location, category, and ratings
- **Advanced Search**: Search restaurants and dishes with smart filters
- **Menu Browsing**: View detailed menus with images, prices, and customization options
- **Cart Management**: Add, update, and remove items with real-time price calculation
- **Order Tracking**: Real-time order status updates and delivery tracking
- **User Profiles**: Complete account management with order history

### 🎨 User Experience
- **Modern UI**: Clean, intuitive design following Material Design principles
- **Smooth Navigation**: Tab-based navigation with bottom navigation bar
- **Location Services**: GPS-based restaurant discovery and delivery
- **Favorites**: Save favorite restaurants and dishes
- **Offers & Promotions**: Display special offers and discounts

### 🛠 Technical Features
- **State Management**: Provider pattern for reactive updates
- **Local Database**: SQLite for offline caching and favorites
- **API Integration**: RESTful API services for backend communication
- **Authentication**: JWT-based secure authentication
- **Push Notifications**: Firebase Cloud Messaging for order updates
- **Payment Integration**: Ready for Razorpay, Stripe, and other payment gateways

## 🏗 Architecture

### Frontend (Flutter)
```
lib/
├── core/
│   ├── app_config.dart          # App configuration and constants
│   ├── theme/
│   │   └── app_theme.dart       # Material Design theme
│   ├── routes/
│   │   └── app_routes.dart      # Navigation routing
│   ├── models/                  # Data models
│   │   ├── user.dart
│   │   ├── restaurant.dart
│   │   ├── cart.dart
│   │   └── order.dart
│   └── services/
│       ├── api_service.dart     # HTTP API client
│       └── database_service.dart # SQLite database
├── features/
│   ├── auth/                    # Authentication
│   ├── home/                    # Home screen & restaurant listing
│   ├── restaurant/              # Restaurant details & menu
│   ├── search/                  # Search functionality
│   ├── cart/                    # Shopping cart
│   ├── checkout/                # Order checkout
│   ├── orders/                  # Order management & tracking
│   ├── profile/                 # User profile
│   └── favorites/               # Favorites management
└── main.dart                    # App entry point
```

### Backend Services
- **API Endpoints**: RESTful APIs for restaurants, orders, users
- **Database**: SQLite for local storage, MySQL/PostgreSQL for backend
- **Authentication**: JWT tokens with refresh mechanism
- **File Storage**: Cloud storage for restaurant and food images
- **Push Notifications**: Firebase Cloud Messaging integration

## 📱 Screens

### 🔐 Authentication
- **Splash Screen**: App initialization and loading
- **Login Screen**: Email/password and social login options
- **Register Screen**: User registration with validation

### 🏪 Restaurant Discovery
- **Home Screen**: Featured restaurants, categories, and offers
- **Search Screen**: Advanced search with filters
- **Restaurant Detail**: Menu, reviews, and restaurant information

### 🛒 Order Management
- **Cart Screen**: Review items and modify quantities
- **Checkout Screen**: Address selection and payment
- **Order Tracking**: Real-time delivery status updates
- **Order History**: Past orders and reorder functionality

### 👤 User Management
- **Profile Screen**: User information and settings
- **Favorites**: Saved restaurants and dishes
- **Addresses**: Manage delivery addresses

## 🛠 Tech Stack

### Frontend
- **Framework**: Flutter 3.24+
- **Language**: Dart
- **State Management**: Provider
- **Local Database**: SQLite (sqflite)
- **HTTP Client**: Dio
- **Maps**: Google Maps Flutter
- **Permissions**: Permission Handler
- **Location**: Geolocator

### Backend Integration
- **API**: RESTful APIs
- **Authentication**: JWT tokens
- **Push Notifications**: Firebase Cloud Messaging
- **Payment**: Razorpay Flutter (ready for integration)
- **Maps**: Google Maps API

### Development Tools
- **IDE**: Android Studio / VS Code
- **Version Control**: Git
- **Package Manager**: Pub
- **Build Tools**: Flutter CLI

## 🚦 Getting Started

### Prerequisites
- Flutter SDK (3.24+)
- Dart SDK (3.0+)
- Android Studio / VS Code
- iOS development tools (for iOS deployment)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd food_delivery_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase** (Optional)
   - Add your `google-services.json` (Android)
   - Add your `GoogleService-Info.plist` (iOS)

4. **Update API Configuration**
   ```dart
   // lib/core/app_config.dart
   static const String baseUrl = 'YOUR_API_BASE_URL';
   static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_KEY';
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1              # State management
  http: ^1.1.0                  # HTTP client
  dio: ^5.3.2                   # Advanced HTTP client
  sqflite: ^2.3.0               # Local database
  shared_preferences: ^2.2.2    # Local storage
  
  # Location Services
  geolocator: ^10.1.0
  geocoding: ^2.1.1
  google_maps_flutter: ^2.5.0
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  firebase_messaging: ^14.7.10
  
  # UI Components
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  carousel_slider: ^4.2.1
  
  # Utilities
  permission_handler: ^11.0.1
  connectivity_plus: ^5.0.1
  image_picker: ^1.0.4
  url_launcher: ^6.2.1
  intl: ^0.19.0
```

## 🔧 Configuration

### API Configuration
Update the `lib/core/app_config.dart` file with your backend URLs:

```dart
class AppConfig {
  static const String baseUrl = 'https://your-api.com/api/v1';
  static const String googleMapsApiKey = 'your_google_maps_api_key';
  static const String razorpayKey = 'your_razorpay_key';
}
```

### Firebase Setup
1. Create a Firebase project
2. Add Android and iOS apps
3. Download configuration files
4. Enable Authentication and Cloud Messaging

## 🎯 Features Roadmap

### Phase 1 - MVP ✅
- [x] User authentication
- [x] Restaurant listing
- [x] Basic cart functionality
- [x] Order placement
- [x] User profile

### Phase 2 - Enhanced Features 🚧
- [ ] Real-time order tracking
- [ ] Payment gateway integration
- [ ] Push notifications
- [ ] Advanced search filters
- [ ] Restaurant reviews and ratings

### Phase 3 - Advanced Features 📋
- [ ] Delivery partner app
- [ ] Admin dashboard
- [ ] Multi-language support
- [ ] Loyalty programs
- [ ] AI-powered recommendations

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and queries:
- Create an issue in the repository
- Email: support@yourapp.com
- Documentation: [Link to detailed docs]

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for UI guidelines
- Swiggy for design inspiration
- Open source community for packages and tools

---

**Built with ❤️ using Flutter**
>>>>>>> 8c2bb35 (i added all the codes)
