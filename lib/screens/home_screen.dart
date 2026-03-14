import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/header/user_greeting_widget.dart';
import '../widgets/header/location_pill_widget.dart';
import '../widgets/dashboard/dashboard_grid.dart';
import '../widgets/cards/essence_analysis_banner.dart';
import '../widgets/quick_actions/quick_action_grid.dart';
import '../widgets/activities/activity_card.dart';
import '../widgets/bottom_nav/custom_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  final bool showBottomNav;

  const HomeScreen({super.key, this.showBottomNav = true});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0; // Home tab when standalone

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ─── HEADER ───────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenHorizontal,
                    AppSpacing.headerTop,
                    AppSpacing.screenHorizontal,
                    0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Flexible(
                        flex: 1,
                        child: UserGreetingWidget(
                          avatarUrl: 'assets/images/avatar.png',
                          name: 'Monica',
                          subtitle: 'Ready to wear your best fragrance?',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.cardBg.withValues(alpha: 0.6),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.cardBorder.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.settings_rounded,
                                  color: AppColors.textSecondary,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: const LocationPillWidget(
                                city: 'Paris',
                                flagEmoji: '🇫🇷',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ─── DASHBOARD GRID (Weather + Device + Cartridge) ──────────
              const SliverToBoxAdapter(
                child: DashboardGrid(
                  batteryPercent: 65,
                  cartridgeVolumePercent: 70,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sectionGap)),

              // ─── ESSENCE ANALYSIS BANNER ──────────────────────────────
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                  child: EssenceAnalysisBanner(),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ─── QUICK ACTIONS ────────────────────────────────────────
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                  child: QuickActionGrid(),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ─── ACTIVITIES SECTION ───────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                  child: Text('Activities', style: AppTextStyles.sectionTitle),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // Horizontal scroll — 75% card width for natural peek effect
              SliverToBoxAdapter(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth =
                        (constraints.maxWidth * 0.75).clamp(260.0, 320.0);
                    return SizedBox(
                      height: 160,
                      child: ListView.separated(
                        padding: const EdgeInsets.only(
                          left: AppSpacing.screenHorizontal,
                          right: 80,
                        ),
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        clipBehavior: Clip.none,
                        itemCount: 5,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: AppSpacing.cardGap),
                        itemBuilder: (context, index) => ActivityCard(
                          date: '28 Jan 2026',
                          title:
                              'The Urban Shield — Optimized for High Humidity',
                          imageAsset: 'assets/images/ysl_libre.png',
                          width: cardWidth,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Photo strip below activities
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 72,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: 6,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) => ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.small),
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(AppRadius.small),
                          border: Border.all(
                            color: AppColors.cardBorder.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Icon(
                          Icons.image_rounded,
                          color: AppColors.textMuted,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // ─── PROMO BANNER ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            const Color(0xFF1A1A2E),
                            const Color(0xFF16213E),
                            const Color(0xFF0F3460).withValues(alpha: 0.9),
                          ],
                        ),
                        border: Border.all(
                          color: AppColors.cardBorder.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Decorative face/profile silhouettes
                          Positioned(
                            left: 20,
                            top: 0,
                            bottom: 0,
                            child: Opacity(
                              opacity: 0.15,
                              child: Icon(
                                Icons.face_rounded,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 30,
                            top: 0,
                            bottom: 0,
                            child: Opacity(
                              opacity: 0.12,
                              child: Icon(
                                Icons.face_rounded,
                                size: 70,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Center(
                            child: Text(
                              'Featured',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom padding for floating nav bar
              SliverToBoxAdapter(
                child: SizedBox(
                  height: AppSpacing.navBarHeight + AppSpacing.navBarBottom + 16,
                ),
              ),
            ],
          ),
      bottomNavigationBar: widget.showBottomNav
          ? CustomBottomNav(
              currentIndex: _currentNavIndex,
              onTap: (i) => setState(() => _currentNavIndex = i),
            )
          : null,
    );
  }
}
