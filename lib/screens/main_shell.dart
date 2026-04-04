import 'package:flutter/material.dart';

import '../models/results_data.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav/custom_bottom_nav.dart';
import 'analysis/scan_product_screen.dart';
import 'ar_visualization_screen.dart';
import 'chat_mia_screen.dart';
import 'community_screen.dart';
import 'discover_screen.dart';
import 'home_screen.dart';
import 'journal_screen.dart';
import 'my_closet_screen.dart';
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
      onAnalyzeTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const ScanProductScreen())),
      onChatMiaTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const ChatMiaScreen(showBottomNav: false),
        ),
      ),
      onARTap: () => setState(() => _showArScreen = true),
      onClosetTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const MyClosetScreen())),
      onDiscoverTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const DiscoverScreen())),
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
                    data: ResultsData.demo(),
                  )
                : IndexedStack(index: _currentNavIndex, children: _screens),
          ),
        ],
      ),
    );
  }
}
