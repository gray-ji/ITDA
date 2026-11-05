import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const List<String> _icons = [
    'assets/icons/home.svg',
    'assets/icons/register.svg',
    'assets/icons/chat.svg',
    'assets/icons/profile.svg',
  ];

  static const List<String> _labels = [
    '홈',
    '등록',
    '채팅',
    '마이페이지',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.gray5,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(
              _icons.length,
              (index) {
                final isSelected = selectedIndex == index;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(index),
                    child: AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 180,
                      ),
                      curve: Curves.easeInOut,
                      color: isSelected
                          ? AppColors.blue
                          : AppColors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            _icons[index],
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              isSelected
                                  ? AppColors.white
                                  : AppColors.gray1,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _labels[index],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.gray1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}