enum ReceptionStatus { unknown, closed, open }

/// Horario de recepción de entregas para un día, sin dependencias de Flutter.
class ReceptionDay {
  ReceptionDay({
    required this.weekday,
    required this.status,
    this.startMinutes,
    this.endMinutes,
  }) {
    if (weekday < 1 || weekday > 7) {
      throw ArgumentError.value(weekday, 'weekday', 'Debe estar entre 1 y 7');
    }
    if (status == ReceptionStatus.open) {
      if (startMinutes == null ||
          endMinutes == null ||
          startMinutes! < 0 ||
          startMinutes! > 1439 ||
          endMinutes! < 0 ||
          endMinutes! > 1439 ||
          startMinutes! >= endMinutes!) {
        throw ArgumentError(
          'El intervalo debe ser válido e inicio anterior a fin',
        );
      }
    } else if (startMinutes != null || endMinutes != null) {
      throw ArgumentError('Solo un día que recibe entregas puede tener horas');
    }
  }

  final int weekday;
  final ReceptionStatus status;
  final int? startMinutes;
  final int? endMinutes;

  static List<ReceptionDay> undefinedWeek() => List.generate(
    7,
    (index) =>
        ReceptionDay(weekday: index + 1, status: ReceptionStatus.unknown),
  );
}
