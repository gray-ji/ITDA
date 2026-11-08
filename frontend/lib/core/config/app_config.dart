class AppConfig {
  // 실행 시 --dart-define-from-file=env.json 으로 주입
  // 폰 테스트: http://PC_IP:8080 / 안드로이드 에뮬레이터: http://10.0.2.2:8080
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );
}