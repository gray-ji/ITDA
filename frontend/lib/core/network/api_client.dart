import 'package:dio/dio.dart';

import '../../features/auth/data/token_storage.dart';
import '../config/app_config.dart';

class ApiClient {
  ApiClient._() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onError: _onError,
    ));
  }

  static final ApiClient instance = ApiClient._();

  static final _options = BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  );

  /// 일반 API 호출용 (토큰 자동 첨부, 401 시 자동 갱신)
  final Dio dio = Dio(_options);

  /// 재발급 호출 전용 (인터셉터 없음 → 무한 루프 방지)
  final Dio _plain = Dio(_options);

  final _tokens = TokenStorage();
  Future<bool>? _refreshing;

  /// 세션이 완전히 만료되었을 때 호출 (필요한 화면에서 연결)
  void Function()? onSessionExpired;

  // 토큰을 붙이지 않는 API
  static const _noAuthPaths = {
    '/api/v1/auth/kakao',
    '/api/v1/auth/refresh',
  };

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_noAuthPaths.contains(options.path)) {
      final token = await _tokens.readAccess();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  Future<void> _onError(
    DioException e,
    ErrorInterceptorHandler handler,
  ) async {
    final req = e.requestOptions;
    final isAuthApi = req.path.startsWith('/api/v1/auth/');
    final alreadyRetried = req.extra['retried'] == true;

    if (e.response?.statusCode == 401 && !isAuthApi && !alreadyRetried) {
      if (await _refresh()) {
        req.extra['retried'] = true;
        try {
          // 재시도 시 onRequest가 새 토큰을 다시 붙임
          return handler.resolve(await dio.fetch(req));
        } on DioException catch (err) {
          return handler.next(err);
        }
      } else {
        onSessionExpired?.call();
      }
    }
    handler.next(e);
  }

  // 동시에 여러 요청이 401이어도 재발급은 한 번만
  Future<bool> _refresh() {
    return _refreshing ??=
        _doRefresh().whenComplete(() => _refreshing = null);
  }

  Future<bool> _doRefresh() async {
    final refresh = await _tokens.readRefresh();
    if (refresh == null) return false;
    try {
      final res = await _plain.post(
        '/api/v1/auth/refresh',
        data: {'refreshToken': refresh},
      );
      final d = res.data['data'];
      await _tokens.save(d['accessToken'], d['refreshToken']);
      return true;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      // 토큰이 무효인 경우에만 삭제 (오프라인 등 네트워크 오류면 유지)
      if (status == 400 || status == 401) await _tokens.clear();
      return false;
    }
  }
}