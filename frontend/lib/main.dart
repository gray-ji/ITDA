// import 'package:flutter/material.dart';
// import 'app.dart';

// void main() {
//   runApp(const ITDAApp());
// }

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const kakaoKey = String.fromEnvironment('KAKAO_NATIVE_APP_KEY');
  if (kakaoKey.isNotEmpty) {
    await KakaoSdk.init(nativeAppKey: kakaoKey);
  }

  runApp(const ITDAApp());
}