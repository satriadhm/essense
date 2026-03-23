import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/bottom_nav/custom_bottom_nav.dart';
import 'ar_visualization_screen.dart';
import 'community_screen.dart';
import 'home_screen.dart';
import 'journal_screen.dart';
import 'user_profile_screen.dart';

/// Main shell that hosts the bottom nav and switches between screens.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentNavIndex = 0;
  bool _showArScreen = false;

  List<Widget> get _screens => [
    HomeScreen(
      showBottomNav: false,
      onAnalyzeTap: () => setState(() => _currentNavIndex = 1),
      onChatMiaTap: () => setState(() => _currentNavIndex = 2),
      onARTap: () => setState(() => _showArScreen = true),
      onClosetTap: () => setState(() => _currentNavIndex = 3),
      onDiscoverTap: () => setState(() => _currentNavIndex = 1),
    ),
    const JournalScreen(showBottomNav: false),
    const CommunityScreen(showBottomNav: false),
    const UserProfileScreen(showBottomNav: false),
  ];

  @override
  Widget build(BuildContext context) {
    final hideBottomNav = _showArScreen;

    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: hideBottomNav
          ? null
          : CustomBottomNav(
              currentIndex: _currentNavIndex.clamp(0, 3),
              onTap: (i) => setState(() {
                _showArScreen = false;
                _currentNavIndex = i;
              }),
            ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.background,
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: _showArScreen
                ? ARVisualizationScreen(
                    showBottomNav: false,
                    onBackPressed: () => setState(() => _showArScreen = false),
                  )
                : IndexedStack(index: _currentNavIndex, children: _screens),
          ),
        ],
      ),
    );
  }
}
