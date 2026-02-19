import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_event.dart';
import 'weather_state.dart';
import '../../../data/repositories/weather_repository.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _repository;

  WeatherBloc(this._repository) : super(WeatherInitial()) {
    on<FetchWeather>(_onFetchWeather);
    on<RefreshWeather>(_onRefreshWeather);
  }

  Future<void> _onFetchWeather(
      FetchWeather event,
      Emitter<WeatherState> emit,
      ) async {
    emit(WeatherLoading());

    try {
      final weather = await _repository.getCurrentWeather(event.city);
      final forecast = await _repository.getForecast(event.city);

      emit(WeatherLoaded(weather: weather, forecast: forecast));
    } catch (e) {
      emit(WeatherError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onRefreshWeather(
      RefreshWeather event,
      Emitter<WeatherState> emit,
      ) async {
    try {
      final weather = await _repository.getCurrentWeather(event.city);
      final forecast = await _repository.getForecast(event.city);

      emit(WeatherLoaded(weather: weather, forecast: forecast));
    } catch (e) {
      emit(WeatherError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}