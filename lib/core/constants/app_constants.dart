import 'dart:ui';

class AppConstants {
  static const String themeKey = 'theme_mode';
  static const String defaultCity = 'New York';

  // App Version
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Developer Info
  static const String developerName = 'Your Name';
  static const String developerEmail = 'your.email@example.com';
  static const String developerGithub = 'https://github.com/yourusername';
  static const String developerLinkedIn = 'https://linkedin.com/in/yourusername';
  static const String developerPortfolio = 'https://yourportfolio.com';

  // App Info
  static const String appDescription = 'Weather Wonders is a beautiful and intuitive '
      'weather application that provides real-time weather information, forecasts, '
      'and inspiring quotes to start your day.';



  // Spacing constants - Strictly following 8/16/24 rule
  static const double spacing4 = 4.0;    // Quarter unit (for micro spacing)
  static const double spacing8 = 8.0;    // Base unit
  static const double spacing12 = 12.0;  // 1.5x base (for tighter sections)
  static const double spacing16 = 16.0;  // 2x base - Primary unit
  static const double spacing20 = 20.0;  // 2.5x base (for comfortable spacing)
  static const double spacing24 = 24.0;  // 3x base - Secondary unit
  static const double spacing32 = 32.0;  // 4x base - Large sections
  static const double spacing40 = 40.0;  // 5x base - Section spacing
  static const double spacing48 = 48.0;  // 6x base - Screen level spacing
  static const double spacing56 = 56.0;  // 7x base - Large gaps
  static const double spacing64 = 64.0;  // 8x base - Maximum spacing

  // Border radius - Modern, consistent curves
  static const double radiusNone = 0.0;
  static const double radiusSmall = 4.0;    // Subtle rounding (buttons, chips)
  static const double radiusMedium = 8.0;   // Standard rounding (cards, inputs)
  static const double radiusLarge = 12.0;   // Generous rounding (modals, sheets)
  static const double radiusXLarge = 16.0;  // Extra large (featured cards)
  static const double radiusXXLarge = 20.0; // 2x large (hero elements)
  static const double radiusRound = 100.0;  // Fully round (avatars, icons)
  // In app_constants.dart, add:
  static const double radiusHuge = 24.0;   // Extra large for cards
  static const double radiusMassive = 32.0; // Maximum rounding

  // Typography Hierarchy - Following modern design principles
  static const double fontSizeDisplayLarge = 34.0;  // Hero numbers (temperature)
  static const double fontSizeDisplayMedium = 28.0; // City names
  static const double fontSizeHeadlineLarge = 24.0; // Section headers
  static const double fontSizeHeadlineMedium = 20.0; // Card titles
  static const double fontSizeTitleLarge = 18.0;    // Subsection headers
  static const double fontSizeTitleMedium = 16.0;    // Body emphasis
  static const double fontSizeBodyLarge = 14.0;      // Regular body text
  static const double fontSizeBodyMedium = 12.0;     // Secondary text
  static const double fontSizeLabelLarge = 11.0;     // Labels, captions
  static const double fontSizeLabelSmall = 10.0;     // Tiny labels

  // Font weights - Consistent hierarchy
  static final FontWeight weightLight = FontWeight.w300;
  static final FontWeight weightRegular = FontWeight.w400;
  static final FontWeight weightMedium = FontWeight.w500;
  static final FontWeight weightSemiBold = FontWeight.w600;
  static final FontWeight weightBold = FontWeight.w700;

  // Icon sizes - Consistent with spacing
  static const double iconSizeTiny = 12.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeLarge = 24.0;
  static const double iconSizeXLarge = 28.0;
  static const double iconSizeXXLarge = 32.0;
  static const double iconSizeHuge = 40.0;

  // Animation durations - Smooth & responsive
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationPage = Duration(milliseconds: 400);
}