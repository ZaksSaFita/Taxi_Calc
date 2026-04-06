import 'package:drift/drift.dart';

class Documents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get typeKey => text()();
  TextColumn get title => text()();
  TextColumn get relatedTo => text().withDefault(const Constant(''))();
  TextColumn get documentNumber => text().withDefault(const Constant(''))();
  DateTimeColumn get issueDate => dateTime().nullable()();
  DateTimeColumn get expiryDate => dateTime()();
  IntColumn get reminderDays => integer().withDefault(const Constant(30))();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
