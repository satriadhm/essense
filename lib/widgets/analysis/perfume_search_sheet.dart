import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class PerfumeOption {
  final String brand;
  final String name;
  final String topNote;
  final String middleNote;
  final String baseNote;

  const PerfumeOption({
    required this.brand,
    required this.name,
    required this.topNote,
    required this.middleNote,
    required this.baseNote,
  });

  String get fullName => '$brand - $name';
}

const _kPerfumeDatabase = [
  PerfumeOption(
    brand: 'YSL',
    name: 'Y Eau De Parfum',
    topNote: 'Bergamot',
    middleNote: 'Lavender',
    baseNote: 'Patchouli',
  ),
  PerfumeOption(
    brand: 'Dior',
    name: 'Sauvage EDP',
    topNote: 'Bergamot',
    middleNote: 'Geranium',
    baseNote: 'Ambroxan',
  ),
  PerfumeOption(
    brand: 'Chanel',
    name: 'Bleu de Chanel',
    topNote: 'Citrus',
    middleNote: 'Ginger',
    baseNote: 'Sandalwood',
  ),
  PerfumeOption(
    brand: 'Tom Ford',
    name: 'Black Orchid',
    topNote: 'Truffle',
    middleNote: 'Orchid',
    baseNote: 'Patchouli',
  ),
  PerfumeOption(
    brand: 'Creed',
    name: 'Aventus',
    topNote: 'Blackcurrant',
    middleNote: 'Rose',
    baseNote: 'Musk',
  ),
  PerfumeOption(
    brand: 'Armani',
    name: 'Acqua di Gio Profumo',
    topNote: 'Aquatic',
    middleNote: 'Sage',
    baseNote: 'Incense',
  ),
  PerfumeOption(
    brand: 'Versace',
    name: 'Eros EDP',
    topNote: 'Mint',
    middleNote: 'Tonka Bean',
    baseNote: 'Vanilla',
  ),
  PerfumeOption(
    brand: 'Gucci',
    name: 'Guilty Pour Homme',
    topNote: 'Lemon',
    middleNote: 'Lavender',
    baseNote: 'Amber',
  ),
  PerfumeOption(
    brand: 'Burberry',
    name: 'Hero EDP',
    topNote: 'Juniper',
    middleNote: 'Black Pepper',
    baseNote: 'Vetiver',
  ),
  PerfumeOption(
    brand: 'Hugo Boss',
    name: 'Boss Bottled',
    topNote: 'Apple',
    middleNote: 'Cinnamon',
    baseNote: 'Sandalwood',
  ),
  PerfumeOption(
    brand: 'Paco Rabanne',
    name: '1 Million EDP',
    topNote: 'Grapefruit',
    middleNote: 'Cinnamon',
    baseNote: 'Leather',
  ),
  PerfumeOption(
    brand: 'Dolce & Gabbana',
    name: 'The One EDP',
    topNote: 'Basil',
    middleNote: 'Cardamom',
    baseNote: 'Tobacco',
  ),
];

class PerfumeSearchSheet extends StatefulWidget {
  const PerfumeSearchSheet({
    super.key,
    required this.scrollController,
    required this.onSelected,
  });

  final ScrollController scrollController;
  final void Function(PerfumeOption selected) onSelected;

  @override
  State<PerfumeSearchSheet> createState() => _PerfumeSearchSheetState();
}

class _PerfumeSearchSheetState extends State<PerfumeSearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  late List<PerfumeOption> _filtered;

  static final TextStyle _noteLineStyle = AppTypography.microLabel.copyWith(
    color: AppColors.textMuted,
    height: 1.2,
  );

  @override
  void initState() {
    super.initState();
    _filtered = List<PerfumeOption>.of(_kPerfumeDatabase);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    final lower = query.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filtered = List<PerfumeOption>.of(_kPerfumeDatabase);
      } else {
        _filtered = _kPerfumeDatabase
            .where((p) => p.fullName.toLowerCase().contains(lower))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'No fragrance found',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text;

    return SizedBox.expand(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgMid,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Select Your Fragrance',
                style: AppTextStyles.h2,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Search by brand or name',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
                cursorColor: AppColors.accentCyan,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.cardBg,
                  hintText: 'e.g. Dior Sauvage, YSL...',
                  hintStyle: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textMuted,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.accentCyan,
                  ),
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded),
                          color: AppColors.textMuted,
                          onPressed: () {
                            _searchController.clear();
                          },
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.accentCyan,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filtered.isEmpty
                  ? ListView(
                      controller: widget.scrollController,
                      padding: const EdgeInsets.only(bottom: 24),
                      children: [_buildEmptyState()],
                    )
                  : ListView.separated(
                      controller: widget.scrollController,
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, _) => const Divider(
                        height: 1,
                        color: AppColors.divider,
                      ),
                      itemBuilder: (context, index) {
                        final option = _filtered[index];
                        return _PerfumeTile(
                          option: option,
                          noteLineStyle: _noteLineStyle,
                          onTap: () {
                            Navigator.pop(context);
                            widget.onSelected(option);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PerfumeTile extends StatelessWidget {
  const _PerfumeTile({
    required this.option,
    required this.noteLineStyle,
    required this.onTap,
  });

  final PerfumeOption option;
  final TextStyle noteLineStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.borderCyan.withValues(alpha: 0.3),
          ),
        ),
        child: const Icon(
          Icons.water_drop_rounded,
          color: AppColors.accentCyan,
          size: 20,
        ),
      ),
      title: Text(option.name, style: AppTextStyles.cardTitle),
      subtitle: Text(
        option.brand,
        style: AppTextStyles.cardSub.copyWith(color: AppColors.textSecondary),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Top: ${option.topNote}', style: noteLineStyle),
          Text('Base: ${option.baseNote}', style: noteLineStyle),
        ],
      ),
      onTap: onTap,
    );
  }
}
