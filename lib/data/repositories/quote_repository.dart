import 'package:live_weather_app/data/repositories/quote_repository_interface.dart';
import '../datasources/quote_remote_datasource.dart';
import '../models/quote_model.dart';

class QuoteRepository implements QuoteRepositoryInterface {
  final QuoteRemoteDataSource _remoteDataSource;

  QuoteRepository(this._remoteDataSource);

  @override
  Future<QuoteModel> getRandomQuote() async {
    try {
      return await _remoteDataSource.getRandomQuote();
    } catch (e) {
      print('Repository error: $e');
      throw Exception('Failed to get quote: $e');
    }
  }
}