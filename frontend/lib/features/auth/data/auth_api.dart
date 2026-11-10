import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import 'token_storage.dart';

class AuthResult {
  final String accessToken;
  final String refreshToken;

  AuthResult({required this.accessToken, required this.refreshToken});
}

class AuthApi {
  final Dio _dio = ApiClient.instance.dio;

  /// 카카오 액세스 토큰으로 로그인 (가입되지 않았으면 서버가 계정을 자동 생성)
  Future<AuthResult> loginWithKakao(String kakaoAccessToken) async {
    final res = await _dio.post(
      '/api/v1/auth/kakao',
      data: {'accessToken': kakaoAccessToken},
    );
    final data = res.data['data'];
    return AuthResult(
      accessToken: data['accessToken'],
      refreshToken: data['refreshToken'],
    );
  }

  /// 닉네임 수정 (토큰은 ApiClient가 자동으로 붙임) - 프로필 수정 화면에서 사용
  Future<void> updateNickname(String nickname) async {
    await _dio.patch('/api/v1/users/me', data: {'nickname': nickname});
  }

  /// 로그아웃 - 마이페이지에서 사용
  Future<void> logout() async {
    final tokens = TokenStorage();
    try {
      final refresh = await tokens.readRefresh();
      // TODO: FCM 토큰이 등록돼 있으면 먼저 DELETE /api/v1/device-tokens
      await _dio.post('/api/v1/auth/logout', data: {'refreshToken': refresh});
    } finally {
      await tokens.clear(); // 서버 호출이 실패해도 앱에서는 로그아웃
    }
  }
}

/// 서버 오류 응답에서 사용자에게 보여줄 메시지 추출
String errorMessage(Object e) {
  if (e is DioException) {
    final body = e.response?.data;
    if (body is Map && body['message'] is String) return body['message'];
    return '서버에 연결할 수 없어요. 잠시 후 다시 시도해주세요.';
  }
  return '오류가 발생했어요. 다시 시도해주세요.';
}