import 'package:flutter_bloc/flutter_bloc.dart';
import 'quote_event.dart';
import 'quote_state.dart';
import '../../../data/repositories/quote_repository.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final QuoteRepository _repository;

  QuoteBloc(this._repository) : super(QuoteInitial()) {
    on<FetchQuote>(_onFetchQuote);
    on<RefreshQuote>(_onRefreshQuote);
  }

  Future<void> _onFetchQuote(
      FetchQuote event,
      Emitter<QuoteState> emit,
      ) async {
    emit(QuoteLoading());

    try {
      final quote = await _repository.getRandomQuote();
      emit(QuoteLoaded(quote: quote));
    } catch (e) {
      emit(QuoteError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onRefreshQuote(
      RefreshQuote event,
      Emitter<QuoteState> emit,
      ) async {
    try {
      final quote = await _repository.getRandomQuote();
      emit(QuoteLoaded(quote: quote));
    } catch (e) {
      emit(QuoteError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}