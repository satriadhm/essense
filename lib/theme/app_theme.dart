import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color bgDeep = Color(0xFF0A0E27);
  static const Color bgMid = Color(0xFF11163A);
  static const Color cardBg = Color(0xFF1A1E3F);
  static const Color cardBgLight = Color(0xFF151B36);
  static const Color cardBorder = Color(0xFF4DD9FF);

  // Accents (legacy names kept for compatibility)
  static const Color accentOrange = Color(0xFFFF9500);
  static const Color accentGold = Color(0xFFFFB700);
  static const Color accentCyan = Color(0xFF4DD9FF);
  static const Color borderCyan = Color(0xFF4DD9FF);
  static const Color accentPurple = accentOrange;
  static const Color accentViolet = accentGold;
  static const Color accentBlue = accentCyan;
  static const Color pillBg = Color(0x331A1E3F);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0A0);
  static const Color textMuted = Color(0xFF6B7280);

  // Misc
  static const Color divider = Color(0xFF1E2D5A);
  static const Color navBarBg = Color(0xFF0A0E27);
  static const Color activeNavPill = Color(0xFFFF9500);

  // Grid cards — shared foundation (deep navy)
  static const Color cardNavyBase = Color(0xFF1A1E3F);
  static const Color cardNavyMid = Color(0xFF1B2045);
  static const Color cardNavyDark = Color(0xFF151B36);

  // Large numbers — near-white for readability
  static const Color statWhiteCool = Color(0xFFE8F7FF);
  static const Color statWhiteWarm = Color(0xFFFFF2DE);

  // Card accents
  static const Color accentWeather = Color(0xFF4DD9FF);
  static const Color accentDevice = Color(0xFFFF9500);
  static const Color accentCartridge = Color(0xFFFFB700);

  // Icon treatment — dark fill + lighter border
  static const Color iconFillDark = Color(0xFF1A1F35);
  static const Color iconBorderGlow = Color(0xFF4A5A8A);

  // Analysis flow palette
  static const Color analysisDarkBlue = Color(0xFF1E3A8A);
  static const Color analysisPurpleStart = Color(0xFF8B3AED);
  static const Color analysisPurpleEnd = Color(0xFF6D28D9);
  static const Color analysisLightSurface = Color(0xFFE5E7EB);
  static const Color analysisMutedCyan = Color(0xFF60A5FA);
  static const Color analysisGolden = Color(0xFFFFD700);
}

class AppGradients {
  static const LinearGradient background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A0E27), Color(0xFF11163A), Color(0xFF0A0E27)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient cardShimmer = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.cardNavyMid, AppColors.cardNavyBase],
  );

  static const LinearGradient weatherCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.cardNavyMid,
      AppColors.cardNavyBase,
      AppColors.cardNavyDark,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient deviceCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1E3F), Color(0xFF171C3A), Color(0xFF151B36)],
  );

  static const LinearGradient cartridgeCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF222050), Color(0xFF1A1E3F), Color(0xFF151B36)],
  );

  static const LinearGradient analysisBanner = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1E3F), Color(0xFF141A35), Color(0xFF111632)],
  );

  static const LinearGradient analysisPrimaryButton = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.analysisPurpleStart, AppColors.analysisPurpleEnd],
  );
}

class AppTextStyles {
  static const TextStyle greeting = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  static const TextStyle greetingSub = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  static const TextStyle tempLarge = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.0,
  );
  static const TextStyle percentLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.0,
  );
  static const TextStyle cardTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  static const TextStyle cardSub = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.2,
  );
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );
  static const TextStyle bannerTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  static const TextStyle bannerSub = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  static const TextStyle iconLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.2,
  );

  // Analysis flow text styles
  static const TextStyle h1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  static const TextStyle h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.6,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.3,
  );
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
    height: 1.3,
  );
}

class AppRadius {
  static const double card = 16.0;
  static const double pill = 50.0;
  static const double button = 12.0;
  static const double icon = 16.0;
  static const double small = 8.0;
}

class AppSpacing {
  static const double screenHorizontal = 16.0;
  static const double gridHorizontal = 16.0;
  static const double gridGap = 12.0;
  static const double cardGap = 12.0;
  static const double sectionGap = 20.0;
  static const double headerTop = 16.0;
  static const double headerBottom = 24.0;
  static const double navBarBottom = 12.0;
  static const double navBarHeight = 64.0;
}

class AppTypography {
  static const TextStyle heroNumber = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.0,
  );
  static const TextStyle namedState = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle supportingStat = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle contextual = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle microLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );
}
