import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/results_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/results/ar_button.dart';
import '../../widgets/results/biometric_reading_card.dart';
import '../../widgets/results/essence_recommends_card.dart';
import '../../widgets/results/perfume_bottle_section.dart';
import '../../widgets/results/result_action_buttons.dart';
import '../../widgets/results/why_this_formula_card.dart';
import '../../widgets/results/your_fragrance_card.dart';
import '../ar_visualization_screen.dart';

class ResultsPage extends StatelessWidget {
  final ResultsData data;

  const ResultsPage({super.key, ResultsData? data})
    : data =
          data ??
          const ResultsData(
            fragranceName: 'YSL - Y Eau De Parfum',
            topNote: 'Bergamot',
            middleNote: 'Lavender',
            baseNote: 'Patchouli',
            heartRate: 87,
            stressLevel: 'High Stress',
            gsrPercentage: 72,
            arousalState: 'Elevated',
            recommendation: 'CALM BOOST',
            ingredients: [
              IngredientData(name: 'Linalool', percentage: 20, icon: Icons.eco),
              IngredientData(
                name: 'Prebiotic',
                percentage: 30,
                icon: Icons.spa,
              ),
              IngredientData(
                name: 'Lipid',
                percentage: 25,
                icon: Icons.opacity,
              ),
              IngredientData(
                name: 'Fixative',
                percentage: 25,
                icon: Icons.tune,
              ),
            ],
            explanation:
                'Your stress markers are high (GSR 72%) in this 9°c chill. Apply Calm Booster; linalool will stabilize Y\'s lavender notes and help lower your cortisol over the next two hours.',
            contextMetrics: [
              ResultsMetricChip(
                icon: Icons.wb_sunny_outlined,
                label: 'Morning',
              ),
              ResultsMetricChip(
                icon: Icons.thermostat_outlined,
                label: '15°c · Overcast',
              ),
              ResultsMetricChip(
                icon: Icons.flag_outlined,
                label: 'Air: Good · 78%',
              ),
            ],
          );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  _ResultsHeader(
                    onBack: () => Navigator.of(context).maybePop(),
                  ).animate().fadeIn(duration: 300.ms),
                  PerfumeBottleSection(data: data)
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 300.ms)
                      .slideY(begin: 0.08, end: 0),
                  YourFragranceCard(data: data)
                      .animate()
                      .fadeIn(delay: 150.ms, duration: 300.ms)
                      .slideY(begin: 0.05, end: 0),
                  BioMetricReadingCard(data: data)
                      .animate()
                      .fadeIn(delay: 250.ms, duration: 300.ms)
                      .slideY(begin: 0.05, end: 0),
                  EssenceRecommendsCard(
                        recommendation: data.recommendation,
                        ingredients: data.ingredients,
                      )
                      .animate()
                      .fadeIn(delay: 350.ms, duration: 300.ms)
                      .slideY(begin: 0.05, end: 0),
                  Transform.translate(
                        offset: const Offset(0, -4),
                        child: WhyThisFormulaCard(
                          explanation: data.explanation,
                          margin: const EdgeInsets.fromLTRB(
                            AppSpacing.screenHorizontal + 2,
                            0,
                            AppSpacing.screenHorizontal + 2,
                            8,
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 300.ms)
                      .slideY(begin: 0.05, end: 0),
                  ARButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ARVisualizationScreen(
                                showBottomNav: false,
                                data: data,
                              ),
                            ),
                          );
                        },
                      )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 300.ms)
                      .slideY(begin: 0.05, end: 0),
                  const SizedBox(height: 140),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ResultActionButtons(
                onAccept: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                onOverride: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Override flow coming soon.')),
                  );
                },
              ).animate().fadeIn(delay: 300.ms, duration: 200.ms),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _ResultsHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: Icon(
                  Icons.chevron_left,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Your Result',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32 / 2,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
