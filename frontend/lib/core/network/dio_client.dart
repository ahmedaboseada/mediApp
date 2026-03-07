import 'package:dio/dio.dart';
import 'package:medi/core/services/hive_service.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://medi-app-dusky.vercel.app',
      headers: {"Content-Type": 'application/json'},
    ),
  );

  DioClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = HiveService.getAccessToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
            print('[DioClient] Adding Authorization header');
            print('[DioClient] Token: ${token.length > 50 ? token.substring(0, 50) : token}...');
          } else {
            print('[DioClient] WARNING: No token found in HiveService');
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 Unauthorized - refresh token and retry
          if (error.response?.statusCode == 401) {
            // Avoid infinite retry loops
            if (error.requestOptions.extra['_retry'] == true) {
              return handler.next(error);
            }

            try {
              final refreshed = await _refreshAccessToken();
              if (refreshed) {
                final token = HiveService.getAccessToken();

                if (token != null) {
                  // Create new request options with updated token and retry flag
                  final newOptions = error.requestOptions;
                  newOptions.headers["Authorization"] = "Bearer $token";
                  newOptions.extra['_retry'] = true;

                  print('[DioClient] Token refreshed, retrying request...');

                  // Retry the original request with updated token
                  try {
                    final response = await _dio.fetch(newOptions);
                    print('[DioClient] Retry successful');
                    return handler.resolve(response);
                  } catch (retryError) {
                    print('[DioClient] Retry failed: $retryError');
                    return handler.next(error);
                  }
                } else {
                  print('[DioClient] No token available after refresh');
                  return handler.next(error);
                }
              } else {
                // Refresh failed, pass error to next handler
                print('[DioClient] Token refresh failed');
                return handler.next(error);
              }
            } catch (e) {
              print('[DioClient] Error during token refresh: $e');
              return handler.next(error);
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
      final refreshToken = HiveService.getRefreshToken();
      print('[DioClient] Attempting token refresh...');
      print('[DioClient] Refresh token exists: ${refreshToken != null}');
      
      if (refreshToken == null) {
        print('[DioClient] No refresh token available');
        return false;
      }

      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://medi-app-dusky.vercel.app',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $refreshToken",
          },
        ),
      );

      print('[DioClient] Calling /users/refreshToken endpoint...');
      final response = await dio.post('/users/refreshToken');
      print('[DioClient] Refresh response: ${response.statusCode}');

      final newAccessToken = response.data['accessToken'] ?? response.data['access_token'];
      final newRefreshToken = response.data['refreshToken'] ?? response.data['refresh_token'];

      if (newAccessToken != null) {
        await HiveService.saveAccessToken(newAccessToken);
        if (newRefreshToken != null) {
          await HiveService.saveRefreshToken(newRefreshToken);
        }
        print('[DioClient] Token refresh successful');
        return true;
      }

      print('[DioClient] No new access token in response');
      return false;
    } catch (e) {
      print('[DioClient] Token refresh failed: $e');
      return false;
    }
  }
}
