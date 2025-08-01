import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/cart_item_card.dart';
import './widgets/checkout_button.dart';
import './widgets/empty_cart_widget.dart';
import './widgets/order_summary_card.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> _cartItems = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  late AnimationController _refreshController;
  late Animation<double> _refreshAnimation;
  int _currentTabIndex = 2; // Cart tab is active

  // Mock product data for availability checking
  final List<Map<String, dynamic>> _mockProducts = [
    {
      "id": 1,
      "name": "Fresh Bananas",
      "category": "Fruits & Vegetables",
      "price": 2.99,
      "image":
          "https://images.pexels.com/photos/2872755/pexels-photo-2872755.jpeg",
      "stock": 25,
      "description": "Fresh organic bananas, perfect for smoothies and snacks",
    },
    {
      "id": 2,
      "name": "Whole Milk",
      "category": "Dairy & Bakery",
      "price": 3.49,
      "image":
          "https://images.pexels.com/photos/236010/pexels-photo-236010.jpeg",
      "stock": 3,
      "description": "Fresh whole milk, rich in calcium and protein",
    },
    {
      "id": 3,
      "name": "Chocolate Cookies",
      "category": "Snacks",
      "price": 4.99,
      "image":
          "https://images.pexels.com/photos/230325/pexels-photo-230325.jpeg",
      "stock": 15,
      "description": "Delicious chocolate chip cookies, perfect for any time",
    },
    {
      "id": 4,
      "name": "Orange Juice",
      "category": "Beverages",
      "price": 5.99,
      "image": "https://images.pexels.com/photos/96974/pexels-photo-96974.jpeg",
      "stock": 8,
      "description": "Fresh squeezed orange juice, 100% natural",
    },
    {
      "id": 5,
      "name": "Hand Soap",
      "category": "Personal Care",
      "price": 2.49,
      "image":
          "https://images.pexels.com/photos/4465831/pexels-photo-4465831.jpeg",
      "stock": 12,
      "description": "Antibacterial hand soap with moisturizing formula",
    },
    {
      "id": 6,
      "name": "Laundry Detergent",
      "category": "Household Essentials",
      "price": 8.99,
      "image":
          "https://images.pexels.com/photos/5591663/pexels-photo-5591663.jpeg",
      "stock": 6,
      "description": "Powerful laundry detergent for all fabric types",
    },
    {
      "id": 7,
      "name": "Greek Yogurt",
      "category": "Dairy & Bakery",
      "price": 4.49,
      "image":
          "https://images.pexels.com/photos/1435735/pexels-photo-1435735.jpeg",
      "stock": 20,
      "description": "Creamy Greek yogurt, high in protein",
    },
    {
      "id": 8,
      "name": "Potato Chips",
      "category": "Snacks",
      "price": 3.99,
      "image":
          "https://images.pexels.com/photos/1583884/pexels-photo-1583884.jpeg",
      "stock": 2,
      "description": "Crispy potato chips with sea salt",
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _refreshAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _refreshController, curve: Curves.easeInOut));
    _loadCartItems();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _loadCartItems() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString('cart_items');

      if (cartData != null) {
        final List<dynamic> decodedData = json.decode(cartData);
        setState(() {
          _cartItems = decodedData
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList();
        });
        await _checkItemAvailability();
      } else {
        // Load sample cart items for demo
        _loadSampleCartItems();
      }
    } catch (e) {
      _loadSampleCartItems();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _loadSampleCartItems() {
    setState(() {
      _cartItems = [
        {
          ..._mockProducts[0],
          "quantity": 2,
        },
        {
          ..._mockProducts[1],
          "quantity": 1,
        },
        {
          ..._mockProducts[2],
          "quantity": 3,
        },
      ];
    });
  }

  Future<void> _saveCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = json.encode(_cartItems);
      await prefs.setString('cart_items', cartData);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _checkItemAvailability() async {
    bool hasChanges = false;

    for (int i = 0; i < _cartItems.length; i++) {
      final cartItem = _cartItems[i];
      final product = _mockProducts.firstWhere((p) => p["id"] == cartItem["id"],
          orElse: () => {});

      if (product.isNotEmpty) {
        // Update stock information
        _cartItems[i]["stock"] = product["stock"];

        // Check if quantity exceeds stock
        if ((cartItem["quantity"] as int) > (product["stock"] as int)) {
          _cartItems[i]["quantity"] = product["stock"];
          hasChanges = true;

          // Show warning
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  '${product["name"]} quantity adjusted due to limited stock',
                  style: AppTheme.lightTheme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white)),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              action: SnackBarAction(
                  label: 'OK', textColor: Colors.white, onPressed: () {})));
        }
      }
    }

    if (hasChanges) {
      await _saveCartItems();
    }
  }

  Future<void> _refreshCart() async {
    setState(() {
      _isRefreshing = true;
    });

    _refreshController.forward();

    await _checkItemAvailability();

    await Future.delayed(Duration(milliseconds: 500));

    _refreshController.reverse();

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Cart updated with latest prices and availability',
            style: AppTheme.lightTheme.textTheme.bodyMedium
                ?.copyWith(color: Colors.white)),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        duration: Duration(seconds: 2)));
  }

  void _removeItem(int index) {
    final removedItem = _cartItems[index];

    setState(() {
      _cartItems.removeAt(index);
    });

    _saveCartItems();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${removedItem["name"]} removed from cart',
            style: AppTheme.lightTheme.textTheme.bodyMedium
                ?.copyWith(color: Colors.white)),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _cartItems.insert(index, removedItem);
              });
              _saveCartItems();
            }),
        duration: Duration(seconds: 4)));
  }

  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      _cartItems[index]["quantity"] = newQuantity;
    });
    _saveCartItems();
  }

  void _saveForLater(int index) {
    final item = _cartItems[index];
    // In a real app, this would save to a "saved for later" list
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${item["name"]} saved for later',
            style: AppTheme.lightTheme.textTheme.bodyMedium
                ?.copyWith(color: Colors.white)),
        backgroundColor: AppTheme.lightTheme.primaryColor));
  }

  void _moveToWishlist(int index) {
    final item = _cartItems[index];
    // In a real app, this would move to wishlist
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${item["name"]} moved to wishlist',
            style: AppTheme.lightTheme.textTheme.bodyMedium
                ?.copyWith(color: Colors.white)),
        backgroundColor: AppTheme.lightTheme.primaryColor));
  }

  void _proceedToCheckout() {
    HapticFeedback.mediumImpact();

    // In a real app, this would navigate to checkout screen
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Row(children: [
                CustomIconWidget(
                    iconName: 'payment',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 24),
                SizedBox(width: 2.w),
                Text('Checkout',
                    style: AppTheme.lightTheme.textTheme.titleLarge),
              ]),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Proceeding to checkout with ${_cartItems.length} items.',
                        style: AppTheme.lightTheme.textTheme.bodyLarge),
                    SizedBox(height: 2.h),
                    Text('Total: \$${_calculateTotal().toStringAsFixed(2)}',
                        style: AppTheme.lightTheme.textTheme.titleMedium
                            ?.copyWith(
                                color: AppTheme.lightTheme.primaryColor,
                                fontWeight: FontWeight.w600)),
                  ]),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigate to checkout screen
                    },
                    child: Text('Continue')),
              ]);
        });
  }

  void _startShopping() {
    Navigator.pushNamed(context, '/product-categories-screen');
  }

  double _calculateSubtotal() {
    return _cartItems.fold(0.0, (sum, item) {
      return sum + ((item["price"] as double) * (item["quantity"] as int));
    });
  }

  double _calculateDeliveryFee() {
    final subtotal = _calculateSubtotal();
    return subtotal >= 25.0 ? 0.0 : 2.99;
  }

  double _calculateTax() {
    final subtotal = _calculateSubtotal();
    return subtotal * 0.08; // 8% tax
  }

  double _calculateTotal() {
    return _calculateSubtotal() + _calculateDeliveryFee() + _calculateTax();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentTabIndex = index;
    });

    // Navigate based on tab
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/customer-home-screen');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/product-categories-screen');
        break;
      case 2:
        // Already on cart screen
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/login-screen');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
            title: Row(children: [
              CustomIconWidget(
                  iconName: 'shopping_cart',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24),
              SizedBox(width: 2.w),
              Text('Cart',
                  style: AppTheme.lightTheme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              if (_cartItems.isNotEmpty) ...[
                SizedBox(width: 2.w),
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(_cartItems.length.toString(),
                        style: AppTheme.lightTheme.textTheme.labelSmall
                            ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600))),
              ],
            ]),
            actions: [
              if (_cartItems.isNotEmpty)
                IconButton(
                    onPressed: _isRefreshing ? null : _refreshCart,
                    icon: AnimatedBuilder(
                        animation: _refreshAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                              angle: _refreshAnimation.value * 2 * 3.14159,
                              child: CustomIconWidget(
                                  iconName: 'refresh',
                                  color: _isRefreshing
                                      ? AppTheme.lightTheme.primaryColor
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                  size: 24));
                        })),
            ],
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            elevation: 2),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: AppTheme.lightTheme.primaryColor))
            : _cartItems.isEmpty
                ? EmptyCartWidget(onStartShopping: _startShopping)
                : Column(children: [
                    // Estimated Total Header
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                            color: AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.1),
                            border: Border(
                                bottom: BorderSide(
                                    color: AppTheme.lightTheme.dividerColor,
                                    width: 1))),
                        child: Row(children: [
                          CustomIconWidget(
                              iconName: 'local_shipping',
                              color: AppTheme.lightTheme.primaryColor,
                              size: 20),
                          SizedBox(width: 2.w),
                          Text('Estimated Total: ',
                              style: AppTheme.lightTheme.textTheme.titleMedium),
                          Text('\$${_calculateTotal().toStringAsFixed(2)}',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                      color: AppTheme.lightTheme.primaryColor,
                                      fontWeight: FontWeight.w700)),
                          Spacer(),
                          if (_calculateDeliveryFee() == 0)
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.tertiary,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Text('FREE DELIVERY',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600))),
                        ])),

                    // Cart Items List
                    Expanded(
                        child: RefreshIndicator(
                            onRefresh: _refreshCart,
                            color: AppTheme.lightTheme.primaryColor,
                            child: ListView.builder(
                                padding: EdgeInsets.only(bottom: 2.h),
                                itemCount: _cartItems.length +
                                    1, // +1 for order summary
                                itemBuilder: (context, index) {
                                  if (index == _cartItems.length) {
                                    // Order Summary Card
                                    return OrderSummaryCard(
                                        subtotal: _calculateSubtotal(),
                                        deliveryFee: _calculateDeliveryFee(),
                                        tax: _calculateTax(),
                                        total: _calculateTotal(),
                                        itemCount: _cartItems.length);
                                  }

                                  final item = _cartItems[index];
                                  return CartItemCard(
                                      item: item,
                                      onRemove: () => _removeItem(index),
                                      onQuantityChanged: (newQuantity) =>
                                          _updateQuantity(index, newQuantity),
                                      onSaveForLater: () =>
                                          _saveForLater(index),
                                      onMoveToWishlist: () =>
                                          _moveToWishlist(index));
                                }))),
                  ]),
        bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
          // Checkout Button
          CheckoutButton(
              isEnabled: _cartItems.isNotEmpty,
              total: _calculateTotal(),
              itemCount: _cartItems.length,
              onPressed: _proceedToCheckout),

          // Bottom Navigation Bar
          BottomNavigationBar(
              currentIndex: _currentTabIndex,
              onTap: _onTabTapped,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppTheme.lightTheme.primaryColor,
              unselectedItemColor:
                  AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              elevation: 8,
              items: [
                BottomNavigationBarItem(
                    icon: CustomIconWidget(
                        iconName: 'home',
                        color: _currentTabIndex == 0
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 24),
                    label: 'Home'),
                BottomNavigationBarItem(
                    icon: CustomIconWidget(
                        iconName: 'category',
                        color: _currentTabIndex == 1
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 24),
                    label: 'Categories'),
                BottomNavigationBarItem(
                    icon: Stack(children: [
                      CustomIconWidget(
                          iconName: 'shopping_cart',
                          color: _currentTabIndex == 2
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 24),
                      if (_cartItems.isNotEmpty)
                        Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightTheme.colorScheme.error,
                                    borderRadius: BorderRadius.circular(8)),
                                constraints:
                                    BoxConstraints(minWidth: 16, minHeight: 16),
                                child: Text(_cartItems.length.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center))),
                    ]),
                    label: 'Cart'),
                BottomNavigationBarItem(
                    icon: CustomIconWidget(
                        iconName: 'person',
                        color: _currentTabIndex == 3
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 24),
                    label: 'Profile'),
              ]),
        ]));
  }
}