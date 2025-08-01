import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyCartWidget extends StatefulWidget {
  final VoidCallback onStartShopping;

  const EmptyCartWidget({
    Key? key,
    required this.onStartShopping,
  }) : super(key: key);

  @override
  State<EmptyCartWidget> createState() => _EmptyCartWidgetState();
}

class _EmptyCartWidgetState extends State<EmptyCartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: Duration(milliseconds: 1200), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 0.6, curve: Curves.easeOut)));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.2, 0.8, curve: Curves.elasticOut)));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Empty Cart Illustration
                                Container(
                                    width: 60.w,
                                    height: 30.h,
                                    decoration: BoxDecoration(
                                        color: AppTheme.lightTheme.primaryColor
                                            .withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          // Background circles for depth
                                          Positioned(
                                              top: 5.h,
                                              right: 8.w,
                                              child: Container(
                                                  width: 15.w,
                                                  height: 15.w,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle))),
                                          Positioned(
                                              bottom: 8.h,
                                              left: 6.w,
                                              child: Container(
                                                  width: 10.w,
                                                  height: 10.w,
                                                  decoration: BoxDecoration(
                                                      color: AppTheme.lightTheme
                                                          .primaryColor
                                                          .withValues(
                                                              alpha: 0.3),
                                                      shape: BoxShape.circle))),

                                          // Main cart icon
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    padding:
                                                        EdgeInsets.all(4.w),
                                                    decoration: BoxDecoration(
                                                        color: AppTheme
                                                            .lightTheme
                                                            .colorScheme
                                                            .surface,
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: AppTheme
                                                                  .lightTheme
                                                                  .primaryColor
                                                                  .withValues(
                                                                      alpha:
                                                                          0.2),
                                                              blurRadius: 20,
                                                              offset:
                                                                  Offset(0, 8)),
                                                        ]),
                                                    child: CustomIconWidget(
                                                        iconName:
                                                            'shopping_cart_outlined',
                                                        color: AppTheme
                                                            .lightTheme
                                                            .primaryColor,
                                                        size: 48)),
                                                SizedBox(height: 2.h),
                                                Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4.w,
                                                            vertical: 1.h),
                                                    decoration: BoxDecoration(
                                                        color: AppTheme
                                                            .lightTheme
                                                            .colorScheme
                                                            .surface,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withValues(
                                                                      alpha:
                                                                          0.1),
                                                              blurRadius: 10,
                                                              offset:
                                                                  Offset(0, 4)),
                                                        ]),
                                                    child: Text('Empty',
                                                        style: AppTheme
                                                            .lightTheme
                                                            .textTheme
                                                            .labelMedium
                                                            ?.copyWith(
                                                                color: AppTheme
                                                                    .lightTheme
                                                                    .colorScheme
                                                                    .onSurfaceVariant))),
                                              ]),
                                        ])),

                                SizedBox(height: 4.h),

                                // Title
                                Text('Your cart is empty',
                                    style: AppTheme
                                        .lightTheme.textTheme.headlineSmall
                                        ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurface),
                                    textAlign: TextAlign.center),

                                SizedBox(height: 2.h),

                                // Description
                                Text(
                                    'Looks like you haven\'t added any items to your cart yet. Start shopping to fill it up!',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyLarge
                                        ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurfaceVariant,
                                            height: 1.5),
                                    textAlign: TextAlign.center),

                                SizedBox(height: 4.h),

                                // Start Shopping Button
                                Container(
                                    width: double.infinity,
                                    height: 6.h,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        gradient: LinearGradient(colors: [
                                          AppTheme.lightTheme.primaryColor,
                                          AppTheme.lightTheme.primaryColor
                                              .withValues(alpha: 0.8),
                                        ]),
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppTheme
                                                  .lightTheme.primaryColor
                                                  .withValues(alpha: 0.3),
                                              blurRadius: 12,
                                              offset: Offset(0, 6)),
                                        ]),
                                    child: ElevatedButton(
                                        onPressed: widget.onStartShopping,
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16))),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomIconWidget(
                                                  iconName: 'shopping_bag',
                                                  color: Colors.white,
                                                  size: 20),
                                              SizedBox(width: 2.w),
                                              Text('Start Shopping',
                                                  style: AppTheme.lightTheme
                                                      .textTheme.titleMedium
                                                      ?.copyWith(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                            ]))),

                                SizedBox(height: 2.h),

                                // Browse Categories Button
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context,
                                          '/product-categories-screen');
                                    },
                                    style: TextButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4.w, vertical: 1.5.h)),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Browse Categories',
                                              style: AppTheme.lightTheme
                                                  .textTheme.bodyLarge
                                                  ?.copyWith(
                                                      color: AppTheme.lightTheme
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                          SizedBox(width: 1.w),
                                          CustomIconWidget(
                                              iconName: 'arrow_forward',
                                              color: AppTheme
                                                  .lightTheme.primaryColor,
                                              size: 16),
                                        ])),
                              ])))));
        });
  }
}
