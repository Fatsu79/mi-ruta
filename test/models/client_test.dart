import 'package:app_clientes/models/client.dart';
import 'package:app_clientes/models/contact.dart';
import 'package:app_clientes/models/purchase.dart';
import 'package:app_clientes/models/reception_day.dart';
import 'package:flutter_test/flutter_test.dart';

Client _client({List<ReceptionDay>? schedule}) => Client(
  id: 'original',
  commercialName: 'Tienda',
  businessName: 'Nombre fiscal',
  state: 'Jalisco',
  municipality: 'Zapopan',
  address: 'Calle 1',
  latitude: 20,
  longitude: -103,
  discount: 5,
  hasCredit: true,
  notes: 'Almacén',
  contacts: const [
    Contact(
      name: 'Ana',
      position: 'Compras',
      phone: '123',
      email: 'ana@example.com',
    ),
  ],
  purchases: [
    Purchase(date: DateTime(2026, 8, 1), amount: 100, invoiceNumber: 'F1'),
  ],
  receptionSchedule: schedule,
);

void main() {
  test(
    'copyWith preserva información no editada y no modifica el original',
    () {
      final original = _client();
      final edited = original.copyWith(
        commercialName: 'Nueva tienda',
        hasCredit: false,
      );
      expect(original.commercialName, 'Tienda');
      expect(edited.commercialName, 'Nueva tienda');
      expect(edited.hasCredit, isFalse);
      expect(edited.id, original.id);
      expect(edited.latitude, original.latitude);
      expect(edited.longitude, original.longitude);
      expect(edited.contacts, original.contacts);
      expect(edited.purchases, original.purchases);
      expect(edited.receptionSchedule, original.receptionSchedule);
      expect(edited.businessName, original.businessName);
      expect(edited.state, original.state);
      expect(edited.municipality, original.municipality);
      expect(edited.address, original.address);
      expect(edited.discount, original.discount);
      expect(edited.notes, original.notes);
    },
  );

  test(
    'horario requiere exactamente siete días sin duplicados ni faltantes',
    () {
      final week = ReceptionDay.undefinedWeek();
      for (final invalid in [
        <ReceptionDay>[],
        week.take(6).toList(),
        [...week, week.first],
        [...week.take(6), week.first],
      ]) {
        expect(() => _client(schedule: invalid), throwsArgumentError);
        expect(
          () => _client().copyWith(receptionSchedule: invalid),
          throwsArgumentError,
        );
      }
    },
  );

  test('ordena el horario y protege la lista contra mutaciones externas', () {
    final week = ReceptionDay.undefinedWeek().reversed.toList();
    final client = _client(schedule: week);
    week.clear();
    expect(client.receptionSchedule.map((day) => day.weekday), [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
    ]);
    expect(() => client.receptionSchedule.clear(), throwsUnsupportedError);
    expect(() => client.contacts.clear(), throwsUnsupportedError);
    expect(() => client.purchases.clear(), throwsUnsupportedError);
  });
}
