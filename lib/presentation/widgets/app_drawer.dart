// lib/presentation/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/responsive_helper.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_event.dart';
import '../bloc/theme/theme_state.dart';

class AppDrawer extends StatelessWidget {
  final String currentCity;
  final VoidCallback onRefresh;

  const AppDrawer({
    Key? key,
    required this.currentCity,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      width: responsive.wp(75),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(responsive.r(30)),
          bottomRight: Radius.circular(responsive.r(30)),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
                : [Colors.white, const Color(0xFFF5F9FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              _buildHeader(responsive, isDark),

              // Drawer Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(height: responsive.hp(2)),

                    // Home
                    _buildDrawerItem(
                      context,
                      icon: Icons.home_rounded,
                      label: 'Home',
                      onTap: () => Navigator.pop(context),
                      isDark: isDark,
                    ),

                    // Search
                    _buildDrawerItem(
                      context,
                      icon: Icons.search_rounded,
                      label: 'Search City',
                      onTap: () async {
                        Navigator.pop(context);
                        final result = await Navigator.pushNamed(
                          context,
                          AppRoutes.search,
                        );
                        if (result != null && result is String) {
                          onRefresh();
                        }
                      },
                      isDark: isDark,
                    ),

                             _buildDrawerItem(
                      context,
                      icon: Icons.info_rounded,
                      label: 'About App',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.about);
                      },
                      isDark: isDark,
                    ),

                    _buildDivider(context, isDark),


                    _buildThemeSwitch(context, isDark),


                    _buildDrawerItem(
                      context,
                      icon: Icons.share_rounded,
                      label: 'Share App',
                      onTap: () {
                        Navigator.pop(context);
                        Share.share(
                          'Check out Weather Wonders app! 🌤️ Get real-time weather updates and forecasts.\n\nDownload now: https://play.google.com/store/apps/details?id=com.example.weather',
                          subject: 'Weather Wonders App',
                        );
                      },
                      isDark: isDark,
                    ),

                    // Rate App
                    _buildDrawerItem(
                      context,
                      icon: Icons.star_rounded,
                      label: 'Rate App',
                      onTap: () => _showRatingDialog(context, responsive),
                      isDark: isDark,
                    ),

                    _buildDivider(context, isDark),


                    _buildFollowUsSection(context, responsive, isDark),
                  ],
                ),
              ),


              _buildFooter(responsive, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ResponsiveHelper responsive, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(responsive.sp(20)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.gradientSunrise,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(responsive.r(30)),
          bottomRight: Radius.circular(responsive.r(30)),
          topRight: Radius.circular(responsive.r(30)),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // App Logo with animation
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, double scale, child) {
              return Transform.scale(
                scale: scale,
                child: Container(
                  padding: EdgeInsets.all(responsive.sp(15)),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.sunny_snowing,
                    size: responsive.sp(45),
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),

          SizedBox(height: responsive.hp(1.5)),

          // App Name
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.white, Color(0xFFE0E0E0)],
            ).createShader(bounds),
            child: Text(
              'Live Weather',
              style: TextStyle(
                color: Colors.white,
                fontSize: responsive.sp(22),
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),

          Text(
            'Wonders',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: responsive.sp(16),
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
            ),
          ),

          SizedBox(height: responsive.hp(1)),

          // Current Location Card
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(4),
              vertical: responsive.hp(0.8),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(responsive.r(30)),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on,
                  size: responsive.sp(14),
                  color: Colors.white,
                ),
                SizedBox(width: responsive.wp(1)),
                Flexible(
                  child: Text(
                    currentCity,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.sp(13),
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
        required bool isDark,
        Color? color,
        Widget? trailing,
      }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: color ?? AppColors.primary,
          size: 20,
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.grey.shade800,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildDivider(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Divider(
        color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
        thickness: 1,
      ),
    );
  }

  Widget _buildThemeSwitch(BuildContext context, bool isDark) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        bool isDarkMode = state.themeMode == ThemeMode.dark;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.grey.shade800,
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    context.read<ThemeBloc>().add(ToggleTheme());
                  },
                  activeColor: AppColors.primary,
                  activeTrackColor: AppColors.primary.withOpacity(0.3),
                  inactiveThumbColor: isDark ? Colors.grey.shade400 : Colors.grey,
                  inactiveTrackColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFollowUsSection(BuildContext context, ResponsiveHelper responsive, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connect with us',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton(
                icon: Icons.facebook,
                color: const Color(0xFF1877F2),
                onTap: () => _launchURL('https://facebook.com'),
              ),
              _buildSocialButton(
                icon: Icons.telegram,
                color: const Color(0xFF0088cc),
                onTap: () => _launchURL('https://telegram.org'),
              ),
              _buildSocialButton(
                icon: Icons.camera_alt,
                color: const Color(0xFFE4405F),
                onTap: () => _launchURL('https://instagram.com'),
              ),
              _buildSocialButton(
                icon: Icons.alternate_email,
                color: const Color(0xFF1DA1F2),
                onTap: () => _launchURL('https://twitter.com'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildFooter(ResponsiveHelper responsive, bool isDark) {
    return Container(
      padding: EdgeInsets.all(responsive.sp(16)),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_rounded,
                size: responsive.sp(14),
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              SizedBox(width: responsive.wp(1)),
              Text(
                'v1.0.0',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontSize: responsive.sp(12),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                '© 2024',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontSize: responsive.sp(12),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.hp(0.5)),
          Text(
            'Made with ❤️ in Flutter',
            style: TextStyle(
              color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
              fontSize: responsive.sp(10),
            ),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context, ResponsiveHelper responsive) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: responsive.wp(5),
          vertical: responsive.hp(2),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.r(30)),
        ),
        child: Container(
          width: responsive.wp(90), // Fixed width
          padding: EdgeInsets.all(responsive.sp(20)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [const Color(0xFF2A2A3A), const Color(0xFF1A1A2A)]
                  : [Colors.white, Colors.grey.shade50],
            ),
            borderRadius: BorderRadius.circular(responsive.r(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(responsive.sp(12)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade400, Colors.orange.shade400],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.star_rounded,
                  color: Colors.white,
                  size: responsive.sp(35),
                ),
              ),

              SizedBox(height: responsive.hp(1.5)),

              // Title
              Text(
                'Love our app?',
                style: TextStyle(
                  fontSize: responsive.sp(20),
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.grey.shade800,
                ),
              ),

              SizedBox(height: responsive.hp(1)),

              // Message
              Padding(
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
                child: Text(
                  'If you enjoy using Live Weather App, please take a moment to rate us on the app store. Your support helps us improve!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: responsive.sp(13),
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ),

              SizedBox(height: responsive.hp(2)),

              // Rating Stars - Fixed (No Overflow)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0), // Fixed padding
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _showThankYouDialog(context, responsive);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(4), // Fixed padding
                          child: Icon(
                            index < 4 ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: responsive.sp(26), // Smaller size
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(height: responsive.hp(2)),

              // Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          padding: EdgeInsets.symmetric(
                            vertical: responsive.hp(1.2),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(responsive.r(12)),
                          ),
                        ),
                        child: Text(
                          'Later',
                          style: TextStyle(
                            fontSize: responsive.sp(13),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: responsive.wp(2)),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _launchURL('https://play.google.com/store/apps/details?id=com.example.weather');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: responsive.hp(1.2),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(responsive.r(12)),
                          ),
                        ),
                        child: Text(
                          'Rate Now',
                          style: TextStyle(
                            fontSize: responsive.sp(13),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThankYouDialog(BuildContext context, ResponsiveHelper responsive) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.r(30)),
        ),
        child: Container(
          padding: EdgeInsets.all(responsive.sp(24)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [const Color(0xFF1A3A2A), const Color(0xFF0A2A1A)]
                  : [Colors.green.shade50, Colors.white],
            ),
            borderRadius: BorderRadius.circular(responsive.r(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(responsive.sp(16)),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: responsive.sp(30),
                ),
              ),
              SizedBox(height: responsive.hp(2)),
              Text(
                'Thank You!',
                style: TextStyle(
                  fontSize: responsive.sp(22),
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              SizedBox(height: responsive.hp(1)),
              Text(
                'Your support means the world to us!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: responsive.sp(14),
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              SizedBox(height: responsive.hp(2)),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(10),
                    vertical: responsive.hp(1.5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(responsive.r(20)),
                  ),
                ),
                child: const Text('You\'re Welcome!'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
}