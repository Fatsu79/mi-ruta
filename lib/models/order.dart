enum OrderStatus { withoutRoute, inRoute, delivered, postponed, cancelled }

extension OrderStatusLabel on OrderStatus {
  String get label => switch (this) {
    OrderStatus.withoutRoute => 'Sin ruta',
    OrderStatus.inRoute => 'En ruta',
    OrderStatus.delivered => 'Entregado',
    OrderStatus.postponed => 'Pospuesto',
    OrderStatus.cancelled => 'Cancelado',
  };
}

class Order {
  Order({
    required this.id,
    required String invoiceNumber,
    required String clientId,
    required this.invoiceDate,
    this.expectedDeliveryDate,
    this.status = OrderStatus.withoutRoute,
    String notes = '',
    String? postponementReason,
  }) : invoiceNumber = invoiceNumber.trim(),
       clientId = clientId.trim(),
       notes = notes.trim(),
       postponementReason = postponementReason?.trim() {
    if (id.trim().isEmpty) {
      throw ArgumentError('El ID es obligatorio');
    }
    if (this.invoiceNumber.isEmpty) {
      throw ArgumentError('El folio es obligatorio');
    }
    if (this.clientId.isEmpty) {
      throw ArgumentError('El cliente es obligatorio');
    }
    if (status == OrderStatus.postponed &&
        (this.postponementReason == null || this.postponementReason!.isEmpty)) {
      throw ArgumentError('Un pedido pospuesto requiere un motivo');
    }
  }

  final String id;
  final String invoiceNumber;
  final String clientId;
  final DateTime invoiceDate;
  final DateTime? expectedDeliveryDate;
  final OrderStatus status;
  final String notes;
  final String? postponementReason;

  Order copyWith({
    String? invoiceNumber,
    String? clientId,
    DateTime? invoiceDate,
    DateTime? expectedDeliveryDate,
    bool clearExpectedDeliveryDate = false,
    OrderStatus? status,
    String? notes,
    String? postponementReason,
  }) => Order(
    id: id,
    invoiceNumber: invoiceNumber ?? this.invoiceNumber,
    clientId: clientId ?? this.clientId,
    invoiceDate: invoiceDate ?? this.invoiceDate,
    expectedDeliveryDate: clearExpectedDeliveryDate
        ? null
        : expectedDeliveryDate ?? this.expectedDeliveryDate,
    status: status ?? this.status,
    notes: notes ?? this.notes,
    postponementReason: postponementReason ?? this.postponementReason,
  );
}
