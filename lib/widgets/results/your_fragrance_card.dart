import 'package:flutter/material.dart';

import '../../models/results_data.dart';
import '../../theme/app_theme.dart';
import 'result_card_shell.dart';

class YourFragranceCard extends StatelessWidget {
  final ResultsData data;

  const YourFragranceCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ResultCardShell(
      title: 'YOUR FRAGRANCE',
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.accentCyan.withValues(alpha: 0.70),
            width: 1.2,
          ),
          color: AppColors.bgDeep.withValues(alpha: 0.30),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.black.withValues(alpha: 0.25),
                width: 48,
                height: 64,
                child: Image.asset(
                  'assets/images/ysl_perfume.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.fragranceName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 28 / 2,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Notes:',
                    style: TextStyle(fontSize: 11, color: AppColors.textLight),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _NoteChip(label: 'Top', value: data.topNote),
                      const SizedBox(width: 4),
                      _NoteChip(label: 'Middle', value: data.middleNote),
                      const SizedBox(width: 4),
                      _NoteChip(label: 'Base', value: data.baseNote),
                    ],
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

class _NoteChip extends StatelessWidget {
  final String label;
  final String value;

  const _NoteChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.analysisDarkBlue.withValues(alpha: 0.35),
        ),
        child: Text.rich(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          TextSpan(
            children: [
              TextSpan(
                text: '$label: ',
                style: const TextStyle(
                  fontSize: 9,
                  color: AppColors.textSecondary,
                ),
              ),
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontSize: 9,
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
