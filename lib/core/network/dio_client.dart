import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';

class DioClient {
  static Dio createDio() {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    dio.interceptors.addAll([
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
      InterceptorsWrapper(
        onError: (error, handler) {
          print('Dio Error: ${error.message}');
          print('Dio Error Type: ${error.type}');
          print('Dio Error Response: ${error.response}');
          return handler.next(error);
        },
      ),
    ]);

    return dio;
  }

  static Dio createGeocodingDio() {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.geocodingUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    dio.interceptors.add(LogInterceptor(responseBody: true));
    return dio;
  }

  static Dio createQuoteDio() {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.quoteApiUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'WeatherApp/1.0', // Add User-Agent header
      },
    ));

    dio.interceptors.add(LogInterceptor(
      request: true,
      responseBody: true,
      error: true,
    ));

    return dio;
  }
}