import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/home/screens/home_screen.dart';

class ITDAApp extends StatelessWidget {
  const ITDAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '잇다',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}