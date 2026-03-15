import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/bottom_nav/custom_bottom_nav.dart';
import 'ar_visualization_screen.dart';
import 'chat_mia_screen.dart';
import 'home_screen.dart';
import 'perfume_detail_screen.dart';
import 'user_profile_screen.dart';

/// Main shell that hosts the bottom nav and switches between screens.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentNavIndex = 1; // Search (Perfume Detail) active by default

  List<Widget> get _screens => [
    HomeScreen(
      showBottomNav: false,
      onAnalyzerTap: () => setState(() => _currentNavIndex = 1), // Navigate to PerfumeDetail (Analyzer)
      onChatMiaTap: () => setState(() => _currentNavIndex = 4), // Navigate to ChatMia
      onARTap: () => setState(() => _currentNavIndex = 2), // Navigate to AR
      onClosetTap: () => setState(() => _currentNavIndex = 1), // Navigate to PerfumeDetail (Closet)
    ),
    const PerfumeDetailScreen(showBottomNav: false),
    ARVisualizationScreen(
      showBottomNav: false,
      onBackPressed: () => setState(() => _currentNavIndex = 0), // Go back to home
    ),
    const UserProfileScreen(showBottomNav: false),
    ChatMiaScreen(
      showBottomNav: false,
      onBackPressed: () => setState(() => _currentNavIndex = 0), // Go back to home
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Hide navbar when in AR visualization or ChatMia screen
    final isARMode = _currentNavIndex == 2;
    final isChatMiaMode = _currentNavIndex == 4;
    final hideBottomNav = isARMode || isChatMiaMode;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Layer 1: Gradient background (full screen)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.background,
              ),
            ),
          ),
          // Layer 2: Scroll body
          SafeArea(
            child: IndexedStack(
              index: _currentNavIndex,
              children: _screens,
            ),
          ),
          // Layer 3: Floating nav bar (hidden in AR mode or Chat Mia mode)
          if (!hideBottomNav)
            Positioned(
              left: AppSpacing.screenHorizontal,
              right: AppSpacing.screenHorizontal,
              bottom: AppSpacing.navBarBottom,
              child: CustomBottomNav(
                currentIndex: _currentNavIndex,
                onTap: (i) => setState(() => _currentNavIndex = i),
              ),
            ),
        ],
      ),
    );
  }
}
