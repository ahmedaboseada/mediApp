import 'package:dio/dio.dart';
import 'package:medi/core/utils/pref_helper.dart';

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
        onRequest: (options, handler) async {
          final token = await PrefHelper.getAccessToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
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
                final token = await PrefHelper.getAccessToken();

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
      final refreshToken = await PrefHelper.getRefreshToken();
      if (refreshToken == null) {
        print('[DioClient] ❌ No refresh token available in storage');
        return false;
      }

      print('[DioClient] 🔄 Attempting to refresh token...');
      print('[DioClient] Refresh token: ${refreshToken.substring(0, 20)}...');

      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://medi-app-dusky.vercel.app',
          headers: {
            "Content-Type": "application/json",
          },
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      // Try sending refresh token in request body (most common pattern)
      final response = await dio.post(
        '/users/refreshToken',
        data: {
          'refreshToken': refreshToken,
        },
      );

      print('[DioClient] ✓ Refresh response code: ${response.statusCode}');
      print('[DioClient] ✓ Refresh response data: ${response.data}');

      final newAccessToken = response.data['accessToken'] ?? 
                            response.data['access_token'] ??
                            response.data['token'];
      final newRefreshToken = response.data['refreshToken'] ?? 
                             response.data['refresh_token'];

      if (newAccessToken != null && newAccessToken.toString().isNotEmpty) {
        await PrefHelper.saveAccessToken(newAccessToken);
        print('[DioClient] ✅ New access token saved');
        
        if (newRefreshToken != null && newRefreshToken.toString().isNotEmpty) {
          await PrefHelper.saveRefreshToken(newRefreshToken);
          print('[DioClient] ✅ New refresh token saved');
        }
        return true;
      } else {
        print('[DioClient] ❌ No access token in refresh response');
        return false;
      }
    } on DioException catch (e) {
      print('[DioClient] ❌ Dio error during token refresh: ${e.message}');
      print('[DioClient] Status code: ${e.response?.statusCode}');
      print('[DioClient] Response: ${e.response?.data}');
      
      // If refresh token endpoint returns 401, it means refresh token is invalid/expired
      if (e.response?.statusCode == 401) {
        print('[DioClient] ⚠️  Refresh token is invalid or expired - clearing all tokens');
        await PrefHelper.clearTokens();
        // TODO: Emit navigation event to redirect to login screen
      }
      
      return false;
    } catch (e) {
      print('[DioClient] ❌ Unexpected error during token refresh: $e');
      return false;
    }
  }
}
