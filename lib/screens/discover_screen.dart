import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../widgets/bottom_nav/custom_bottom_nav.dart';

class _FragranceItem {
  final String name;
  final String brand;
  final String family;
  final int matchScore;
  final String topNote;
  final String middleNote;
  final String baseNote;
  final Color accentColor;

  const _FragranceItem({
    required this.name,
    required this.brand,
    required this.family,
    required this.matchScore,
    required this.topNote,
    required this.middleNote,
    required this.baseNote,
    required this.accentColor,
  });
}

const _kFragrances = [
  _FragranceItem(
    name: 'Libre',
    brand: 'YSL',
    family: 'Floral',
    matchScore: 97,
    topNote: 'Lavender',
    middleNote: 'Orange Blossom',
    baseNote: 'Musk',
    accentColor: Color(0xFF8B3AED),
  ),
  _FragranceItem(
    name: 'Mon Paris',
    brand: 'YSL',
    family: 'Floral',
    matchScore: 91,
    topNote: 'Strawberry',
    middleNote: 'Peony',
    baseNote: 'Patchouli',
    accentColor: Color(0xFFFF6B9D),
  ),
  _FragranceItem(
    name: 'Sauvage',
    brand: 'Dior',
    family: 'Fresh',
    matchScore: 88,
    topNote: 'Bergamot',
    middleNote: 'Lavender',
    baseNote: 'Ambroxan',
    accentColor: Color(0xFF4DD9FF),
  ),
  _FragranceItem(
    name: 'Oud Wood',
    brand: 'TF',
    family: 'Woody',
    matchScore: 85,
    topNote: 'Oud',
    middleNote: 'Rosewood',
    baseNote: 'Vanilla',
    accentColor: Color(0xFFFFB700),
  ),
  _FragranceItem(
    name: 'Black Orchid',
    brand: 'TF',
    family: 'Oriental',
    matchScore: 82,
    topNote: 'Black Truffle',
    middleNote: 'Orchid',
    baseNote: 'Sandalwood',
    accentColor: Color(0xFF8B3AED),
  ),
  _FragranceItem(
    name: 'Aventus',
    brand: 'Creed',
    family: 'Fresh',
    matchScore: 79,
    topNote: 'Pineapple',
    middleNote: 'Birch',
    baseNote: 'Oakmoss',
    accentColor: Color(0xFF4DD9FF),
  ),
  _FragranceItem(
    name: 'Baccarat Rouge',
    brand: '540',
    family: 'Oriental',
    matchScore: 94,
    topNote: 'Saffron',
    middleNote: 'Jasmine',
    baseNote: 'Fir Resin',
    accentColor: Color(0xFFFF9500),
  ),
  _FragranceItem(
    name: 'Acqua di Gio',
    brand: 'Armani',
    family: 'Citrus',
    matchScore: 76,
    topNote: 'Bergamot',
    middleNote: 'Neroli',
    baseNote: 'Cedar',
    accentColor: Color(0xFF4DD9FF),
  ),
];

const _kCategories = ['All', 'Floral', 'Woody', 'Citrus', 'Oriental', 'Fresh'];

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key, this.showBottomNav = false});

  final bool showBottomNav;

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  int _selectedCategoryIndex = 0;
  String _searchQuery = '';
  int _currentNavIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  List<_FragranceItem> get _filteredFragrances {
    return _kFragrances.where((f) {
      final matchesCategory =
          _selectedCategoryIndex == 0 ||
          f.family == _kCategories[_selectedCategoryIndex];
      final normalizedQuery = _searchQuery.toLowerCase();
      final matchesSearch =
          _searchQuery.isEmpty ||
          f.name.toLowerCase().contains(normalizedQuery) ||
          f.brand.toLowerCase().contains(normalizedQuery);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fragrances = _filteredFragrances;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
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
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _DiscoverHeader(
                    onBackTap: () => Navigator.of(context).maybePop(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _DiscoverSearchBar(
                        controller: _searchController,
                        query: _searchQuery,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        onClear: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 44,
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.screenHorizontal,
                          ),
                          itemBuilder: (context, index) {
                            final isActive = _selectedCategoryIndex == index;
                            return GestureDetector(
                              onTap: () => setState(
                                () => _selectedCategoryIndex = index,
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                curve: Curves.easeOut,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? AppColors.accentCyan.withValues(
                                          alpha: 0.15,
                                        )
                                      : AppColors.cardBg,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.pill,
                                  ),
                                  border: Border.all(
                                    color: isActive
                                        ? AppColors.accentCyan
                                        : AppColors.borderCyan.withValues(
                                            alpha: 0.2,
                                          ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    _kCategories[index],
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: isActive
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: isActive
                                          ? AppColors.accentCyan
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemCount: _kCategories.length,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenHorizontal,
                      AppSpacing.sectionGap,
                      AppSpacing.screenHorizontal,
                      12,
                    ),
                    child: Text(
                      'FRAGRANCES FOR YOU',
                      style: AppTextStyles.sectionTitle.copyWith(
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: fragrances.isEmpty
                      ? const _DiscoverEmptyState()
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: AppSpacing.gridGap,
                                crossAxisSpacing: AppSpacing.gridGap,
                                childAspectRatio: 0.72,
                              ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.screenHorizontal,
                          ),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: fragrances.length,
                          itemBuilder: (context, index) =>
                              _DiscoverCard(item: fragrances[index]),
                        ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.navBarHeight + 16),
                ),
              ],
            ),
          ),
          if (widget.showBottomNav)
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

class _DiscoverHeader extends StatelessWidget {
  const _DiscoverHeader({required this.onBackTap});

  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.headerTop,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBackTap,
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
                Icons.arrow_back_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Discover',
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
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
                Icons.tune_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscoverSearchBar extends StatelessWidget {
  const _DiscoverSearchBar({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        8,
        AppSpacing.screenHorizontal,
        0,
      ),
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderCyan.withValues(alpha: 0.3)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search fragrances...',
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textMuted,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textMuted,
            size: 20,
          ),
          suffixIcon: query.isNotEmpty
              ? GestureDetector(
                  onTap: onClear,
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textMuted,
                    size: 18,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _DiscoverCard extends StatelessWidget {
  const _DiscoverCard({required this.item});

  final _FragranceItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.cardShimmer,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: item.accentColor.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 9,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.card),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          item.accentColor.withValues(alpha: 0.18),
                          AppColors.cardBg,
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Icon(
                      Icons.water_drop_rounded,
                      size: 48,
                      color: item.accentColor.withValues(alpha: 0.7),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgDeep.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(
                          color: AppColors.accentGold.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            size: 10,
                            color: AppColors.accentGold,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${item.matchScore}%',
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accentGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.brand,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: item.accentColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.name,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.family,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${item.topNote} · ${item.middleNote} · ${item.baseNote}',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMuted,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscoverEmptyState extends StatelessWidget {
  const _DiscoverEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: 32,
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 36,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 10),
            Text(
              'No fragrances found',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
