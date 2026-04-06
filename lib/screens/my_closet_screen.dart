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

  int _matchPercentForItem(_ClosetItem item) {
    const fallback = 80;
    const scores = <String, int>{
      'Libre': 97,
      'Mon Paris': 91,
      'Sauvage': 88,
      'Oud Wood': 85,
      'Black Orchid': 82,
      'Y EDP': 94,
    };
    return scores[item.name] ?? fallback;
  }

  void _showClosetItemDetail(BuildContext context, _ClosetItem item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (_) => _ClosetItemDetailSheet(
        item: item,
        matchPercent: _matchPercentForItem(item),
      ),
    );
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenHorizontal,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF1C1828), Color(0xFF0D0B14)],
                          ),
                          color: const Color(0xFF12101A),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF3D2F5C),
                            width: 1.5,
                          ),
                        ),
                        child: GridView.builder(
                          itemCount: filteredItems.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.72,
                              ),
                          itemBuilder: (context, index) {
                            final item = filteredItems[index].value;
                            return _ClosetGridCell(
                              item: item,
                              matchPercent: _matchPercentForItem(item),
                              onTap: () => _showClosetItemDetail(context, item),
                            );
                          },
                        ),
                      ),
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

class _ClosetGridCell extends StatelessWidget {
  const _ClosetGridCell({
    required this.item,
    required this.matchPercent,
    required this.onTap,
  });

  final _ClosetItem item;
  final int matchPercent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final levelColor = item.volumePercent > 50
        ? item.accentColor
        : item.volumePercent > 20
        ? AppColors.accentGold
        : AppColors.warningRed;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: AppGradients.cardShimmer,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: item.accentColor.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: item.accentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: item.accentColor.withValues(alpha: 0.6),
                    ),
                  ),
                  child: Text(
                    '$matchPercent%',
                    style: GoogleFonts.montserrat(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: item.accentColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        item.accentColor.withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: item.accentColor.withValues(alpha: 0.25),
                        blurRadius: 16,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.water_drop_rounded,
                      size: 36,
                      color: item.accentColor.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.brand,
                style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: item.accentColor,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: item.volumePercent / 100,
                  minHeight: 3,
                  backgroundColor: AppColors.cardBgLight,
                  valueColor: AlwaysStoppedAnimation<Color>(levelColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClosetItemDetailSheet extends StatefulWidget {
  const _ClosetItemDetailSheet({required this.item, required this.matchPercent});

  final _ClosetItem item;
  final int matchPercent;

  @override
  State<_ClosetItemDetailSheet> createState() => _ClosetItemDetailSheetState();
}

class _ClosetItemDetailSheetState extends State<_ClosetItemDetailSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scale = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final volumeColor = item.volumePercent > 50
        ? item.accentColor
        : item.volumePercent > 20
        ? AppColors.accentGold
        : AppColors.warningRed;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: FadeTransition(
        opacity: _fade,
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: item.accentColor.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.45),
                  blurRadius: 40,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
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
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                  color: item.accentColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.name,
                                style: GoogleFonts.montserrat(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: item.accentColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: item.accentColor.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          '${widget.matchPercent}% Match',
                          style: GoogleFonts.montserrat(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: item.accentColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Highly Compatible · ${item.family}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 72,
                          height: 80,
                          decoration: BoxDecoration(
                            color: item.accentColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: item.accentColor.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Icon(
                            Icons.water_drop_rounded,
                            size: 48,
                            color: item.accentColor.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.pillBg,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.pill,
                                  ),
                                  border: Border.all(
                                    color: item.accentColor.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  item.family,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: item.accentColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Last worn: ${item.lastWorn}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.textLight,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: item.volumePercent / 100,
                                  minHeight: 4,
                                  backgroundColor: AppColors.cardBgLight,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    volumeColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${item.volumePercent}% remaining',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
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
                                  color: item.accentColor.withValues(
                                    alpha: 0.25,
                                  ),
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
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgDeep.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border(
                          left: BorderSide(color: item.accentColor, width: 4),
                        ),
                      ),
                      child: Text(
                        'A signature scent that complements your biometric profile. '
                        'Your skin chemistry amplifies the ${item.notes.first} accord, '
                        'making it last longer on you.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textLight,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
