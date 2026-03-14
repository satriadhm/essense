import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../widgets/bottom_nav/custom_bottom_nav.dart';

// ═══════════════════════════════════════
// THEME COLORS (from prompt)
// ═══════════════════════════════════════
const _kBg = Color(0xFF07111F);
const _kPanelBg = Color(0xFF0D1E35);
const _kAccentCyan = Color(0xFF00C8D4);
const _kLavender = Color(0xFFD4BFEC);
const _kTextSecondary = Color(0xFF8A9AB5);
const _kArSmokeBlob = Color(0xFF1A3D2E);
class PerfumeDetailScreen extends StatefulWidget {
  final bool showBottomNav;

  const PerfumeDetailScreen({super.key, this.showBottomNav = true});

  @override
  State<PerfumeDetailScreen> createState() => _PerfumeDetailScreenState();
}

class _PerfumeDetailScreenState extends State<PerfumeDetailScreen> {
  int _currentNavIndex = 1; // Search tab active
  bool _isDayMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildWeekCalendarStrip(),
              const SizedBox(height: 20),
              _buildHeroProductSection(),
              _buildBottomDataPanel(),
              if (widget.showBottomNav) ...[
                const SizedBox(height: 16),
                CustomBottomNav(
                  currentIndex: _currentNavIndex,
                  onTap: (i) => setState(() => _currentNavIndex = i),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekCalendarStrip() {
    const days = [
      ('T', 25),
      ('W', 26),
      ('T', 27),
      ('F', 28),
      ('S', 29),
      ('S', 30),
      ('M', 31),
    ];
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) => WeekDayTile(
          letter: days[i].$1,
          day: days[i].$2,
          isActive: i == 4,
        ),
      ),
    );
  }

  Widget _buildHeroProductSection() {
    return SizedBox(
      height: 260,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final centerX = w / 2;
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Layer 1 — AR Smoke blobs (positioned relative to layout width)
              Positioned(
                left: centerX - 220 - 20,
                top: 70,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                    child: Container(
                      width: 220,
                      height: 120,
                      decoration: BoxDecoration(
                        color: _kArSmokeBlob.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: centerX + 20,
                top: 90,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                    child: Container(
                      width: 180,
                      height: 100,
                      decoration: BoxDecoration(
                        color: _kArSmokeBlob.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
              ),
              // Layer 2 — Perfume bottle
              Center(
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: _kAccentCyan.withOpacity(0.2),
                        blurRadius: 40,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: _buildPerfumeBottleImage(),
                ),
              ),
              // Layer 3 — Product label pill
              Positioned(
                left: 0,
                right: 0,
                bottom: 8,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                          color: Colors.white.withOpacity(0.05),
                        ),
                        child: Text(
                          'YSL Libre Perfume',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPerfumeBottleImage() {
    try {
      return Image.asset(
        'assets/images/ysl_libre.png',
        height: 200,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildPerfumeBottleFallback(),
      );
    } catch (_) {
      return _buildPerfumeBottleFallback();
    }
  }

  Widget _buildPerfumeBottleFallback() {
    return Icon(
      Icons.liquor_rounded,
      size: 120,
      color: _kAccentCyan.withOpacity(0.6),
    );
  }

  Widget _buildBottomDataPanel() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _kPanelBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFragranceProfileSection(),
          const SizedBox(height: 24),
          _buildSkinAnalysisSection(),
          const SizedBox(height: 24),
          _buildRecommendedActionCard(),
        ],
      ),
    );
  }

  Widget _buildFragranceProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'FRAGRANCE PROFILE'),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 400;
            if (isNarrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 110,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: const [
                        NotesTile(emoji: '🪻', label: 'Lavender'),
                        SizedBox(width: 12),
                        NotesTile(emoji: '🍊', label: 'Orange Blossom'),
                        SizedBox(width: 12),
                        NotesTile(emoji: '🌿', label: 'Vanilla'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildStatPill(Icons.schedule_rounded, '7h longevity'),
                  const SizedBox(height: 8),
                  _buildStatPill(Icons.air_rounded, 'Strong Sillage'),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      NotesTile(emoji: '🪻', label: 'Lavender'),
                      NotesTile(emoji: '🍊', label: 'Orange Blossom'),
                      NotesTile(emoji: '🌿', label: 'Vanilla'),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      _buildStatPill(Icons.schedule_rounded, '7h longevity'),
                      const SizedBox(height: 8),
                      _buildStatPill(Icons.air_rounded, 'Strong Sillage'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        _buildDayNightToggle(),
      ],
    );
  }

  Widget _buildStatPill(IconData icon, String text) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(icon, size: 18, color: _kAccentCyan),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayNightToggle() {
    return GestureDetector(
      onTap: () => setState(() => _isDayMode = !_isDayMode),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _isDayMode ? _kLavender : Colors.transparent,
                  borderRadius: BorderRadius.circular(29),
                ),
                child: Text(
                  'Day',
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _isDayMode ? const Color(0xFF1a0a2e) : _kTextSecondary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !_isDayMode ? _kLavender : Colors.transparent,
                  borderRadius: BorderRadius.circular(29),
                ),
                child: Text(
                  'Night',
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: !_isDayMode ? const Color(0xFF1a0a2e) : _kTextSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkinAnalysisSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'SKIN ANALYSIS'),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final chartSize = (constraints.maxWidth * 0.35).clamp(80.0, 110.0);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: const [
                      CircularRingMetric(
                        score: 6,
                        percent: 0.6,
                        title: 'Hydration',
                        subtitle: 'Balanced moisture',
                      ),
                      SizedBox(height: 12),
                      CircularRingMetric(
                        score: 4,
                        percent: 0.4,
                        title: 'pH Level',
                        subtitle: 'Slightly acidic',
                      ),
                      SizedBox(height: 12),
                      CircularRingMetric(
                        score: 8,
                        percent: 0.8,
                        title: 'Oil Balance',
                        subtitle: 'Optimal for scent',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: chartSize,
                  height: chartSize,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _kAccentCyan.withOpacity(0.3),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: _buildRadarChart(),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.end,
          children: const [
            ConditionBadge(icon: Icons.thermostat_rounded, value: '15°'),
            ConditionBadge(icon: Icons.water_drop_rounded, value: '18%'),
            ConditionBadge(icon: Icons.wb_sunny_rounded, value: 'High'),
          ],
        ),
      ],
    );
  }

  Widget _buildRadarChart() {
    return RadarChart(
      RadarChartData(
        dataSets: [
          RadarDataSet(
            fillColor: _kAccentCyan.withValues(alpha: 0.2),
            borderColor: _kAccentCyan,
            borderWidth: 1.5,
            dataEntries: const [
              RadarEntry(value: 0.8),
              RadarEntry(value: 0.6),
              RadarEntry(value: 0.9),
            ],
          ),
        ],
        titleTextStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
        getTitle: (index, angle) => RadarChartTitle(text: '', angle: angle),
        tickCount: 2,
        ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
        tickBorderData: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        gridBorderData: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        radarBackgroundColor: Colors.transparent,
        radarBorderData: BorderSide.none,
        borderData: FlBorderData(show: false),
      ),
      swapAnimationDuration: const Duration(milliseconds: 0),
    );
  }

  Widget _buildRecommendedActionCard() {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
        color: Colors.white.withOpacity(0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'RECOMMENDED ACTION'),
          const SizedBox(height: 16),
          DosageProgressBar(
            value: 0.75,
            label: 'Dosage Level: 15µL\n(Concentrated)',
          ),
          const SizedBox(height: 16),
          _buildExpectedPerformance(),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 320;
              if (isNarrow) {
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedActionButton(
                        label: 'ACTIVATE THE BOOSTER',
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedActionButton(
                        label: 'GENERATE AR\nVISUALIZATION',
                        onTap: () {},
                        multiline: true,
                      ),
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: OutlinedActionButton(
                      label: 'ACTIVATE THE BOOSTER',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedActionButton(
                      label: 'GENERATE AR\nVISUALIZATION',
                      onTap: () {},
                      multiline: true,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExpectedPerformance() {
    const bullets = [
      'Longevity: 10–12 Hours (Extended)',
      'Sillage: Moderate (Polite & Professional)',
      'Vibe: Crisp, Clean, and Rooted.',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: bullets
          .map(
            (text) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: _kAccentCyan,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      text,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

// ═══════════════════════════════════════
// REUSABLE WIDGETS
// ═══════════════════════════════════════

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.montserrat(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

class WeekDayTile extends StatelessWidget {
  final String letter;
  final int day;
  final bool isActive;

  const WeekDayTile({
    super.key,
    required this.letter,
    required this.day,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 60,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            letter,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isActive ? Colors.black : _kTextSecondary,
            ),
          ),
          Text(
            '$day',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isActive ? Colors.black : _kTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class NotesTile extends StatelessWidget {
  final String emoji;
  final String label;

  const NotesTile({super.key, required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 32)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 9,
            fontWeight: FontWeight.w400,
            color: _kTextSecondary,
          ),
        ),
      ],
    );
  }
}

class CircularRingMetric extends StatelessWidget {
  final int score;
  final double percent;
  final String title;
  final String subtitle;

  const CircularRingMetric({
    super.key,
    required this.score,
    required this.percent,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 52,
          height: 52,
          child: CustomPaint(
            painter: _CircularRingPainter(progress: percent),
            child: Center(
              child: Text(
                '$score',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: _kTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CircularRingPainter extends CustomPainter {
  final double progress;

  _CircularRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    // Background arc
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = _kAccentCyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ConditionBadge extends StatelessWidget {
  final IconData icon;
  final String value;

  const ConditionBadge({super.key, required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: _kAccentCyan),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class DosageProgressBar extends StatelessWidget {
  final double value;
  final String label;

  const DosageProgressBar({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(_kAccentCyan),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          flex: 2,
          child: Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: _kTextSecondary,
            ),
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class OutlinedActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool multiline;

  const OutlinedActionButton({
    super.key,
    required this.label,
    required this.onTap,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.white.withOpacity(0.25)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          textAlign: multiline ? TextAlign.center : TextAlign.left,
          style: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
