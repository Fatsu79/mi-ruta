import 'package:app_clientes/models/client.dart';
import 'package:app_clientes/models/contact.dart';
import 'package:app_clientes/models/purchase.dart';
import 'package:app_clientes/models/reception_day.dart';
import 'package:app_clientes/screens/clients/client_detail_screen.dart';
import 'package:app_clientes/screens/clients/clients_screen.dart';
import 'package:app_clientes/screens/clients/widgets/reception_schedule_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Client _client() => Client(
  id: 'original',
  commercialName: 'Tienda original',
  businessName: 'Nombre fiscal',
  state: 'Jalisco',
  municipality: 'Zapopan',
  address: 'Calle 1',
  latitude: 20,
  longitude: -103,
  discount: 5,
  hasCredit: true,
  notes: 'Preguntar por Ana',
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
  receptionSchedule: [
    ReceptionDay(
      weekday: 1,
      status: ReceptionStatus.open,
      startMinutes: 480,
      endMinutes: 1020,
    ),
    ReceptionDay(weekday: 2, status: ReceptionStatus.closed),
    ...ReceptionDay.undefinedWeek().skip(2),
  ],
);

Finder _field(String label) => find.ancestor(
  of: find.byWidgetPredicate(
    (widget) => widget is TextField && widget.decoration?.labelText == label,
  ),
  matching: find.byType(TextFormField),
);

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _enter(WidgetTester tester, String label, String value) async {
  final field = _field(label);
  await tester.ensureVisible(field);
  await tester.enterText(field, value);
  await tester.pump();
}

Future<void> _chooseTime(
  WidgetTester tester,
  Key buttonKey,
  String hour,
  String minute,
) async {
  await _tap(tester, find.byKey(buttonKey));
  await _tap(tester, find.byIcon(Icons.keyboard_outlined));
  final fields = find.descendant(
    of: find.byType(TimePickerDialog),
    matching: find.byType(TextField),
  );
  await tester.enterText(fields.at(0), hour);
  await tester.enterText(fields.at(1), minute);
  await _tap(tester, find.text('OK'));
}

