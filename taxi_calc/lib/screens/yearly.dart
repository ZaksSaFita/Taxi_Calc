import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:taxi_calc/core/localization/app_strings.dart';
import 'package:taxi_calc/data/database.dart';
import 'package:taxi_calc/data/providers/daily_entries_provider.dart';
import 'package:taxi_calc/layout_screen.dart/master_screen.dart';

class YearlyScreen extends StatefulWidget {
  const YearlyScreen({super.key});

  @override
  State<YearlyScreen> createState() => _YearlyScreenState();
}

class _YearlyScreenState extends State<YearlyScreen> {
  late final AppDatabase _db;
  late final DailyEntriesProvider _provider;

  late int _selectedYear;
  bool _loading = true;
  PeriodFinancialSummary? _summary;
  List<MonthFinancialSummary> _months = const [];

  int get _currentYear => DateTime.now().year;
  int get _startYear => 2026;

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _provider = DailyEntriesProvider(_db);
    _selectedYear = _currentYear < _startYear ? _startYear : _currentYear;
    _load();
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  List<int> get _availableYears {
    final end = _currentYear < _startYear ? _startYear : _currentYear;
    return [for (int y = _startYear; y <= end; y++) y];
  }

  Future<void> _load() async {
    setState(() => _loading = true);

    final start = DateTime(_selectedYear, 1, 1);
    final end = DateTime(_selectedYear + 1, 1, 1);
    final summary = await _provider.getSummaryForRange(
      startInclusive: start,
      endExclusive: end,
    );
    final months = await _provider.getMonthlySummariesForYear(_selectedYear);

    if (!mounted) {
      return;
    }

    setState(() {
      _summary = summary;
      _months = months;
      _loading = false;
    });
  }

  String _money(double value) => '${value.toStringAsFixed(2)} KM';

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return MasterScreen(
      title: strings.yearlyTitle,
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          children: [
            _YearSelector(
              title: strings.chooseYear,
              yearLabel: strings.year,
              selectedYear: _selectedYear,
              years: _availableYears,
              onChanged: (year) async {
                setState(() => _selectedYear = year);
                await _load();
              },
            ),
            const SizedBox(height: 14),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _summary == null || _summary!.entriesCount == 0
                  ? Center(child: Text(strings.noDataForYear))
                  : _YearlyDashboard(
                      summary: _summary!,
                      months: _months,
                      strings: strings,
                      money: _money,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YearlyDashboard extends StatelessWidget {
  const _YearlyDashboard({
    required this.summary,
    required this.months,
    required this.strings,
    required this.money,
  });

  final PeriodFinancialSummary summary;
  final List<MonthFinancialSummary> months;
  final AppStrings strings;
  final String Function(double) money;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.secondaryContainer,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.net,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                money(summary.net),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${strings.entriesCount}: ${summary.entriesCount}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 180,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.yearlyTrend,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: CustomPaint(
                  painter: _YearTrendPainter(
                    values: months.map((m) => m.summary.net).toList(),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            _StatCard(label: strings.grossRevenue, value: money(summary.gross)),
            _StatCard(
              label: strings.totalExpenses,
              value: money(summary.expenses),
            ),
            _StatCard(label: strings.fuelLabel, value: money(summary.fuel)),
            _StatCard(label: strings.foodLabel, value: money(summary.food)),
            _StatCard(
              label: strings.serviceLabel,
              value: money(summary.service),
            ),
            _StatCard(label: strings.otherLabel, value: money(summary.other)),
          ],
        ),
      ],
    );
  }
}

class _YearTrendPainter extends CustomPainter {
  _YearTrendPainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) {
      return;
    }

    final maxAbs = values.fold<double>(0, (p, e) => math.max(p, e.abs()));
    final safeMax = maxAbs == 0 ? 1 : maxAbs;
    final centerY = size.height / 2;

    final axisPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), axisPaint);

    final barWidth = size.width / (values.length * 1.8);
    for (var i = 0; i < values.length; i++) {
      final x = (i + 0.5) * (size.width / values.length);
      final h = (values[i].abs() / safeMax) * (size.height * 0.45);
      final top = values[i] >= 0 ? centerY - h : centerY;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x - barWidth / 2, top, barWidth, h),
        const Radius.circular(4),
      );
      final paint = Paint()..color = values[i] >= 0 ? color : Colors.redAccent;
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _YearTrendPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _YearSelector extends StatelessWidget {
  const _YearSelector({
    required this.title,
    required this.yearLabel,
    required this.selectedYear,
    required this.years,
    required this.onChanged,
  });

  final String title;
  final String yearLabel;
  final int selectedYear;
  final List<int> years;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 10),
          DropdownButton<int>(
            value: selectedYear,
            underline: const SizedBox.shrink(),
            onChanged: (value) {
              if (value == null) {
                return;
              }
              onChanged(value);
            },
            items: years
                .map(
                  (year) => DropdownMenuItem<int>(
                    value: year,
                    child: Text('$yearLabel $year'),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
