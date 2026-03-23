import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../models/journal_entry_model.dart';
import '../../theme/app_theme.dart';

class JournalEntryCard extends StatelessWidget {
  const JournalEntryCard({super.key, required this.entry, required this.onTap});

  final JournalEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('h:mm a').format(entry.dateTime);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.journalNeutral.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getEntryTypeColor(entry.entryType).withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getEntryTypeColor(entry.entryType),
                  width: 2,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$timeString • ${entry.location} • ${entry.durationHours.toStringAsFixed(1)}h',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.journalNeutral,
            ),
          ],
        ),
      ),
    );
  }

  Color _getEntryTypeColor(JournalEntryType type) {
    switch (type) {
      case JournalEntryType.calm:
        return AppColors.journalCalm;
      case JournalEntryType.energy:
        return AppColors.journalEnergy;
      case JournalEntryType.neutral:
        return AppColors.journalNeutral;
    }
  }
}
