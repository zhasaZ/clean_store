import 'dart:io';

import 'package:dio/dio.dart';

import '../error/exceptions.dart';

/// Обёртка над Dio. Все ошибки HTTP превращаются в исключения Data Layer.
class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<dynamic> get(String path) async {
    try {
      final response = await _dio.get(path);
      return response.data;
    } on DioException catch (e) {
      throw _map(e);
    } catch (_) {
      throw const UnknownException();
    }
  }

  AppException _map(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode ?? 0;
        if (code == 400) return const ValidationException();
        if (code == 401 || code == 403) return const UnauthorizedException();
        return const ServerException();
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        if (e.error is SocketException) return const NetworkException();
        return const UnknownException();
    }
  }
}
