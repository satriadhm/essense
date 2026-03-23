import 'package:flutter/material.dart';

import '../../models/results_data.dart';
import '../../theme/app_theme.dart';
import 'result_card_shell.dart';

class BioMetricReadingCard extends StatelessWidget {
  final ResultsData data;

  const BioMetricReadingCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ResultCardShell(
      title: 'BIO METRIC READING',
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 84,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.bgDeep.withValues(alpha: 0.50),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.accentCyan.withValues(alpha: 0.50),
                    width: 1.1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.heartRate.toString(),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentCyan,
                        height: 0.9,
                      ),
                    ),
                    const Text(
                      'BPM',
                      style: TextStyle(
                        fontSize: 16 / 2,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Heart Rates',
                      style: TextStyle(
                        fontSize: 9,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.bgDeep.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.accentCyan.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Skin Arousal\n(GSR)',
                        style: TextStyle(
                          fontSize: 30 / 2,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: LinearProgressIndicator(
                          value: data.gsrPercentage / 100,
                          minHeight: 5,
                          backgroundColor: Colors.white.withValues(alpha: 0.12),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.accentCyan,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            'Arousal State',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${data.arousalState} · ${data.gsrPercentage}%',
                            style: const TextStyle(
                              fontSize: 14 / 2,
                              color: AppColors.accentCyan,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          data.stressLevel,
                          style: const TextStyle(
                            fontSize: 24 / 2,
                            color: AppColors.warningRed,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: data.contextMetrics
                .map((metric) => Expanded(child: _MetricChip(metric: metric)))
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final ResultsMetricChip metric;

  const _MetricChip({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.bgDeep.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.accentCyan.withValues(alpha: 0.38),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(metric.icon, size: 14, color: AppColors.textLight),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                metric.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
