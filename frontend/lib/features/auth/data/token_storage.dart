import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 서비스 accessToken / refreshToken을 기기에 안전하게 저장
class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _accessKey = 'accessToken';
  static const _refreshKey = 'refreshToken';

  Future<void> save(String access, String refresh) async {
    await _storage.write(key: _accessKey, value: access);
    await _storage.write(key: _refreshKey, value: refresh);
  }

  Future<String?> readAccess() => _storage.read(key: _accessKey);

  Future<String?> readRefresh() => _storage.read(key: _refreshKey);

  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}