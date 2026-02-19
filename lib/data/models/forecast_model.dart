import 'package:flutter/material.dart';

import '../../core/utils/date_formatter.dart';

class ForecastModel {
  final List<DailyForecast> daily;

  ForecastModel({required this.daily});

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final daily = json['daily'];
    List<DailyForecast> forecasts = [];

    for (int i = 0; i < daily['time'].length; i++) {
      forecasts.add(DailyForecast(
        date: DateTime.parse(daily['time'][i]),
        minTemp: daily['temperature_2m_min'][i],
        maxTemp: daily['temperature_2m_max'][i],
        weatherCode: daily['weather_code'][i],
      ));
    }

    return ForecastModel(daily: forecasts);
  }
}

class DailyForecast {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final int weatherCode;

  DailyForecast({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.weatherCode,
  });

  String getWeatherCondition() {
    switch (weatherCode) {
      case 0:
        return 'Clear';
      case 1:
      case 2:
      case 3:
        return 'Cloudy';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
        return 'Rainy';
      case 71:
      case 73:
      case 75:
        return 'Snowy';
      default:
        return 'Unknown';
    }
  }

  IconData getWeatherIcon() {
    switch (weatherCode) {
      case 0:
        return Icons.wb_sunny;
      case 1:
      case 2:
      case 3:
        return Icons.wb_cloudy;
      case 45:
      case 48:
        return Icons.cloud;
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
        return Icons.umbrella;
      case 71:
      case 73:
      case 75:
        return Icons.ac_unit;
      default:
        return Icons.help;
    }
  }

  String getFormattedDate() {
    final now = DateTime.now();
    if (date.day == now.day) {
      return 'Today';
    } else if (date.day == now.add(Duration(days: 1)).day) {
      return 'Tomorrow';
    } else {
      return DateFormatter.formatDate(date);
    }
  }
}