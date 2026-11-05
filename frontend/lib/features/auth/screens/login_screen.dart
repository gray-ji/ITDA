import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

import 'join_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // 카카오 로그인 버튼 디자인 가이드 색상
  static const _kakaoYellow = Color(0xFFFEE500); // 컨테이너
  static const _kakaoLabel = Color(0xD9000000); // 레이블 #000000 85%

  static const double _buttonHeight = 52;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: _buttonHeight,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: 카카오 로그인 연동 (#20 API 완료 후)
                      debugPrint('카카오 로그인 버튼 클릭');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kakaoYellow,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 카카오 공식 심볼 (비율 유지, 색 변경 금지)
                        Image.asset(
                          'assets/images/kakao_symbol.png',
                          height: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '카카오 로그인',
                          style: TextStyle(
                            fontSize: 16,
                            color: _kakaoLabel,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: _buttonHeight + 220),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '간편하게 로그인하고\n서비스를 이용해보세요',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: AppColors.gray1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: _buttonHeight + 80),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const JoinScreen()),
                      );
                    },
                    child: const Text(
                      '회원가입하기',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.gray1,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.gray1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}