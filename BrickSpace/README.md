# BrickSpace - Real Estate App

A modern Flutter real estate application for browsing and discovering properties. This app provides a clean, user-friendly interface for property search, favorites, and property management.

## Features

### 🏠 Core Features
- **Property Browsing**: Browse through a comprehensive list of properties
- **Advanced Search**: Search properties by location, type, price range, and amenities
- **Property Details**: View detailed information about each property including images, amenities, and agent contact
- **Favorites**: Save your favorite properties for easy access
- **Map View**: View properties on a map (placeholder for Google Maps integration)
- **User Authentication**: Secure login and registration system

### 📱 Screens Included
1. **Splash Screen** - Welcome screen with app branding
2. **Authentication**
   - Login Screen
   - Registration Screen
   - Forgot Password Screen
3. **Home Dashboard** - Main property browsing interface
4. **Property Management**
   - Property List Screen
   - Property Detail Screen
   - Search Screen
   - Filters Screen
5. **User Features**
   - Favorites Screen
   - Profile Screen
   - Edit Profile Screen
   - Settings Screen
6. **Map View** - Property location visualization

### 🎨 Design Features
- **Modern UI**: Clean, intuitive interface following Material Design principles
- **Responsive Design**: Optimized for both iOS and Android
- **Dark/Light Theme**: System-based theme switching
- **Custom Components**: Reusable widgets for consistent design
- **Smooth Animations**: Engaging user experience with smooth transitions

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator (for testing)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/narayananitgithub/BrickSpace.git
   cd BrickSpace
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── property.dart
│   └── user.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── property_provider.dart
│   └── favorites_provider.dart
├── screens/                  # UI screens
│   ├── splash_screen.dart
│   ├── auth/
│   ├── home/
│   ├── properties/
│   ├── map/
│   ├── favorites/
│   └── profile/
├── widgets/                  # Reusable components
│   ├── custom_text_field.dart
│   ├── custom_button.dart
│   ├── property_card.dart
│   └── ...
├── services/                 # API services
│   ├── auth_service.dart
│   └── property_service.dart
├── routes/                   # Navigation
│   └── app_router.dart
└── utils/                    # Utilities
    └── app_theme.dart
```

## Dependencies

### Core Dependencies
- **provider**: State management
- **go_router**: Navigation and routing
- **google_fonts**: Typography
- **cached_network_image**: Image caching
- **shared_preferences**: Local storage

### UI Dependencies
- **google_maps_flutter**: Map integration
- **flutter_svg**: SVG support
- **lottie**: Animations

## Configuration

### Google Maps Setup (Optional)
To enable map functionality:

1. Get a Google Maps API key from the [Google Cloud Console](https://console.cloud.google.com/)
2. Add the API key to your platform-specific configuration:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE"/>
```

**iOS** (`ios/Runner/AppDelegate.swift`):
```swift
GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
```

## Features Implementation

### Authentication
- Mock authentication system
- User registration and login
- Password reset functionality
- Social login placeholders (Google, Apple)

### Property Management
- Property listing with filters
- Detailed property views
- Image carousels
- Amenities display
- Agent information

### Search & Filters
- Text-based search
- Advanced filtering options
- Price range selection
- Property type filtering
- Amenities filtering

### User Experience
- Favorites system
- Profile management
- Settings and preferences
- Responsive design

## Customization

### Theming
The app uses a custom theme system defined in `lib/utils/app_theme.dart`. You can customize:
- Colors
- Typography
- Component styles
- Dark/Light theme variants

### Adding New Features
1. Create new models in `lib/models/`
2. Add providers for state management in `lib/providers/`
3. Create screens in `lib/screens/`
4. Add routes in `lib/routes/app_router.dart`

## Testing

### Running Tests
```bash
flutter test
```

### Test Coverage
```bash
flutter test --coverage
```

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Contact the development team

## Roadmap

### Planned Features
- [ ] Real API integration
- [ ] Push notifications
- [ ] Property comparison
- [ ] Virtual tours
- [ ] Chat with agents
- [ ] Property alerts
- [ ] Advanced map features
- [ ] Offline support

### Performance Improvements
- [ ] Image optimization
- [ ] Lazy loading
- [ ] Caching improvements
- [ ] Bundle size optimization

---

**Note**: This is a demo application with mock data. For production use, integrate with real APIs and implement proper authentication and data persistence.
