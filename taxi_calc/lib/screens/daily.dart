import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taxi_calc/core/localization/app_strings.dart';
import 'package:taxi_calc/data/database.dart';
import 'package:taxi_calc/data/providers/daily_entries_provider.dart';
import 'package:taxi_calc/layout_screen.dart/master_screen.dart';

class DailyScreen extends StatelessWidget {
  const DailyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return MasterScreen(
      title: strings.dailyTitle,
      showBackButton: true,
      child: const _DailyContent(),
    );
  }
}

class _DailyContent extends StatefulWidget {
  const _DailyContent();

  @override
  State<_DailyContent> createState() => _DailyContentState();
}

class _DailyContentState extends State<_DailyContent> {
  late final AppDatabase _db;
  late final DailyEntriesProvider _provider;

  DateTime _selectedDate = DateUtils.dateOnly(DateTime.now());
  bool _isLoading = true;
  List<DailyEntry> _entries = const [];
  Map<int, List<DailyExpenseItem>> _expenseItemsByEntryId = const {};

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _provider = DailyEntriesProvider(_db);
    _loadEntries();
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  Future<void> _loadEntries() async {
    setState(() => _isLoading = true);
    final entries = await _provider.getByDate(_selectedDate);
    final items = await _provider.getExpenseItemsByEntryIds(
      entries.map((e) => e.id).toList(),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _entries = entries;
      _expenseItemsByEntryId = items;
      _isLoading = false;
    });
  }

  Future<void> _pickDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: today,
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _selectedDate = DateUtils.dateOnly(picked);
    });

    await _loadEntries();
  }

  String _money(double value) => '${value.toStringAsFixed(2)} KM';

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    final gross = _entries.fold<double>(0, (sum, e) => sum + e.income);
    final totalExpenses = _entries.fold<double>(
      0,
      (sum, e) => sum + e.expenses,
    );
    final net = gross - totalExpenses;

    var fuel = 0.0;
    var food = 0.0;
    var service = 0.0;
    var other = 0.0;

    for (final entry in _entries) {
      final items =
          _expenseItemsByEntryId[entry.id] ?? const <DailyExpenseItem>[];

      if (items.isEmpty) {
        other += entry.expenses;
        continue;
      }

      for (final item in items) {
        final label = strings.expenseLabelFromStored(item.label);
        if (label.startsWith(strings.fuelLabel)) {
          fuel += item.amount;
        } else if (label.startsWith(strings.foodLabel)) {
          food += item.amount;
        } else if (label.startsWith(strings.serviceLabel)) {
          service += item.amount;
        } else {
          other += item.amount;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _DateSelector(
                  title: strings.selectDate,
                  dateText: DateFormat('dd.MM.yyyy').format(_selectedDate),
                  onPickDate: _pickDate,
                ),
                const SizedBox(height: 12),
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
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _money(net),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${strings.entriesCount}: ${_entries.length}',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (_entries.isEmpty)
                  Center(child: Text(strings.noDataForDate))
                else
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.3,
                    children: [
                      _StatCard(
                        label: strings.totalRevenue,
                        value: _money(gross),
                      ),
                      _StatCard(
                        label: strings.totalExpenses,
                        value: _money(totalExpenses),
                      ),
                      _StatCard(label: strings.fuelLabel, value: _money(fuel)),
                      _StatCard(label: strings.foodLabel, value: _money(food)),
                      _StatCard(
                        label: strings.serviceLabel,
                        value: _money(service),
                      ),
                      _StatCard(
                        label: strings.otherLabel,
                        value: _money(other),
                      ),
                    ],
                  ),
              ],
            ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  const _DateSelector({
    required this.title,
    required this.dateText,
    required this.onPickDate,
  });

  final String title;
  final String dateText;
  final VoidCallback onPickDate;

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
          OutlinedButton.icon(
            onPressed: onPickDate,
            icon: const Icon(Icons.calendar_today),
            label: Text(dateText),
          ),
        ],
      ),
    );
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
