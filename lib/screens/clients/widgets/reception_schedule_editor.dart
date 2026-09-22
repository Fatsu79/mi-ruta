import 'package:flutter/material.dart';

import '../../../models/reception_day.dart';

class ReceptionScheduleEditor extends StatefulWidget {
  const ReceptionScheduleEditor({
    required this.initialSchedule,
    required this.onChanged,
    super.key,
  });

  final List<ReceptionDay> initialSchedule;
  final ValueChanged<List<ReceptionDay>> onChanged;

  @override
  State<ReceptionScheduleEditor> createState() =>
      _ReceptionScheduleEditorState();
}

class _ReceptionScheduleEditorState extends State<ReceptionScheduleEditor> {
  static const _days = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];
  late final List<ReceptionStatus> _statuses;
  late final List<int?> _starts;
  late final List<int?> _ends;

  @override
  void initState() {
    super.initState();
    _statuses = widget.initialSchedule.map((day) => day.status).toList();
    _starts = widget.initialSchedule.map((day) => day.startMinutes).toList();
    _ends = widget.initialSchedule.map((day) => day.endMinutes).toList();
  }

  String? _error(int index) {
    if (_statuses[index] != ReceptionStatus.open) return null;
    final start = _starts[index];
    final end = _ends[index];
    if (start == null || end == null) return 'Selecciona ambas horas';
    if (start >= end) return 'La hora inicial debe ser anterior a la final';
    return null;
  }

  void _notify(FormFieldState<bool> field) {
    field.didChange(true);
    if (List.generate(7, _error).any((error) => error != null)) return;
    widget.onChanged(
      List.generate(
        7,
        (index) => ReceptionDay(
          weekday: index + 1,
          status: _statuses[index],
          startMinutes: _starts[index],
          endMinutes: _ends[index],
        ),
      ),
    );
  }

  Future<void> _pickTime(
    int index,
    bool isStart,
    FormFieldState<bool> field,
  ) async {
    final current = isStart ? _starts[index] : _ends[index];
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: (current ?? (isStart ? 480 : 1020)) ~/ 60,
        minute: (current ?? 0) % 60,
      ),
      helpText: isStart
          ? 'Hora inicial de recepción'
          : 'Hora final de recepción',
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (time == null || !mounted) return;
    setState(() {
      final minutes = time.hour * 60 + time.minute;
      if (isStart) {
        _starts[index] = minutes;
      } else {
        _ends[index] = minutes;
      }
    });
    _notify(field);
  }

  String _time(int? minutes) => minutes == null
      ? 'Seleccionar'
      : '${(minutes ~/ 60).toString().padLeft(2, '0')}:${(minutes % 60).toString().padLeft(2, '0')}';

  Future<void> _applyToSeveralDays(FormFieldState<bool> field) async {
    final selected = List.filled(7, false);
    var status = ReceptionStatus.unknown;
    int? startMinutes;
    int? endMinutes;
    String? error;

    final result =
        await showDialog<
          ({Set<int> indexes, ReceptionStatus status, int? start, int? end})
        >(
          context: context,
          builder: (dialogContext) => StatefulBuilder(
            builder: (context, setDialogState) {
              Future<void> pickTime(bool isStart) async {
                final current = isStart ? startMinutes : endMinutes;
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: (current ?? (isStart ? 480 : 1020)) ~/ 60,
                    minute: (current ?? 0) % 60,
                  ),
                  helpText: isStart
                      ? 'Hora inicial de recepción'
                      : 'Hora final de recepción',
                  builder: (context, child) => MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(alwaysUse24HourFormat: true),
                    child: child!,
                  ),
                );
                if (time == null || !dialogContext.mounted) return;
                setDialogState(() {
                  final minutes = time.hour * 60 + time.minute;
                  if (isStart) {
                    startMinutes = minutes;
                  } else {
                    endMinutes = minutes;
                  }
                  error = null;
                });
              }

              void apply() {
                final indexes = <int>{
                  for (var index = 0; index < selected.length; index++)
                    if (selected[index]) index,
                };
                String? validationError;
                if (indexes.isEmpty) {
                  validationError = 'Selecciona al menos un día';
                } else if (status == ReceptionStatus.open &&
                    (startMinutes == null || endMinutes == null)) {
                  validationError = 'Selecciona ambas horas';
                } else if (status == ReceptionStatus.open &&
                    startMinutes! >= endMinutes!) {
                  validationError =
                      'La hora inicial debe ser anterior a la final';
                }
                if (validationError != null) {
                  setDialogState(() => error = validationError);
                  return;
                }
                Navigator.of(dialogContext).pop((
                  indexes: indexes,
                  status: status,
                  start: startMinutes,
                  end: endMinutes,
                ));
              }

              return AlertDialog(
                title: const Text('Aplicar horario a varios días'),
                content: SizedBox(
                  width: 420,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Selecciona los días'),
                        for (var index = 0; index < 7; index++)
                          CheckboxListTile(
                            key: Key('bulkDay-${index + 1}'),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Text(_days[index]),
                            value: selected[index],
                            onChanged: (value) => setDialogState(() {
                              selected[index] = value ?? false;
                              error = null;
                            }),
                          ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<ReceptionStatus>(
                          key: const Key('bulkStatus'),
                          initialValue: status,
                          decoration: const InputDecoration(
                            labelText: 'Estado a aplicar',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: ReceptionStatus.unknown,
                              child: Text('Sin definir'),
                            ),
                            DropdownMenuItem(
                              value: ReceptionStatus.closed,
                              child: Text('No recibe'),
                            ),
                            DropdownMenuItem(
                              value: ReceptionStatus.open,
                              child: Text('Recibe en un intervalo'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            setDialogState(() {
                              status = value;
                              if (value != ReceptionStatus.open) {
                                startMinutes = null;
                                endMinutes = null;
                              }
                              error = null;
                            });
                          },
                        ),
                        if (status == ReceptionStatus.open) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              OutlinedButton(
                                key: const Key('bulkStart'),
                                onPressed: () => pickTime(true),
                                child: Text('Desde: ${_time(startMinutes)}'),
                              ),
                              OutlinedButton(
                                key: const Key('bulkEnd'),
                                onPressed: () => pickTime(false),
                                child: Text('Hasta: ${_time(endMinutes)}'),
                              ),
                            ],
                          ),
                        ],
                        if (error != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            error!,
                            key: const Key('bulkError'),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Cancelar'),
                  ),
                  FilledButton(
                    key: const Key('bulkApply'),
                    onPressed: apply,
                    child: const Text('Aplicar'),
                  ),
                ],
              );
            },
          ),
        );

    if (result == null || !mounted) return;
    setState(() {
      for (final index in result.indexes) {
        _statuses[index] = result.status;
        _starts[index] = result.status == ReceptionStatus.open
            ? result.start
            : null;
        _ends[index] = result.status == ReceptionStatus.open
            ? result.end
            : null;
      }
    });
    _notify(field);
  }

  @override
  Widget build(BuildContext context) => FormField<bool>(
    validator: (_) => List.generate(7, _error).any((error) => error != null)
        ? 'Revisa el horario de recepción de entregas'
        : null,
    builder: (field) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            key: const Key('bulkScheduleButton'),
            onPressed: () => _applyToSeveralDays(field),
            icon: const Icon(Icons.date_range_outlined),
            label: const Text('Aplicar horario a varios días'),
          ),
        ),
        const SizedBox(height: 16),
        for (var index = 0; index < 7; index++)
          Padding(
            key: ValueKey(
              'receptionDay-$index-${_statuses[index]}-${_starts[index]}-${_ends[index]}',
            ),
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<ReceptionStatus>(
                  key: Key('receptionStatus-${index + 1}'),
                  initialValue: _statuses[index],
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: _days[index],
                    border: const OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: ReceptionStatus.unknown,
                      child: Text('Sin definir'),
                    ),
                    DropdownMenuItem(
                      value: ReceptionStatus.closed,
                      child: Text('No recibe'),
                    ),
                    DropdownMenuItem(
                      value: ReceptionStatus.open,
                      child: Text('Recibe en un intervalo'),
                    ),
                  ],
                  onChanged: (status) {
                    if (status == null) return;
                    setState(() {
                      _statuses[index] = status;
                      if (status != ReceptionStatus.open) {
                        _starts[index] = null;
                        _ends[index] = null;
                      }
                    });
                    _notify(field);
                  },
                ),
                if (_statuses[index] == ReceptionStatus.open) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton(
                        key: Key('receptionStart-${index + 1}'),
                        onPressed: () => _pickTime(index, true, field),
                        child: Text('Desde: ${_time(_starts[index])}'),
                      ),
                      OutlinedButton(
                        key: Key('receptionEnd-${index + 1}'),
                        onPressed: () => _pickTime(index, false, field),
                        child: Text('Hasta: ${_time(_ends[index])}'),
                      ),
                    ],
                  ),
                  if (field.hasError && _error(index) != null)
                    Text(
                      _error(index)!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                ],
              ],
            ),
          ),
        if (field.hasError)
          Text(
            field.errorText!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
      ],
    ),
  );
}
