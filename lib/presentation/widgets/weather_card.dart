// lib/presentation/widgets/weather_card.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive_helper.dart';

class WeatherCard extends StatelessWidget {
  final String city;
  final double temperature;
  final String condition;
  final IconData icon;
  final int humidity;
  final double windSpeed;
  final double feelsLike;

  const WeatherCard({
    Key? key,
    required this.city,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        // Add tap animation later
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(responsive.r(40)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _getWeatherGradient(condition),
          ),
          boxShadow: [
            BoxShadow(
              color: _getWeatherGradient(condition).first.withOpacity(0.4),
              blurRadius: responsive.wp(6),
              spreadRadius: 2,
              offset: Offset(0, responsive.hp(1.5)),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative floating particles
            ..._buildParticles(responsive),

            // Main content
            Padding(
              padding: EdgeInsets.all(responsive.sp(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location with glass effect
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(4),
                      vertical: responsive.hp(0.8),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(responsive.r(30)),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: Colors.white,
                          size: responsive.sp(16),
                        ),
                        SizedBox(width: responsive.wp(1)),
                        Text(
                          city,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.sp(16),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: responsive.hp(2)),

                  // Temperature
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        temperature.round().toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.sp(72),
                          fontWeight: FontWeight.w200,
                          height: 0.9,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: responsive.hp(1)),
                        child: Text(
                          '°C',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: responsive.sp(28),
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Condition
                  Text(
                    condition,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.sp(18),
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(height: responsive.hp(2)),

                  // Stats row with glass effect
                  Container(
                    padding: EdgeInsets.all(responsive.sp(16)),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(responsive.r(25)),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          Icons.thermostat,
                          '${feelsLike.round()}°',
                          'Feels like',
                          responsive,
                        ),
                        _buildStatItem(
                          Icons.air,
                          '${windSpeed.round()} km/h',
                          'Wind',
                          responsive,
                        ),
                        _buildStatItem(
                          Icons.water_drop,
                          '$humidity%',
                          'Humidity',
                          responsive,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildParticles(ResponsiveHelper responsive) {
    return List.generate(8, (index) {
      return Positioned(
        left: (index * 45) % responsive.wp(100),
        top: (index * 30) % responsive.hp(100),
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: Duration(seconds: 3 + index),
          curve: Curves.linear,
          builder: (context, double value, child) {
            return Opacity(
              opacity: (0.2 * (1 - value)).clamp(0.0, 0.2),
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildStatItem(IconData icon, String value, String label, ResponsiveHelper responsive) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: responsive.sp(18)),
        SizedBox(height: responsive.hp(0.3)),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: responsive.sp(14),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: responsive.sp(11),
          ),
        ),
      ],
    );
  }

  List<Color> _getWeatherGradient(String condition) {
    if (condition.toLowerCase().contains('clear') || condition.toLowerCase().contains('sun')) {
      return [const Color(0xFFF9B43A), const Color(0xFFFAD961), const Color(0xFFFFB347)];
    } else if (condition.toLowerCase().contains('cloud')) {
      return [const Color(0xFF4A6FA5), const Color(0xFF6B8CBF), const Color(0xFF8BA9D9)];
    } else if (condition.toLowerCase().contains('rain')) {
      return [const Color(0xFF2B4C7C), const Color(0xFF4A7A9C), const Color(0xFF6A9AB0)];
    } else if (condition.toLowerCase().contains('snow')) {
      return [const Color(0xFF7F9EB5), const Color(0xFF9FB6D0), const Color(0xFFBFCEEB)];
    } else if (condition.toLowerCase().contains('storm')) {
      return [const Color(0xFF2C3E50), const Color(0xFF4A5F6E), const Color(0xFF6B7F8C)];
    }
    return AppColors.gradientSunrise;
  }
}