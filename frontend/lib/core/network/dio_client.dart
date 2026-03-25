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
import 'package:medi/features/shared/auth/data/repo/auth_repo_impl.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://medi-app-dusky.vercel.app",
      headers: {
        //"Content-Type": "application/json",
      },
    ),
  );

  bool _isRefreshing = false;
  final List<Completer<void>> _refreshCompleters = [];

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
          if (error.response?.statusCode == 401 &&
              error.requestOptions.path != "/users/refreshToken") {
            final requestOptions = error.requestOptions;

            if (_isRefreshing) {
              final completer = Completer<void>();
              _refreshCompleters.add(completer);

              await completer.future;

              final token = HiveService.getAccessToken();

              requestOptions.headers["Authorization"] = "Bearer $token";

              final response = await _dio.fetch(requestOptions);

              return handler.resolve(response);
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

              requestOptions.headers["Authorization"] = "Bearer $token";

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

  /// refresh token logic
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = HiveService.getRefreshToken();
      log('Attempting token refresh, refresh token exists: $refreshToken');

      if (refreshToken == null) {
        log("No refresh token → logout");
        return false;
      }

      final dio = Dio(
        BaseOptions(
          baseUrl: "https://medi-app-dusky.vercel.app",
          headers: {"Authorization": "bearer $refreshToken"},
        ),
      );

      final response = await dio.post(
        "/users/refreshToken",
        options: Options(validateStatus: (status) => status != null),
      );
      log("Refresh response status: ${response.statusCode}");
      log("Refresh response data: ${response.data}");

      if (response.statusCode != 200) {
        log("Refresh failed");
        AuthRepoImpl(ApiService()).signOut();
        return false;
      }

      final newAccessToken = response.data["accessToken"];
      final newRefreshToken = response.data["refreshToken"];

      if (newAccessToken == null) return false;

      await HiveService.saveAccessToken(newAccessToken);

      if (newRefreshToken != null) {
        await HiveService.saveRefreshToken(newRefreshToken);
      }

      log("Token refreshed successfully");

      return true;
    } catch (e) {
      log("Refresh error: $e");
      return false;
    }
  }
}
