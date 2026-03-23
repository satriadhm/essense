import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/journal_entry_model.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav/custom_bottom_nav.dart';
import '../widgets/journal/filter_pills.dart';
import '../widgets/journal/journal_calendar.dart';
import '../widgets/journal/journal_entry_card.dart';
import '../widgets/journal/journal_entry_detail_card.dart';
import '../widgets/journal/journal_header.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key, this.showBottomNav = true});

  final bool showBottomNav;

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  static final DateTime _initialSelectedDate = DateTime(2027, 3, 17);

  final List<String> _filters = const [
    'All Fragrance',
    'YSL Libre',
    'Mon Paris',
    'Y Eau de Perfume',
  ];

  int _selectedFilterIndex = 0;
  int _currentNavIndex = 1;
  DateTime _selectedDate = _initialSelectedDate;

  List<JournalEntry> get _allEntries => JournalMockData.entries;

  @override
  Widget build(BuildContext context) {
    final filteredEntries = _entriesForSelectedDate();
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              JournalHeader(
                onSearch: () {},
                onViewOptions: () {},
                entryCount: 18,
              ),
              FilterPills(
                filters: _filters,
                selectedIndex: _selectedFilterIndex,
                onFilterSelected: (index) {
                  setState(() => _selectedFilterIndex = index);
                },
              ),
              JournalCalendar(
                initialDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() => _selectedDate = date);
                },
                entryTypes: _buildEntryTypeMap(_allEntries),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _DateSectionHeader(
                  date: _selectedDate,
                  entryCount: filteredEntries.length,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: filteredEntries.isEmpty
                    ? _buildEmptyEntries()
                    : Column(
                        children: filteredEntries
                            .map(
                              (entry) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: JournalEntryCard(
                                  entry: entry,
                                  onTap: () => showJournalEntryDetailSheet(
                                    context,
                                    entry,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ),
              if (widget.showBottomNav) ...[
                const SizedBox(height: 16),
                CustomBottomNav(
                  currentIndex: _currentNavIndex,
                  onTap: (index) => setState(() => _currentNavIndex = index),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyEntries() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.journalNeutral.withOpacity(0.35)),
      ),
      child: Text(
        'No journal entries for this date and filter.',
        style: GoogleFonts.inter(fontSize: 13, color: AppColors.textLight),
      ),
    );
  }

  List<JournalEntry> _entriesForSelectedDate() {
    final selected = _dateOnly(_selectedDate);
    return _allEntries.where((entry) {
      final matchesDate = _dateOnly(entry.dateTime) == selected;
      if (!matchesDate) {
        return false;
      }

      if (_selectedFilterIndex == 0) {
        return true;
      }

      final selectedFilter = _filters[_selectedFilterIndex].toLowerCase();
      return entry.product1Full.toLowerCase() == selectedFilter;
    }).toList()..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  Map<DateTime, JournalEntryType> _buildEntryTypeMap(
    List<JournalEntry> entries,
  ) {
    final map = <DateTime, JournalEntryType>{};
    for (final entry in entries) {
      map[_dateOnly(entry.dateTime)] = entry.entryType;
    }
    return map;
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}

class _DateSectionHeader extends StatelessWidget {
  const _DateSectionHeader({required this.date, required this.entryCount});

  final DateTime date;
  final int entryCount;

  @override
  Widget build(BuildContext context) {
    final headerDate = DateFormat('EEE, d MMMM').format(date);
    final entryText = entryCount == 1 ? 'entry' : 'entries';
    return Row(
      children: [
        Expanded(
          child: Text(
            '$headerDate • $entryCount $entryText',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'View >',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.journalEnergy,
            ),
          ),
        ),
      ],
    );
  }
}
