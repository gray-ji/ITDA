import 'package:flutter/material.dart';

class AppColors {
  static const yellow = Color(0xFFFFD95A);
  static const blue = Color(0xFF70C1E8);
  static const coral = Color(0xFFFF8E7B);

  static const black = Color(0xFF1A1A1A);
  static const lightYellow = Color(0xFFFFF8E7);

  static const gray1 = Color(0xFF8E8E93);
  static const gray2 = Color(0xFFAEAEB2);
  static const gray3 = Color(0xFFC7C7CC);
  static const gray4 = Color(0xFFD1D1D6);
  static const gray5 = Color(0xFFE5E5EA);
  static const gray6 = Color(0xFFF2F2F7);

  static const white = Colors.white;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.yellow,
        primary: AppColors.yellow,
        secondary: AppColors.blue,
        surface: AppColors.white,
      ),
      fontFamily: 'Pretendard',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        elevation: 0,
      ),
    );
  }
}