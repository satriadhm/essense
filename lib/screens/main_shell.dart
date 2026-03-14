import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/bottom_nav/custom_bottom_nav.dart';
import 'ar_visualization_screen.dart';
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
    const HomeScreen(showBottomNav: false),
    const PerfumeDetailScreen(showBottomNav: false),
    const ARVisualizationScreen(showBottomNav: false),
    const UserProfileScreen(showBottomNav: false),
  ];

  @override
  Widget build(BuildContext context) {
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
          // Layer 3: Floating nav bar
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
