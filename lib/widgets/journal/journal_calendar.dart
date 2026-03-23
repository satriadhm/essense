import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../models/journal_entry_model.dart';
import '../../theme/app_theme.dart';

class JournalCalendar extends StatefulWidget {
  const JournalCalendar({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
    required this.entryTypes,
  });

  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;
  final Map<DateTime, JournalEntryType> entryTypes;

  @override
  State<JournalCalendar> createState() => _JournalCalendarState();
}

class _JournalCalendarState extends State<JournalCalendar> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = _dateOnly(widget.initialDate);
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  @override
  Widget build(BuildContext context) {
    final monthFormatter = DateFormat('MMMM yyyy');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.journalNeutral.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  monthFormatter.format(_currentMonth),
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _goToPreviousMonth,
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 24,
                        color: AppColors.journalNeutral,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _goToNextMonth,
                      icon: const Icon(
                        Icons.chevron_right,
                        size: 24,
                        color: AppColors.journalNeutral,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                  .map(
                    (day) => Expanded(
                      child: Center(
                        child: Text(day, textAlign: TextAlign.center),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            _buildGrid(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _LegendItem(label: 'Calm', color: AppColors.journalCalm),
                SizedBox(width: 16),
                _LegendItem(label: 'Energy', color: AppColors.journalEnergy),
                SizedBox(width: 16),
                _LegendItem(label: 'Neutral', color: AppColors.journalNeutral),
                SizedBox(width: 16),
                _LegendItem(
                  label: 'Selected',
                  color: AppColors.journalCalm,
                  square: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    final daysInMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    ).day;
    final firstDayOffset =
        DateTime(_currentMonth.year, _currentMonth.month, 1).weekday - 1;
    final totalCells = ((firstDayOffset + daysInMonth + 6) ~/ 7) * 7;

    return GridView.builder(
      itemCount: totalCells,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final date = _dateAtGridIndex(index, firstDayOffset);
        final isCurrentMonth = date.month == _currentMonth.month;
        return _buildDayCell(date, isCurrentMonth: isCurrentMonth);
      },
    );
  }

  DateTime _dateAtGridIndex(int index, int firstDayOffset) {
    if (index < firstDayOffset) {
      final previousMonthStart = DateTime(
        _currentMonth.year,
        _currentMonth.month,
        1,
      );
      return DateTime(
        previousMonthStart.year,
        previousMonthStart.month,
        index - firstDayOffset + 1,
      );
    }

    final day = index - firstDayOffset + 1;
    return DateTime(_currentMonth.year, _currentMonth.month, day);
  }

  Widget _buildDayCell(DateTime date, {required bool isCurrentMonth}) {
    final dayDate = _dateOnly(date);
    final isToday = _isSameDate(dayDate, _dateOnly(DateTime.now()));
    final isSelected = _isSameDate(dayDate, _selectedDate);
    final color = _typeColor(widget.entryTypes[dayDate]);
    final hasType = color != null;

    Color? backgroundColor;
    if (isSelected) {
      backgroundColor = color ?? AppColors.journalCalm.withOpacity(0.6);
    } else if (hasType && isCurrentMonth) {
      backgroundColor = color!.withOpacity(0.35);
    } else if (!isCurrentMonth) {
      backgroundColor = AppColors.journalNeutral.withOpacity(0.08);
    }

    BoxBorder? border;
    if (isToday) {
      border = Border.all(color: Colors.white, width: 1);
    } else if (isSelected && color != null) {
      border = Border.all(color: color, width: 1);
    }

    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () {
        setState(() {
          _selectedDate = dayDate;
          _currentMonth = DateTime(dayDate.year, dayDate.month);
        });
        widget.onDateSelected(dayDate);
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6),
          border: border,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              dayDate.day.toString().padLeft(2, '0'),
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isCurrentMonth
                    ? Colors.white
                    : AppColors.textJournalMuted,
              ),
            ),
            if (hasType)
              Positioned(
                bottom: 4,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _goToPreviousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Color? _typeColor(JournalEntryType? type) {
    switch (type) {
      case JournalEntryType.calm:
        return AppColors.journalCalm;
      case JournalEntryType.energy:
        return AppColors.journalEnergy;
      case JournalEntryType.neutral:
        return AppColors.journalNeutral;
      case null:
        return null;
    }
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.label,
    required this.color,
    this.square = false,
  });

  final String label;
  final Color color;
  final bool square;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: square ? BoxShape.rectangle : BoxShape.circle,
            borderRadius: square ? BorderRadius.circular(2) : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }
}
