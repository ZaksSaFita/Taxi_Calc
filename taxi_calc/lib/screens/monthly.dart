import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taxi_calc/core/localization/app_strings.dart';
import 'package:taxi_calc/data/database.dart';
import 'package:taxi_calc/data/providers/daily_entries_provider.dart';
import 'package:taxi_calc/layout_screen.dart/master_screen.dart';

class MonthlyScreen extends StatefulWidget {
  const MonthlyScreen({super.key});

  @override
  State<MonthlyScreen> createState() => _MonthlyScreenState();
}

class _MonthlyScreenState extends State<MonthlyScreen> {
  late final AppDatabase _db;
  late final DailyEntriesProvider _provider;

  late int _selectedYear;
  bool _loading = true;
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
    final result = await _provider.getMonthlySummariesForYear(_selectedYear);

    if (!mounted) {
      return;
    }

    setState(() {
      _months = result;
      _loading = false;
    });
  }

  String _money(double value) => '${value.toStringAsFixed(2)} KM';

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return MasterScreen(
      title: strings.monthlyTitle,
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
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.95,
                          ),
                      itemCount: _months.length,
                      itemBuilder: (context, index) {
                        final month = _months[index];
                        final s = month.summary;

                        return InkWell(
                          borderRadius: BorderRadius.circular(22),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => _MonthDetailsScreen(
                                year: _selectedYear,
                                month: month.month,
                              ),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainer,
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    strings.monthName(month.month),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _MetricLine(
                                    label: strings.grossRevenue,
                                    value: _money(s.gross),
                                  ),
                                  _MetricLine(
                                    label: strings.fuelLabel,
                                    value: _money(s.fuel),
                                  ),
                                  _MetricLine(
                                    label: strings.serviceLabel,
                                    value: _money(s.service),
                                  ),
                                  _MetricLine(
                                    label: strings.foodLabel,
                                    value: _money(s.food),
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface
                                          .withValues(alpha: 0.75),
                                    ),
                                    child: Text(
                                      '${strings.net}: ${_money(s.net)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthDetailsScreen extends StatefulWidget {
  const _MonthDetailsScreen({required this.year, required this.month});

  final int year;
  final int month;

  @override
  State<_MonthDetailsScreen> createState() => _MonthDetailsScreenState();
}

class _MonthDetailsScreenState extends State<_MonthDetailsScreen> {
  late final AppDatabase _db;
  late final DailyEntriesProvider _provider;

  bool _loading = true;
  List<DailyEntry> _entries = const [];
  Map<int, List<DailyExpenseItem>> _itemsByEntry = const {};

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _provider = DailyEntriesProvider(_db);
    _load();
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final entries = await _provider.getEntriesForMonth(
      year: widget.year,
      month: widget.month,
    );
    final items = await _provider.getExpenseItemsByEntryIds(
      entries.map((e) => e.id).toList(),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _entries = entries;
      _itemsByEntry = items;
      _loading = false;
    });
  }

  String _money(double value) => '${value.toStringAsFixed(2)} KM';

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return MasterScreen(
      title: strings.entriesForMonth(widget.month),
      showBackButton: true,
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _entries.isEmpty
          ? Center(child: Text(strings.noDataForMonth))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                final items = _itemsByEntry[entry.id] ?? const [];
                final expenses = items.isEmpty
                    ? entry.expenses
                    : items.fold<double>(0, (s, i) => s + i.amount);
                final net = entry.income - expenses;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('dd.MM.yyyy').format(entry.date),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${strings.grossRevenue}: ${_money(entry.income)}',
                        ),
                        Text('${strings.totalExpenses}: ${_money(expenses)}'),
                        Text('${strings.net}: ${_money(net)}'),
                        if (items.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            strings.expenseItemsSubtitle,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          ...items.map(
                            (i) => Text(
                              '- ${strings.expenseLabelFromStored(i.label)}: ${_money(i.amount)}',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
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

class _MetricLine extends StatelessWidget {
  const _MetricLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
