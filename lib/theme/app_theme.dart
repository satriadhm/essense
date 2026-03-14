import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color bgDeep        = Color(0xFF0A1628);
  static const Color bgMid         = Color(0xFF0F1E3D);
  static const Color cardBg        = Color(0xFF152040);
  static const Color cardBgLight   = Color(0xFF1C2B50);
  static const Color cardBorder    = Color(0xFF243360);

  // Accents
  static const Color accentPurple  = Color(0xFF6B5CE7);
  static const Color accentViolet  = Color(0xFF8B7FFF);
  static const Color accentBlue    = Color(0xFF3B82F6);
  static const Color pillBg        = Color(0xFF2A1F6E);

  // Text
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFADB5D6);
  static const Color textMuted     = Color(0xFF6B7BA4);

  // Misc
  static const Color divider       = Color(0xFF1E2D5A);
  static const Color navBarBg      = Color(0xFF101828);
  static const Color activeNavPill = Color(0xFFFFFFFF);

  // Grid cards — shared foundation (deep navy)
  static const Color cardNavyBase   = Color(0xFF1A2545);
  static const Color cardNavyMid    = Color(0xFF1E2A50);
  static const Color cardNavyDark   = Color(0xFF1E2245);

  // Large numbers — near-white for readability
  static const Color statWhiteCool  = Color(0xFFD8E4F8);  // weather
  static const Color statWhiteWarm  = Color(0xFFD8D4F8);  // device, cartridge

  // Card accents
  static const Color accentWeather  = Color(0xFF5A82D0);  // blue, meteorological
  static const Color accentDevice   = Color(0xFF4A9E6B);  // green, device status
  static const Color accentCartridge = Color(0xFF7870C0);  // violet, glass-like

  // Icon treatment — dark fill + lighter border
  static const Color iconFillDark   = Color(0xFF1A1F35);
  static const Color iconBorderGlow = Color(0xFF4A5A8A);
}

class AppGradients {
  static const LinearGradient background = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A1628), Color(0xFF0D1F45), Color(0xFF0A1628)],
    stops: [0.0, 0.5, 1.0],
  );

  // Generic card (activity, etc.) — deep navy base
  static const LinearGradient cardShimmer = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.cardNavyMid, AppColors.cardNavyBase],
  );

  // Weather — purest navy
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

  // Device — dark green
  static const LinearGradient deviceCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A2E2A),
      Color(0xFF152520),
      Color(0xFF1A2528),
    ],
  );

  // Cartridge — indigo/purple tint
  static const LinearGradient cartridgeCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF222050),
      Color(0xFF1E2245),
      Color(0xFF1A1F45),
    ],
  );

  static const LinearGradient analysisBanner = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF1A1040), Color(0xFF2A1F6E), Color(0xFF1A1040)],
  );
}

class AppTextStyles {
  static const TextStyle greeting = TextStyle(
    fontSize: 24, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, letterSpacing: -0.5,
  );
  static const TextStyle greetingSub = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w400,
    color: AppColors.textSecondary, fontStyle: FontStyle.italic,
  );
  static const TextStyle tempLarge = TextStyle(
    fontSize: 64, fontWeight: FontWeight.w800,
    color: AppColors.textPrimary, height: 1.0,
  );
  static const TextStyle percentLarge = TextStyle(
    fontSize: 48, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, height: 1.0,
  );
  static const TextStyle cardTitle = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle cardSub = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const TextStyle bannerTitle = TextStyle(
    fontSize: 20, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, letterSpacing: -0.3,
  );
  static const TextStyle bannerSub = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: AppColors.textSecondary, height: 1.5,
  );
  static const TextStyle iconLabel = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
}

class AppRadius {
  static const double card    = 20.0;
  static const double pill    = 50.0;
  static const double button  = 12.0;
  static const double icon    = 16.0;
  static const double small   = 8.0;
}

/// Spacing constants for the dashboard grid and card layout.
class AppSpacing {
  static const double screenHorizontal = 20.0;
  static const double gridHorizontal   = 20.0;
  static const double gridGap          = 12.0;   // between left/right columns
  static const double cardGap          = 12.0;   // between stacked right cards
  static const double sectionGap       = 20.0;   // below grid section
  static const double headerTop        = 16.0;
  static const double headerBottom     = 24.0;
  static const double navBarBottom     = 24.0;
  static const double navBarHeight     = 80.0;
}

/// 5-level typography scale for dashboard cards.
class AppTypography {
  // Level 1 (40–48px bold) — Hero numbers
  static const TextStyle heroNumber = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.0,
  );
  // Level 2 (15–16px semibold) — Named states
  static const TextStyle namedState = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  // Level 3 (14px medium) — Supporting stats
  static const TextStyle supportingStat = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  // Level 4 (12px regular) — Contextual text
  static const TextStyle contextual = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  // Level 5 (10–11px regular) — Micro labels
  static const TextStyle microLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );
}
