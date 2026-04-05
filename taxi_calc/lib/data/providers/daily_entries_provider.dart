import 'package:drift/drift.dart';
import 'package:taxi_calc/data/database.dart';
import 'package:taxi_calc/data/providers/base_crud_provider.dart';

class PeriodFinancialSummary {
  const PeriodFinancialSummary({
    required this.gross,
    required this.expenses,
    required this.fuel,
    required this.food,
    required this.service,
    required this.other,
    required this.net,
    required this.entriesCount,
  });

  final double gross;
  final double expenses;
  final double fuel;
  final double food;
  final double service;
  final double other;
  final double net;
  final int entriesCount;
}

class MonthFinancialSummary {
  const MonthFinancialSummary({required this.month, required this.summary});

  final int month;
  final PeriodFinancialSummary summary;
}

class DailyEntriesProvider
    extends BaseCrudProvider<DailyEntry, DailyEntriesCompanion> {
  DailyEntriesProvider(this._db);

  final AppDatabase _db;

  @override
  Future<List<DailyEntry>> getAll() {
    return _db.select(_db.dailyEntries).get();
  }

  @override
  Future<DailyEntry?> getById(int id) {
    return (_db.select(
      _db.dailyEntries,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  @override
  Future<int> create(DailyEntriesCompanion item) {
    return _db.into(_db.dailyEntries).insert(item);
  }

  @override
  Future<bool> update(DailyEntriesCompanion item) {
    if (!item.id.present) {
      throw ArgumentError(
        'DailyEntriesCompanion.id mora biti postavljen za update.',
      );
    }

    return _db.update(_db.dailyEntries).replace(item);
  }

  @override
  Future<int> delete(int id) {
    return (_db.delete(
      _db.dailyEntries,
    )..where((table) => table.id.equals(id))).go();
  }

  Future<List<DailyEntry>> getByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (_db.select(_db.dailyEntries)..where(
          (table) =>
              table.date.isBiggerOrEqual(Variable(startOfDay)) &
              table.date.isSmallerThan(Variable(endOfDay)),
        ))
        .get();
  }

  Future<DailyEntry?> getFirstByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (_db.select(_db.dailyEntries)
          ..where(
            (table) =>
                table.date.isBiggerOrEqual(Variable(startOfDay)) &
                table.date.isSmallerThan(Variable(endOfDay)),
          )
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<DailyExpenseItem>> getExpenseItemsByEntryId(int entryId) {
    return (_db.select(
      _db.dailyExpenseItems,
    )..where((table) => table.dailyEntryId.equals(entryId))).get();
  }

  Future<Map<int, List<DailyExpenseItem>>> getExpenseItemsByEntryIds(
    List<int> entryIds,
  ) async {
    if (entryIds.isEmpty) {
      return {};
    }

    final rows = await (_db.select(
      _db.dailyExpenseItems,
    )..where((table) => table.dailyEntryId.isIn(entryIds))).get();

    final grouped = <int, List<DailyExpenseItem>>{};
    for (final row in rows) {
      grouped.putIfAbsent(row.dailyEntryId, () => []).add(row);
    }

    return grouped;
  }

  Future<int> createWithExpenseItems({
    required DailyEntriesCompanion entry,
    required List<DailyExpenseItemsCompanion> expenseItems,
  }) async {
    return _db.transaction(() async {
      final entryId = await _db.into(_db.dailyEntries).insert(entry);

      if (expenseItems.isNotEmpty) {
        final mapped = expenseItems
            .map((item) => item.copyWith(dailyEntryId: Value(entryId)))
            .toList();

        await _db.batch((batch) {
          batch.insertAll(_db.dailyExpenseItems, mapped);
        });
      }

      return entryId;
    });
  }

  Future<int> upsertByDateWithExpenseItems({
    required DateTime date,
    required DailyEntriesCompanion entry,
    required List<DailyExpenseItemsCompanion> expenseItems,
  }) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _db.transaction(() async {
      final existing =
          await (_db.select(_db.dailyEntries)
                ..where(
                  (table) =>
                      table.date.isBiggerOrEqual(Variable(startOfDay)) &
                      table.date.isSmallerThan(Variable(endOfDay)),
                )
                ..orderBy([(table) => OrderingTerm.desc(table.createdAt)])
                ..limit(1))
              .getSingleOrNull();

      late final int entryId;
      if (existing == null) {
        entryId = await _db.into(_db.dailyEntries).insert(entry);
      } else {
        entryId = existing.id;
        await _db
            .update(_db.dailyEntries)
            .replace(entry.copyWith(id: Value(entryId)));

        await (_db.delete(
          _db.dailyExpenseItems,
        )..where((table) => table.dailyEntryId.equals(entryId))).go();
      }

      if (expenseItems.isNotEmpty) {
        final mapped = expenseItems
            .map((item) => item.copyWith(dailyEntryId: Value(entryId)))
            .toList();

        await _db.batch((batch) {
          batch.insertAll(_db.dailyExpenseItems, mapped);
        });
      }

      return entryId;
    });
  }

  Future<PeriodFinancialSummary> getSummaryForRange({
    required DateTime startInclusive,
    required DateTime endExclusive,
  }) async {
    final entries = await _getEntriesInRange(
      startInclusive: startInclusive,
      endExclusive: endExclusive,
    );
    final entryIds = entries.map((e) => e.id).toList();
    final itemsByEntryId = await getExpenseItemsByEntryIds(entryIds);
    return _buildSummary(entries: entries, itemsByEntryId: itemsByEntryId);
  }

  Future<List<MonthFinancialSummary>> getMonthlySummariesForYear(
    int year,
  ) async {
    final start = DateTime(year, 1, 1);
    final end = DateTime(year + 1, 1, 1);
    final entries = await _getEntriesInRange(
      startInclusive: start,
      endExclusive: end,
    );
    final entryIds = entries.map((e) => e.id).toList();
    final itemsByEntryId = await getExpenseItemsByEntryIds(entryIds);

    final monthEntries = <int, List<DailyEntry>>{
      for (var m = 1; m <= 12; m++) m: [],
    };

    for (final entry in entries) {
      monthEntries[entry.date.month]!.add(entry);
    }

    final result = <MonthFinancialSummary>[];
    for (var month = 1; month <= 12; month++) {
      result.add(
        MonthFinancialSummary(
          month: month,
          summary: _buildSummary(
            entries: monthEntries[month]!,
            itemsByEntryId: itemsByEntryId,
          ),
        ),
      );
    }
    return result;
  }

  Future<List<DailyEntry>> getEntriesForMonth({
    required int year,
    required int month,
  }) {
    final start = DateTime(year, month, 1);
    final end = month == 12
        ? DateTime(year + 1, 1, 1)
        : DateTime(year, month + 1, 1);
    return _getEntriesInRange(startInclusive: start, endExclusive: end);
  }

  Future<List<DailyEntry>> _getEntriesInRange({
    required DateTime startInclusive,
    required DateTime endExclusive,
  }) {
    return (_db.select(_db.dailyEntries)..where(
          (table) =>
              table.date.isBiggerOrEqual(Variable(startInclusive)) &
              table.date.isSmallerThan(Variable(endExclusive)),
        ))
        .get();
  }

  PeriodFinancialSummary _buildSummary({
    required List<DailyEntry> entries,
    required Map<int, List<DailyExpenseItem>> itemsByEntryId,
  }) {
    var gross = 0.0;
    var expenses = 0.0;
    var fuel = 0.0;
    var food = 0.0;
    var service = 0.0;
    var other = 0.0;

    for (final entry in entries) {
      gross += entry.income;
      final items = itemsByEntryId[entry.id] ?? const <DailyExpenseItem>[];

      if (items.isEmpty) {
        expenses += entry.expenses;
        other += entry.expenses;
        continue;
      }

      for (final item in items) {
        expenses += item.amount;
        switch (_normalizeExpenseLabel(item.label)) {
          case 'fuel':
            fuel += item.amount;
            break;
          case 'food':
            food += item.amount;
            break;
          case 'service':
            service += item.amount;
            break;
          default:
            other += item.amount;
            break;
        }
      }
    }

    return PeriodFinancialSummary(
      gross: gross,
      expenses: expenses,
      fuel: fuel,
      food: food,
      service: service,
      other: other,
      net: gross - expenses,
      entriesCount: entries.length,
    );
  }

  String _normalizeExpenseLabel(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized.startsWith('service:')) {
      return 'service';
    }
    switch (normalized) {
      case 'fuel':
      case 'gorivo':
      case 'kraftstoff':
        return 'fuel';
      case 'food':
      case 'hrana':
      case 'essen':
        return 'food';
      case 'service':
      case 'servis':
        return 'service';
      case 'other':
      case 'ostalo':
      case 'sonstiges':
        return 'other';
      default:
        return 'other';
    }
  }
}
