import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class PostTypeTabs extends StatelessWidget {
  final bool isFoundTab;
  final ValueChanged<bool> onChanged;

  const PostTypeTabs({
    super.key,
    required this.isFoundTab,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildTab(
          label: '주웠어요',
          isSelected: isFoundTab,
          color: AppColors.blue,
          onTap: () => onChanged(true),
        ),
        const SizedBox(width: 10),
        _buildTab(
          label: '잃어버렸어요',
          isSelected: !isFoundTab,
          color: AppColors.yellow,
          onTap: () => onChanged(false),
        ),
      ],
    );
  }

  Widget _buildTab({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? color : AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? color : AppColors.gray5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? (color == AppColors.yellow
                      ? AppColors.black
                      : AppColors.white)
                  : AppColors.gray1,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}