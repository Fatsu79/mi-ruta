import 'package:app_clientes/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('navega del inicio de sesión a la pantalla principal', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MiRutaApp());

    expect(find.text('Mi Ruta'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Iniciar sesión'), findsOneWidget);

    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();

    expect(find.text('Clientes'), findsOneWidget);
    expect(find.text('Pedidos'), findsOneWidget);
    expect(find.text('Rutas'), findsOneWidget);
    expect(find.text('Entregas'), findsOneWidget);
  });
}
