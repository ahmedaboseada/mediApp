// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:medi/core/services/hive_service.dart';

// class DioClient {
//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: 'https://medi-app-dusky.vercel.app',
//       headers: {"Content-Type": 'application/json'},
//     ),
//   );

//   DioClient() {
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           final token = HiveService.getAccessToken();
//           if (token != null) {
//             options.headers["Authorization"] = "Bearer $token";
//             print('[DioClient] Adding Authorization header');
//             print(
//               '[DioClient] Token: ${token.length > 50 ? token.substring(0, 50) : token}...',
//             );
//           } else {
//             print('[DioClient] WARNING: No token found in HiveService');
//           }
//           return handler.next(options);
//         },
//         onError: (error, handler) async {
//           // Handle 401 Unauthorized - refresh token and retry
//           if (error.response?.statusCode == 401 &&
//               error.requestOptions.path != '/users/refreshToken') {
//             // Avoid infinite retry loops
//             if (error.requestOptions.extra['_retry'] == true) {
//               return handler.next(error);
//             }

//             try {
//               final refreshed = await _refreshAccessToken();
//               if (refreshed) {
//                 final token = HiveService.getAccessToken();

//                 if (token != null) {
//                   // Create new request options with updated token and retry flag
//                   final newOptions = error.requestOptions;
//                   newOptions.headers["Authorization"] = "Bearer $token";
//                   newOptions.extra['_retry'] = true;

//                   print('[DioClient] Token refreshed, retrying request...');

//                   // Retry the original request with updated token
//                   try {
//                     final response = await _dio.fetch(newOptions);
//                     print('[DioClient] Retry successful');
//                     return handler.resolve(response);
//                   } catch (retryError) {
//                     print('[DioClient] Retry failed: $retryError');
//                     return handler.next(error);
//                   }
//                 } else {
//                   print('[DioClient] No token available after refresh');
//                   return handler.next(error);
//                 }
//               } else {
//                 // Refresh failed, pass error to next handler
//                 print('[DioClient] Token refresh failed');
//                 return handler.next(error);
//               }
//             } catch (e) {
//               print('[DioClient] Error during token refresh: $e');
//               return handler.next(error);
//             }
//           }

//           return handler.next(error);
//         },
//       ),
//     );
//   }

//   Dio get dio => _dio;

//   Future<bool> _refreshAccessToken() async {
//     try {
//       final refreshToken = HiveService.getRefreshToken();
//       print('[DioClient] Attempting token refresh...');
//       log(refreshToken.toString());
//       print('[DioClient] Refresh token exists: ${refreshToken != null}');

//       if (refreshToken == null) {
//         print('[DioClient] No refresh token available');
//         return false;
//       }

//       final dio = Dio(
//         BaseOptions(
//           baseUrl: 'https://medi-app-dusky.vercel.app',
//           headers: {
//             "Content-Type": "application/json",
//             "Authorization": "Bearer $refreshToken",
//           },
//         ),
//       );

//       print('[DioClient] Calling /users/refreshToken endpoint...');
//       final response = await dio.post('/users/refreshToken');
//       print('[DioClient] Refresh response: ${response.statusCode}');

//       final newAccessToken =
//           response.data['accessToken'] ?? response.data['access_token'];
//       final newRefreshToken =
//           response.data['refreshToken'] ?? response.data['refresh_token'];

//       if (newAccessToken != null) {
//         await HiveService.saveAccessToken(newAccessToken);
//         if (newRefreshToken != null) {
//           await HiveService.saveRefreshToken(newRefreshToken);
//         }
//         print('[DioClient] Token refresh successful');
//         return true;
//       }

//       print('[DioClient] No new access token in response');
//       return false;
//     } catch (e) {
//       print('[DioClient] Token refresh failed: $e');
//       return false;
//     }
//   }
// }

// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:medi/core/services/hive_service.dart';

// class DioClient {
//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: 'https://medi-app-dusky.vercel.app',
//       headers: {
//         "Content-Type": "application/json",
//       },
//     ),
//   );

//   bool _isRefreshing = false;

//   DioClient() {
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           final token = HiveService.getAccessToken();

//           if (token != null) {
//             options.headers["Authorization"] = "Bearer $token";
//           }

//           return handler.next(options);
//         },

//         /// ERROR HANDLER
//         onError: (error, handler) async {
//           final statusCode = error.response?.statusCode;

//           /// لو التوكن انتهى
//           if (statusCode == 401 &&
//               error.requestOptions.path != '/users/refreshToken') {
//             if (error.requestOptions.extra['_retry'] == true) {
//               return handler.next(error);
//             }

//             if (_isRefreshing) {
//               return handler.next(error);
//             }

//             try {
//               _isRefreshing = true;

//               final refreshed = await _refreshAccessToken();

//               _isRefreshing = false;

//               if (!refreshed) {
//                 return handler.next(error);
//               }

//               final newToken = HiveService.getAccessToken();

//               if (newToken == null) {
//                 return handler.next(error);
//               }

//               /// إعادة الطلب الأصلي
//               final requestOptions = error.requestOptions;

//               requestOptions.headers["Authorization"] = "Bearer $newToken";
//               requestOptions.extra['_retry'] = true;

//               final response = await _dio.fetch(requestOptions);

//               return handler.resolve(response);
//             } catch (e) {
//               log("Refresh error: $e");
//               _isRefreshing = false;
//               return handler.next(error);
//             }
//           }

//           return handler.next(error);
//         },
//       ),
//     );
//   }

//   Dio get dio => _dio;

