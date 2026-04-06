import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taxi_calc/core/localization/app_strings.dart';
import 'package:taxi_calc/data/database.dart';
import 'package:taxi_calc/data/providers/daily_entries_provider.dart';
import 'package:taxi_calc/layout_screen.dart/master_screen.dart';

class AddEntryScreen extends StatelessWidget {
  const AddEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return MasterScreen(
      title: strings.addDailyEntryTitle,
      showBackButton: true,
      child: const _AddEntryForm(),
    );
  }
}

enum _ExpenseType { fuel, food, service, other }

enum _ServiceSubtype {
  smallService,
  bigService,
  frontBrakes,
  rearBrakes,
  frontDiscs,
  rearDiscs,
  shockAbsorbers,
  tires,
  battery,
  clutch,
  otherService,
}

extension _ServiceSubtypeX on _ServiceSubtype {
  String get key {
    switch (this) {
      case _ServiceSubtype.smallService:
        return 'small_service';
      case _ServiceSubtype.bigService:
        return 'big_service';
      case _ServiceSubtype.frontBrakes:
        return 'front_brakes';
      case _ServiceSubtype.rearBrakes:
        return 'rear_brakes';
      case _ServiceSubtype.frontDiscs:
        return 'front_discs';
      case _ServiceSubtype.rearDiscs:
        return 'rear_discs';
      case _ServiceSubtype.shockAbsorbers:
        return 'shock_absorbers';
      case _ServiceSubtype.tires:
        return 'tires';
      case _ServiceSubtype.battery:
        return 'battery';
      case _ServiceSubtype.clutch:
        return 'clutch';
      case _ServiceSubtype.otherService:
        return 'other_service';
    }
  }

  String label(AppStrings strings) => strings.serviceSubtypeLabel(key);

  static _ServiceSubtype? fromKey(String key) {
    for (final value in _ServiceSubtype.values) {
      if (value.key == key) {
        return value;
      }
    }
    return null;
  }
}

extension _ExpenseTypeX on _ExpenseType {
  String get key {
    switch (this) {
      case _ExpenseType.fuel:
        return 'fuel';
      case _ExpenseType.food:
        return 'food';
      case _ExpenseType.service:
        return 'service';
      case _ExpenseType.other:
        return 'other';
    }
  }

  static _ExpenseType? fromStored(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized.startsWith('service:')) {
      return _ExpenseType.service;
    }

    switch (normalized) {
      case 'fuel':
      case 'gorivo':
      case 'kraftstoff':
        return _ExpenseType.fuel;
      case 'food':
      case 'hrana':
      case 'essen':
        return _ExpenseType.food;
      case 'service':
      case 'servis':
        return _ExpenseType.service;
      case 'other':
      case 'ostalo':
      case 'sonstiges':
        return _ExpenseType.other;
      default:
        return null;
    }
  }

  String label(AppStrings strings) {
    switch (this) {
      case _ExpenseType.fuel:
        return strings.fuelLabel;
      case _ExpenseType.food:
        return strings.foodLabel;
      case _ExpenseType.service:
        return strings.serviceLabel;
      case _ExpenseType.other:
        return strings.otherLabel;
    }
  }
}

class _AddEntryForm extends StatefulWidget {
  const _AddEntryForm();

  @override
  State<_AddEntryForm> createState() => _AddEntryFormState();
}

