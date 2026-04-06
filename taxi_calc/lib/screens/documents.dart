import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taxi_calc/core/localization/app_strings.dart';
import 'package:taxi_calc/layout_screen.dart/master_screen.dart';

class DocsScreen extends StatefulWidget {
  const DocsScreen({super.key});

  @override
  State<DocsScreen> createState() => _DocsScreenState();
}

class _DocsScreenState extends State<DocsScreen> {
  final List<_DocumentItem> _documents = [];
  _DocumentFilter _filter = _DocumentFilter.all;
  List<_DocumentItem> get _visibleDocuments {
    final filtered = _documents.where((doc) {
      switch (_filter) {
        case _DocumentFilter.all:
          return true;
        case _DocumentFilter.active:
          return _documentStatus(doc) == _DocumentStatus.active;
        case _DocumentFilter.expiringSoon:
          return _documentStatus(doc) == _DocumentStatus.expiringSoon;
        case _DocumentFilter.expired:
          return _documentStatus(doc) == _DocumentStatus.expired;
      }
    }).toList();

    filtered.sort((a, b) {
      final statusCompare = _documentStatus(
        a,
      ).sortOrder.compareTo(_documentStatus(b).sortOrder);
      if (statusCompare != 0) {
        return statusCompare;
      }
      return a.expiryDate.compareTo(b.expiryDate);
    });

    return filtered;
  }

  Future<void> _openDocumentSheet([_DocumentItem? existing]) async {
    final strings = AppStrings.of(context);
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: existing?.title ?? '');
    final relatedToController = TextEditingController(
      text: existing?.relatedTo ?? '',
    );
    final numberController = TextEditingController(
      text: existing?.documentNumber ?? '',
    );
    final noteController = TextEditingController(text: existing?.note ?? '');

    var isSubmitting = false;
    var typeKey = existing?.typeKey ?? 'registration';
    var reminderDays = existing?.reminderDays ?? 30;
    DateTime? issueDate = existing?.issueDate == null
        ? null
        : DateUtils.dateOnly(existing!.issueDate!);
    DateTime expiryDate = DateUtils.dateOnly(
      existing?.expiryDate ?? DateTime.now().add(const Duration(days: 365)),
    );

    if (nameController.text.trim().isEmpty && typeKey != 'custom') {
      nameController.text = strings.documentTypeLabel(typeKey);
    }

    Future<void> pickDate({
      required BuildContext sheetContext,
      required DateTime initialDate,
      required ValueChanged<DateTime> onPicked,
    }) async {
      final picked = await showDatePicker(
        context: sheetContext,
        initialDate: initialDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        onPicked(DateUtils.dateOnly(picked));
      }
    }

