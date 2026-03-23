import 'package:flutter/material.dart';

import 'results_page.dart';
import '../../theme/app_theme.dart';
import '../../widgets/analysis/dot_progression_loader.dart';

class ReadingCompleteScreen extends StatefulWidget {
  const ReadingCompleteScreen({super.key});

  @override
  State<ReadingCompleteScreen> createState() => _ReadingCompleteScreenState();
}

class _ReadingCompleteScreenState extends State<ReadingCompleteScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onComplete() {
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const ResultsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DotProgressionLoader(onComplete: _onComplete),
                const SizedBox(height: 40),
                const Text(
                  'Reading complete!',
                  style: AppTextStyles.h1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Now, Analyzing your Essense...',
                  style: AppTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
