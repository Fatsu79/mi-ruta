import 'package:app_clientes/main.dart';
import 'package:app_clientes/screens/clients/clients_screen.dart';
import 'package:app_clientes/screens/home_screen.dart';
import 'package:app_clientes/screens/orders/orders_screen.dart';
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

  testWidgets('navega de Home a Clientes y muestra el listado', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    await tester.tap(find.text('Clientes'));
    await tester.pumpAndSettle();

    expect(find.byType(ClientsScreen), findsOneWidget);
    expect(find.text('Buscar clientes'), findsOneWidget);
    expect(find.text('Abarrotes La Esperanza'), findsOneWidget);
    expect(find.text('Papelería Central'), findsOneWidget);
    expect(find.text('Agregar cliente'), findsOneWidget);
  });

  testWidgets('abre el formulario para agregar un cliente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ClientsScreen()));

    await tester.tap(find.byKey(const Key('addClientButton')));
    await tester.pumpAndSettle();

    expect(find.text('Nuevo cliente'), findsOneWidget);
    expect(find.text('Nombre comercial'), findsOneWidget);
    expect(find.text('Razón social'), findsOneWidget);
  });

  testWidgets('navega de Home a Pedidos y muestra el listado', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    await tester.tap(find.text('Pedidos'));
    await tester.pumpAndSettle();

    expect(find.byType(OrdersScreen), findsOneWidget);
    expect(find.text('Buscar por folio o cliente'), findsOneWidget);
    expect(find.text('Factura A50000'), findsOneWidget);
    expect(find.text('Agregar pedido'), findsOneWidget);
  });
}
