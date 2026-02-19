// lib/presentation/widgets/custom_error_widget.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive_helper.dart';

class CustomErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final IconData icon;
  final List<Color> gradient;

  const CustomErrorWidget({
    Key? key,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    required this.icon,
    required this.gradient,
  }) : super(key: key);

  factory CustomErrorWidget.noInternet({required VoidCallback onRetry}) {
    return CustomErrorWidget(
      title: 'No Connection',
      message: 'Oops! You\'re offline. Check your connection and try again.',
      actionLabel: 'Try Again',
      onAction: onRetry,
      icon: Icons.wifi_off_rounded,
      gradient: AppColors.gradientSunset,
    );
  }

  factory CustomErrorWidget.cityNotFound({
    required String city,
    required VoidCallback onSearch,
    required VoidCallback onRetry,
  }) {
    return CustomErrorWidget(
      title: 'City Not Found',
      message: 'Couldn\'t find "$city". Please check the spelling or try another city.',
      actionLabel: 'Search Again',
      onAction: onSearch,
      icon: Icons.location_off_rounded,
      gradient: AppColors.gradientPeach,
    );
  }

  factory CustomErrorWidget.apiError({required VoidCallback onRetry}) {
    return CustomErrorWidget(
      title: 'Service Unavailable',
      message: 'Weather service is taking a break. Please try again.',
      actionLabel: 'Retry',
      onAction: onRetry,
      icon: Icons.cloud_off_rounded,
      gradient: AppColors.gradientCloudy,
    );
  }

  factory CustomErrorWidget.timeout({required VoidCallback onRetry}) {
    return CustomErrorWidget(
      title: 'Taking Too Long',
      message: 'Request is taking longer than expected. Please check your connection.',
      actionLabel: 'Try Again',
      onAction: onRetry,
      icon: Icons.timer_off_rounded,
      gradient: AppColors.gradientSunset,
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(responsive.sp(24)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Icon Container
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: responsive.wp(25),
                      height: responsive.wp(25),
                      constraints: BoxConstraints(
                        maxWidth: 120,
                        maxHeight: 120,
                        minWidth: 80,
                        minHeight: 80,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: gradient,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: gradient.first.withOpacity(0.3),
                            blurRadius: responsive.wp(5),
                            offset: Offset(0, responsive.hp(1)),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        size: responsive.sp(30),
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: responsive.hp(3)),

              // Title
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: responsive.sp(24),
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: responsive.hp(1.5)),

              // Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  height: 1.5,
                  fontSize: responsive.sp(14),
                ),
              ),

              SizedBox(height: responsive.hp(3)),

              // Action Button
              Container(
                width: responsive.wp(50),
                constraints: const BoxConstraints(
                  minWidth: 160,
                  maxWidth: 200,
                ),
                height: responsive.hp(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  borderRadius: BorderRadius.circular(responsive.r(30)),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.first.withOpacity(0.3),
                      blurRadius: responsive.wp(3),
                      offset: Offset(0, responsive.hp(1)),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onAction,
                    borderRadius: BorderRadius.circular(responsive.r(30)),
                    child: Center(
                      child: Text(
                        actionLabel,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.sp(15),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============ Specific Error Widget Classes ============

class NoInternetWidget extends StatelessWidget {
  final VoidCallback onRetry;
  const NoInternetWidget({Key? key, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget.noInternet(onRetry: onRetry);
  }
}

class TimeoutErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;
  const TimeoutErrorWidget({Key? key, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget.timeout(onRetry: onRetry);
  }
}

class CityNotFoundWidget extends StatelessWidget {
  final String city;
  final VoidCallback onRetry;
  final VoidCallback onSearchAgain;

  const CityNotFoundWidget({
    Key? key,
    required this.city,
    required this.onRetry,
    required this.onSearchAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget.cityNotFound(
      city: city,
      onSearch: onSearchAgain,
      onRetry: onRetry,
    );
  }
}

class ApiErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ApiErrorWidget({Key? key, required this.message, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget.apiError(onRetry: onRetry);
  }
}

class ErrorDisplayWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorDisplayWidget({
    Key? key,
    required this.message,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(responsive.sp(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: responsive.sp(48),
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(height: responsive.hp(1.5)),
            Text(
              'Error',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: responsive.sp(20),
              ),
            ),
            SizedBox(height: responsive.hp(1)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: responsive.sp(14),
              ),
            ),
            SizedBox(height: responsive.hp(2.5)),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(6),
                  vertical: responsive.hp(1.2),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(responsive.r(12)),
                ),
              ),
              child: Text('Try Again', style: TextStyle(fontSize: responsive.sp(14))),
            ),
          ],
        ),
      ),
    );
  }
}