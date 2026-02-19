// lib/presentation/widgets/empty_state.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive_helper.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final IconData icon;

  const EmptyState({
    Key? key,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    required this.icon,
  }) : super(key: key);

  factory EmptyState.noSearches({required VoidCallback onSearch}) {
    return EmptyState(
      title: 'No Searches Yet',
      message: 'Start exploring weather around the world by searching for a city.',
      actionLabel: 'Search City',
      onAction: onSearch,
      icon: Icons.search_rounded,
    );
  }

  factory EmptyState.noData({required VoidCallback onRefresh}) {
    return EmptyState(
      title: 'No Weather Data',
      message: 'Unable to load weather information. Pull down to refresh.',
      actionLabel: 'Refresh',
      onAction: onRefresh,
      icon: Icons.refresh_rounded,
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
              // Icon with animated glow
              Container(
                width: responsive.wp(30),
                height: responsive.wp(30),
                constraints: BoxConstraints(
                  maxWidth: 140,
                  maxHeight: 140,
                  minWidth: 100,
                  minHeight: 100,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Icon(
                  icon,
                  size: responsive.sp(40),
                  color: isDark ? AppColors.primary : AppColors.primary.withOpacity(0.7),
                ),
              ),

              SizedBox(height: responsive.hp(2.5)),

              // Title
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: responsive.sp(22),
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: responsive.hp(1.2)),

              // Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontSize: responsive.sp(14),
                  height: 1.4,
                ),
              ),

              SizedBox(height: responsive.hp(3)),

              // Action Button
              Container(
                width: responsive.wp(45),
                constraints: const BoxConstraints(
                  minWidth: 140,
                  maxWidth: 180,
                ),
                height: responsive.hp(5.5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.gradientLavender,
                  ),
                  borderRadius: BorderRadius.circular(responsive.r(30)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: responsive.wp(3),
                      offset: Offset(0, responsive.hp(0.8)),
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
                          fontSize: responsive.sp(14),
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