import '../../data/models/quote_model.dart';

abstract class QuoteRepositoryInterface {
  Future<QuoteModel> getRandomQuote();
}