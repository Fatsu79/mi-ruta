import 'package:app_clientes/models/order.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Order createOrder({
    String id = 'order-1',
    String invoiceNumber = 'A50000',
    String clientId = 'client-1',
    OrderStatus status = OrderStatus.withoutRoute,
    String? postponementReason,
  }) => Order(
    id: id,
    invoiceNumber: invoiceNumber,
    clientId: clientId,
    invoiceDate: DateTime(2026, 9, 24),
    status: status,
    postponementReason: postponementReason,
  );

  test('un pedido nuevo inicia Sin ruta', () {
    final order = createOrder();

    expect(order.status, OrderStatus.withoutRoute);
  });

  test('folio e ID interno son campos independientes', () {
    final first = createOrder(id: '1', invoiceNumber: 'A1');
    final second = createOrder(id: '2', invoiceNumber: 'A1');

    expect(first.invoiceNumber, second.invoiceNumber);
    expect(first.id, isNot(second.id));
  });

  test('un pedido pospuesto requiere un motivo no vacío', () {
    expect(
      () => createOrder(status: OrderStatus.postponed),
      throwsArgumentError,
    );
    expect(
      () =>
          createOrder(status: OrderStatus.postponed, postponementReason: '   '),
      throwsArgumentError,
    );
  });

  test('observaciones y motivo de posposición son independientes', () {
    final order = Order(
      id: '1',
      invoiceNumber: 'B50001',
      clientId: 'client-1',
      invoiceDate: DateTime(2026, 9, 24),
      status: OrderStatus.postponed,
      notes: 'Entregar en almacén',
      postponementReason: 'Cliente cerrado',
    );

    expect(order.notes, 'Entregar en almacén');
    expect(order.postponementReason, 'Cliente cerrado');
  });

  test('conserva el motivo al abandonar Pospuesto', () {
    final postponed = createOrder(
      status: OrderStatus.postponed,
      postponementReason: 'Recibir la próxima semana',
    );

    final delivered = postponed.copyWith(status: OrderStatus.delivered);

    expect(delivered.status, OrderStatus.delivered);
    expect(delivered.postponementReason, 'Recibir la próxima semana');
  });

  test('todos los estados tienen etiqueta de interfaz', () {
    expect(OrderStatus.values.map((status) => status.label), [
      'Sin ruta',
      'En ruta',
      'Entregado',
      'Pospuesto',
      'Cancelado',
    ]);
  });
}
