import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../widgets/bottom_nav/custom_bottom_nav.dart';

class _ClosetItem {
  final String name;
  final String brand;
  final String family;
  final List<String> notes;
  final String lastWorn;
  final int volumePercent;
  final Color accentColor;

  const _ClosetItem({
    required this.name,
    required this.brand,
    required this.family,
    required this.notes,
    required this.lastWorn,
    required this.volumePercent,
    required this.accentColor,
  });
}

const _kClosetItems = [
  _ClosetItem(
    name: 'Libre',
    brand: 'YSL',
    family: 'Floral',
    notes: ['Lavender', 'Musk', 'Vanilla'],
    lastWorn: 'Yesterday',
    volumePercent: 72,
    accentColor: Color(0xFF8B3AED),
  ),
  _ClosetItem(
    name: 'Mon Paris',
    brand: 'YSL',
    family: 'Floral',
    notes: ['Strawberry', 'Peony'],
    lastWorn: '3 days ago',
    volumePercent: 45,
    accentColor: Color(0xFFFF6B9D),
  ),
  _ClosetItem(
    name: 'Sauvage',
    brand: 'Dior',
    family: 'Fresh',
    notes: ['Bergamot', 'Ambroxan'],
    lastWorn: '1 week ago',
    volumePercent: 88,
    accentColor: Color(0xFF4DD9FF),
  ),
  _ClosetItem(
    name: 'Oud Wood',
    brand: 'Tom Ford',
    family: 'Woody',
    notes: ['Oud', 'Rosewood', 'Cedar'],
    lastWorn: '2 weeks ago',
    volumePercent: 30,
    accentColor: Color(0xFFFFB700),
  ),
  _ClosetItem(
    name: 'Black Orchid',
    brand: 'Tom Ford',
    family: 'Oriental',
    notes: ['Orchid', 'Truffle'],
    lastWorn: '1 month ago',
    volumePercent: 60,
    accentColor: Color(0xFF8B3AED),
  ),
  _ClosetItem(
    name: 'Y EDP',
    brand: 'YSL',
    family: 'Fresh',
    notes: ['Bergamot', 'Lavender', 'Cedar'],
    lastWorn: 'Today',
    volumePercent: 95,
    accentColor: Color(0xFF4DD9FF),
  ),
];

class MyClosetScreen extends StatefulWidget {
  const MyClosetScreen({super.key, this.showBottomNav = false});

  final bool showBottomNav;

  @override
  State<MyClosetScreen> createState() => _MyClosetScreenState();
}

class _MyClosetScreenState extends State<MyClosetScreen> {
  int _selectedTabIndex = 0;
  int _currentNavIndex = 3;
  Set<int> _favoriteIds = {0, 2};

  List<MapEntry<int, _ClosetItem>> get _filteredItems {
    final entries = _kClosetItems.asMap().entries.toList();
    switch (_selectedTabIndex) {
      case 1:
        return entries.where((e) => _favoriteIds.contains(e.key)).toList();
      case 2:
        const recent = {'Today', 'Yesterday', '2 days ago', '3 days ago'};
        return entries.where((e) => recent.contains(e.value.lastWorn)).toList();
      default:
        return entries;
    }
  }

  void _toggleFavorite(int index) {
    setState(() {
      if (_favoriteIds.contains(index)) {
        _favoriteIds = {..._favoriteIds}..remove(index);
      } else {
        _favoriteIds = {..._favoriteIds, index};
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _filteredItems;

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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ClosetHeader(
                    onBackTap: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenHorizontal,
                    ),
                    child: Row(
                      children: [
                        _StatChip(
                          number: '${_kClosetItems.length}',
                          label: ' Fragrances',
                          accentColor: AppColors.accentCyan,
                        ),
                        const SizedBox(width: 8),
                        _StatChip(
                          number: '${_favoriteIds.length}',
                          label: ' Favorites',
                          accentColor: AppColors.accentGold,
                        ),
                        const SizedBox(width: 8),
                        const _StatChip(
                          number: '1',
                          label: ' New',
                          accentColor: AppColors.accentOrange,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenHorizontal,
                    ),
                    child: Row(
                      children: List.generate(3, (i) {
                        const labels = ['All', 'Favorites', 'Recently Used'];
                        final isActive = _selectedTabIndex == i;
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedTabIndex = i),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    curve: Curves.easeOut,
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      labels[i],
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: isActive
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                        color: isActive
                                            ? AppColors.textPrimary
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    curve: Curves.easeOut,
                                    height: 2,
                                    width: isActive ? 32.0 : 0.0,
                                    decoration: BoxDecoration(
                                      color: AppColors.accentOrange,
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (i < 2) const SizedBox(width: 28),
                          ],
                        );
                      }),
                    ),
                  ),
                  const Divider(color: AppColors.divider, height: 1),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenHorizontal,
                      AppSpacing.sectionGap,
                      AppSpacing.screenHorizontal,
                      12,
                    ),
                    child: Text(
                      'MY COLLECTION',
                      style: AppTextStyles.sectionTitle.copyWith(
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  if (filteredItems.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.water_drop_outlined,
                              size: 48,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No fragrances here',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Add fragrances to your closet',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      itemCount: filteredItems.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final entry = filteredItems[index];
                        final itemIndex = entry.key;
                        final item = entry.value;
                        return _ClosetCard(
                          item: item,
                          isFavorite: _favoriteIds.contains(itemIndex),
                          onFavoriteTap: () => _toggleFavorite(itemIndex),
                        );
                      },
                    ),
                  const SizedBox(height: AppSpacing.navBarHeight + 24),
                ],
              ),
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

class _ClosetHeader extends StatelessWidget {
  const _ClosetHeader({required this.onBackTap});

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
            'My Closet',
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
                color: AppColors.accentOrange.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accentOrange.withValues(alpha: 0.5),
                ),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: AppColors.accentOrange,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.number,
    required this.label,
    required this.accentColor,
  });

  final String number;
  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: accentColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            number,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: accentColor,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClosetCard extends StatelessWidget {
  const _ClosetCard({
    required this.item,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  final _ClosetItem item;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.cardGap),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: AppGradients.cardShimmer,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: item.accentColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.small),
              child: Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      item.accentColor.withValues(alpha: 0.2),
                      AppColors.cardBg,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.water_drop_rounded,
                    size: 32,
                    color: item.accentColor.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
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
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: onFavoriteTap,
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite
                              ? AppColors.warningRed
                              : AppColors.textMuted,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${item.family}  ·  ${item.lastWorn}  ·  ${item.volumePercent}% full',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: item.volumePercent / 100,
                      backgroundColor: AppColors.cardBgLight,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        item.volumePercent > 50
                            ? item.accentColor
                            : item.volumePercent > 20
                            ? AppColors.accentGold
                            : AppColors.warningRed,
                      ),
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: item.notes
                        .map(
                          (note) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.pillBg,
                              borderRadius: BorderRadius.circular(
                                AppRadius.pill,
                              ),
                              border: Border.all(
                                color: item.accentColor.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Text(
                              note,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: item.accentColor,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
