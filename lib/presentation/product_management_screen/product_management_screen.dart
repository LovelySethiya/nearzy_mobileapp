import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/bulk_actions_bar.dart';
import './widgets/empty_state_widget.dart';
import './widgets/product_card_widget.dart';
import './widgets/product_form_modal.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({Key? key}) : super(key: key);

  @override
  State<ProductManagementScreen> createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  Set<int> _selectedProducts = {};
  String _selectedCategoryFilter = 'All';
  bool _isMultiSelectMode = false;
  bool _isLoading = false;

  final List<String> _categories = [
    'All',
    'Fruits & Vegetables',
    'Snacks',
    'Dairy & Bakery',
    'Beverages',
    'Personal Care',
    'Household Essentials',
  ];

  @override
  void initState() {
    super.initState();
    _initializeMockData();
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeMockData() {
    _products = [
      {
        "id": 1,
        "name": "Fresh Bananas",
        "description":
            "Sweet and ripe bananas, perfect for breakfast or snacking. Rich in potassium and natural sugars.",
        "price": "\$2.99",
        "category": "Fruits & Vegetables",
        "stock": 45,
        "image":
            "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400",
        "isAvailable": true,
      },
      {
        "id": 2,
        "name": "Organic Apples",
        "description":
            "Crisp and juicy organic apples. No pesticides used, perfect for healthy snacking.",
        "price": "\$4.50",
        "category": "Fruits & Vegetables",
        "stock": 32,
        "image":
            "https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400",
        "isAvailable": true,
      },
      {
        "id": 3,
        "name": "Whole Wheat Bread",
        "description":
            "Freshly baked whole wheat bread. High in fiber and perfect for sandwiches.",
        "price": "\$3.25",
        "category": "Dairy & Bakery",
        "stock": 18,
        "image":
            "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400",
        "isAvailable": true,
      },
      {
        "id": 4,
        "name": "Greek Yogurt",
        "description":
            "Creamy Greek yogurt packed with protein. Available in various flavors.",
        "price": "\$5.99",
        "category": "Dairy & Bakery",
        "stock": 0,
        "image":
            "https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400",
        "isAvailable": false,
      },
      {
        "id": 5,
        "name": "Potato Chips",
        "description":
            "Crispy and delicious potato chips. Perfect for parties and snacking.",
        "price": "\$2.75",
        "category": "Snacks",
        "stock": 67,
        "image":
            "https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=400",
        "isAvailable": true,
      },
      {
        "id": 6,
        "name": "Orange Juice",
        "description":
            "Fresh squeezed orange juice. No added sugar, 100% natural.",
        "price": "\$4.25",
        "category": "Beverages",
        "stock": 28,
        "image":
            "https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=400",
        "isAvailable": true,
      },
      {
        "id": 7,
        "name": "Hand Sanitizer",
        "description":
            "Antibacterial hand sanitizer with 70% alcohol. Kills 99.9% of germs.",
        "price": "\$3.50",
        "category": "Personal Care",
        "stock": 15,
        "image":
            "https://images.unsplash.com/photo-1584362917165-526a968579e8?w=400",
        "isAvailable": true,
      },
      {
        "id": 8,
        "name": "Laundry Detergent",
        "description":
            "Powerful laundry detergent for all fabric types. Fresh scent and deep cleaning.",
        "price": "\$8.99",
        "category": "Household Essentials",
        "stock": 22,
        "image":
            "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400",
        "isAvailable": true,
      },
    ];
    _filteredProducts = List.from(_products);
  }

  void _filterProducts() {
    setState(() {
      _filteredProducts = _products.where((product) {
        final matchesSearch = _searchController.text.isEmpty ||
            (product['name'] as String)
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            (product['category'] as String)
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());

        final matchesCategory = _selectedCategoryFilter == 'All' ||
            product['category'] == _selectedCategoryFilter;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _showProductForm({Map<String, dynamic>? product}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductFormModal(
        product: product,
        onSave: (productData) {
          setState(() {
            if (product != null) {
              // Edit existing product
              final index =
                  _products.indexWhere((p) => p['id'] == product['id']);
              if (index != -1) {
                _products[index] = productData;
              }
            } else {
              // Add new product
              _products.add(productData);
            }
            _filterProducts();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(product != null
                  ? 'Product updated successfully!'
                  : 'Product added successfully!'),
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              action: SnackBarAction(
                label: 'Undo',
                textColor: Colors.white,
                onPressed: () {
                  // Implement undo functionality
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _deleteProduct(int productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 12),
            Text('Delete Product'),
          ],
        ),
        content: Text(
            'Are you sure you want to delete this product? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _products.removeWhere((product) => product['id'] == productId);
                _selectedProducts.remove(productId);
                _filterProducts();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Product deleted successfully'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _duplicateProduct(Map<String, dynamic> product) {
    final duplicatedProduct = Map<String, dynamic>.from(product);
    duplicatedProduct['id'] = DateTime.now().millisecondsSinceEpoch;
    duplicatedProduct['name'] = '${product['name']} (Copy)';

    setState(() {
      _products.add(duplicatedProduct);
      _filterProducts();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product duplicated successfully!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _toggleProductAvailability(int productId, bool isAvailable) {
    setState(() {
      final index =
          _products.indexWhere((product) => product['id'] == productId);
      if (index != -1) {
        _products[index]['isAvailable'] = isAvailable;
        _filterProducts();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isAvailable
            ? 'Product made available'
            : 'Product made unavailable'),
        backgroundColor: isAvailable
            ? AppTheme.lightTheme.colorScheme.tertiary
            : Colors.orange,
      ),
    );
  }

  void _toggleProductSelection(int productId) {
    setState(() {
      if (_selectedProducts.contains(productId)) {
        _selectedProducts.remove(productId);
        if (_selectedProducts.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _selectedProducts.add(productId);
        _isMultiSelectMode = true;
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedProducts.clear();
      _isMultiSelectMode = false;
    });
  }

  void _deleteSelectedProducts() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 12),
            Text('Delete Products'),
          ],
        ),
        content: Text(
            'Are you sure you want to delete ${_selectedProducts.length} selected products? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _products.removeWhere(
                    (product) => _selectedProducts.contains(product['id']));
                _selectedProducts.clear();
                _isMultiSelectMode = false;
                _filterProducts();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Selected products deleted successfully'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Delete All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _updateSelectedPrices() {
    final TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Update Prices'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'Update prices for ${_selectedProducts.length} selected products:'),
            SizedBox(height: 16),
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'New Price (\$)',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12),
                  child: CustomIconWidget(
                    iconName: 'attach_money',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (priceController.text.isNotEmpty) {
                final newPrice = double.tryParse(priceController.text);
                if (newPrice != null) {
                  setState(() {
                    for (final productId in _selectedProducts) {
                      final index = _products
                          .indexWhere((product) => product['id'] == productId);
                      if (index != -1) {
                        _products[index]['price'] =
                            '\$${newPrice.toStringAsFixed(2)}';
                      }
                    }
                    _selectedProducts.clear();
                    _isMultiSelectMode = false;
                    _filterProducts();
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Prices updated successfully'),
                      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                    ),
                  );
                }
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _changeSelectedCategory() {
    String selectedCategory =
        _categories[1]; // Default to first non-"All" category

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Change Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'Change category for ${_selectedProducts.length} selected products:'),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                labelText: 'New Category',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12),
                  child: CustomIconWidget(
                    iconName: 'category',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
              items: _categories.skip(1).map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                selectedCategory = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                for (final productId in _selectedProducts) {
                  final index = _products
                      .indexWhere((product) => product['id'] == productId);
                  if (index != -1) {
                    _products[index]['category'] = selectedCategory;
                  }
                }
                _selectedProducts.clear();
                _isMultiSelectMode = false;
                _filterProducts();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Categories updated successfully'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              );
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Products refreshed'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Top Row with Shop Name and Menu
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: CustomIconWidget(
                          iconName: 'arrow_back',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Green Valley Store',
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Manage your products',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_isLoading)
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Search Bar
                  TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12),
                        child: CustomIconWidget(
                          iconName: 'search',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                _filterProducts();
                              },
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: CustomIconWidget(
                                  iconName: 'clear',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: 12),
                  // Category Filter Chips
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = _selectedCategoryFilter == category;

                        return Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategoryFilter = category;
                                _filterProducts();
                              });
                            },
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.surface,
                            selectedColor: AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.2),
                            labelStyle: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                            side: BorderSide(
                              color: isSelected
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.lightTheme.dividerColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Products Grid
            Expanded(
              child: _filteredProducts.isEmpty
                  ? _products.isEmpty
                      ? EmptyStateWidget(onAddProduct: () => _showProductForm())
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'search_off',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 64,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No products found',
                                style: AppTheme.lightTheme.textTheme.titleLarge
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Try adjusting your search or filters',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        )
                  : RefreshIndicator(
                      onRefresh: _refreshProducts,
                      child: GridView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          final productId = product['id'] as int;
                          final isSelected =
                              _selectedProducts.contains(productId);

                          return ProductCardWidget(
                            product: product,
                            isSelected: isSelected,
                            onTap: () {
                              if (_isMultiSelectMode) {
                                _toggleProductSelection(productId);
                              } else {
                                _showProductForm(product: product);
                              }
                            },
                            onLongPress: () =>
                                _toggleProductSelection(productId),
                            onEdit: () => _showProductForm(product: product),
                            onDelete: () => _deleteProduct(productId),
                            onDuplicate: () => _duplicateProduct(product),
                            onToggleAvailability: (isAvailable) =>
                                _toggleProductAvailability(
                                    productId, isAvailable),
                          );
                        },
                      ),
                    ),
            ),
            // Bulk Actions Bar
            if (_isMultiSelectMode)
              BulkActionsBar(
                selectedCount: _selectedProducts.length,
                onDeleteSelected: _deleteSelectedProducts,
                onUpdatePrices: _updateSelectedPrices,
                onChangeCategory: _changeSelectedCategory,
                onClearSelection: _clearSelection,
              ),
          ],
        ),
      ),
      // Floating Action Button
      floatingActionButton: _isMultiSelectMode
          ? null
          : FloatingActionButton(
              onPressed: () => _showProductForm(),
              child: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 24,
              ),
            ),
    );
  }
}
