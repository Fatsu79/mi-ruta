import 'package:app_clientes/models/reception_day.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('semana inicial contiene lunes a domingo sin definir', () {
    final week = ReceptionDay.undefinedWeek();
    expect(week.map((day) => day.weekday), [1, 2, 3, 4, 5, 6, 7]);
    expect(week.every((day) => day.status == ReceptionStatus.unknown), isTrue);
  });

  test('sin definir y no recibe son estados diferentes sin horas', () {
    final unknown = ReceptionDay(weekday: 1, status: ReceptionStatus.unknown);
    final closed = ReceptionDay(weekday: 2, status: ReceptionStatus.closed);
    expect(unknown.status, isNot(closed.status));
    expect(unknown.startMinutes, isNull);
    expect(closed.endMinutes, isNull);
  });

  test('acepta un intervalo válido incluyendo límites del día', () {
    final day = ReceptionDay(
      weekday: 7,
      status: ReceptionStatus.open,
      startMinutes: 0,
      endMinutes: 1439,
    );
    expect(day.endMinutes, 1439);
  });

  test('rechaza días inválidos', () {
    for (final weekday in [0, 8]) {
      expect(
        () => ReceptionDay(weekday: weekday, status: ReceptionStatus.unknown),
        throwsArgumentError,
      );
    }
  });

  test(
    'rechaza intervalos incompletos, invertidos, iguales o fuera de rango',
    () {
      for (final interval in <(int?, int?)>[
        (null, 600),
        (480, null),
        (600, 480),
        (480, 480),
        (-1, 600),
        (480, 1440),
      ]) {
        expect(
          () => ReceptionDay(
            weekday: 1,
            status: ReceptionStatus.open,
            startMinutes: interval.$1,
            endMinutes: interval.$2,
          ),
          throwsArgumentError,
        );
      }
    },
  );

  test('rechaza horas en días sin definir o que no reciben', () {
    for (final status in [ReceptionStatus.unknown, ReceptionStatus.closed]) {
      expect(
        () => ReceptionDay(
          weekday: 1,
          status: status,
          startMinutes: 480,
          endMinutes: 600,
        ),
        throwsArgumentError,
      );
    }
  });
}
