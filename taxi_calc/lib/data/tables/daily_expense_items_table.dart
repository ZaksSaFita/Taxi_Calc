import 'package:drift/drift.dart';
import 'package:taxi_calc/data/tables/daily_entries_table.dart';

class DailyExpenseItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dailyEntryId => integer().references(DailyEntries, #id)();
  TextColumn get label => text()();
  RealColumn get amount => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