//   /// REFRESH TOKEN
//   Future<bool> _refreshAccessToken() async {
//     try {
//       final refreshToken = HiveService.getRefreshToken();

//       if (refreshToken == null) {
//         log("No refresh token found");
//         return false;
//       }

//       final dio = Dio(
//         BaseOptions(
//           baseUrl: 'https://medi-app-dusky.vercel.app',
//           headers: {
//             "Content-Type": "application/json",
//             "Authorization": "bearer $refreshToken",
//           },
//         ),
//       );

//       final response = await dio.post('/users/refreshToken');

//       final newAccessToken = response.data['accessToken'];
//       final newRefreshToken = response.data['refreshToken'];

//       if (newAccessToken == null) return false;

//       await HiveService.saveAccessToken(newAccessToken);

//       if (newRefreshToken != null) {
//         await HiveService.saveRefreshToken(newRefreshToken);
//       }

//       log("Token refreshed successfully");

//       return true;
//     } catch (e) {
//       log("Refresh token failed: $e");
//       return false;
//     }
//   }
// }
import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:medi/core/network/api_service.dart';
import 'package:medi/core/services/hive_service.dart';

typedef OnAuthenticationFailure = Future<void> Function();

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://35.246.202.219:8000/",
      headers: {
        //"Content-Type": "application/json",
      },
    ),
  );

  bool _isRefreshing = false;
  final List<Completer<void>> _refreshCompleters = [];
  OnAuthenticationFailure? _onAuthFailure;

  DioClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = HiveService.getAccessToken();

          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },

        onError: (DioException error, handler) async {
          // Handle 401 Unauthorized
          if (error.response?.statusCode == 401 &&
              error.requestOptions.path != "/users/refreshToken") {
            log('[DioClient] 401 Unauthorized - Attempting token refresh');
            final requestOptions = error.requestOptions;

            if (_isRefreshing) {
              log('[DioClient] Token refresh already in progress, waiting...');
              final completer = Completer<void>();
              _refreshCompleters.add(completer);

              await completer.future;

              final token = HiveService.getAccessToken();
              if (token != null) {
                requestOptions.headers["Authorization"] = "Bearer $token";
                try {
                  final response = await _dio.fetch(requestOptions);
                  return handler.resolve(response);
                } catch (e) {
                  log('[DioClient] Retry after refresh failed: $e');
                  return handler.next(error);
                }
              } else {
                log('[DioClient] No token available after refresh completion');
                return handler.next(error);
              }
            }

            _isRefreshing = true;

            final refreshed = await _refreshToken();

            _isRefreshing = false;

            for (final completer in _refreshCompleters) {
              completer.complete();
            }
            _refreshCompleters.clear();

            if (refreshed) {
              final token = HiveService.getAccessToken();

              if (token != null) {
                requestOptions.headers["Authorization"] = "Bearer $token";
                try {
                  final response = await _dio.fetch(requestOptions);
                  log('[DioClient] Retry after token refresh successful');
                  return handler.resolve(response);
                } catch (retryError) {
                  log('[DioClient] Retry after token refresh failed: $retryError');
                  return handler.next(error);
                }
              } else {
                log('[DioClient] No token available after successful refresh');
                await _handleAuthenticationFailure();
                return handler.next(error);
              }
            } else {
              log('[DioClient] Token refresh failed, triggering logout');
              await _handleAuthenticationFailure();
            }
          }

          // Handle 403 Forbidden (usually means tokens are invalid)
          if (error.response?.statusCode == 403) {
            log('[DioClient] 403 Forbidden - Tokens may be invalid');
            await _handleAuthenticationFailure();
          }

          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  /// Set callback for authentication failure handling
  void setOnAuthFailureCallback(OnAuthenticationFailure callback) {
    _onAuthFailure = callback;
  }

  /// Handle authentication failure
  Future<void> _handleAuthenticationFailure() async {
    try {
      log('[DioClient] Clearing stored credentials');
      await HiveService.clearTokens();

      if (_onAuthFailure != null) {
        log('[DioClient] Triggering onAuthFailure callback');
        await _onAuthFailure!();
      } else {
        log('[DioClient] WARNING: No onAuthFailure callback set');
      }
    } catch (e) {
      log('[DioClient] Error during authentication failure handling: $e');
    }
  }

  /// Refresh token logic with improved error handling
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = HiveService.getRefreshToken();
      log('[DioClient] Attempting token refresh, refresh token available: ${refreshToken != null}');

      if (refreshToken == null) {
        log('[DioClient] No refresh token available - logout required');
        return false;
      }

      final dio = Dio(
        BaseOptions(
          baseUrl: "http://35.246.202.219:8000/",
          headers: {"Authorization": "Bearer $refreshToken"},
        ),
      );

      final response = await dio.post(
        "/users/refreshToken",
        options: Options(validateStatus: (status) => status != null),
      );
      
      log('[DioClient] Refresh token response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newAccessToken = response.data["accessToken"] ?? response.data["access_token"];
        final newRefreshToken = response.data["refreshToken"] ?? response.data["refresh_token"];

        if (newAccessToken == null) {
          log('[DioClient] No access token in refresh response');
          return false;
        }

        await HiveService.saveAccessToken(newAccessToken);
        if (newRefreshToken != null) {
          await HiveService.saveRefreshToken(newRefreshToken);
        }

        log('[DioClient] Token refreshed successfully');
        return true;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        log('[DioClient] Refresh token invalid (${response.statusCode}) - logout required');
        log('[DioClient] Response: ${response.data}');
        return false;
      } else {
        log('[DioClient] Unexpected response status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('[DioClient] Error during token refresh: $e');
      return false;
    }
  }
}
