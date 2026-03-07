import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';

class ApiService {
  final DioClient _dioClient = DioClient();

  /// CRUD METHODS

  /// get
  Future<dynamic> get(String endPoint, {Map<String, String>? headers}) async {
    try {
      final response = await _dioClient.dio.get(endPoint,
          options: headers != null ? Options(headers: headers) : null);
      return response.data;
    } on DioException catch (e) {
      return ServerFailure.fromDioError(e);
    }
  }

  /// post
  Future<dynamic> post(String endPoint, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      final response = await _dioClient.dio.post(endPoint,
          data: body,
          options: Options(headers: headers));
      return response.data;
    } on DioException catch (e) {
      return ServerFailure.fromDioError(e);
    }
  }

  /// put || update
  Future<dynamic> put(String endPoint, dynamic body) async {
    try {
      final response = await _dioClient.dio.put(endPoint, data: body);
      return response.data;
    } on DioException catch (e) {
      return ServerFailure.fromDioError(e);
    }
  }

  /// patch
  Future< dynamic> patch(String endPoint, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      final response = await _dioClient.dio.patch(endPoint,
          data: body,
          options: Options(headers: headers));
      return response.data;
    } on DioException catch (e) {
      return ServerFailure.fromDioError(e);
    }
  }

  /// delete
  Future<dynamic> delete(String endPoint, dynamic body) async {
    try {
      final response = await _dioClient.dio.delete(endPoint, data: body);
      return response.data;
    } on DioException catch (e) {
      return ServerFailure.fromDioError(e);
    }
  }
}
