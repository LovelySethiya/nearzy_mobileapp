import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CartItemCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback onRemove;
  final Function(int) onQuantityChanged;
  final VoidCallback? onSaveForLater;
  final VoidCallback? onMoveToWishlist;

  const CartItemCard({
    Key? key,
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
    this.onSaveForLater,
    this.onMoveToWishlist,
  }) : super(key: key);

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isRemoving = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showRemoveConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Remove Item',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          content: Text(
            'Are you sure you want to remove ${widget.item["name"]} from your cart?',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _removeItem();
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _removeItem() {
    setState(() {
      _isRemoving = true;
    });
    _animationController.forward().then((_) {
      widget.onRemove();
    });
  }

  void _showContextMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'bookmark_border',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                title: Text(
                  'Save for Later',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  widget.onSaveForLater?.call();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'favorite_border',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                title: Text(
                  'Move to Wishlist',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  widget.onMoveToWishlist?.call();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete_outline',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 24,
                ),
                title: Text(
                  'Remove',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showRemoveConfirmation();
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  void _updateQuantity(int newQuantity) {
    if (newQuantity > 0) {
      HapticFeedback.lightImpact();
      widget.onQuantityChanged(newQuantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final quantity = widget.item["quantity"] as int;
    final price = widget.item["price"] as double;
    final isLowStock = (widget.item["stock"] as int) < 5;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isRemoving ? _scaleAnimation.value : 1.0,
          child: Dismissible(
            key: Key(widget.item["id"].toString()),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              _showRemoveConfirmation();
              return false;
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.error,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'delete',
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Remove',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onLongPress: _showContextMenu,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppTheme.lightTheme.colorScheme.surface,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CustomImageWidget(
                            imageUrl: widget.item["image"] as String,
                            width: 20.w,
                            height: 20.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),

                      // Product Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.item["name"] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isLowStock)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                      vertical: 0.5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme
                                          .lightTheme.colorScheme.error
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Low Stock',
                                      style: AppTheme
                                          .lightTheme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.error,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 1.h),

                            if (widget.item["category"] != null)
                              Text(
                                widget.item["category"] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              ),

                            SizedBox(height: 1.h),

                            // Price and Quantity Controls
                            Row(
                              children: [
                                Text(
                                  '\$${(price * quantity).toStringAsFixed(2)}',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (quantity > 1) ...[
                                  SizedBox(width: 2.w),
                                  Text(
                                    '\$${price.toStringAsFixed(2)} each',
                                    style:
                                        AppTheme.lightTheme.textTheme.bodySmall,
                                  ),
                                ],
                                Spacer(),

                                // Quantity Controls
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppTheme.lightTheme.dividerColor,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: quantity > 1
                                            ? () =>
                                                _updateQuantity(quantity - 1)
                                            : null,
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          width: 8.w,
                                          height: 8.w,
                                          child: Center(
                                            child: CustomIconWidget(
                                              iconName: 'remove',
                                              color: quantity > 1
                                                  ? AppTheme
                                                      .lightTheme.primaryColor
                                                  : AppTheme
                                                      .lightTheme
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 12.w,
                                        height: 8.w,
                                        child: Center(
                                          child: Text(
                                            quantity.toString(),
                                            style: AppTheme.lightTheme.textTheme
                                                .titleSmall,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () =>
                                            _updateQuantity(quantity + 1),
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          width: 8.w,
                                          height: 8.w,
                                          child: Center(
                                            child: CustomIconWidget(
                                              iconName: 'add',
                                              color: AppTheme
                                                  .lightTheme.primaryColor,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
