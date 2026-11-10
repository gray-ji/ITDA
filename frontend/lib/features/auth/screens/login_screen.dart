import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../data/auth_api.dart';
import '../data/kakao_auth.dart';
import '../data/token_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // true: 카카오 로그인만 테스트 (서버 호출 없음)
  // false: 서버까지 연동 (서버 준비 후 false로 변경)
  static const bool _testKakaoOnly = true;

  // 카카오 로그인 버튼 디자인 가이드 색상
  static const _kakaoYellow = Color(0xFFFEE500);
  static const _kakaoLabel = Color(0xD9000000); // #000000 85%
  static const double _buttonHeight = 52;

  bool _loading = false;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _login() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      debugPrint('[LOGIN] 1. 카카오 로그인 시작');
      final kakaoToken = await KakaoAuth().login();
      debugPrint('[LOGIN] 2. 카카오 토큰 수신 (${kakaoToken.length}자)');

      if (_testKakaoOnly) {
        if (!mounted) return;
        _showMessage('카카오 로그인 성공! (토큰 ${kakaoToken.length}자)');
        return;
      }

      final result = await AuthApi().loginWithKakao(kakaoToken);
      await TokenStorage().save(result.accessToken, result.refreshToken);
      debugPrint('[LOGIN] 3. 서버 로그인 성공');
      if (!mounted) return;

      if (Navigator.of(context).canPop()) {
        // 다른 화면에서 로그인 요청으로 열린 경우: 결과를 돌려주고 닫기
        Navigator.of(context).pop(true);
      } else {
        _showMessage('로그인되었어요');
      }
    } on PlatformException catch (e) {
      debugPrint('[LOGIN] PlatformException: ${e.code} / ${e.message}');
      if (e.code != 'CANCELED') _showMessage('카카오 오류: ${e.code}');
    } catch (e) {
      debugPrint('[LOGIN] 오류: $e');
      _showMessage(_testKakaoOnly ? '오류: $e' : errorMessage(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      // 다른 화면에서 열린 경우에만 뒤로 가기 제공
      appBar: Navigator.of(context).canPop() ? AppBar() : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Stack(
            children: [
              // 정중앙: 카카오 로그인 버튼
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: _buttonHeight,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kakaoYellow,
                      disabledBackgroundColor: _kakaoYellow,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: _kakaoLabel,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/kakao_symbol.png',
                                height: 18,
                                // TODO: 공식 심볼 추가 후 errorBuilder 삭제
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.chat_bubble,
                                  size: 18,
                                  color: Colors.black,
                                ),
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

              // 버튼 위쪽: 로고(크게) + 멘트(작게)
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
            ],
          ),
        ),
      ),
    );
  }
}