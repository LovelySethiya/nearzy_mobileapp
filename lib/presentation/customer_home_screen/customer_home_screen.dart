import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_download_banner_widget.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/hero_section_widget.dart';
import './widgets/nearby_stores_widget.dart';
import './widgets/product_categories_widget.dart';
import './widgets/search_bar_widget.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _currentBottomNavIndex = 0;
  bool _isRefreshing = false;

  // Mock data for nearby stores
  final List<Map<String, dynamic>> _nearbyStores = [
    {
      "id": 1,
      "name": "Fresh Mart Grocery",
      "image":
          "https://images.pexels.com/photos/264636/pexels-photo-264636.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "rating": 4.5,
      "deliveryTime": "15-20 min",
      "distance": "0.8 km",
      "isOpen": true,
    },
    {
      "id": 2,
      "name": "Green Valley Store",
      "image":
          "https://images.pexels.com/photos/1005638/pexels-photo-1005638.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "rating": 4.2,
      "deliveryTime": "20-25 min",
      "distance": "1.2 km",
      "isOpen": true,
    },
    {
      "id": 3,
      "name": "Quick Stop Market",
      "image":
          "https://images.pexels.com/photos/2292837/pexels-photo-2292837.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "rating": 4.0,
      "deliveryTime": "25-30 min",
      "distance": "1.5 km",
      "isOpen": false,
    },
    {
      "id": 4,
      "name": "Organic Basket",
      "image":
          "https://images.pexels.com/photos/1435904/pexels-photo-1435904.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "rating": 4.7,
      "deliveryTime": "10-15 min",
      "distance": "0.5 km",
      "isOpen": true,
    },
  ];

  // Mock data for product categories
  final List<Map<String, dynamic>> _productCategories = [
    {
      "id": 1,
      "name": "Fruits & Vegetables",
      "image":
          "https://images.pexels.com/photos/1300972/pexels-photo-1300972.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "icon": "eco",
    },
    {
      "id": 2,
      "name": "Snacks",
      "image":
          "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "icon": "fastfood",
    },
    {
      "id": 3,
      "name": "Dairy & Bakery",
      "image":
          "https://images.pexels.com/photos/236010/pexels-photo-236010.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "icon": "bakery_dining",
    },
    {
      "id": 4,
      "name": "Beverages",
      "image":
          "https://images.pexels.com/photos/544961/pexels-photo-544961.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "icon": "local_drink",
    },
    {
      "id": 5,
      "name": "Personal Care",
      "image":
          "https://images.pexels.com/photos/3018845/pexels-photo-3018845.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "icon": "face",
    },
    {
      "id": 6,
      "name": "Household Essentials",
      "image":
          "https://images.pexels.com/photos/4239091/pexels-photo-4239091.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "icon": "home",
    },
  ];

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _handleSearchTap() {
    // Navigate to search screen or show search functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Search functionality coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleLocationTap() {
    // Show location picker or current location details
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Select Location',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'my_location',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Use Current Location'),
              subtitle: Text('Downtown, City Center'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              title: Text('Select on Map'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _handleStoreTap(Map<String, dynamic> store) {
    // Navigate to store detail screen with shared element transition
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${store['name']}...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleStoreLongPress(Map<String, dynamic> store) {
    // Show quick actions bottom sheet
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              store['name'] as String,
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'menu_book',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('View Menu'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              title: Text('Call Store'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'directions',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              title: Text('Get Directions'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCategoryTap(Map<String, dynamic> category) {
    // Navigate to product categories screen
    Navigator.pushNamed(context, '/product-categories-screen');
  }

  void _handleBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    // Navigate based on selected tab
    switch (index) {
      case 0:
        // Already on home screen
        break;
      case 1:
        Navigator.pushNamed(context, '/product-categories-screen');
        break;
      case 2:
        Navigator.pushNamed(context, '/shopping-cart-screen');
        break;
      case 3:
        // Navigate to orders screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Orders screen coming soon!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      case 4:
        // Navigate to profile screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile screen coming soon!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
    }
  }

  void _handleAppDownload() {
    // Handle app download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Redirecting to app store...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.primaryColor,
          child: CustomScrollView(
            slivers: [
              // Search Bar
              SliverToBoxAdapter(
                child: SearchBarWidget(
                  currentLocation: 'Downtown',
                  onSearchTap: _handleSearchTap,
                  onLocationTap: _handleLocationTap,
                ),
              ),

              // Hero Section
              SliverToBoxAdapter(
                child: HeroSectionWidget(
                  heroTitle: 'Fresh Groceries\nDelivered in 15 Minutes',
                  heroSubtitle:
                      'Shop from local stores and get hyperlocal delivery at your doorstep',
                  backgroundImageUrl:
                      'https://images.pexels.com/photos/1435904/pexels-photo-1435904.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                ),
              ),

              // Nearby Stores
              SliverToBoxAdapter(
                child: NearbyStoresWidget(
                  stores: _nearbyStores,
                  onStoreTap: _handleStoreTap,
                  onStoreLongPress: _handleStoreLongPress,
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 3.h)),

              // Product Categories
              SliverToBoxAdapter(
                child: ProductCategoriesWidget(
                  categories: _productCategories,
                  onCategoryTap: _handleCategoryTap,
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 3.h)),

              // App Download Banner
              SliverToBoxAdapter(
                child: AppDownloadBannerWidget(
                  onDownloadTap: _handleAppDownload,
                ),
              ),

              // Bottom padding for navigation
              SliverToBoxAdapter(child: SizedBox(height: 2.h)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _currentBottomNavIndex,
        onTap: _handleBottomNavTap,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleSearchTap,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        child: CustomIconWidget(
          iconName: 'search',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
