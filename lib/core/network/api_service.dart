import 'package:dio/dio.dart';
import 'dio_client.dart';
import 'network_exception.dart';

class ApiService {
  final Dio _weatherDio;
  final Dio _geocodingDio;
  final Dio _quoteDio;

  ApiService()
      : _weatherDio = DioClient.createDio(),
        _geocodingDio = DioClient.createGeocodingDio(),
        _quoteDio = DioClient.createQuoteDio();

  // Weather APIs
  Future<Response> getCurrentWeather(double lat, double lon) async {
    try {
      return await _weatherDio.get('/forecast', queryParameters: {
        'latitude': lat,
        'longitude': lon,
        'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,wind_speed_10m,weather_code',
        'timezone': 'auto',
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> getForecast(double lat, double lon) async {
    try {
      return await _weatherDio.get('/forecast', queryParameters: {
        'latitude': lat,
        'longitude': lon,
        'daily': 'weather_code,temperature_2m_max,temperature_2m_min',
        'timezone': 'auto',
        'forecast_days': 5,
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Geocoding APIs
  Future<Response> searchCity(String city) async {
    try {
      return await _geocodingDio.get('/search', queryParameters: {
        'name': city,
        'count': 1,
        'language': 'en',
        'format': 'json',
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Quote APIs - Fixed version
  Future<Response> getRandomQuote() async {
    try {
      // ZenQuotes API sometimes requires a User-Agent header
      final response = await _quoteDio.get(
        '',
        options: Options(
          headers: {
            'User-Agent': 'WeatherApp/1.0',
          },
        ),
      );

      // Log the response for debugging
      print('Quote API Response: ${response.data}');
      print('Quote API Status Code: ${response.statusCode}');

      return response;
    } catch (e) {
      print('Quote API Error: $e');
      throw _handleError(e);
    }
  }
  dynamic _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          throw NetworkException('Connection timeout');
        case DioExceptionType.connectionError:
          throw NetworkException('No internet connection');
        case DioExceptionType.badResponse:
          throw NetworkException('Server error: ${error.response?.statusCode}');
        default:
          throw NetworkException('Network error occurred');
      }
    }
    throw NetworkException('Unexpected error occurred');
  }
}