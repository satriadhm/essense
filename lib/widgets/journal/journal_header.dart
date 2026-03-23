import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

class JournalHeader extends StatelessWidget {
  const JournalHeader({
    super.key,
    required this.onSearch,
    required this.onViewOptions,
    this.entryCount = 18,
  });

  final VoidCallback onSearch;
  final VoidCallback onViewOptions;
  final int entryCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Journal',
                style: GoogleFonts.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '23 entries • March 2027',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textJournalMuted,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _HeaderIconButton(
                onTap: onSearch,
                child: const Icon(Icons.search, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              _HeaderIconButton(
                onTap: onViewOptions,
                decorated: true,
                child: Text(
                  '$entryCount',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.onTap,
    required this.child,
    this.decorated = false,
  });

  final VoidCallback onTap;
  final Widget child;
  final bool decorated;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 44,
        height: 44,
        decoration: decorated
            ? BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
