// lib/presentation/widgets/forecast_card.dart
import 'package:flutter/material.dart';
import '../../data/models/forecast_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/responsive_helper.dart';

class ForecastCard extends StatelessWidget {
  final List<DailyForecast> forecasts;

  const ForecastCard({Key? key, required this.forecasts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(responsive.r(30)),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            blurRadius: responsive.wp(4),
            spreadRadius: 2,
            offset: Offset(0, responsive.hp(1)),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.sp(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient text
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ).createShader(bounds),
              child: Text(
                '5-Day Forecast',
                style: TextStyle(
                  fontSize: responsive.sp(20),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: responsive.hp(2)),

            // Horizontal Scroll List
            SizedBox(
              height: responsive.hp(18),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: forecasts.length,
                separatorBuilder: (_, __) => SizedBox(width: responsive.wp(3)),
                itemBuilder: (context, index) {
                  final forecast = forecasts[index];
                  return _buildForecastDay(context, forecast, index, responsive);
                },
              ),
            ),

            SizedBox(height: responsive.hp(2)),

            // Weekly summary
            ...List.generate(forecasts.length, (index) {
              if (index > 2) return const SizedBox.shrink();
              final forecast = forecasts[index];
              return Padding(
                padding: EdgeInsets.only(bottom: responsive.hp(1)),
                child: _buildForecastRow(forecast, index, responsive),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastDay(
      BuildContext context,
      DailyForecast forecast,
      int index,
      ResponsiveHelper responsive,
      ) {
    final isToday = index == 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String dayLabel;
    if (index == 0) {
      dayLabel = 'Today';
    } else if (index == 1) {
      dayLabel = 'Tomorrow';
    } else {
      dayLabel = DateFormatter.formatShortDay(forecast.date);
    }

    return Container(
      width: responsive.wp(25),
      decoration: BoxDecoration(
        gradient: isToday
            ? LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.2),
            AppColors.secondary.withOpacity(0.1),
          ],
        )
            : null,
        color: isToday
            ? null
            : (isDark ? AppColors.darkSurface : Colors.grey.shade50),
        borderRadius: BorderRadius.circular(responsive.r(20)),
        border: isToday
            ? Border.all(
          color: AppColors.primary.withOpacity(0.5),
          width: 2,
        )
            : null,
        boxShadow: isToday
            ? [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ]
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.sp(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayLabel,
              style: TextStyle(
                fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                fontSize: responsive.sp(13),
                color: isToday ? AppColors.primary : null,
              ),
            ),
            SizedBox(height: responsive.hp(1)),
            Container(
              padding: EdgeInsets.all(responsive.sp(8)),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                forecast.getWeatherIcon(),
                size: responsive.sp(24),
                color: isToday ? AppColors.primary : Colors.grey.shade600,
              ),
            ),
            SizedBox(height: responsive.hp(1)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${forecast.maxTemp.round()}°',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.sp(14),
                    color: isToday ? AppColors.primary : null,
                  ),
                ),
                SizedBox(width: responsive.wp(1)),
                Text(
                  '${forecast.minTemp.round()}°',
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                    fontSize: responsive.sp(12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastRow(DailyForecast forecast, int index, ResponsiveHelper responsive) {
    final isToday = index == 0;

    return Row(
      children: [
        Container(
          width: responsive.wp(20),
          child: Text(
            index == 0 ? 'Today' : DateFormatter.formatDate(forecast.date),
            style: TextStyle(
              fontSize: responsive.sp(14),
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: isToday ? AppColors.primary : null,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.shade300,
                  Colors.blue.shade300,
                ],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        SizedBox(width: responsive.wp(3)),
        Text(
          '${forecast.maxTemp.round()}° / ${forecast.minTemp.round()}°',
          style: TextStyle(
            fontSize: responsive.sp(14),
            fontWeight: FontWeight.w600,
            color: isToday ? AppColors.primary : null,
          ),
        ),
      ],
    );
  }
}