void main() {
  testWidgets('muestra la acción masiva y los siete días seleccionables', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ReceptionScheduleEditor(
              initialSchedule: ReceptionDay.undefinedWeek(),
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );
    expect(find.text('Aplicar horario a varios días'), findsOneWidget);
    await _tap(tester, find.byKey(const Key('bulkScheduleButton')));
    expect(find.text('Aplicar horario a varios días'), findsNWidgets(2));
    for (var weekday = 1; weekday <= 7; weekday++) {
      expect(find.byKey(Key('bulkDay-$weekday')), findsOneWidget);
    }
    await _tap(tester, find.text('Cancelar'));
  });

  testWidgets(
    'aplica un intervalo a días libres, conserva los demás y permite editar uno',
    (tester) async {
      List<ReceptionDay>? schedule;
      final initial = ReceptionDay.undefinedWeek();
      initial[5] = ReceptionDay(weekday: 6, status: ReceptionStatus.closed);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ReceptionScheduleEditor(
                initialSchedule: initial,
                onChanged: (value) => schedule = value,
              ),
            ),
          ),
        ),
      );
      await _tap(tester, find.byKey(const Key('bulkScheduleButton')));
      for (var weekday = 1; weekday <= 5; weekday++) {
        await _tap(tester, find.byKey(Key('bulkDay-$weekday')));
      }
      await _tap(tester, find.byKey(const Key('bulkStatus')));
      await _tap(tester, find.text('Recibe en un intervalo').last);
      await _chooseTime(tester, const Key('bulkStart'), '09', '00');
      await _chooseTime(tester, const Key('bulkEnd'), '17', '00');
      await _tap(tester, find.byKey(const Key('bulkApply')));

      for (var index = 0; index < 5; index++) {
        expect(schedule![index].status, ReceptionStatus.open);
        expect(schedule![index].startMinutes, 540);
        expect(schedule![index].endMinutes, 1020);
      }
      expect(schedule![5].status, ReceptionStatus.closed);
      expect(schedule![6].status, ReceptionStatus.unknown);
      expect(find.text('Desde: 09:00'), findsNWidgets(5));
      expect(find.text('Hasta: 17:00'), findsNWidgets(5));

      await _chooseTime(tester, const Key('receptionEnd-5'), '14', '00');
      expect(schedule![4].endMinutes, 840);
      for (var index = 0; index < 4; index++) {
        expect(schedule![index].endMinutes, 1020);
      }
      expect(schedule![5].status, ReceptionStatus.closed);
      expect(schedule![6].status, ReceptionStatus.unknown);
    },
  );

  testWidgets('aplica No recibe y Sin definir a varios días', (tester) async {
    List<ReceptionDay>? schedule;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ReceptionScheduleEditor(
              initialSchedule: [
                for (var weekday = 1; weekday <= 7; weekday++)
                  ReceptionDay(
                    weekday: weekday,
                    status: ReceptionStatus.open,
                    startMinutes: 480,
                    endMinutes: 1020,
                  ),
              ],
              onChanged: (value) => schedule = value,
            ),
          ),
        ),
      ),
    );

    await _tap(tester, find.byKey(const Key('bulkScheduleButton')));
    for (final weekday in [6, 7]) {
      await _tap(tester, find.byKey(Key('bulkDay-$weekday')));
    }
    await _tap(tester, find.byKey(const Key('bulkStatus')));
    await _tap(tester, find.text('No recibe').last);
    await _tap(tester, find.byKey(const Key('bulkApply')));
    expect(schedule![5].status, ReceptionStatus.closed);
    expect(schedule![6].status, ReceptionStatus.closed);
    expect(schedule![0].status, ReceptionStatus.open);

    await _tap(tester, find.byKey(const Key('bulkScheduleButton')));
    for (final weekday in [1, 3]) {
      await _tap(tester, find.byKey(Key('bulkDay-$weekday')));
    }
    // Sin definir es el estado inicial del diálogo.
    await _tap(tester, find.byKey(const Key('bulkApply')));
    expect(schedule![0].status, ReceptionStatus.unknown);
    expect(schedule![2].status, ReceptionStatus.unknown);
    expect(schedule![1].status, ReceptionStatus.open);
    expect(schedule![5].status, ReceptionStatus.closed);
    expect(schedule![6].status, ReceptionStatus.closed);
  });

  testWidgets('valida selección e intervalo en la aplicación masiva', (
    tester,
  ) async {
    List<ReceptionDay>? schedule;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ReceptionScheduleEditor(
              initialSchedule: ReceptionDay.undefinedWeek(),
              onChanged: (value) => schedule = value,
            ),
          ),
        ),
      ),
    );
    await _tap(tester, find.byKey(const Key('bulkScheduleButton')));
    await _tap(tester, find.byKey(const Key('bulkApply')));
    expect(find.text('Selecciona al menos un día'), findsOneWidget);
    await _tap(tester, find.byKey(const Key('bulkDay-2')));
    await _tap(tester, find.byKey(const Key('bulkStatus')));
    await _tap(tester, find.text('Recibe en un intervalo').last);
    await _tap(tester, find.byKey(const Key('bulkApply')));
    expect(find.text('Selecciona ambas horas'), findsOneWidget);
    await _chooseTime(tester, const Key('bulkStart'), '17', '00');
    await _chooseTime(tester, const Key('bulkEnd'), '09', '00');
    await _tap(tester, find.byKey(const Key('bulkApply')));
    expect(
      find.text('La hora inicial debe ser anterior a la final'),
      findsOneWidget,
    );
    expect(schedule, isNull);
  });

  testWidgets('cancelar aplicación masiva no modifica el horario', (
    tester,
  ) async {
    var changes = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ReceptionScheduleEditor(
              initialSchedule: ReceptionDay.undefinedWeek(),
              onChanged: (_) => changes++,
            ),
          ),
        ),
      ),
    );
    await _tap(tester, find.byKey(const Key('bulkScheduleButton')));
    await _tap(tester, find.byKey(const Key('bulkDay-1')));
    await _tap(tester, find.byKey(const Key('bulkStatus')));
    await _tap(tester, find.text('No recibe').last);
    await _tap(tester, find.text('Cancelar'));
    expect(changes, 0);
    expect(find.byKey(const Key('bulkDay-1')), findsNothing);
  });

  testWidgets('configura un intervalo y lo conserva al reabrir el formulario', (
    tester,
  ) async {
    Client? updated;
    await tester.pumpWidget(
      MaterialApp(
        home: ClientDetailScreen(
          client: _client(),
          onClientUpdated: (client) => updated = client,
        ),
      ),
    );
    await _tap(tester, find.text('Editar cliente'));
    await _tap(tester, find.byKey(const Key('receptionStatus-4')));
    await _tap(tester, find.text('Recibe en un intervalo').last);
    // Un día abierto incompleto no puede guardarse.
    await _tap(tester, find.text('Guardar cliente'));
    expect(updated, isNull);
    expect(find.text('Selecciona ambas horas'), findsOneWidget);
    await _tap(tester, find.byKey(const Key('receptionStart-4')));
    await _tap(tester, find.text('OK'));
    await _tap(tester, find.byKey(const Key('receptionEnd-4')));
    await _tap(tester, find.text('OK'));
    await _tap(tester, find.text('Guardar cliente'));
    expect(updated!.receptionSchedule[3].startMinutes, 480);
    expect(updated!.receptionSchedule[3].endMinutes, 1020);
    await tester.scrollUntilVisible(
      find.text('Jueves: 08:00 - 17:00'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Jueves: 08:00 - 17:00'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Editar cliente'),
      -200,
      scrollable: find.byType(Scrollable).first,
    );
    await _tap(tester, find.text('Editar cliente'));
    await tester.ensureVisible(find.byKey(const Key('receptionStart-4')));
    await tester.pumpAndSettle();
    expect(find.text('Desde: 08:00'), findsNWidgets(2));
    expect(find.text('Hasta: 17:00'), findsNWidgets(2));
    await _tap(tester, find.byKey(const Key('receptionStart-4')));
    await _tap(tester, find.text('Cancel'));
    await _tap(tester, find.text('Guardar cliente'));
    expect(updated!.receptionSchedule[3].startMinutes, 480);
    expect(updated!.receptionSchedule[3].endMinutes, 1020);
  });

  testWidgets('edita datos precargados sin perder información existente', (
    tester,
  ) async {
    final original = _client();
    Client? updated;
    await tester.pumpWidget(
      MaterialApp(
        home: ClientDetailScreen(
          client: original,
          onClientUpdated: (client) => updated = client,
        ),
      ),
    );
    await _tap(tester, find.text('Editar cliente'));
    final name = tester.widget<TextFormField>(_field('Nombre comercial'));
    expect(name.controller!.text, original.commercialName);
    expect(
      tester.widget<TextFormField>(_field('Razón social')).controller!.text,
      original.businessName,
    );
    expect(_field('Nombre de contacto'), findsNothing);
    await _enter(tester, 'Nombre comercial', 'Tienda actualizada');
    await _tap(tester, find.text('Guardar cliente'));
    expect(updated, isNotNull);
    expect(updated!.commercialName, 'Tienda actualizada');
    expect(updated!.id, original.id);
    expect(updated!.latitude, original.latitude);
    expect(updated!.longitude, original.longitude);
    expect(updated!.contacts, original.contacts);
    expect(updated!.purchases, original.purchases);
    expect(updated!.receptionSchedule, original.receptionSchedule);
    expect(updated!.notes, original.notes);
    expect(find.text('Tienda actualizada'), findsOneWidget);
  });

  testWidgets('editar actualiza también la lista en memoria por ID', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ClientsScreen()));
    await _tap(tester, find.text('Abarrotes La Esperanza'));
    await _tap(tester, find.text('Editar cliente'));
    await _enter(tester, 'Nombre comercial', 'Abarrotes Actualizados');
    await _tap(tester, find.text('Guardar cliente'));
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Abarrotes Actualizados'), findsOneWidget);
    expect(find.text('Abarrotes La Esperanza'), findsNothing);
    await _tap(tester, find.text('Abarrotes Actualizados'));
    expect(
      find.text('Nombre comercial: Abarrotes Actualizados'),
      findsOneWidget,
    );
  });

  testWidgets('agrega varios contactos sin perder los anteriores', (
    tester,
  ) async {
    final original = _client();
    Client? updated;
    await tester.pumpWidget(
      MaterialApp(
        home: ClientDetailScreen(
          client: original,
          onClientUpdated: (client) => updated = client,
        ),
      ),
    );
    for (final name in ['Luis', 'María']) {
      await _tap(tester, find.text('Agregar contacto'));
      await _enter(tester, 'Nombre', name);
      await _enter(tester, 'Puesto/área', 'Almacén');
      await _enter(tester, 'Teléfono', '5551234567');
      await _enter(tester, 'Correo', '$name@example.com');
      await _tap(tester, find.text('Guardar contacto'));
    }
    expect(updated!.contacts.map((contact) => contact.name), [
      'Ana',
      'Luis',
      'María',
    ]);
    expect(updated!.purchases, original.purchases);
    expect(updated!.receptionSchedule, original.receptionSchedule);
    for (final name in ['Ana', 'Luis', 'María']) {
      await tester.scrollUntilVisible(
        find.text('Nombre: $name'),
        -150,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 15,
      );
      expect(find.text('Nombre: $name'), findsOneWidget);
    }
  });

  testWidgets('cancelar edición o alta de contacto no actualiza el cliente', (
    tester,
  ) async {
    var updates = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: ClientDetailScreen(
          client: _client(),
          onClientUpdated: (_) => updates++,
        ),
      ),
    );
    await _tap(tester, find.text('Editar cliente'));
    await _enter(tester, 'Nombre comercial', 'No guardar');
    await tester.pageBack();
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Agregar contacto'));
    await _enter(tester, 'Nombre', 'No guardar');
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(updates, 0);
  });

  testWidgets('detalle distingue intervalo, No recibe y Sin definir', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ClientDetailScreen(client: _client(), onClientUpdated: (_) {}),
      ),
    );
    await tester.scrollUntilVisible(
      find.text('Domingo: Sin definir'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Horario de recepción de entregas'), findsOneWidget);
    expect(find.text('Lunes: 08:00 - 17:00'), findsOneWidget);
    expect(find.text('Martes: No recibe'), findsOneWidget);
    expect(find.text('Miércoles: Sin definir'), findsOneWidget);
    expect(find.text('Domingo: Sin definir'), findsOneWidget);
  });

  testWidgets('configura un día sin recepción y lo muestra al guardar', (
    tester,
  ) async {
    Client? updated;
    await tester.pumpWidget(
      MaterialApp(
        home: ClientDetailScreen(
          client: _client(),
          onClientUpdated: (client) => updated = client,
        ),
      ),
    );
    await _tap(tester, find.text('Editar cliente'));
    await _tap(tester, find.byKey(const Key('receptionStatus-3')));
    await _tap(tester, find.text('No recibe').last);
    await _tap(tester, find.text('Guardar cliente'));
    expect(updated!.receptionSchedule[2].status, ReceptionStatus.closed);
    expect(updated!.receptionSchedule[3].status, ReceptionStatus.unknown);
    await tester.scrollUntilVisible(
      find.text('Miércoles: No recibe'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Miércoles: No recibe'), findsOneWidget);
    expect(find.text('Jueves: Sin definir'), findsOneWidget);
  });

  testWidgets('selecciona horas y valida intervalos incompletos o invertidos', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    List<ReceptionDay>? schedule;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: ReceptionScheduleEditor(
                initialSchedule: ReceptionDay.undefinedWeek(),
                onChanged: (value) => schedule = value,
              ),
            ),
          ),
        ),
      ),
    );
    await _tap(tester, find.byKey(const Key('receptionStatus-1')));
    await _tap(tester, find.text('Recibe en un intervalo').last);
    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Selecciona ambas horas'), findsOneWidget);

    Future<void> choose(String key, String hour, String minute) async {
      await _tap(tester, find.byKey(Key(key)));
      await _tap(tester, find.byIcon(Icons.keyboard_outlined));
      final fields = find.descendant(
        of: find.byType(TimePickerDialog),
        matching: find.byType(TextField),
      );
      await tester.enterText(fields.at(0), hour);
      await tester.enterText(fields.at(1), minute);
      await _tap(tester, find.text('OK'));
    }

    await choose('receptionStart-1', '17', '00');
    await choose('receptionEnd-1', '08', '00');
    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(
      find.text('La hora inicial debe ser anterior a la final'),
      findsOneWidget,
    );
    expect(schedule, isNull);
    await choose('receptionStart-1', '07', '30');
    expect(formKey.currentState!.validate(), isTrue);
    expect(schedule!.first.startMinutes, 450);
    expect(schedule!.first.endMinutes, 480);
    expect(schedule!.length, 7);
    expect(find.text('Desde: 07:30'), findsOneWidget);
    expect(find.text('Hasta: 08:00'), findsOneWidget);
  });
}
