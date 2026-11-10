import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoAuth {
  /// 카카오 로그인 후 카카오 액세스 토큰을 반환
  /// 사용자가 직접 취소하면 PlatformException(code: 'CANCELED')을 던진다
  Future<String> login() async {
    OAuthToken token;
    if (await isKakaoTalkInstalled()) {
      try {
        token = await UserApi.instance.loginWithKakaoTalk();
      } catch (e) {
        // 카카오톡 로그인이 실패한 진짜 원인 (확인용)
        debugPrint('[KAKAO] 카카오톡 로그인 실패: $e');
        // 의도적인 취소는 계정 로그인으로 넘어가지 않음
        if (e is PlatformException && e.code == 'CANCELED') rethrow;
        // 카카오톡에 연결된 계정이 없는 경우 등은 카카오계정으로 로그인
        try {
          token = await UserApi.instance.loginWithKakaoAccount();
        } catch (e2) {
          debugPrint('[KAKAO] 카카오계정 로그인 실패: $e2');
          rethrow;
        }
      }
    } else {
      token = await UserApi.instance.loginWithKakaoAccount();
    }
    return token.accessToken;
  }
}