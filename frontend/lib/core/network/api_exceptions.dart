import 'package:dio/dio.dart';
import 'package:medi/core/network/api_error.dart';

class ServerFailure extends ApiError {
  ServerFailure(super.message, [super.errors]);
  factory ServerFailure.fromDioError(DioException dioError) {
    {
      switch (dioError.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ServerFailure("Connection Timeout with Server");
        case DioExceptionType.badResponse:
          return ServerFailure.fromResponse(
            dioError.response!.statusCode!,
            dioError.response!.data,
          );
        case DioExceptionType.cancel:
          return ServerFailure("Request to server was cancelled");
        case DioExceptionType.connectionError:
          return ServerFailure(
            "Connection to server failed due to internet connection",
          );
        case DioExceptionType.badCertificate:
          return ServerFailure("Bad Certificate");
        case DioExceptionType.unknown:
          if ((dioError.message ?? '').contains('SocketException')) {
            return ServerFailure("No Internet Connection");
          }
          return ServerFailure("Unexpected error occurred");
      }
    }
  }
  // factory ServerFailure.fromResponse(int statusCode, dynamic response) {

  //   if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
  //     return ServerFailure(response['message']);
  //   } else if (statusCode == 404) {
  //     return ServerFailure("Your request not found, Please try later!");
  //   } else if (statusCode == 500) {
  //     return ServerFailure("Internal Server error, Please try later!");
  //   } else {
  //     return ServerFailure("Something went wrong, Please try later!");
  //   }
  // }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (response == null) {
      return ServerFailure("Unknown error");
    }

    if (response is! Map<String, dynamic>) {
      return ServerFailure(response.toString());
    }

    if (response['message'] is String) {
      final errors = response['errors'] is List
          ? List<String>.from(response['errors'])
          : <String>[];
      return ServerFailure(response['message'], errors);
    }

    if (response['errors'] is Map<String, dynamic>) {
      final errors = response['errors'] as Map<String, dynamic>;
      if (errors.isNotEmpty) {
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          return ServerFailure(firstError.first.toString());
        }
      }
    }

    switch (statusCode) {
      case 400:
      case 401:
      case 403:
        return ServerFailure("Unauthorized request");
      case 404:
        return ServerFailure("Your request not found, Please try later!");
      case 500:
        return ServerFailure("Internal Server error, Please try later!");
      default:
        return ServerFailure("Something went wrong, Please try later!");
    }
  }
}
