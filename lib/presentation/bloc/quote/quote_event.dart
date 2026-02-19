import 'package:equatable/equatable.dart';

abstract class QuoteEvent extends Equatable {
  const QuoteEvent();

  @override
  List<Object?> get props => [];
}

class FetchQuote extends QuoteEvent {}

class RefreshQuote extends QuoteEvent {}