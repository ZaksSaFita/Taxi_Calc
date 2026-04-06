import 'package:drift/drift.dart';

class DailyEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  RealColumn get income => real()();
  RealColumn get expenses => real().withDefault(const Constant(0))();
  RealColumn get kilometrage => real().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
