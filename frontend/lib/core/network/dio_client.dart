import 'package:dio/dio.dart';
import 'package:medi/core/utils/pref_helper.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://medi-app-dusky.vercel.app/api/v1/auth/',
      headers: {"Content-Type": 'application/json'},
    ),
  );

  DioClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await PrefHelper.getAccessToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 400 &&
              !error.requestOptions.extra.containsKey('retry')) {
            final refreshed = await _refreshAccessToken();
            if (refreshed) {
              final token = await PrefHelper.getAccessToken();
              final requestOptions = error.requestOptions;

              if (token != null) {
                requestOptions.headers["Authorization"] = "Bearer $token";
                requestOptions.extra['retry'] = true;
              }
              final response = await _dio.fetch(requestOptions);

              return handler.resolve(response);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<bool> _refreshAccessToken() async {
    try {
      final refreshToken = await PrefHelper.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/api/auth/refresh-token',
        data: {'refresh_token': refreshToken},
      );

      final newAccessToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];

      await PrefHelper.saveAccessToken(newAccessToken);
      await PrefHelper.saveRefreshToken(newRefreshToken);

      return true;
    } catch (e) {
      return false;
    }
  }
}
