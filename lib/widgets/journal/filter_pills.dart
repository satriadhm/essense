import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

class FilterPills extends StatelessWidget {
  const FilterPills({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.onFilterSelected,
  });

  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isActive = index == selectedIndex;
          return InkWell(
            onTap: () => onFilterSelected(index),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.journalEnergy : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: isActive
                    ? null
                    : Border.all(color: AppColors.journalDarkBlue, width: 1.5),
              ),
              child: Center(
                child: Text(
                  filters[index],
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? AppColors.bgDeep : AppColors.textLight,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
