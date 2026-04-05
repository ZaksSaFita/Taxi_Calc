// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DailyEntriesTable extends DailyEntries
    with TableInfo<$DailyEntriesTable, DailyEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _incomeMeta = const VerificationMeta('income');
  @override
  late final GeneratedColumn<double> income = GeneratedColumn<double>(
    'income',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expensesMeta = const VerificationMeta(
    'expenses',
  );
  @override
  late final GeneratedColumn<double> expenses = GeneratedColumn<double>(
    'expenses',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _kilometrageMeta = const VerificationMeta(
    'kilometrage',
  );
  @override
  late final GeneratedColumn<double> kilometrage = GeneratedColumn<double>(
    'kilometrage',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fuelPriceMeta = const VerificationMeta(
    'fuelPrice',
  );
  @override
  late final GeneratedColumn<double> fuelPrice = GeneratedColumn<double>(
    'fuel_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    income,
    expenses,
    kilometrage,
    fuelPrice,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('income')) {
      context.handle(
        _incomeMeta,
        income.isAcceptableOrUnknown(data['income']!, _incomeMeta),
      );
    } else if (isInserting) {
      context.missing(_incomeMeta);
    }
    if (data.containsKey('expenses')) {
      context.handle(
        _expensesMeta,
        expenses.isAcceptableOrUnknown(data['expenses']!, _expensesMeta),
      );
    }
    if (data.containsKey('kilometrage')) {
      context.handle(
        _kilometrageMeta,
        kilometrage.isAcceptableOrUnknown(
          data['kilometrage']!,
          _kilometrageMeta,
        ),
      );
    }
    if (data.containsKey('fuel_price')) {
      context.handle(
        _fuelPriceMeta,
        fuelPrice.isAcceptableOrUnknown(data['fuel_price']!, _fuelPriceMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      income: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}income'],
      )!,
      expenses: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}expenses'],
      )!,
      kilometrage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kilometrage'],
      ),
      fuelPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fuel_price'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DailyEntriesTable createAlias(String alias) {
    return $DailyEntriesTable(attachedDatabase, alias);
  }
}

