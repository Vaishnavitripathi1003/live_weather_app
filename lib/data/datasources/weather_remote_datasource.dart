import 'package:dio/dio.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../../core/constants/api_constants.dart';

class WeatherRemoteDataSource {
  final Dio _dio;

  WeatherRemoteDataSource() : _dio = Dio(BaseOptions(
    connectTimeout: Duration(milliseconds: ApiConstants.connectTimeout),
    receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
  ));

  Future<WeatherModel> getCurrentWeather(double lat, double lon, String cityName) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/forecast',
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
          'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,wind_speed_10m,weather_code',
          'timezone': 'auto',
        },
      );

      return WeatherModel.fromJson(response.data, cityName);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ForecastModel> getForecast(double lat, double lon) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/forecast',
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
          'daily': 'weather_code,temperature_2m_max,temperature_2m_min',
          'timezone': 'auto',
          'forecast_days': 5,
        },
      );

      return ForecastModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, double>> getCoordinates(String city) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.geocodingUrl}/search',
        queryParameters: {
          'name': city,
          'count': 1,
          'language': 'en',
          'format': 'json',
        },
      );

      final results = response.data['results'];
      if (results == null || results.isEmpty) {
        throw Exception('City not found');
      }

      return {
        'lat': results[0]['latitude'],
        'lon': results[0]['longitude'],
      };
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Exception('Connection timeout');
    } else if (e.type == DioExceptionType.connectionError) {
      return Exception('No internet connection');
    } else {
      return Exception('Failed to fetch weather data');
    }
  }
}