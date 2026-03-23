import 'package:flutter/material.dart';

import '../../models/results_data.dart';
import '../../theme/app_theme.dart';
import 'result_card_shell.dart';

class EssenceRecommendsCard extends StatelessWidget {
  final String recommendation;
  final List<IngredientData> ingredients;

  const EssenceRecommendsCard({
    super.key,
    required this.recommendation,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    return ResultCardShell(
      title: 'ESSENSE RECOMMENDS',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recommendation,
            style: const TextStyle(
              fontSize: 38 / 2,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 60,
            child: Row(
              children: ingredients
                  .map(
                    (ingredient) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: _IngredientTile(ingredient: ingredient),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        ],
      ),
    );
  }
}

class _IngredientTile extends StatelessWidget {
  final IngredientData ingredient;

  const _IngredientTile({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.accentCyan.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentCyan.withValues(alpha: 0.20),
                ),
                child: Icon(
                  ingredient.icon,
                  size: 10,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  ingredient.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${ingredient.percentage}%',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textLight,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
