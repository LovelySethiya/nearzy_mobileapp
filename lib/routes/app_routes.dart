import 'package:flutter/material.dart';
import '../presentation/customer_home_screen/customer_home_screen.dart';
import '../presentation/product_management_screen/product_management_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/shopping_cart_screen/shopping_cart_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/product_categories_screen/product_categories_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String customerHome = '/customer-home-screen';
  static const String productManagement = '/product-management-screen';
  static const String splash = '/splash-screen';
  static const String shoppingCart = '/shopping-cart-screen';
  static const String login = '/login-screen';
  static const String productCategories = '/product-categories-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    customerHome: (context) => const CustomerHomeScreen(),
    productManagement: (context) => const ProductManagementScreen(),
    splash: (context) => const SplashScreen(),
    shoppingCart: (context) => const ShoppingCartScreen(),
    login: (context) => const LoginScreen(),
    productCategories: (context) => const ProductCategoriesScreen(),
    // TODO: Add your other routes here
  };
}
