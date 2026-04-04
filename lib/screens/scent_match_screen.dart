import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class _ScentOption {
  final String brand;
  final String name;
  final String topNote;
  final String middleNote;
  final String baseNote;

  const _ScentOption({
    required this.brand,
    required this.name,
    required this.topNote,
    required this.middleNote,
    required this.baseNote,
  });
}

const _kScentDatabase = [
  _ScentOption(
    brand: 'YSL',
    name: 'Y Eau De Parfum',
    topNote: 'Bergamot',
    middleNote: 'Lavender',
    baseNote: 'Patchouli',
  ),
  _ScentOption(
    brand: 'YSL',
    name: 'Libre EDP',
    topNote: 'Lavender',
    middleNote: 'Orange Blossom',
    baseNote: 'Musk',
  ),
  _ScentOption(
    brand: 'YSL',
    name: 'Mon Paris',
    topNote: 'Strawberry',
    middleNote: 'Peony',
    baseNote: 'Patchouli',
  ),
  _ScentOption(
    brand: 'Dior',
    name: 'Sauvage EDP',
    topNote: 'Bergamot',
    middleNote: 'Geranium',
    baseNote: 'Ambroxan',
  ),
  _ScentOption(
    brand: 'Chanel',
    name: 'Bleu de Chanel',
    topNote: 'Citrus',
    middleNote: 'Ginger',
    baseNote: 'Sandalwood',
  ),
  _ScentOption(
    brand: 'Tom Ford',
    name: 'Black Orchid',
    topNote: 'Truffle',
    middleNote: 'Orchid',
    baseNote: 'Patchouli',
  ),
  _ScentOption(
    brand: 'Creed',
    name: 'Aventus',
    topNote: 'Blackcurrant',
    middleNote: 'Rose',
    baseNote: 'Musk',
  ),
  _ScentOption(
    brand: 'Armani',
    name: 'Acqua di Gio Profumo',
    topNote: 'Aquatic',
    middleNote: 'Sage',
    baseNote: 'Incense',
  ),
  _ScentOption(
    brand: 'Versace',
    name: 'Eros EDP',
    topNote: 'Mint',
    middleNote: 'Tonka Bean',
    baseNote: 'Vanilla',
  ),
  _ScentOption(
    brand: 'Paco Rabanne',
    name: '1 Million EDP',
    topNote: 'Grapefruit',
    middleNote: 'Cinnamon',
    baseNote: 'Leather',
  ),
  _ScentOption(
    brand: 'Gucci',
    name: 'Guilty Pour Homme',
    topNote: 'Lemon',
    middleNote: 'Lavender',
    baseNote: 'Amber',
  ),
  _ScentOption(
    brand: 'Burberry',
    name: 'Hero EDP',
    topNote: 'Juniper',
    middleNote: 'Black Pepper',
    baseNote: 'Vetiver',
  ),
];

class ScentMatchScreen extends StatefulWidget {
  const ScentMatchScreen({super.key});

  @override
  State<ScentMatchScreen> createState() => _ScentMatchScreenState();
}

