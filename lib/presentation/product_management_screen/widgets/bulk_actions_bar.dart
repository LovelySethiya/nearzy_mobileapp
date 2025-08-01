import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class BulkActionsBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onDeleteSelected;
  final VoidCallback onUpdatePrices;
  final VoidCallback onChangeCategory;
  final VoidCallback onClearSelection;

  const BulkActionsBar({
    Key? key,
    required this.selectedCount,
    required this.onDeleteSelected,
    required this.onUpdatePrices,
    required this.onChangeCategory,
    required this.onClearSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Selection Info
            Expanded(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onClearSelection,
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    '$selectedCount selected',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // Action Buttons
            Row(
              children: [
                _buildActionButton(
                  icon: 'edit',
                  onTap: onUpdatePrices,
                  tooltip: 'Update Prices',
                ),
                SizedBox(width: 8),
                _buildActionButton(
                  icon: 'category',
                  onTap: onChangeCategory,
                  tooltip: 'Change Category',
                ),
                SizedBox(width: 8),
                _buildActionButton(
                  icon: 'delete',
                  onTap: onDeleteSelected,
                  tooltip: 'Delete Selected',
                  isDestructive: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required VoidCallback onTap,
    required String tooltip,
    bool isDestructive = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive
                ? Colors.red.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: isDestructive ? Colors.red[300]! : Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
