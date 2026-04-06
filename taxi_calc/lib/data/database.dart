import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taxi_calc/data/tables/daily_entries_table.dart';
import 'package:taxi_calc/data/tables/daily_expense_items_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [DailyEntries, DailyExpenseItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(dailyExpenseItems);
        await m.addColumn(dailyEntries, dailyEntries.kilometrage);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File('${dbFolder.path}/taxi_calc.sqlite');
    return NativeDatabase.createInBackground(file);
  });
}
