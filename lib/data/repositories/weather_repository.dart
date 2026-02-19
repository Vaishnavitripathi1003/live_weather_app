import 'package:live_weather_app/data/repositories/weather_repository_interface.dart';

import '../datasources/weather_remote_datasource.dart';
import '../models/forecast_model.dart';
import '../models/weather_model.dart';

class WeatherRepository implements WeatherRepositoryInterface {
  final WeatherRemoteDataSource _remoteDataSource;

  WeatherRepository(this._remoteDataSource);

  @override
  Future<WeatherModel> getCurrentWeather(String city) async {
    try {
      final coordinates = await _remoteDataSource.getCoordinates(city);
      return await _remoteDataSource.getCurrentWeather(
        coordinates['lat']!,
        coordinates['lon']!,
        city,
      );
    } catch (e) {
      throw Exception('Failed to get weather: $e');
    }
  }

  @override
  Future<ForecastModel> getForecast(String city) async {
    try {
      final coordinates = await _remoteDataSource.getCoordinates(city);
      return await _remoteDataSource.getForecast(
        coordinates['lat']!,
        coordinates['lon']!,
      );
    } catch (e) {
      throw Exception('Failed to get forecast: $e');
    }
  }
}