class DailyEntry extends DataClass implements Insertable<DailyEntry> {
  final int id;
  final DateTime date;
  final double income;
  final double expenses;
  final double? kilometrage;
  final double? fuelPrice;
  final String? note;
  final DateTime createdAt;
  const DailyEntry({
    required this.id,
    required this.date,
    required this.income,
    required this.expenses,
    this.kilometrage,
    this.fuelPrice,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['income'] = Variable<double>(income);
    map['expenses'] = Variable<double>(expenses);
    if (!nullToAbsent || kilometrage != null) {
      map['kilometrage'] = Variable<double>(kilometrage);
    }
    if (!nullToAbsent || fuelPrice != null) {
      map['fuel_price'] = Variable<double>(fuelPrice);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DailyEntriesCompanion toCompanion(bool nullToAbsent) {
    return DailyEntriesCompanion(
      id: Value(id),
      date: Value(date),
      income: Value(income),
      expenses: Value(expenses),
      kilometrage: kilometrage == null && nullToAbsent
          ? const Value.absent()
          : Value(kilometrage),
      fuelPrice: fuelPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(fuelPrice),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory DailyEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyEntry(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      income: serializer.fromJson<double>(json['income']),
      expenses: serializer.fromJson<double>(json['expenses']),
      kilometrage: serializer.fromJson<double?>(json['kilometrage']),
      fuelPrice: serializer.fromJson<double?>(json['fuelPrice']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'income': serializer.toJson<double>(income),
      'expenses': serializer.toJson<double>(expenses),
      'kilometrage': serializer.toJson<double?>(kilometrage),
      'fuelPrice': serializer.toJson<double?>(fuelPrice),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DailyEntry copyWith({
    int? id,
    DateTime? date,
    double? income,
    double? expenses,
    Value<double?> kilometrage = const Value.absent(),
    Value<double?> fuelPrice = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => DailyEntry(
    id: id ?? this.id,
    date: date ?? this.date,
    income: income ?? this.income,
    expenses: expenses ?? this.expenses,
    kilometrage: kilometrage.present ? kilometrage.value : this.kilometrage,
    fuelPrice: fuelPrice.present ? fuelPrice.value : this.fuelPrice,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  DailyEntry copyWithCompanion(DailyEntriesCompanion data) {
    return DailyEntry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      income: data.income.present ? data.income.value : this.income,
      expenses: data.expenses.present ? data.expenses.value : this.expenses,
      kilometrage: data.kilometrage.present
          ? data.kilometrage.value
          : this.kilometrage,
      fuelPrice: data.fuelPrice.present ? data.fuelPrice.value : this.fuelPrice,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyEntry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('income: $income, ')
          ..write('expenses: $expenses, ')
          ..write('kilometrage: $kilometrage, ')
          ..write('fuelPrice: $fuelPrice, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    income,
    expenses,
    kilometrage,
    fuelPrice,
    note,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyEntry &&
          other.id == this.id &&
          other.date == this.date &&
          other.income == this.income &&
          other.expenses == this.expenses &&
          other.kilometrage == this.kilometrage &&
          other.fuelPrice == this.fuelPrice &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class DailyEntriesCompanion extends UpdateCompanion<DailyEntry> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<double> income;
  final Value<double> expenses;
  final Value<double?> kilometrage;
  final Value<double?> fuelPrice;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const DailyEntriesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.income = const Value.absent(),
    this.expenses = const Value.absent(),
    this.kilometrage = const Value.absent(),
    this.fuelPrice = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DailyEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required double income,
    this.expenses = const Value.absent(),
    this.kilometrage = const Value.absent(),
    this.fuelPrice = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : date = Value(date),
       income = Value(income);
  static Insertable<DailyEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<double>? income,
    Expression<double>? expenses,
    Expression<double>? kilometrage,
    Expression<double>? fuelPrice,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (income != null) 'income': income,
      if (expenses != null) 'expenses': expenses,
      if (kilometrage != null) 'kilometrage': kilometrage,
      if (fuelPrice != null) 'fuel_price': fuelPrice,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DailyEntriesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<double>? income,
    Value<double>? expenses,
    Value<double?>? kilometrage,
    Value<double?>? fuelPrice,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return DailyEntriesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      income: income ?? this.income,
      expenses: expenses ?? this.expenses,
      kilometrage: kilometrage ?? this.kilometrage,
      fuelPrice: fuelPrice ?? this.fuelPrice,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (income.present) {
      map['income'] = Variable<double>(income.value);
    }
    if (expenses.present) {
      map['expenses'] = Variable<double>(expenses.value);
    }
    if (kilometrage.present) {
      map['kilometrage'] = Variable<double>(kilometrage.value);
    }
    if (fuelPrice.present) {
      map['fuel_price'] = Variable<double>(fuelPrice.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyEntriesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('income: $income, ')
          ..write('expenses: $expenses, ')
          ..write('kilometrage: $kilometrage, ')
          ..write('fuelPrice: $fuelPrice, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DailyExpenseItemsTable extends DailyExpenseItems
    with TableInfo<$DailyExpenseItemsTable, DailyExpenseItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyExpenseItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dailyEntryIdMeta = const VerificationMeta(
    'dailyEntryId',
  );
  @override
  late final GeneratedColumn<int> dailyEntryId = GeneratedColumn<int>(
    'daily_entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES daily_entries (id)',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dailyEntryId,
    label,
    amount,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_expense_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyExpenseItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('daily_entry_id')) {
      context.handle(
        _dailyEntryIdMeta,
        dailyEntryId.isAcceptableOrUnknown(
          data['daily_entry_id']!,
          _dailyEntryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailyEntryIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyExpenseItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyExpenseItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dailyEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_entry_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DailyExpenseItemsTable createAlias(String alias) {
    return $DailyExpenseItemsTable(attachedDatabase, alias);
  }
}

class DailyExpenseItem extends DataClass
    implements Insertable<DailyExpenseItem> {
  final int id;
  final int dailyEntryId;
  final String label;
  final double amount;
  final DateTime createdAt;
  const DailyExpenseItem({
    required this.id,
    required this.dailyEntryId,
    required this.label,
    required this.amount,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['daily_entry_id'] = Variable<int>(dailyEntryId);
    map['label'] = Variable<String>(label);
    map['amount'] = Variable<double>(amount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DailyExpenseItemsCompanion toCompanion(bool nullToAbsent) {
    return DailyExpenseItemsCompanion(
      id: Value(id),
      dailyEntryId: Value(dailyEntryId),
      label: Value(label),
      amount: Value(amount),
      createdAt: Value(createdAt),
    );
  }

  factory DailyExpenseItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyExpenseItem(
      id: serializer.fromJson<int>(json['id']),
      dailyEntryId: serializer.fromJson<int>(json['dailyEntryId']),
      label: serializer.fromJson<String>(json['label']),
      amount: serializer.fromJson<double>(json['amount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dailyEntryId': serializer.toJson<int>(dailyEntryId),
      'label': serializer.toJson<String>(label),
      'amount': serializer.toJson<double>(amount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DailyExpenseItem copyWith({
    int? id,
    int? dailyEntryId,
    String? label,
    double? amount,
    DateTime? createdAt,
  }) => DailyExpenseItem(
    id: id ?? this.id,
    dailyEntryId: dailyEntryId ?? this.dailyEntryId,
    label: label ?? this.label,
    amount: amount ?? this.amount,
    createdAt: createdAt ?? this.createdAt,
  );
  DailyExpenseItem copyWithCompanion(DailyExpenseItemsCompanion data) {
    return DailyExpenseItem(
      id: data.id.present ? data.id.value : this.id,
      dailyEntryId: data.dailyEntryId.present
          ? data.dailyEntryId.value
          : this.dailyEntryId,
      label: data.label.present ? data.label.value : this.label,
      amount: data.amount.present ? data.amount.value : this.amount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyExpenseItem(')
          ..write('id: $id, ')
          ..write('dailyEntryId: $dailyEntryId, ')
          ..write('label: $label, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dailyEntryId, label, amount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyExpenseItem &&
          other.id == this.id &&
          other.dailyEntryId == this.dailyEntryId &&
          other.label == this.label &&
          other.amount == this.amount &&
          other.createdAt == this.createdAt);
}

class DailyExpenseItemsCompanion extends UpdateCompanion<DailyExpenseItem> {
  final Value<int> id;
  final Value<int> dailyEntryId;
  final Value<String> label;
  final Value<double> amount;
  final Value<DateTime> createdAt;
  const DailyExpenseItemsCompanion({
    this.id = const Value.absent(),
    this.dailyEntryId = const Value.absent(),
    this.label = const Value.absent(),
    this.amount = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DailyExpenseItemsCompanion.insert({
    this.id = const Value.absent(),
    required int dailyEntryId,
    required String label,
    required double amount,
    this.createdAt = const Value.absent(),
  }) : dailyEntryId = Value(dailyEntryId),
       label = Value(label),
       amount = Value(amount);
  static Insertable<DailyExpenseItem> custom({
    Expression<int>? id,
    Expression<int>? dailyEntryId,
    Expression<String>? label,
    Expression<double>? amount,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dailyEntryId != null) 'daily_entry_id': dailyEntryId,
      if (label != null) 'label': label,
      if (amount != null) 'amount': amount,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DailyExpenseItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? dailyEntryId,
    Value<String>? label,
    Value<double>? amount,
    Value<DateTime>? createdAt,
  }) {
    return DailyExpenseItemsCompanion(
      id: id ?? this.id,
      dailyEntryId: dailyEntryId ?? this.dailyEntryId,
      label: label ?? this.label,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dailyEntryId.present) {
      map['daily_entry_id'] = Variable<int>(dailyEntryId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyExpenseItemsCompanion(')
          ..write('id: $id, ')
          ..write('dailyEntryId: $dailyEntryId, ')
          ..write('label: $label, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DailyEntriesTable dailyEntries = $DailyEntriesTable(this);
  late final $DailyExpenseItemsTable dailyExpenseItems =
      $DailyExpenseItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dailyEntries,
    dailyExpenseItems,
  ];
}

typedef $$DailyEntriesTableCreateCompanionBuilder =
    DailyEntriesCompanion Function({
      Value<int> id,
      required DateTime date,
      required double income,
      Value<double> expenses,
      Value<double?> kilometrage,
      Value<double?> fuelPrice,
      Value<String?> note,
      Value<DateTime> createdAt,
    });
typedef $$DailyEntriesTableUpdateCompanionBuilder =
    DailyEntriesCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<double> income,
      Value<double> expenses,
      Value<double?> kilometrage,
      Value<double?> fuelPrice,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

final class $$DailyEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $DailyEntriesTable, DailyEntry> {
  $$DailyEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DailyExpenseItemsTable, List<DailyExpenseItem>>
  _dailyExpenseItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.dailyExpenseItems,
        aliasName: $_aliasNameGenerator(
          db.dailyEntries.id,
          db.dailyExpenseItems.dailyEntryId,
        ),
      );

  $$DailyExpenseItemsTableProcessedTableManager get dailyExpenseItemsRefs {
    final manager = $$DailyExpenseItemsTableTableManager(
      $_db,
      $_db.dailyExpenseItems,
    ).filter((f) => f.dailyEntryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dailyExpenseItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DailyEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DailyEntriesTable> {
  $$DailyEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get income => $composableBuilder(
    column: $table.income,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get expenses => $composableBuilder(
    column: $table.expenses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kilometrage => $composableBuilder(
    column: $table.kilometrage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fuelPrice => $composableBuilder(
    column: $table.fuelPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> dailyExpenseItemsRefs(
    Expression<bool> Function($$DailyExpenseItemsTableFilterComposer f) f,
  ) {
    final $$DailyExpenseItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyExpenseItems,
      getReferencedColumn: (t) => t.dailyEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyExpenseItemsTableFilterComposer(
            $db: $db,
            $table: $db.dailyExpenseItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DailyEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyEntriesTable> {
  $$DailyEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get income => $composableBuilder(
    column: $table.income,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get expenses => $composableBuilder(
    column: $table.expenses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kilometrage => $composableBuilder(
    column: $table.kilometrage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fuelPrice => $composableBuilder(
    column: $table.fuelPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyEntriesTable> {
  $$DailyEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get income =>
      $composableBuilder(column: $table.income, builder: (column) => column);

  GeneratedColumn<double> get expenses =>
      $composableBuilder(column: $table.expenses, builder: (column) => column);

  GeneratedColumn<double> get kilometrage => $composableBuilder(
    column: $table.kilometrage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fuelPrice =>
      $composableBuilder(column: $table.fuelPrice, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> dailyExpenseItemsRefs<T extends Object>(
    Expression<T> Function($$DailyExpenseItemsTableAnnotationComposer a) f,
  ) {
    final $$DailyExpenseItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.dailyExpenseItems,
          getReferencedColumn: (t) => t.dailyEntryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DailyExpenseItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.dailyExpenseItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DailyEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyEntriesTable,
          DailyEntry,
          $$DailyEntriesTableFilterComposer,
          $$DailyEntriesTableOrderingComposer,
          $$DailyEntriesTableAnnotationComposer,
          $$DailyEntriesTableCreateCompanionBuilder,
          $$DailyEntriesTableUpdateCompanionBuilder,
          (DailyEntry, $$DailyEntriesTableReferences),
          DailyEntry,
          PrefetchHooks Function({bool dailyExpenseItemsRefs})
        > {
  $$DailyEntriesTableTableManager(_$AppDatabase db, $DailyEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> income = const Value.absent(),
                Value<double> expenses = const Value.absent(),
                Value<double?> kilometrage = const Value.absent(),
                Value<double?> fuelPrice = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DailyEntriesCompanion(
                id: id,
                date: date,
                income: income,
                expenses: expenses,
                kilometrage: kilometrage,
                fuelPrice: fuelPrice,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required double income,
                Value<double> expenses = const Value.absent(),
                Value<double?> kilometrage = const Value.absent(),
                Value<double?> fuelPrice = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DailyEntriesCompanion.insert(
                id: id,
                date: date,
                income: income,
                expenses: expenses,
                kilometrage: kilometrage,
                fuelPrice: fuelPrice,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DailyEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({dailyExpenseItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (dailyExpenseItemsRefs) db.dailyExpenseItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dailyExpenseItemsRefs)
                    await $_getPrefetchedData<
                      DailyEntry,
                      $DailyEntriesTable,
                      DailyExpenseItem
                    >(
                      currentTable: table,
                      referencedTable: $$DailyEntriesTableReferences
                          ._dailyExpenseItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DailyEntriesTableReferences(
                            db,
                            table,
                            p0,
                          ).dailyExpenseItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.dailyEntryId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DailyEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyEntriesTable,
      DailyEntry,
      $$DailyEntriesTableFilterComposer,
      $$DailyEntriesTableOrderingComposer,
      $$DailyEntriesTableAnnotationComposer,
      $$DailyEntriesTableCreateCompanionBuilder,
      $$DailyEntriesTableUpdateCompanionBuilder,
      (DailyEntry, $$DailyEntriesTableReferences),
      DailyEntry,
      PrefetchHooks Function({bool dailyExpenseItemsRefs})
    >;
typedef $$DailyExpenseItemsTableCreateCompanionBuilder =
    DailyExpenseItemsCompanion Function({
      Value<int> id,
      required int dailyEntryId,
      required String label,
      required double amount,
      Value<DateTime> createdAt,
    });
typedef $$DailyExpenseItemsTableUpdateCompanionBuilder =
    DailyExpenseItemsCompanion Function({
      Value<int> id,
      Value<int> dailyEntryId,
      Value<String> label,
      Value<double> amount,
      Value<DateTime> createdAt,
    });

final class $$DailyExpenseItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DailyExpenseItemsTable,
          DailyExpenseItem
        > {
  $$DailyExpenseItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DailyEntriesTable _dailyEntryIdTable(_$AppDatabase db) =>
      db.dailyEntries.createAlias(
        $_aliasNameGenerator(
          db.dailyExpenseItems.dailyEntryId,
          db.dailyEntries.id,
        ),
      );

  $$DailyEntriesTableProcessedTableManager get dailyEntryId {
    final $_column = $_itemColumn<int>('daily_entry_id')!;

    final manager = $$DailyEntriesTableTableManager(
      $_db,
      $_db.dailyEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dailyEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DailyExpenseItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyExpenseItemsTable> {
  $$DailyExpenseItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DailyEntriesTableFilterComposer get dailyEntryId {
    final $$DailyEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dailyEntryId,
      referencedTable: $db.dailyEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyEntriesTableFilterComposer(
            $db: $db,
            $table: $db.dailyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyExpenseItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyExpenseItemsTable> {
  $$DailyExpenseItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DailyEntriesTableOrderingComposer get dailyEntryId {
    final $$DailyEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dailyEntryId,
      referencedTable: $db.dailyEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.dailyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyExpenseItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyExpenseItemsTable> {
  $$DailyExpenseItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DailyEntriesTableAnnotationComposer get dailyEntryId {
    final $$DailyEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dailyEntryId,
      referencedTable: $db.dailyEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyExpenseItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyExpenseItemsTable,
          DailyExpenseItem,
          $$DailyExpenseItemsTableFilterComposer,
          $$DailyExpenseItemsTableOrderingComposer,
          $$DailyExpenseItemsTableAnnotationComposer,
          $$DailyExpenseItemsTableCreateCompanionBuilder,
          $$DailyExpenseItemsTableUpdateCompanionBuilder,
          (DailyExpenseItem, $$DailyExpenseItemsTableReferences),
          DailyExpenseItem,
          PrefetchHooks Function({bool dailyEntryId})
        > {
  $$DailyExpenseItemsTableTableManager(
    _$AppDatabase db,
    $DailyExpenseItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyExpenseItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyExpenseItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyExpenseItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dailyEntryId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DailyExpenseItemsCompanion(
                id: id,
                dailyEntryId: dailyEntryId,
                label: label,
                amount: amount,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int dailyEntryId,
                required String label,
                required double amount,
                Value<DateTime> createdAt = const Value.absent(),
              }) => DailyExpenseItemsCompanion.insert(
                id: id,
                dailyEntryId: dailyEntryId,
                label: label,
                amount: amount,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DailyExpenseItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({dailyEntryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (dailyEntryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.dailyEntryId,
                                referencedTable:
                                    $$DailyExpenseItemsTableReferences
                                        ._dailyEntryIdTable(db),
                                referencedColumn:
                                    $$DailyExpenseItemsTableReferences
                                        ._dailyEntryIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DailyExpenseItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyExpenseItemsTable,
      DailyExpenseItem,
      $$DailyExpenseItemsTableFilterComposer,
      $$DailyExpenseItemsTableOrderingComposer,
      $$DailyExpenseItemsTableAnnotationComposer,
      $$DailyExpenseItemsTableCreateCompanionBuilder,
      $$DailyExpenseItemsTableUpdateCompanionBuilder,
      (DailyExpenseItem, $$DailyExpenseItemsTableReferences),
      DailyExpenseItem,
      PrefetchHooks Function({bool dailyEntryId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DailyEntriesTableTableManager get dailyEntries =>
      $$DailyEntriesTableTableManager(_db, _db.dailyEntries);
  $$DailyExpenseItemsTableTableManager get dailyExpenseItems =>
      $$DailyExpenseItemsTableTableManager(_db, _db.dailyExpenseItems);
}
