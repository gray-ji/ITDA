import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback? onTap;

  const HomeSearchBar({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.gray6,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              color: AppColors.gray1,
              size: 22,
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                '어떤 물건을 찾고 있나요?',
                style: TextStyle(
                  color: AppColors.gray1,
                  fontSize: 14,
                ),
              ),
            ),
            const Icon(
              Icons.tune,
              color: AppColors.gray1,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}