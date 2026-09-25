import 'package:app_clientes/models/client.dart';
import 'package:app_clientes/models/order.dart';
import 'package:app_clientes/screens/orders/order_detail_screen.dart';
import 'package:app_clientes/screens/orders/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final clients = [
    Client(
      id: 'client-1',
      commercialName: 'Cliente Norte',
      businessName: 'Cliente Norte, S.A.',
      state: 'Jalisco',
      municipality: 'Guadalajara',
      address: 'Calle Uno',
      discount: 0,
      hasCredit: false,
      notes: '',
    ),
    Client(
      id: 'client-2',
      commercialName: 'Cliente Sur',
      businessName: 'Cliente Sur, S.A.',
      state: 'Jalisco',
      municipality: 'Zapopan',
      address: 'Calle Dos',
      discount: 5,
      hasCredit: true,
      notes: '',
    ),
  ];

  Order order({
    String id = 'order-1',
    String invoiceNumber = 'A50000',
    String clientId = 'client-1',
    OrderStatus status = OrderStatus.withoutRoute,
    String notes = '',
    String? postponementReason,
  }) => Order(
    id: id,
    invoiceNumber: invoiceNumber,
    clientId: clientId,
    invoiceDate: DateTime(2026, 9, 24),
    status: status,
    notes: notes,
    postponementReason: postponementReason,
  );

  testWidgets('muestra, busca y filtra pedidos por estado', (tester) async {
    final orders = [
      order(),
      order(
        id: 'order-2',
        invoiceNumber: 'B50001',
        clientId: 'client-2',
        status: OrderStatus.inRoute,
      ),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: OrdersScreen(clients: clients, orders: orders),
      ),
    );

    expect(find.text('Factura A50000'), findsOneWidget);
    expect(find.text('Factura B50001'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('ordersSearchField')),
      'Cliente Sur',
    );
    await tester.pump();
    expect(find.text('Factura A50000'), findsNothing);
    expect(find.text('Factura B50001'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('ordersSearchField')), '');
    await tester.tap(find.byKey(const Key('ordersStatusFilter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sin ruta').last);
    await tester.pumpAndSettle();
    expect(find.text('Factura A50000'), findsOneWidget);
    expect(find.text('Factura B50001'), findsNothing);
  });

  testWidgets('crea un pedido en Sin ruta sin selector de estado', (
    tester,
  ) async {
    final orders = <Order>[];
    await tester.pumpWidget(
      MaterialApp(
        home: OrdersScreen(clients: clients, orders: orders),
      ),
    );

    await tester.tap(find.byKey(const Key('addOrderButton')));
    await tester.pumpAndSettle();
    expect(find.text('Nuevo pedido'), findsOneWidget);
    expect(find.text('Estado'), findsNothing);
    expect(find.text('En ruta'), findsNothing);

    await tester.enterText(
      find.byKey(const Key('invoiceNumberField')),
      'A123456789012345',
    );
    await tester.tap(find.byKey(const Key('orderClientDropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cliente Norte').last);
    await tester.ensureVisible(find.byKey(const Key('saveOrderButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saveOrderButton')));
    await tester.pumpAndSettle();

    expect(orders, hasLength(1));
    expect(orders.single.status, OrderStatus.withoutRoute);
    expect(find.text('Factura A123456789012345'), findsOneWidget);
  });

  testWidgets('editar conserva ID, estado, motivo y relación con cliente', (
    tester,
  ) async {
    final orders = [
      order(
        status: OrderStatus.postponed,
        notes: 'Observación general',
        postponementReason: 'Cliente cerrado',
      ),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: OrdersScreen(clients: clients, orders: orders),
      ),
    );

    await tester.tap(find.text('Factura A50000'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('editOrderButton')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('invoiceNumberField')),
      'A50000-EDITADO',
    );
    await tester.tap(find.byKey(const Key('saveOrderButton')));
    await tester.pumpAndSettle();

    expect(orders.single.id, 'order-1');
    expect(orders.single.clientId, 'client-1');
    expect(orders.single.status, OrderStatus.postponed);
    expect(orders.single.postponementReason, 'Cliente cerrado');
    expect(orders.single.notes, 'Observación general');
    expect(find.text('Pedido A50000-EDITADO'), findsOneWidget);
  });

  testWidgets('En ruta se muestra pero no se ofrece como cambio manual', (
    tester,
  ) async {
    final current = order(status: OrderStatus.inRoute);
    await tester.pumpWidget(
      MaterialApp(
        home: OrderDetailScreen(
          order: current,
          clients: clients,
          onOrderUpdated: (_) {},
          onClientsChanged: () {},
        ),
      ),
    );

    expect(find.text('Estado: En ruta'), findsOneWidget);
    await tester.tap(find.byKey(const Key('changeOrderStatusButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('changeOrderStatusDropdown')));
    await tester.pumpAndSettle();

    expect(find.text('Sin ruta'), findsOneWidget);
    expect(find.text('Entregado'), findsOneWidget);
    expect(find.text('Pospuesto'), findsOneWidget);
    expect(find.text('Cancelado'), findsOneWidget);
    expect(find.text('En ruta'), findsNothing);
  });

  testWidgets('exige motivo independiente al cambiar a Pospuesto', (
    tester,
  ) async {
    Order? updated;
    await tester.pumpWidget(
      MaterialApp(
        home: OrderDetailScreen(
          order: order(notes: 'Llevar acuse'),
          clients: clients,
          onOrderUpdated: (value) => updated = value,
          onClientsChanged: () {},
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('changeOrderStatusButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('changeOrderStatusDropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pospuesto').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirmOrderStatusButton')));
    await tester.pump();
    expect(find.text('Ingresa el motivo de posposición'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('postponementReasonField')),
      'Cliente solicitó otra fecha',
    );
    await tester.tap(find.byKey(const Key('confirmOrderStatusButton')));
    await tester.pumpAndSettle();

    expect(updated?.status, OrderStatus.postponed);
    expect(updated?.notes, 'Llevar acuse');
    expect(updated?.postponementReason, 'Cliente solicitó otra fecha');
    expect(
      find.text('Motivo de posposición: Cliente solicitó otra fecha'),
      findsOneWidget,
    );
  });

  testWidgets('abre el detalle del cliente relacionado', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: OrderDetailScreen(
          order: order(),
          clients: clients,
          onOrderUpdated: (_) {},
          onClientsChanged: () {},
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('openRelatedClientButton')));
    await tester.pumpAndSettle();

    expect(find.text('Datos generales'), findsOneWidget);
    expect(find.text('Nombre comercial: Cliente Norte'), findsOneWidget);
  });
}