    if (!mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;

            Future<void> saveDocument() async {
              if (!formKey.currentState!.validate() || isSubmitting) {
                return;
              }

              setSheetState(() => isSubmitting = true);

              if (!mounted) {
                return;
              }

              setState(() {
                final document = _DocumentItem(
                  typeKey: typeKey,
                  title: nameController.text.trim(),
                  relatedTo: relatedToController.text.trim(),
                  documentNumber: numberController.text.trim(),
                  issueDate: issueDate,
                  expiryDate: expiryDate,
                  reminderDays: reminderDays,
                  note: noteController.text.trim(),
                );

                if (existing == null) {
                  _documents.add(document);
                } else {
                  final index = _documents.indexOf(existing);
                  if (index != -1) {
                    _documents[index] = document;
                  }
                }
              });

              Navigator.of(sheetContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    existing == null
                        ? strings.documentSaved
                        : strings.documentUpdated,
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, bottomInset + 16),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        existing == null
                            ? strings.addDocument
                            : strings.editDocument,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        strings.chooseDocumentTemplate,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _documentTemplateKeys.map((key) {
                          final selected = typeKey == key;
                          return ChoiceChip(
                            label: Text(strings.documentTypeLabel(key)),
                            selected: selected,
                            onSelected: (_) {
                              setSheetState(() {
                                typeKey = key;
                                if (typeKey != 'custom') {
                                  nameController.text =
                                      strings.documentTypeLabel(typeKey);
                                } else if (existing == null) {
                                  nameController.clear();
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: strings.documentName,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return strings.requiredField;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: relatedToController,
                        decoration: InputDecoration(
                          labelText: strings.relatedToOptional,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: numberController,
                        decoration: InputDecoration(
                          labelText: strings.documentNumberOptional,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _DateField(
                        label: strings.issueDateOptional,
                        value: issueDate == null
                            ? '-'
                            : DateFormat('dd.MM.yyyy').format(issueDate!),
                        icon: Icons.calendar_month_outlined,
                        onTap: () async {
                          await pickDate(
                            sheetContext: sheetContext,
                            initialDate:
                                issueDate ?? DateUtils.dateOnly(DateTime.now()),
                            onPicked: (value) {
                              setSheetState(() => issueDate = value);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      _DateField(
                        label: strings.expiryDate,
                        value: DateFormat('dd.MM.yyyy').format(expiryDate),
                        icon: Icons.event_available_outlined,
                        onTap: () async {
                          await pickDate(
                            sheetContext: sheetContext,
                            initialDate: expiryDate,
                            onPicked: (value) {
                              setSheetState(() => expiryDate = value);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        initialValue: reminderDays,
                        decoration: InputDecoration(
                          labelText: strings.reminderDays,
                        ),
                        items: const [7, 15, 30, 60, 90]
                            .map(
                              (days) => DropdownMenuItem<int>(
                                value: days,
                                child: Text('$days'),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setSheetState(() => reminderDays = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: noteController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: strings.noteOptional,
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: isSubmitting ? null : saveDocument,
                          icon: isSubmitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.save_outlined),
                          label: Text(
                            isSubmitting
                                ? strings.saving
                                : existing == null
                                ? strings.saveDocument
                                : strings.editDocument,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    nameController.dispose();
    relatedToController.dispose();
    numberController.dispose();
    noteController.dispose();
  }

  Future<void> _deleteDocument(_DocumentItem document) async {
    final strings = AppStrings.of(context);
    setState(() {
      _documents.remove(document);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(strings.documentDeleted)));
  }

  void _openDocumentDetails(_DocumentItem document) {
    final strings = AppStrings.of(context);

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final status = _documentStatus(document);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        document.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _StatusBadge(
                      label: status.label(strings),
                      color: status.badgeColor,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _DetailLine(
                  label: strings.documentType,
                  value: strings.documentTypeLabel(document.typeKey),
                ),
                _DetailLine(
                  label: strings.expiryDate,
                  value: DateFormat('dd.MM.yyyy').format(document.expiryDate),
                ),
                _DetailLine(
                  label: strings.reminderDays,
                  value: '${document.reminderDays}',
                ),
                _DetailLine(
                  label: strings.statusLabel,
                  value: _statusInfo(document),
                ),
                if (document.relatedTo.isNotEmpty)
                  _DetailLine(
                    label: strings.relatedToOptional,
                    value: document.relatedTo,
                  ),
                if (document.documentNumber.isNotEmpty)
                  _DetailLine(
                    label: strings.documentNumberOptional,
                    value: document.documentNumber,
                  ),
                if (document.issueDate != null)
                  _DetailLine(
                    label: strings.issueDateOptional,
                    value: DateFormat('dd.MM.yyyy').format(document.issueDate!),
                  ),
                if (document.note.isNotEmpty)
                  _DetailLine(
                    label: strings.noteOptional,
                    value: document.note,
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                          _openDocumentSheet(document);
                        },
                        icon: const Icon(Icons.edit_outlined),
                        label: Text(strings.editDocument),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: () async {
                          Navigator.of(sheetContext).pop();
                          await _deleteDocument(document);
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: Text(strings.deleteDocument),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _DocumentStatus _documentStatus(_DocumentItem document) {
    final today = DateUtils.dateOnly(DateTime.now());
    final expiryDate = DateUtils.dateOnly(document.expiryDate);
    final days = expiryDate.difference(today).inDays;

    if (days < 0) {
      return _DocumentStatus.expired;
    }
    if (days <= document.reminderDays) {
      return _DocumentStatus.expiringSoon;
    }
    return _DocumentStatus.active;
  }

  String _statusInfo(_DocumentItem document) {
    return document.statusInfo;
  }

  int _countByStatus(_DocumentStatus status) {
    return _documents.where((doc) => _documentStatus(doc) == status).length;
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final visibleDocuments = _visibleDocuments;
    final activeCount = _countByStatus(_DocumentStatus.active);
    final expiringCount = _countByStatus(_DocumentStatus.expiringSoon);
    final expiredCount = _countByStatus(_DocumentStatus.expired);
    final hasDocuments = _documents.isNotEmpty;

    return MasterScreen(
      title: strings.documentsTitle,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DocumentsHero(
            onAdd: _openDocumentSheet,
            total: _documents.length,
          ),
          const SizedBox(height: 14),
          if (hasDocuments) ...[
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    label: strings.activeDocuments,
                    value: '$activeCount',
                    color: Colors.green,
                    icon: Icons.verified_outlined,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SummaryCard(
                    label: strings.expiringSoonDocuments,
                    value: '$expiringCount',
                    color: Colors.orange,
                    icon: Icons.schedule_outlined,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SummaryCard(
                    label: strings.expiredDocuments,
                    value: '$expiredCount',
                    color: Colors.red,
                    icon: Icons.warning_amber_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FilterChip(
                  label: strings.allDocuments,
                  selected: _filter == _DocumentFilter.all,
                  onTap: () => setState(() => _filter = _DocumentFilter.all),
                ),
                _FilterChip(
                  label: strings.activeDocuments,
                  selected: _filter == _DocumentFilter.active,
                  onTap: () => setState(() => _filter = _DocumentFilter.active),
                ),
                _FilterChip(
                  label: strings.expiringSoonDocuments,
                  selected: _filter == _DocumentFilter.expiringSoon,
                  onTap: () =>
                      setState(() => _filter = _DocumentFilter.expiringSoon),
                ),
                _FilterChip(
                  label: strings.expiredDocuments,
                  selected: _filter == _DocumentFilter.expired,
                  onTap: () => setState(() => _filter = _DocumentFilter.expired),
                ),
              ],
            ),
            const SizedBox(height: 14),
          ],
          if (!hasDocuments)
            _EmptyDocumentsState(
              message: strings.noDocumentsYet,
              onAdd: _openDocumentSheet,
            )
          else if (visibleDocuments.isEmpty)
            _EmptyDocumentsState(
              message: strings.noDocumentsForFilter,
              onAdd: _openDocumentSheet,
            )
          else
            ...visibleDocuments.map((document) {
              final status = _documentStatus(document);

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _openDocumentDetails(document),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      border: Border.all(
                        color: status.badgeColor.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: status.badgeColor.withValues(alpha: 0.14),
                          ),
                          child: Icon(
                            _documentIcon(document.typeKey),
                            color: status.badgeColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                document.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                strings.documentTypeLabel(document.typeKey),
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${strings.expiryDate}: ${DateFormat('dd.MM.yyyy').format(document.expiryDate)}',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                              if (document.relatedTo.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  document.relatedTo,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _StatusBadge(
                              label: status.label(strings),
                              color: status.badgeColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _statusInfo(document),
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
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
    );
  }
}

class _DocumentsHero extends StatelessWidget {
  const _DocumentsHero({required this.onAdd, required this.total});

  final VoidCallback onAdd;
  final int total;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.tertiaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: colorScheme.onPrimaryContainer.withValues(alpha: 0.10),
                ),
                child: Icon(
                  Icons.folder_copy_outlined,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.documentsTitle,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      strings.documentsIntro,
                      style: TextStyle(color: colorScheme.onPrimaryContainer),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: colorScheme.surface.withValues(alpha: 0.35),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${strings.allDocuments}: $total',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                Flexible(
                  child: FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 44),
                    ),
                    onPressed: onAdd,
                    icon: const Icon(Icons.add),
                    label: Text(
                      strings.addDocument,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withValues(alpha: 0.14),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Icon(icon),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyDocumentsState extends StatelessWidget {
  const _EmptyDocumentsState({required this.message, required this.onAdd});

  final String message;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
      ),
      child: Column(
        children: [
          Icon(
            Icons.description_outlined,
            size: 38,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: Text(strings.addDocument),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _documentTemplateKeys.map((key) {
              return Chip(
                label: Text(strings.documentTypeLabel(key)),
                avatar: Icon(_documentIcon(key), size: 18),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

enum _DocumentFilter { all, active, expiringSoon, expired }

enum _DocumentStatus {
  expired,
  expiringSoon,
  active;

  int get sortOrder {
    switch (this) {
      case _DocumentStatus.expired:
        return 0;
      case _DocumentStatus.expiringSoon:
        return 1;
      case _DocumentStatus.active:
        return 2;
    }
  }

  Color get badgeColor {
    switch (this) {
      case _DocumentStatus.expired:
        return Colors.red;
      case _DocumentStatus.expiringSoon:
        return Colors.orange;
      case _DocumentStatus.active:
        return Colors.green;
    }
  }

  String label(AppStrings strings) {
    switch (this) {
      case _DocumentStatus.expired:
        return strings.expiredStatus;
      case _DocumentStatus.expiringSoon:
        return strings.expiringSoonStatus;
      case _DocumentStatus.active:
        return strings.activeStatus;
    }
  }
}

IconData _documentIcon(String typeKey) {
  switch (typeKey) {
    case 'id_card':
    case 'passport':
    case 'driving_license':
      return Icons.badge_outlined;
    case 'registration':
    case 'technical_inspection':
      return Icons.directions_car_outlined;
    case 'taxi_license':
    case 'taxi_sign':
      return Icons.local_taxi_outlined;
    case 'fire_extinguisher':
      return Icons.local_fire_department_outlined;
    case 'disinfection':
      return Icons.cleaning_services_outlined;
    default:
      return Icons.description_outlined;
  }
}

class _DocumentItem {
  _DocumentItem({
    required this.typeKey,
    required this.title,
    required this.relatedTo,
    required this.documentNumber,
    required this.issueDate,
    required this.expiryDate,
    required this.reminderDays,
    required this.note,
  });

  final String typeKey;
  final String title;
  final String relatedTo;
  final String documentNumber;
  final DateTime? issueDate;
  final DateTime expiryDate;
  final int reminderDays;
  final String note;

  String get statusInfo {
    final today = DateUtils.dateOnly(DateTime.now());
    final days = DateUtils.dateOnly(expiryDate).difference(today).inDays;
    if (days < 0) {
      return '${days.abs()} d';
    }
    if (days == 0) {
      return '0 d';
    }
    return '$days d';
  }
}

const List<String> _documentTemplateKeys = [
  'id_card',
  'driving_license',
  'taxi_license',
  'taxi_sign',
  'registration',
  'technical_inspection',
  'fire_extinguisher',
  'disinfection',
  'custom',
];
