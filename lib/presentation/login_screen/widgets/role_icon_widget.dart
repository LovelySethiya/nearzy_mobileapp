import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class RoleIconWidget extends StatelessWidget {
  final String role;
  final double size;

  const RoleIconWidget({
    Key? key,
    required this.role,
    this.size = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String iconName;
    Color iconColor;

    switch (role.toLowerCase()) {
      case 'customer':
        iconName = 'shopping_cart';
        iconColor = AppTheme.lightTheme.colorScheme.primary;
        break;
      case 'shopkeeper':
        iconName = 'store';
        iconColor = AppTheme.lightTheme.colorScheme.secondary;
        break;
      case 'admin':
        iconName = 'settings';
        iconColor = AppTheme.lightTheme.colorScheme.tertiary;
        break;
      default:
        iconName = 'person';
        iconColor = AppTheme.lightTheme.colorScheme.primary;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: iconColor.withValues(alpha: 0.1),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: iconName,
          color: iconColor,
          size: size * 0.5,
        ),
      ),
    );
  }
}
