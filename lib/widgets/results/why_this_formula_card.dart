import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class WhyThisFormulaCard extends StatelessWidget {
  final String explanation;
  final EdgeInsetsGeometry? margin;

  const WhyThisFormulaCard({super.key, required this.explanation, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          margin ??
          const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal + 2,
            8,
            AppSpacing.screenHorizontal + 2,
            8,
          ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgDeep.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accentCyan.withValues(alpha: 0.45),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WHY THIS FORMULA',
            style: TextStyle(
              fontSize: 26 / 2,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            explanation,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textLight,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
