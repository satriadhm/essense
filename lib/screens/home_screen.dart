import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard/dashboard_grid.dart';
import '../widgets/cards/essence_analysis_banner.dart';
import '../widgets/quick_actions/quick_action_grid.dart';
import '../widgets/activities/activity_card.dart';
import '../widgets/bottom_nav/custom_bottom_nav.dart';
import '../services/weather_provider.dart';

class HomeScreen extends StatefulWidget {
  final bool showBottomNav;
  final VoidCallback? onAnalyzeTap;
  final VoidCallback? onChatMiaTap;
  final VoidCallback? onARTap;
  final VoidCallback? onClosetTap;
  final VoidCallback? onDiscoverTap;

  const HomeScreen({
    super.key,
    this.showBottomNav = true,
    this.onAnalyzeTap,
    this.onChatMiaTap,
    this.onARTap,
    this.onClosetTap,
    this.onDiscoverTap,
  });
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  late final ScrollController _scrollController;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (!mounted) return;
        setState(() => _scrollOffset = _scrollController.offset);
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(
        context,
        listen: false,
      ).fetchWeatherByLocation();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const heroHeight = 240.0;
    final hideProgress = (_scrollOffset / 220).clamp(0.0, 1.0);
    final heroTop = -(heroHeight * hideProgress);
    final heroOpacity = 1.0 - hideProgress;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            top: heroTop,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: heroOpacity,
              child: SizedBox(
                height: heroHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/hero.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                    Container(color: Colors.black.withValues(alpha: 0.4)),
                  ],
                ),
              ),
            ),
          ),
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenHorizontal,
                    AppSpacing.headerTop + 8,
                    AppSpacing.screenHorizontal,
                    0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 24),
                      const Text(
                        'ESSENSE',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 24,
                            color: AppColors.textPrimary,
                          ),
                          SizedBox(width: 12),
                          Icon(
                            Icons.notifications_none_rounded,
                            size: 24,
                            color: AppColors.textPrimary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning,',
                        style: AppTextStyles.greeting.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Jasmine',
                              style: AppTextStyles.greeting.copyWith(
                                fontSize: 28,
                                height: 1.2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const TextSpan(text: '  '),
                            const TextSpan(
                              text: '🔥',
                              style: TextStyle(fontSize: 24),
                            ),
                            TextSpan(
                              text: '7',
                              style: AppTextStyles.greeting.copyWith(
                                color: AppColors.accentOrange,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
              const SliverToBoxAdapter(
                child: DashboardGrid(
                  batteryPercent: 65,
                  cartridgeVolumePercent: 70,
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.sectionGap),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal,
                  ),
                  child: EssenceAnalysisBanner(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal,
                  ),
                  child: QuickActionGrid(
                    onAnalyzeTap: widget.onAnalyzeTap,
                    onChatMiaTap: widget.onChatMiaTap,
                    onARTap: widget.onARTap,
                    onClosetTap: widget.onClosetTap,
                    onDiscoverTap: widget.onDiscoverTap,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal,
                  ),
                  child: Text(
                    'LAST WEAR',
                    style: AppTextStyles.sectionTitle.copyWith(
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenHorizontal,
                    12,
                    AppSpacing.screenHorizontal,
                    0,
                  ),
                  child: const ActivityCard(
                    date: 'Yesterday · Paris, FR',
                    title:
                        'Your most stable wear this month — the scent held beautifully through the afternoon.',
                    imageAsset: 'assets/images/activity_card_2.png',
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal,
                  ),
                  child: Text(
                    'DAILY UPDATES',
                    style: AppTextStyles.sectionTitle.copyWith(
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 160,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenHorizontal,
                      12,
                      AppSpacing.screenHorizontal,
                      0,
                    ),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
                    itemBuilder: (_, index) => _DailyUpdateCard(
                      imageAsset: index == 0
                          ? 'assets/images/mon_paris.png'
                          : index == 1
                          ? 'assets/images/activity_card_1.png'
                          : 'assets/images/activity_card_2.png',
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height:
                      AppSpacing.navBarHeight + AppSpacing.navBarBottom + 16,
                ),
              ),
            ],
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

class _DailyUpdateCard extends StatelessWidget {
  final String imageAsset;

  const _DailyUpdateCard({
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: AppColors.cardBgLight),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
