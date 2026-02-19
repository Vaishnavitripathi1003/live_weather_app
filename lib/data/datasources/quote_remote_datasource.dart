import 'package:dio/dio.dart';
import '../models/quote_model.dart';
import '../../core/constants/api_constants.dart';

class QuoteRemoteDataSource {
  final Dio _dio;

  QuoteRemoteDataSource() : _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.quoteApiUrl,
    connectTimeout: Duration(milliseconds: ApiConstants.connectTimeout),
    receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': 'WeatherApp/1.0',
    },
  ));

  Future<QuoteModel> getRandomQuote() async {
    try {
      final response = await _dio.get('');

      // Debug: Print the response type and data
      print('Response type: ${response.data.runtimeType}');
      print('Response data: ${response.data}');

      // Check if response is a List (which it is for ZenQuotes)
      if (response.data is List) {
        final List dataList = response.data as List;

        if (dataList.isNotEmpty) {
          // Get the first item from the list
          final Map<String, dynamic> quoteData = dataList.first as Map<String, dynamic>;

          return QuoteModel(
            content: quoteData['q'] ?? '',
            author: quoteData['a'] ?? 'Unknown',
          );
        }
      }

      // If it's a direct Map (for other APIs)
      if (response.data is Map) {
        final Map<String, dynamic> quoteData = response.data as Map<String, dynamic>;

        return QuoteModel(
          content: quoteData['q'] ?? quoteData['content'] ?? '',
          author: quoteData['a'] ?? quoteData['author'] ?? 'Unknown',
        );
      }

      throw Exception('Invalid response format: Expected List or Map, got ${response.data.runtimeType}');
    } on DioException catch (e) {
      print('DioError: ${e.message}');
      print('Response data: ${e.response?.data}');
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
      return Exception('Failed to fetch quote: ${e.message}');
    }
  }
}