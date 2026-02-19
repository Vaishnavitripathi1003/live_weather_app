import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class FetchWeather extends WeatherEvent {
  final String city;

  const FetchWeather(this.city);

  @override
  List<Object?> get props => [city];
}

class RefreshWeather extends WeatherEvent {
  final String city;

  const RefreshWeather(this.city);

  @override
  List<Object?> get props => [city];
}