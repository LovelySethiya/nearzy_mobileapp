import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/category_section_widget.dart';
import './widgets/empty_search_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/search_filter_bar_widget.dart';

class ProductCategoriesScreen extends StatefulWidget {
  const ProductCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<ProductCategoriesScreen> createState() =>
      _ProductCategoriesScreenState();
}

class _ProductCategoriesScreenState extends State<ProductCategoriesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController();

  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {};
  int _cartItemCount = 0;

  // Mock data for product categories
  final Map<String, List<Map<String, dynamic>>> _productCategories = {
    'Fruits & Vegetables': [
      {
        'id': 1,
        'name': 'Fresh Bananas',
        'price': '\$2.99',
        'originalPrice': '\$3.49',
        'unit': '1 kg',
        'image':
            'https://images.pexels.com/photos/2872755/pexels-photo-2872755.jpeg',
        'isAvailable': true,
        'brand': 'Fresh Farm',
        'quantity': 0,
      },
      {
        'id': 2,
        'name': 'Organic Apples',
        'price': '\$4.99',
        'unit': '1 kg',
        'image':
            'https://images.pexels.com/photos/102104/pexels-photo-102104.jpeg',
        'isAvailable': true,
        'brand': 'Organic Valley',
        'quantity': 0,
      },
      {
        'id': 3,
        'name': 'Fresh Carrots',
        'price': '\$1.99',
        'unit': '500g',
        'image':
            'https://images.pexels.com/photos/143133/pexels-photo-143133.jpeg',
        'isAvailable': false,
        'brand': 'Green Choice',
        'quantity': 0,
      },
      {
        'id': 4,
        'name': 'Red Tomatoes',
        'price': '\$3.49',
        'unit': '1 kg',
        'image':
            'https://images.pexels.com/photos/533280/pexels-photo-533280.jpeg',
        'isAvailable': true,
        'brand': 'Fresh Farm',
        'quantity': 0,
      },
      {
        'id': 5,
        'name': 'Green Spinach',
        'price': '\$2.49',
        'unit': '250g',
        'image':
            'https://images.pexels.com/photos/2255935/pexels-photo-2255935.jpeg',
        'isAvailable': true,
        'brand': 'Organic Valley',
        'quantity': 0,
      },
      {
        'id': 6,
        'name': 'Fresh Broccoli',
        'price': '\$3.99',
        'unit': '500g',
        'image':
            'https://images.pexels.com/photos/47347/broccoli-vegetable-food-healthy-47347.jpeg',
        'isAvailable': true,
        'brand': 'Green Choice',
        'quantity': 0,
      },
      {
        'id': 7,
        'name': 'Sweet Potatoes',
        'price': '\$2.79',
        'unit': '1 kg',
        'image':
            'https://images.pexels.com/photos/89247/pexels-photo-89247.jpeg',
        'isAvailable': true,
        'brand': 'Nature\'s Best',
        'quantity': 0,
      },
      {
        'id': 8,
        'name': 'Fresh Lemons',
        'price': '\$1.99',
        'unit': '500g',
        'image':
            'https://images.pexels.com/photos/1414110/pexels-photo-1414110.jpeg',
        'isAvailable': true,
        'brand': 'Fresh Farm',
        'quantity': 0,
      },
    ],
    'Dairy & Bakery': [
      {
        'id': 9,
        'name': 'Fresh Milk',
        'price': '\$3.99',
        'unit': '1L',
        'image':
            'https://images.pexels.com/photos/248412/pexels-photo-248412.jpeg',
        'isAvailable': true,
        'brand': 'Pure Harvest',
        'quantity': 0,
      },
      {
        'id': 10,
        'name': 'Whole Wheat Bread',
        'price': '\$2.49',
        'unit': '500g',
        'image':
            'https://images.pexels.com/photos/209206/pexels-photo-209206.jpeg',
        'isAvailable': true,
        'brand': 'Local Market',
        'quantity': 0,
      },
      {
        'id': 11,
        'name': 'Greek Yogurt',
        'price': '\$4.99',
        'unit': '500g',
        'image':
            'https://images.pexels.com/photos/1435735/pexels-photo-1435735.jpeg',
        'isAvailable': true,
        'brand': 'Pure Harvest',
        'quantity': 0,
      },
      {
        'id': 12,
        'name': 'Cheddar Cheese',
        'price': '\$5.99',
        'unit': '200g',
        'image':
            'https://images.pexels.com/photos/773253/pexels-photo-773253.jpeg',
        'isAvailable': false,
        'brand': 'Local Market',
        'quantity': 0,
      },
      {
        'id': 13,
        'name': 'Fresh Eggs',
        'price': '\$3.49',
        'unit': '12 pcs',
        'image':
            'https://images.pexels.com/photos/162712/egg-white-food-protein-162712.jpeg',
        'isAvailable': true,
        'brand': 'Fresh Farm',
        'quantity': 0,
      },
      {
        'id': 14,
        'name': 'Butter',
        'price': '\$4.49',
        'unit': '250g',
        'image':
            'https://images.pexels.com/photos/209540/pexels-photo-209540.jpeg',
        'isAvailable': true,
        'brand': 'Pure Harvest',
        'quantity': 0,
      },
      {
        'id': 15,
        'name': 'Croissants',
        'price': '\$3.99',
        'unit': '4 pcs',
        'image':
            'https://images.pexels.com/photos/2135/food-france-morning-breakfast.jpg',
        'isAvailable': true,
        'brand': 'Local Market',
        'quantity': 0,
      },
      {
        'id': 16,
        'name': 'Cream Cheese',
        'price': '\$2.99',
        'unit': '200g',
        'image':
            'https://images.pexels.com/photos/1435735/pexels-photo-1435735.jpeg',
        'isAvailable': true,
        'brand': 'Pure Harvest',
        'quantity': 0,
      },
    ],
    'Snacks': [
      {
        'id': 17,
        'name': 'Mixed Nuts',
        'price': '\$6.99',
        'unit': '250g',
        'image':
            'https://images.pexels.com/photos/1295572/pexels-photo-1295572.jpeg',
        'isAvailable': true,
        'brand': 'Nature\'s Best',
        'quantity': 0,
      },
      {
        'id': 18,
        'name': 'Potato Chips',
        'price': '\$2.99',
        'unit': '150g',
        'image':
            'https://images.pexels.com/photos/209540/pexels-photo-209540.jpeg',
        'isAvailable': true,
        'brand': 'Local Market',
        'quantity': 0,
      },
      {
        'id': 19,
        'name': 'Chocolate Bar',
        'price': '\$1.99',
        'unit': '100g',
        'image':
            'https://images.pexels.com/photos/65882/chocolate-dark-coffee-confiserie-65882.jpeg',
        'isAvailable': true,
        'brand': 'Green Choice',
        'quantity': 0,
      },
      {
        'id': 20,
        'name': 'Granola Bars',
        'price': '\$4.49',
        'unit': '6 pcs',
        'image':
            'https://images.pexels.com/photos/1092730/pexels-photo-1092730.jpeg',
        'isAvailable': false,
        'brand': 'Nature\'s Best',
        'quantity': 0,
      },
      {
        'id': 21,
        'name': 'Pretzels',
        'price': '\$3.49',
        'unit': '200g',
        'image':
            'https://images.pexels.com/photos/209540/pexels-photo-209540.jpeg',
        'isAvailable': true,
        'brand': 'Local Market',
        'quantity': 0,
      },
      {
        'id': 22,
        'name': 'Trail Mix',
        'price': '\$5.99',
        'unit': '300g',
        'image':
            'https://images.pexels.com/photos/1295572/pexels-photo-1295572.jpeg',
        'isAvailable': true,
        'brand': 'Nature\'s Best',
        'quantity': 0,
      },
      {
        'id': 23,
        'name': 'Cookies',
        'price': '\$3.99',
        'unit': '250g',
        'image':
            'https://images.pexels.com/photos/230325/pexels-photo-230325.jpeg',
        'isAvailable': true,
        'brand': 'Local Market',
        'quantity': 0,
      },
      {
        'id': 24,
        'name': 'Popcorn',
        'price': '\$2.49',
        'unit': '100g',
        'image':
            'https://images.pexels.com/photos/33129/popcorn-movie-party-entertainment.jpg',
        'isAvailable': true,
        'brand': 'Green Choice',
        'quantity': 0,
      },
    ],
    'Beverages': [
      {
        'id': 25,
        'name': 'Orange Juice',
        'price': '\$3.99',
        'unit': '1L',
        'image':
            'https://images.pexels.com/photos/96974/pexels-photo-96974.jpeg',
        'isAvailable': true,
        'brand': 'Fresh Farm',
        'quantity': 0,
      },
      {
        'id': 26,
        'name': 'Green Tea',
        'price': '\$4.49',
        'unit': '20 bags',
        'image':
            'https://images.pexels.com/photos/1638280/pexels-photo-1638280.jpeg',
        'isAvailable': true,
        'brand': 'Nature\'s Best',
        'quantity': 0,
      },
      {
        'id': 27,
        'name': 'Sparkling Water',
        'price': '\$2.99',
        'unit': '500ml',
        'image':
            'https://images.pexels.com/photos/416528/pexels-photo-416528.jpeg',
        'isAvailable': false,
        'brand': 'Pure Harvest',
        'quantity': 0,
      },
      {
        'id': 28,
        'name': 'Coffee Beans',
        'price': '\$8.99',
        'unit': '500g',
        'image':
            'https://images.pexels.com/photos/894695/pexels-photo-894695.jpeg',
        'isAvailable': true,
        'brand': 'Local Market',
        'quantity': 0,
      },
      {
        'id': 29,
        'name': 'Energy Drink',
        'price': '\$2.49',
        'unit': '250ml',
        'image':
            'https://images.pexels.com/photos/416528/pexels-photo-416528.jpeg',
        'isAvailable': true,
        'brand': 'Green Choice',
        'quantity': 0,
      },
      {
        'id': 30,
        'name': 'Coconut Water',
        'price': '\$3.49',
        'unit': '330ml',
        'image':
            'https://images.pexels.com/photos/1435735/pexels-photo-1435735.jpeg',
        'isAvailable': true,
        'brand': 'Nature\'s Best',
        'quantity': 0,
      },
      {
        'id': 31,
        'name': 'Herbal Tea',
        'price': '\$5.99',
        'unit': '25 bags',
        'image':
            'https://images.pexels.com/photos/1638280/pexels-photo-1638280.jpeg',
        'isAvailable': true,
        'brand': 'Pure Harvest',
        'quantity': 0,
      },
      {
        'id': 32,
        'name': 'Soda',
        'price': '\$1.99',
        'unit': '330ml',
        'image':
            'https://images.pexels.com/photos/50593/coca-cola-cold-drink-soft-drink-coke-50593.jpeg',
        'isAvailable': true,
        'brand': 'Local Market',
        'quantity': 0,
      },
    ],
    'Personal Care': [
      {
        'id': 33,
        'name': 'Shampoo',
        'price': '\$7.99',
        'unit': '400ml',
        'image':
            'https://images.pexels.com/photos/4465831/pexels-photo-4465831.jpeg',
        'isAvailable': true,
        'brand': 'Pure Harvest',
        'quantity': 0,
      },
      {
        'id': 34,
        'name': 'Toothpaste',
        'price': '\$3.49',
        'unit': '100ml',
        'image':
            'https://images.pexels.com/photos/298611/pexels-photo-298611.jpeg',
        'isAvailable': true,
        'brand': 'Green Choice',
        'quantity': 0,
      },
      {
        'id': 35,
        'name': 'Body Soap',
        'price': '\$2.99',
        'unit': '125g',
        'image':
            'https://images.pexels.com/photos/4465831/pexels-photo-4465831.jpeg',
        'isAvailable': false,
        'brand': 'Nature\'s Best',
        'quantity': 0,
      },
      {
        'id': 36,
        'name': 'Face Cream',
        'price': '\$12.99',
        'unit': '50ml',
        'image':
            'https://images.pexels.com/photos/4465831/pexels-photo-4465831.jpeg',
        'isAvailable': true,
        'brand': 'Pure Harvest',
        'quantity': 0,
      },
      {
        'id': 37,
        'name': 'Deodorant',
        'price': '\$4.99',
        'unit': '150ml',
        'image':
            'https://images.pexels.com/photos/4465831/pexels-photo-4465831.jpeg',
        'isAvailable': true,
        'brand': 'Green Choice',
        'quantity': 0,
      },
      {
        'id': 38,
        'name': 'Hand Sanitizer',
        'price': '\$3.99',
        'unit': '250ml',
        'image':
            'https://images.pexels.com/photos/4465831/pexels-photo-4465831.jpeg',
        'isAvailable': true,
        'brand': 'Nature\'s Best',
        'quantity': 0,
      },
      {
        'id': 39,
        'name': 'Conditioner',
        'price': '\$8.49',
        'unit': '400ml',
        'image':
            'https://images.pexels.com/photos/4465831/pexels-photo-4465831.jpeg',
        'isAvailable': true,
        'brand': 'Pure Harvest',
        'quantity': 0,
      },
      {
        'id': 40,
        'name': 'Sunscreen',
        'price': '\$9.99',
        'unit': '100ml',
        'image':
            'https://images.pexels.com/photos/4465831/pexels-photo-4465831.jpeg',
        'isAvailable': true,
        'brand': 'Green Choice',
        'quantity': 0,
      },
    ],
    'Household Essentials': [
      {
        'id': 41,
        'name': 'Dish Soap',
        'price': '\$3.99',
        'unit': '500ml',
        'image':
            'https://images.pexels.com/photos/4465831/pexels-photo-4465831.jpeg',
        'isAvailable': true,
        'brand': 'Green Choice',
        'quantity': 0,
      },
      {
        'id': 42,
        'name': 'Laundry Detergent',
        'price': '\$8.99',
        'unit': '1L',
        'image':
            'https://images.pexels.com/photos/4465831/pexels-photo-4465831.jpeg',
        'isAvailable': true,
        'brand': 'Pure Harvest',
        'quantity': 0,
      },
      {
        'id': 43,
        'name': 'Toilet Paper',
        'price': '\$6.99',
        'unit': '8 rolls',
        'image':
            'https://images.pexels.com/photos/4465831/pexels-photo-4465831.jpeg',
        'isAvailable': false,
        'brand': 'Local Market',
        'quantity': 0,
      },
      {
        'id': 44,
        'name': 'Paper Towels',
        'price': '\$4.49',
        'unit': '4 rolls',
        'image':
            'https://images.pexels.com/photos/4465831/pexels-photo-4465831.jpeg',
        'isAvailable': true,
        'brand': 'Nature\'s Best',
        'quantity': 0,
      },
      {
        'id': 45,
        'name': 'All-Purpose Cleaner',
        'price': '\$5.99',
        'unit': '750ml',
        'image':
            'https://images.pexels.com/photos/4465831/pexels-photo-4465831.jpeg',
        'isAvailable': true,
        'brand': 'Green Choice',
        'quantity': 0,
      },
      {
        'id': 46,
        'name': 'Trash Bags',
        'price': '\$7.49',
        'unit': '30 pcs',
        'image':
            'https://images.pexels.com/photos/4465831/pexels-photo-4465831.jpeg',
        'isAvailable': true,
        'brand': 'Local Market',
        'quantity': 0,
      },
      {
        'id': 47,
        'name': 'Sponges',
        'price': '\$2.99',
        'unit': '6 pcs',
        'image':
            'https://images.pexels.com/photos/4465831/pexels-photo-4465831.jpeg',
        'isAvailable': true,
        'brand': 'Nature\'s Best',
        'quantity': 0,
      },
      {
        'id': 48,
        'name': 'Glass Cleaner',
        'price': '\$4.99',
        'unit': '500ml',
        'image':
            'https://images.pexels.com/photos/4465831/pexels-photo-4465831.jpeg',
        'isAvailable': true,
        'brand': 'Pure Harvest',
        'quantity': 0,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.index = 1; // Set Categories tab as active
    _calculateCartItemCount();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _calculateCartItemCount() {
    int count = 0;
    _productCategories.values.forEach((products) {
      products.forEach((product) {
        count += (product['quantity'] as int?) ?? 0;
      });
    });
    setState(() {
      _cartItemCount = count;
    });
  }

  void _onQuantityChanged(Map<String, dynamic> product, int quantity) {
    setState(() {
      product['quantity'] = quantity;
    });
    _calculateCartItemCount();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        currentFilters: _activeFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _activeFilters = filters;
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    // Simulate refresh delay
    await Future.delayed(Duration(seconds: 1));

    // Update product availability and pricing
    setState(() {
      _productCategories.values.forEach((products) {
        products.forEach((product) {
          // Randomly update availability
          if (product['id'] % 7 == 0) {
            product['isAvailable'] = !product['isAvailable'];
          }
        });
      });
    });

    _refreshController.refreshCompleted();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Products updated!')),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  void _onCategoryTap(String categoryName) {
    _searchController.text = categoryName.toLowerCase();
    _onSearchChanged(categoryName.toLowerCase());
  }

  Map<String, List<Map<String, dynamic>>> _getFilteredCategories() {
    Map<String, List<Map<String, dynamic>>> filteredCategories = {};

    _productCategories.forEach((categoryName, products) {
      List<Map<String, dynamic>> filteredProducts = products.where((product) {
        // Search filter
        bool matchesSearch = _searchQuery.isEmpty ||
            (product['name'] as String).toLowerCase().contains(_searchQuery) ||
            categoryName.toLowerCase().contains(_searchQuery);

        // Price filter
        bool matchesPrice = true;
        if (_activeFilters['minPrice'] != null &&
            _activeFilters['maxPrice'] != null) {
          double price = double.tryParse(
                  (product['price'] as String).replaceAll('\$', '')) ??
              0;
          matchesPrice = price >= _activeFilters['minPrice'] &&
              price <= _activeFilters['maxPrice'];
        }

        // Brand filter
        bool matchesBrand = true;
        if (_activeFilters['brands'] != null &&
            (_activeFilters['brands'] as List).isNotEmpty) {
          matchesBrand =
              (_activeFilters['brands'] as List).contains(product['brand']);
        }

        // Availability filter
        bool matchesAvailability = true;
        if (_activeFilters['showOnlyAvailable'] == true) {
          matchesAvailability = product['isAvailable'] == true;
        }

        return matchesSearch &&
            matchesPrice &&
            matchesBrand &&
            matchesAvailability;
      }).toList();

      if (filteredProducts.isNotEmpty) {
        filteredCategories[categoryName] = filteredProducts;
      }
    });

    return filteredCategories;
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = _getFilteredCategories();
    final bool hasResults = filteredCategories.isNotEmpty;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Search and Filter Bar
          SearchFilterBarWidget(
            searchController: _searchController,
            onSearchChanged: _onSearchChanged,
            onFilterTap: _showFilterModal,
          ),

          // Main Content
          Expanded(
            child: hasResults
                ? RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: filteredCategories.length,
                      itemBuilder: (context, index) {
                        final categoryName =
                            filteredCategories.keys.elementAt(index);
                        final products = filteredCategories[categoryName]!;

                        return CategorySectionWidget(
                          categoryName: categoryName,
                          products: products,
                          onQuantityChanged: _onQuantityChanged,
                        );
                      },
                    ),
                  )
                : EmptySearchWidget(
                    searchQuery: _searchQuery,
                    onClearSearch: _clearSearch,
                    onCategoryTap: _onCategoryTap,
                  ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 1, // Categories tab active
          selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedItemColor:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'home',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'home',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'category',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'category',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  CustomIconWidget(
                    iconName: 'shopping_cart',
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                    size: 24,
                  ),
                  if (_cartItemCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$_cartItemCount',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'favorite_border',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'favorite',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/customer-home-screen');
                break;
              case 1:
                // Already on categories screen
                break;
              case 2:
                Navigator.pushNamed(context, '/shopping-cart-screen');
                break;
              case 3:
                // Navigate to wishlist screen
                break;
              case 4:
                // Navigate to profile screen
                break;
            }
          },
        ),
      ),

      // Floating Action Button for Cart
      floatingActionButton: _cartItemCount > 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/shopping-cart-screen');
              },
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              child: Stack(
                children: [
                  CustomIconWidget(
                    iconName: 'shopping_cart',
                    color: Colors.white,
                    size: 24,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$_cartItemCount',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

class RefreshController {
  void refreshCompleted() {
    // Implementation for refresh completion
  }

  void dispose() {
    // Cleanup resources
  }
}