class _ScentMatchScreenState extends State<ScentMatchScreen>
    with SingleTickerProviderStateMixin {
  int _step = 0;
  _ScentOption? _selectedFragrance;
  int _matchScore = 0;
  bool _addedToCloset = false;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  List<_ScentOption> get _filteredOptions {
    if (_searchQuery.isEmpty) return _kScentDatabase;
    final q = _searchQuery.toLowerCase();
    return _kScentDatabase
        .where(
          (o) =>
              o.brand.toLowerCase().contains(q) ||
              o.name.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onFragranceSelected(_ScentOption option) {
    setState(() {
      _selectedFragrance = option;
      _step = 1;
      _addedToCloset = false;
    });

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      setState(() {
        _matchScore = 75 + (option.name.length * 3) % 23;
        _step = 2;
      });
    });
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.headerTop,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
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
            title,
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputStep() {
    final options = _filteredOptions;
    return Column(
      key: const ValueKey('input'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader('Scent Match'),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            4,
            AppSpacing.screenHorizontal,
            16,
          ),
          child: Text(
            'Search for a fragrance to check your compatibility',
            style: AppTextStyles.bodyLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(
                color: AppColors.borderCyan.withValues(alpha: 0.3),
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search by brand or name...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textMuted,
                  size: 20,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.textMuted,
                          size: 18,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: Text(
            _searchQuery.isEmpty ? 'POPULAR' : 'RESULTS',
            style: AppTextStyles.sectionTitle.copyWith(letterSpacing: 0.8),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: options.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.search_off_rounded,
                        size: 40,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No fragrance found',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal,
                  ),
                  itemCount: options.length,
                  separatorBuilder: (_, index) =>
                      const Divider(height: 1, color: AppColors.divider),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return _ScentOptionTile(
                      option: option,
                      onTap: () => _onFragranceSelected(option),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAnalyzingStep() {
    return Center(
      key: const ValueKey('analyzing'),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cardBg,
                  border: Border.all(
                    color: AppColors.accentCyan.withValues(alpha: 0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentCyan.withValues(alpha: 0.2),
                      blurRadius: 32,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  size: 56,
                  color: AppColors.accentCyan,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Analyzing your match...',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _selectedFragrance == null
                  ? ''
                  : '${_selectedFragrance!.brand} · ${_selectedFragrance!.name}',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.accentCyan,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: const LinearProgressIndicator(
                backgroundColor: AppColors.cardBgLight,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentCyan),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Reading your biometric profile',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFragranceIdentityCard(_ScentOption fragrance) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppGradients.cardShimmer,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: AppColors.borderCyan.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.bgDeep,
                borderRadius: BorderRadius.circular(AppRadius.small),
                border: Border.all(
                  color: AppColors.accentCyan.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(
                Icons.water_drop_rounded,
                size: 30,
                color: AppColors.accentCyan,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fragrance.brand,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentCyan,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fragrance.name,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${fragrance.topNote}  ·  ${fragrance.middleNote}  ·  ${fragrance.baseNote}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchScoreCard(int score, String label, Color scoreColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppGradients.cardShimmer,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: scoreColor.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: scoreColor.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'MATCH SCORE',
                  style: AppTextStyles.sectionTitle.copyWith(
                    letterSpacing: 0.8,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: scoreColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(
                      color: scoreColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 12,
                        color: scoreColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'AI Analyzed',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: scoreColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '$score%',
              style: GoogleFonts.montserrat(
                fontSize: 72,
                fontWeight: FontWeight.w800,
                color: scoreColor,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: scoreColor,
              ),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: LinearProgressIndicator(
                value: score / 100,
                backgroundColor: AppColors.cardBgLight,
                valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(_ScentOption fragrance) {
    final notes = [
      ('Top Note', fragrance.topNote, AppColors.accentCyan),
      ('Middle Note', fragrance.middleNote, AppColors.accentGold),
      ('Base Note', fragrance.baseNote, AppColors.accentOrange),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppGradients.cardShimmer,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: AppColors.borderCyan.withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FRAGRANCE NOTES',
              style: AppTextStyles.sectionTitle.copyWith(letterSpacing: 0.8),
            ),
            const SizedBox(height: 14),
            ...notes.map(
              (note) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: note.$3,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 80,
                      child: Text(
                        note.$1,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: note.$3.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(
                          color: note.$3.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Text(
                        note.$2,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: note.$3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosisCard(String diagnosis) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgDeep.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: AppColors.accentCyan.withValues(alpha: 0.35),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.science_rounded,
                  size: 14,
                  color: AppColors.accentCyan,
                ),
                const SizedBox(width: 6),
                Text(
                  'WHY THIS SCORE',
                  style: AppTextStyles.sectionTitle.copyWith(
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              diagnosis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textLight,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultStep() {
    final fragrance = _selectedFragrance!;
    final score = _matchScore;
    final scoreLabel = score >= 90
        ? 'Highly Compatible'
        : score >= 75
        ? 'Good Match'
        : 'Moderate Match';
    final scoreColor = score >= 90
        ? AppColors.accentCyan
        : score >= 75
        ? AppColors.accentGold
        : AppColors.accentOrange;

    final diagnosis =
        'Based on your current biometric profile and skin chemistry, '
        '${fragrance.brand} ${fragrance.name} achieves a $score% compatibility rating. '
        'The ${fragrance.topNote} top note pairs with your elevated skin pH, '
        'while the ${fragrance.baseNote} base enhances longevity on your skin type.';

    return SingleChildScrollView(
      key: const ValueKey('result'),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Your Result'),
          const SizedBox(height: 4),
          _buildFragranceIdentityCard(fragrance),
          const SizedBox(height: AppSpacing.cardGap),
          _buildMatchScoreCard(score, scoreLabel, scoreColor),
          const SizedBox(height: AppSpacing.cardGap),
          _buildNotesCard(fragrance),
          const SizedBox(height: AppSpacing.cardGap),
          _buildDiagnosisCard(diagnosis),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _addedToCloset
                        ? null
                        : () => setState(() => _addedToCloset = true),
                    icon: Icon(
                      _addedToCloset
                          ? Icons.check_circle_rounded
                          : Icons.add_rounded,
                      size: 20,
                    ),
                    label: Text(
                      _addedToCloset
                          ? 'Added to My Closet!'
                          : 'Add to My Closet',
                      style: AppTextStyles.buttonLarge,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _addedToCloset
                          ? AppColors.accentCyan.withValues(alpha: 0.3)
                          : AppColors.analysisDarkBlue,
                      foregroundColor: _addedToCloset
                          ? AppColors.accentCyan
                          : AppColors.textPrimary,
                      disabledBackgroundColor: AppColors.accentCyan.withValues(
                        alpha: 0.2,
                      ),
                      disabledForegroundColor: AppColors.accentCyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.button),
                        side: _addedToCloset
                            ? const BorderSide(
                                color: AppColors.accentCyan,
                                width: 1.5,
                              )
                            : BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () => setState(() {
                      _step = 0;
                      _selectedFragrance = null;
                      _addedToCloset = false;
                      _searchController.clear();
                      _searchQuery = '';
                    }),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accentCyan,
                      side: const BorderSide(
                        color: AppColors.accentCyan,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.button),
                      ),
                    ),
                    child: Text(
                      'Try Another Fragrance',
                      style: AppTextStyles.buttonLarge.copyWith(
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.04, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: switch (_step) {
                0 => _buildInputStep(),
                1 => _buildAnalyzingStep(),
                2 => _buildResultStep(),
                _ => _buildInputStep(),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ScentOptionTile extends StatelessWidget {
  const _ScentOptionTile({required this.option, required this.onTap});

  final _ScentOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.small),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(AppRadius.small),
                border: Border.all(
                  color: AppColors.borderCyan.withValues(alpha: 0.2),
                ),
              ),
              child: const Icon(
                Icons.water_drop_rounded,
                color: AppColors.accentCyan,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.brand,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.accentCyan,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(option.name, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 4),
                  Text(
                    '${option.topNote}  ·  ${option.middleNote}  ·  ${option.baseNote}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