class _AddEntryFormState extends State<_AddEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _grossController = TextEditingController();
  final _kilometrageController = TextEditingController();
  final _fuelExpenseController = TextEditingController();
  final _foodExpenseController = TextEditingController();
  final _otherExpenseController = TextEditingController();
  final _noteController = TextEditingController();

  late final AppDatabase _db;
  late final DailyEntriesProvider _provider;

  final List<_ExpenseDraft> _expenseItems = [];

  DateTime _selectedDate = DateUtils.dateOnly(DateTime.now());
  bool _isSaving = false;
  bool _isLoadingDateData = true;
  int? _editingEntryId;

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _provider = DailyEntriesProvider(_db);
    _grossController.addListener(_refreshTotals);
    _fuelExpenseController.addListener(_refreshTotals);
    _foodExpenseController.addListener(_refreshTotals);
    _otherExpenseController.addListener(_refreshTotals);
    _loadExistingDataForDate();
  }

  @override
  void dispose() {
    _grossController.removeListener(_refreshTotals);
    _grossController.dispose();
    _kilometrageController.dispose();
    _fuelExpenseController.dispose();
    _foodExpenseController.dispose();
    _otherExpenseController.dispose();
    _noteController.dispose();

    for (final item in _expenseItems) {
      item.dispose();
    }

    _db.close();
    super.dispose();
  }

  void _refreshTotals() {
    setState(() {});
  }

  double _parseNumber(String value) {
    return double.tryParse(value.replaceAll(',', '.')) ?? 0;
  }

  String _formatOptionalDouble(double? value) {
    if (value == null) {
      return '';
    }
    return value.toStringAsFixed(2);
  }

  double get _gross => _parseNumber(_grossController.text);

  double get _expenseTotal {
    return _parseNumber(_fuelExpenseController.text) +
        _parseNumber(_foodExpenseController.text) +
        _parseNumber(_otherExpenseController.text) +
        _expenseItems.fold<double>(0, (sum, item) {
          return sum + _parseNumber(item.amountController.text);
        });
  }

  double get _net => _gross - _expenseTotal;

  Future<void> _loadExistingDataForDate() async {
    setState(() {
      _isLoadingDateData = true;
    });

    final existing = await _provider.getFirstByDate(_selectedDate);

    if (!mounted) {
      return;
    }

    for (final item in _expenseItems) {
      item.amountController.removeListener(_refreshTotals);
      item.dispose();
    }

    _expenseItems.clear();

    if (existing == null) {
      _editingEntryId = null;
      _grossController.clear();
      _kilometrageController.clear();
      _fuelExpenseController.clear();
      _foodExpenseController.clear();
      _otherExpenseController.clear();
      _noteController.clear();

      setState(() {
        _isLoadingDateData = false;
      });
      return;
    }

    _editingEntryId = existing.id;
    _grossController.text = existing.income.toStringAsFixed(2);
    _kilometrageController.text = _formatOptionalDouble(existing.kilometrage);
    _fuelExpenseController.clear();
    _foodExpenseController.clear();
    _otherExpenseController.clear();
    _noteController.text = existing.note ?? '';

    final existingItems = await _provider.getExpenseItemsByEntryId(existing.id);
    for (final row in existingItems) {
      final parsed = _StoredExpense.parse(row.label);
      if (parsed == null) {
        continue;
      }

      if (parsed.type == _ExpenseType.service) {
        final draft = _ExpenseDraft(
          type: parsed.type,
          serviceSubtype: parsed.serviceSubtype,
        )..amountController.text = row.amount.toStringAsFixed(2);

        draft.amountController.addListener(_refreshTotals);
        _expenseItems.add(draft);
        continue;
      }

      switch (parsed.type) {
        case _ExpenseType.fuel:
          _fuelExpenseController.text = row.amount.toStringAsFixed(2);
          break;
        case _ExpenseType.food:
          _foodExpenseController.text = row.amount.toStringAsFixed(2);
          break;
        case _ExpenseType.other:
          _otherExpenseController.text = row.amount.toStringAsFixed(2);
          break;
        case _ExpenseType.service:
          break;
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoadingDateData = false;
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

    await _loadExistingDataForDate();
  }

  Future<void> _chooseAndAddExpenseItem() async {
    final usedServiceSubtypes = _expenseItems
        .where((item) => item.type == _ExpenseType.service)
        .map((item) => item.serviceSubtype)
        .whereType<_ServiceSubtype>()
        .toSet();

    final selectedSubtype = await _chooseServiceSubtype(usedServiceSubtypes);
    if (selectedSubtype == null) {
      return;
    }

    _addExpenseItem(_ExpenseType.service, serviceSubtype: selectedSubtype);
  }

  Future<_ServiceSubtype?> _chooseServiceSubtype(
    Set<_ServiceSubtype> usedSubtypes,
  ) async {
    final strings = AppStrings.of(context);
    final available = _ServiceSubtype.values
        .where((subtype) => !usedSubtypes.contains(subtype))
        .toList();

    if (available.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.noMoreItems)));
      return null;
    }

    return showModalBottomSheet<_ServiceSubtype>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: Text(
                    strings.chooseServiceType,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                ...available.map(
                  (subtype) => ListTile(
                    title: Text(subtype.label(strings)),
                    onTap: () => Navigator.pop(context, subtype),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addExpenseItem(_ExpenseType type, {_ServiceSubtype? serviceSubtype}) {
    final draft = _ExpenseDraft(type: type, serviceSubtype: serviceSubtype);
    draft.amountController.addListener(_refreshTotals);

    setState(() {
      _expenseItems.add(draft);
    });
  }

  void _removeExpenseItem(int index) {
    final item = _expenseItems.removeAt(index);
    item.amountController.removeListener(_refreshTotals);
    item.dispose();
    setState(() {});
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final strings = AppStrings.of(context);
    final wasEditing = _editingEntryId != null;
    final gross = _parseNumber(_grossController.text);
    final kilometrageText = _kilometrageController.text.trim();
    final fuelExpense = _parseNumber(_fuelExpenseController.text);
    final foodExpense = _parseNumber(_foodExpenseController.text);
    final otherExpense = _parseNumber(_otherExpenseController.text);

    final expenseCompanions = <DailyExpenseItemsCompanion>[];
    if (_fuelExpenseController.text.trim().isNotEmpty) {
      expenseCompanions.add(
        DailyExpenseItemsCompanion.insert(
          dailyEntryId: 0,
          label: _ExpenseType.fuel.key,
          amount: fuelExpense,
        ),
      );
    }
    if (_foodExpenseController.text.trim().isNotEmpty) {
      expenseCompanions.add(
        DailyExpenseItemsCompanion.insert(
          dailyEntryId: 0,
          label: _ExpenseType.food.key,
          amount: foodExpense,
        ),
      );
    }
    if (_otherExpenseController.text.trim().isNotEmpty) {
      expenseCompanions.add(
        DailyExpenseItemsCompanion.insert(
          dailyEntryId: 0,
          label: _ExpenseType.other.key,
          amount: otherExpense,
        ),
      );
    }
    for (final item in _expenseItems) {
      final amountText = item.amountController.text.trim();
      if (amountText.isEmpty) {
        continue;
      }

      expenseCompanions.add(
        DailyExpenseItemsCompanion.insert(
          dailyEntryId: 0,
          label: item.storedLabel,
          amount: _parseNumber(amountText),
        ),
      );
    }

    setState(() => _isSaving = true);

    final id = await _provider.upsertByDateWithExpenseItems(
      date: _selectedDate,
      entry: DailyEntriesCompanion.insert(
        date: _selectedDate,
        income: gross,
        expenses: Value(_expenseTotal),
        kilometrage: kilometrageText.isEmpty
            ? const Value.absent()
            : Value(_parseNumber(kilometrageText)),
        note: _noteController.text.trim().isEmpty
            ? const Value.absent()
            : Value(_noteController.text.trim()),
      ),
      expenseItems: expenseCompanions,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
      _editingEntryId = id;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(wasEditing ? strings.entryUpdated : strings.entrySaved),
      ),
    );
    Navigator.of(context).pop(true);
  }

  String? _validateRequiredMoney(String? value) {
    final strings = AppStrings.of(context);

    if (value == null || value.trim().isEmpty) {
      return strings.requiredField;
    }

    final parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed == null) {
      return strings.invalidNumber;
    }

    if (parsed < 0) {
      return strings.numberMustBeNonNegative;
    }

    return null;
  }

  String? _validateOptionalMoney(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    return _validateRequiredMoney(value);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    if (_isLoadingDateData) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _DateSelector(
              title: strings.selectDate,
              dateText: DateFormat('dd.MM.yyyy').format(_selectedDate),
              onPickDate: _pickDate,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _grossController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: strings.grossRevenue,
                        suffixText: 'KM',
                      ),
                      validator: _validateRequiredMoney,
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _kilometrageController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: strings.kilometrageOptional,
                        suffixText: 'km',
                      ),
                      validator: _validateOptionalMoney,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _fuelExpenseController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: strings.fuelOptional,
                        suffixText: 'KM',
                      ),
                      validator: _validateOptionalMoney,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _foodExpenseController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: strings.foodOptional,
                        suffixText: 'KM',
                      ),
                      validator: _validateOptionalMoney,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _otherExpenseController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: strings.otherOptional,
                        suffixText: 'KM',
                      ),
                      validator: _validateOptionalMoney,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: strings.noteOptional,
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.45),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.12),
                                ),
                                child: Icon(
                                  Icons.build_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      strings.serviceLabel,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      strings.chooseServiceType,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FilledButton.tonalIcon(
                              onPressed: _chooseAndAddExpenseItem,
                              icon: const Icon(Icons.add),
                              label: Text(strings.addItemTooltip),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_expenseItems.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ..._expenseItems.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant,
                              ),
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest
                                  .withValues(alpha: 0.25),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: 0.10),
                                      ),
                                      child: Icon(
                                        Icons.miscellaneous_services_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.label(strings),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            strings.amountLabel,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          _removeExpenseItem(index),
                                      icon: const Icon(Icons.delete_outline),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: item.amountController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  decoration: InputDecoration(
                                    labelText: strings.amountLabel,
                                    suffixText: 'KM',
                                    isDense: true,
                                  ),
                                  validator: _validateRequiredMoney,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _SummaryRow(label: strings.grossRevenue, value: _gross),
                    _SummaryRow(
                      label: strings.totalExpenses,
                      value: _expenseTotal,
                    ),
                    const Divider(),
                    _SummaryRow(label: strings.net, value: _net, bold: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _isSaving ? null : _save,
              icon: _isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_isSaving ? strings.saving : strings.saveEntry),
            ),
          ],
        ),
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final double value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = bold
        ? const TextStyle(fontWeight: FontWeight.w700)
        : const TextStyle();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text('${value.toStringAsFixed(2)} KM', style: style),
        ],
      ),
    );
  }
}

