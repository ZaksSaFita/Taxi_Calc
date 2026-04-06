import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taxi_calc/core/localization/app_strings.dart';
import 'package:taxi_calc/data/database.dart';
import 'package:taxi_calc/data/providers/daily_entries_provider.dart';
import 'package:taxi_calc/layout_screen.dart/master_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late final AppDatabase _db;
  late final DailyEntriesProvider _provider;

  late int _selectedYear;
  bool _loading = true;
  List<_ServiceBucket> _buckets = const [];

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

    final monthlyEntries = await Future.wait([
      for (var month = 1; month <= 12; month++)
        _provider.getEntriesForMonth(year: _selectedYear, month: month),
    ]);
    final entries = monthlyEntries.expand((e) => e).toList();
    final itemsByEntryId = await _provider.getExpenseItemsByEntryIds(
      entries.map((e) => e.id).toList(),
    );

    final bySubtype = <String, _ServiceBucketBuilder>{};
    for (final entry in entries) {
      final items = itemsByEntryId[entry.id] ?? const <DailyExpenseItem>[];
      for (final item in items) {
        final subtype = _serviceSubtypeKey(item.label);
        if (subtype == null) {
          continue;
        }

        final current = bySubtype.putIfAbsent(
          subtype,
          () => _ServiceBucketBuilder(subtypeKey: subtype),
        );
        current.total += item.amount;
        current.records.add(_ServiceRecord(date: entry.date, amount: item.amount));
      }
    }

    final buckets = bySubtype.values.map((e) => e.build()).toList()
      ..sort((a, b) => b.total.compareTo(a.total));

    if (!mounted) {
      return;
    }

    setState(() {
      _buckets = buckets;
      _loading = false;
    });
  }

  String? _serviceSubtypeKey(String label) {
    final normalized = label.trim().toLowerCase();
    if (normalized.startsWith('service:')) {
      final key = normalized.substring('service:'.length);
      if (key.isEmpty) {
        return 'general_service';
      }
      return key;
    }
    if (normalized == 'service' || normalized == 'servis') {
      return 'general_service';
    }
    return null;
  }

  String _money(double value) => '${value.toStringAsFixed(2)} KM';

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final totalService = _buckets.fold<double>(0, (sum, e) => sum + e.total);
    final totalItems = _buckets.fold<int>(0, (sum, e) => sum + e.count);
    final latestDate = _buckets
        .where((e) => e.lastDate != null)
        .map((e) => e.lastDate!)
        .fold<DateTime?>(null, (prev, date) {
          if (prev == null || date.isAfter(prev)) {
            return date;
          }
          return prev;
        });
    final latestDateText = latestDate == null
        ? '-'
        : DateFormat('dd.MM.yyyy').format(latestDate);

    return MasterScreen(
      title: strings.servicesTitle,
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
                  : _buckets.isEmpty
                  ? Center(child: Text(strings.noServiceDataForYear))
                  : ListView(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primaryContainer,
                                Theme.of(context).colorScheme.tertiaryContainer,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                strings.serviceSpend,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _money(totalService),
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${strings.serviceItemsCount}: $totalItems',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                              Text(
                                '${strings.lastServiceDate}: $latestDateText',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          strings.serviceByType,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._buckets.map((bucket) {
                          final typeLabel =
                              bucket.subtypeKey == 'general_service'
                              ? strings.serviceGeneral
                              : strings.serviceSubtypeLabel(bucket.subtypeKey);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => _ServiceTypeDetailsScreen(
                                      bucket: bucket,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHigh,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            typeLabel,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${strings.serviceItemsCount}: ${bucket.count}',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 0.8),
                                            ),
                                          ),
                                          Text(
                                            '${strings.lastServiceDate}: ${bucket.lastDateText}',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          _money(bucket.total),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Icon(
                                          Icons.chevron_right,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceTypeDetailsScreen extends StatelessWidget {
  const _ServiceTypeDetailsScreen({required this.bucket});

  final _ServiceBucket bucket;

  String _money(double value) => '${value.toStringAsFixed(2)} KM';

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final typeLabel = bucket.subtypeKey == 'general_service'
        ? strings.serviceGeneral
        : strings.serviceSubtypeLabel(bucket.subtypeKey);

    return MasterScreen(
      title: typeLabel,
      showBackButton: true,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.serviceDetailsTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  label: strings.serviceSpend,
                  value: _money(bucket.total),
                ),
                _DetailRow(
                  label: strings.serviceItemsCount,
                  value: '${bucket.count}',
                ),
                _DetailRow(
                  label: strings.lastServiceDate,
                  value: bucket.lastDateText,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            strings.serviceHistory,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ...bucket.records.map((record) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${strings.serviceDateLabel}: ${record.dateText}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          typeLabel,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _money(record.amount),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            );
          }),
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _ServiceBucket {
  const _ServiceBucket({
    required this.subtypeKey,
    required this.total,
    required this.records,
  });

  final String subtypeKey;
  final double total;
  final List<_ServiceRecord> records;

  int get count => records.length;
  DateTime? get lastDate => records.isEmpty ? null : records.first.date;
  String get lastDateText =>
      lastDate == null ? '-' : DateFormat('dd.MM.yyyy').format(lastDate!);
}

class _ServiceBucketBuilder {
  _ServiceBucketBuilder({required this.subtypeKey});

  final String subtypeKey;
  double total = 0;
  final List<_ServiceRecord> records = [];

  _ServiceBucket build() {
    records.sort((a, b) => b.date.compareTo(a.date));
    return _ServiceBucket(
      subtypeKey: subtypeKey,
      total: total,
      records: List<_ServiceRecord>.unmodifiable(records),
    );
  }
}

class _ServiceRecord {
  const _ServiceRecord({required this.date, required this.amount});

  final DateTime date;
  final double amount;

  String get dateText => DateFormat('dd.MM.yyyy').format(date);
}
