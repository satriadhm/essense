import 'package:flutter/material.dart';

class IngredientData {
  final String name;
  final int percentage;
  final IconData icon;

  const IngredientData({
    required this.name,
    required this.percentage,
    required this.icon,
  });
}

class ResultsMetricChip {
  final IconData icon;
  final String label;

  const ResultsMetricChip({required this.icon, required this.label});
}

class ResultsData {
  final String fragranceName;
  final String topNote;
  final String middleNote;
  final String baseNote;
  final int heartRate;
  final String stressLevel;
  final int gsrPercentage;
  final String arousalState;
  final String recommendation;
  final List<IngredientData> ingredients;
  final String explanation;
  final List<ResultsMetricChip> contextMetrics;

  const ResultsData({
    required this.fragranceName,
    required this.topNote,
    required this.middleNote,
    required this.baseNote,
    required this.heartRate,
    required this.stressLevel,
    required this.gsrPercentage,
    required this.arousalState,
    required this.recommendation,
    required this.ingredients,
    required this.explanation,
    required this.contextMetrics,
  });

  factory ResultsData.demo() {
    return const ResultsData(
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
        IngredientData(name: 'Prebiotic', percentage: 30, icon: Icons.spa),
        IngredientData(name: 'Lipid', percentage: 25, icon: Icons.opacity),
        IngredientData(name: 'Fixative', percentage: 25, icon: Icons.tune),
      ],
      explanation:
          'Your stress markers are high (GSR 72%) in this 9°c chill. Apply Calm Booster; linalool will stabilize Y\'s lavender notes and help lower your cortisol over the next two hours.',
      contextMetrics: [
        ResultsMetricChip(icon: Icons.wb_sunny_outlined, label: 'Morning'),
        ResultsMetricChip(
          icon: Icons.thermostat_outlined,
          label: '15°c · Overcast',
        ),
        ResultsMetricChip(icon: Icons.flag_outlined, label: 'Air: Good · 78%'),
      ],
    );
  }
}
