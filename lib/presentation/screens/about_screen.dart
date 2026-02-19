// lib/presentation/screens/about_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive_helper.dart';
import '../widgets/glassmorphism_card.dart';

class AboutScreen extends StatefulWidget {
  final String? version;

  const AboutScreen({Key? key, this.version}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [Colors.grey.shade900, Colors.grey.shade800]
                : [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              _buildAppBar(responsive),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(responsive.sp(16)),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          // App Logo and Name
                          _buildAppHeader(responsive),

                          SizedBox(height: responsive.hp(2)),

                          // Version Info
                          _buildVersionCard(responsive),

                          SizedBox(height: responsive.hp(2)),

                          // Description
                          _buildDescriptionCard(responsive),

                          SizedBox(height: responsive.hp(2)),

                          // Features
                          _buildFeaturesSection(responsive),

                          SizedBox(height: responsive.hp(2)),

                          // Developer Info
                          _buildDeveloperInfo(responsive),

                          SizedBox(height: responsive.hp(2)),

                          // Social Links
                          _buildSocialLinks(responsive),

                          SizedBox(height: responsive.hp(2)),

                          // Tech Stack
                          _buildTechStack(responsive),

                          SizedBox(height: responsive.hp(2)),

                          // Acknowledgments
                          _buildAcknowledgments(responsive),

                          SizedBox(height: responsive.hp(2)),

                          // Copyright
                          _buildCopyright(responsive),
                        ],
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

  Widget _buildAppBar(ResponsiveHelper responsive) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(4),
        vertical: responsive.hp(1),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              size: responsive.sp(24),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'About App',
              style: TextStyle(
                fontSize: responsive.sp(20),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: responsive.wp(10)), // For balance
        ],
      ),
    );
  }

  Widget _buildAppHeader(ResponsiveHelper responsive) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(responsive.sp(20)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.gradientSunrise,
        ),
        borderRadius: BorderRadius.circular(responsive.r(30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Animated Logo
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.elasticOut,
            builder: (context, double scale, child) {
              return Transform.scale(
                scale: scale,
                child: Container(
                  padding: EdgeInsets.all(responsive.sp(15)),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.sunny_snowing,
                    size: responsive.sp(50),
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),

          SizedBox(height: responsive.hp(1.5)),

          Text(
            'Live Weather App',
            style: TextStyle(
              color: Colors.white,
              fontSize: responsive.sp(28),
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),

          SizedBox(height: responsive.hp(0.5)),

          Text(
            'Your Personal Weather Companion',
            style: TextStyle(
              color: Colors.white70,
              fontSize: responsive.sp(14),
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionCard(ResponsiveHelper responsive) {
    return GlassmorphismCard(
      child: Padding(
        padding: EdgeInsets.all(responsive.sp(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(responsive.sp(8)),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_rounded,
                    color: AppColors.primary,
                    size: responsive.sp(20),
                  ),
                ),
                SizedBox(width: responsive.wp(3)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Version',
                      style: TextStyle(
                        fontSize: responsive.sp(12),
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      widget.version ?? AppConstants.appVersion,
                      style: TextStyle(
                        fontSize: responsive.sp(18),
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(3),
                vertical: responsive.hp(0.5),
              ),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(responsive.r(20)),
                border: Border.all(color: Colors.green),
              ),
              child: Text(
                'Latest',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: responsive.sp(12),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(ResponsiveHelper responsive) {
    return GlassmorphismCard(
      child: Padding(
        padding: EdgeInsets.all(responsive.sp(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About the App',
              style: TextStyle(
                fontSize: responsive.sp(16),
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: responsive.hp(1)),
            Text(
              'Live Weather App is a beautiful and intuitive weather application '
                  'that provides real-time weather information, forecasts, and inspiring '
                  'quotes to start your day. Built with Flutter for a seamless experience '
                  'across all devices.',
              style: TextStyle(
                fontSize: responsive.sp(14),
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(ResponsiveHelper responsive) {
    final features = [
      {
        'icon': Icons.my_location,
        'title': 'Current Location',
        'description': 'Automatic weather detection for your location',
      },
      {
        'icon': Icons.search,
        'title': 'City Search',
        'description': 'Search weather for any city worldwide',
      },
      {
        'icon': Icons.calendar_month,
        'title': '5-Day Forecast',
        'description': 'Detailed weather forecast for the next 5 days',
      },
      {
        'icon': Icons.format_quote,
        'title': 'Daily Quotes',
        'description': 'Inspiring quotes to brighten your day',
      },
      {
        'icon': Icons.dark_mode,
        'title': 'Dark Mode',
        'description': 'Switch between light and dark themes',
      },
      {
        'icon': Icons.history,
        'title': 'Search History',
        'description': 'Quick access to your recent searches',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: responsive.wp(2), bottom: responsive.hp(1)),
          child: Text(
            'Features',
            style: TextStyle(
              fontSize: responsive.sp(18),
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: responsive.wp(2),
            mainAxisSpacing: responsive.hp(1),
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return GlassmorphismCard(
              child: Padding(
                padding: EdgeInsets.all(responsive.sp(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      feature['icon'] as IconData,
                      color: AppColors.primary,
                      size: responsive.sp(24),
                    ),
                    SizedBox(height: responsive.hp(0.5)),
                    Text(
                      feature['title'] as String,
                      style: TextStyle(
                        fontSize: responsive.sp(12),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsive.hp(0.3)),
                    Text(
                      feature['description'] as String,
                      style: TextStyle(
                        fontSize: responsive.sp(10),
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDeveloperInfo(ResponsiveHelper responsive) {
    return GlassmorphismCard(
      child: Padding(
        padding: EdgeInsets.all(responsive.sp(16)),
        child: Row(
          children: [
            Container(
              width: responsive.wp(15),
              height: responsive.wp(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.gradientLavender,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                Icons.code,
                color: Colors.white,
                size: responsive.sp(20),
              ),
            ),
            SizedBox(width: responsive.wp(4)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Developed with ❤️ by',
                    style: TextStyle(
                      fontSize: responsive.sp(12),
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    'Vaishnavi Tripathi',
                    style: TextStyle(
                      fontSize: responsive.sp(18),
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    'Flutter Developer',
                    style: TextStyle(
                      fontSize: responsive.sp(12),
                      color: Colors.grey.shade600,
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

  Widget _buildSocialLinks(ResponsiveHelper responsive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Gmail
        _buildSocialButton(
          responsive,
          icon: Icons.email_rounded,
          color: const Color(0xFFD44638), // Gmail red
          onTap: () => _launchURL('mailto:vaishnavitripathi1003@gmail.com'),
        ),

        // GitHub
        _buildSocialButton(
          responsive,
          icon: Icons.code_rounded, // Better icon for GitHub
          color: const Color(0xFF2E7D32) , // GitHub black
          onTap: () => _launchURL('https://github.com/Vaishnavitripathi1003'),
        ),

        // LinkedIn
        _buildSocialButton(
          responsive,
          icon: Icons.business_center_rounded, // Better icon for LinkedIn
          color: const Color(0xFF0077B5), // LinkedIn blue
          onTap: () => _launchURL('https://www.linkedin.com/in/vaishnavi-tripathi-80569024'),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
      ResponsiveHelper responsive, {
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(responsive.r(30)),
      child: Container(
        padding: EdgeInsets.all(responsive.sp(10)),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: responsive.sp(20),
        ),
      ),
    );
  }

// Update _launchURL for email
  Future<void> _launchURL(String url) async {
    try {
      // Handle email separately
      if (url.startsWith('mailto:')) {
        final emailUrl = Uri.parse(url);
        if (await canLaunchUrl(emailUrl)) {
          await launchUrl(emailUrl);
        }
      } else {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');

      // Show snackbar for error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open link'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
  Widget _buildTechStack(ResponsiveHelper responsive) {
    final techs = [
      {'name': 'Flutter', 'icon': '🔥'},
      {'name': 'Dart', 'icon': '🎯'},
      {'name': 'BLoC', 'icon': '🔄'},
      {'name': 'REST API', 'icon': '🌐'},
    ];

    return GlassmorphismCard(
      child: Padding(
        padding: EdgeInsets.all(responsive.sp(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tech Stack',
              style: TextStyle(
                fontSize: responsive.sp(16),
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: responsive.hp(1)),
            Wrap(
              spacing: responsive.wp(2),
              runSpacing: responsive.hp(1),
              children: techs.map((tech) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(3),
                    vertical: responsive.hp(0.5),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(responsive.r(20)),
                  ),
                  child: Text(
                    '${tech['icon']} ${tech['name']}',
                    style: TextStyle(
                      fontSize: responsive.sp(12),
                      color: AppColors.primary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcknowledgments(ResponsiveHelper responsive) {
    return GlassmorphismCard(
      child: Padding(
        padding: EdgeInsets.all(responsive.sp(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acknowledgments',
              style: TextStyle(
                fontSize: responsive.sp(16),
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: responsive.hp(1)),
            _buildAcknowledgementItem(
              'OpenWeather API',
              'For providing accurate weather data',
            ),
            _buildAcknowledgementItem(
              'Quote API',
              'For daily inspirational quotes',
            ),
            _buildAcknowledgementItem(
              'Flutter Community',
              'For amazing packages and support',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcknowledgementItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.favorite,
            size: 12,
            color: Colors.red.shade300,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyright(ResponsiveHelper responsive) {
    return Text(
      '© 2024 Weather Wonders. All rights reserved.',
      style: TextStyle(
        fontSize: responsive.sp(10),
        color: Colors.grey.shade500,
      ),
    );
  }


}