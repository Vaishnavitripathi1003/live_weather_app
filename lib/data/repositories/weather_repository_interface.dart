import '../../data/models/weather_model.dart';
import '../../data/models/forecast_model.dart';

abstract class WeatherRepositoryInterface {
  Future<WeatherModel> getCurrentWeather(String city);
  Future<ForecastModel> getForecast(String city);
}