class _ExpenseDraft {
  _ExpenseDraft({required this.type, this.serviceSubtype});

  final _ExpenseType type;
  final _ServiceSubtype? serviceSubtype;
  final TextEditingController amountController = TextEditingController();

  String label(AppStrings strings) {
    if (type == _ExpenseType.service && serviceSubtype != null) {
      return '${strings.serviceLabel} - ${serviceSubtype!.label(strings)}';
    }
    return type.label(strings);
  }

  String get storedLabel {
    if (type == _ExpenseType.service && serviceSubtype != null) {
      return 'service:${serviceSubtype!.key}';
    }
    return type.key;
  }

  void dispose() {
    amountController.dispose();
  }
}

class _StoredExpense {
  const _StoredExpense({required this.type, this.serviceSubtype});

  final _ExpenseType type;
  final _ServiceSubtype? serviceSubtype;

  static _StoredExpense? parse(String value) {
    final type = _ExpenseTypeX.fromStored(value);
    if (type == null) {
      return null;
    }

    final normalized = value.trim().toLowerCase();
    if (normalized.startsWith('service:')) {
      final subtypeKey = normalized.substring('service:'.length);
      final subtype = _ServiceSubtypeX.fromKey(subtypeKey);
      return _StoredExpense(type: type, serviceSubtype: subtype);
    }

    return _StoredExpense(type: type);
  }
}
