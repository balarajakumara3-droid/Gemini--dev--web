import '../../features/home/screens/main_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/cart/screens/simple_cart_screen.dart';
import '../../features/orders/screens/order_history_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/demo/screens/supabase_demo_screen.dart';
import '../../features/demo/screens/excel_demo_screen.dart';
import '../../features/demo/screens/excel_food_display.dart';
import '../../features/demo/screens/excel_data_analyzer.dart';
// import '../../features/demo/screens/csv_food_display.dart'; // Removed CSV support
import '../../features/food/screens/food_detail_screen.dart';
import '../../features/products/screens/products_screen.dart';
import '../../features/debug/screens/debug_products_screen.dart';
import '../../features/debug/screens/add_sample_data_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String restaurantDetail = '/restaurant-detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderTracking = '/order-tracking';
  static const String orderHistory = '/order-history';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String search = '/search';
  static const String supabaseDemo = '/supabase-demo';
  static const String excelDemo = '/excel-demo';
  static const String excelFoodDisplay = '/excel-food-display';
  static const String excelDataAnalyzer = '/excel-data-analyzer';
  static const String csvFoodDisplay = '/csv-food-display';
  static const String foodDetail = '/food-detail';
  static const String products = '/products';
  static const String debugProducts = '/debug-products';
  static const String addSampleData = '/add-sample-data';

  static final routes = {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    main: (context) => const MainScreen(),
    cart: (context) => const SimpleCartScreen(),
    orderHistory: (context) => const OrderHistoryScreen(),
    profile: (context) => const ProfileScreen(),
    editProfile: (context) => const EditProfileScreen(),
    search: (context) => const SearchScreen(),
    supabaseDemo: (context) => const SupabaseDemoScreen(),
    excelDemo: (context) => const ExcelDemoScreen(),
    excelFoodDisplay: (context) => const ExcelFoodDisplay(),
    excelDataAnalyzer: (context) => const ExcelDataAnalyzer(),
    // csvFoodDisplay: (context) => const CsvFoodDisplay(), // Removed CSV support
    products: (context) => const ProductsScreen(),
    debugProducts: (context) => const DebugProductsScreen(),
    addSampleData: (context) => const AddSampleDataScreen(),
  };

  static const List<String> publicRoutes = [
    splash,
    login,
    register,
  ];

  static bool isPublicRoute(String route) {
    return publicRoutes.contains(route);
  }
}