import '../models/client.dart';
import '../models/contact.dart';
import '../models/order.dart';
import '../models/purchase.dart';

List<Client> createSampleClients() => [
  Client(
    id: '1',
    commercialName: 'Abarrotes La Esperanza',
    businessName: 'Comercializadora La Esperanza, S.A. de C.V.',
    state: 'Jalisco',
    municipality: 'Guadalajara',
    address: 'Av. Juárez 120, Centro',
    latitude: 20.6752,
    longitude: -103.3476,
    discount: 5,
    hasCredit: true,
    notes: 'Recibe mercancía de lunes a viernes por la mañana.',
    contacts: const [
      Contact(
        name: 'María López',
        position: 'Compras',
        phone: '33 1234 5678',
        email: 'maria@example.com',
      ),
    ],
    purchases: [
      Purchase(
        date: DateTime(2026, 8, 15),
        amount: 2450,
        invoiceNumber: 'F-1042',
      ),
      Purchase(date: DateTime(2026, 7, 28), amount: 1875.50),
    ],
  ),
  Client(
    id: '2',
    commercialName: 'Papelería Central',
    businessName: 'Papelería Central de Occidente',
    state: 'Jalisco',
    municipality: 'Zapopan',
    address: 'Av. Vallarta 850',
    discount: 0,
    hasCredit: false,
    notes: '',
    contacts: const [
      Contact(
        name: 'Carlos Ruiz',
        position: 'Propietario',
        phone: '33 9876 5432',
        email: 'carlos@example.com',
      ),
    ],
  ),
];

List<Order> createSampleOrders() => [
  Order(
    id: 'order-1',
    invoiceNumber: 'A50000',
    clientId: '1',
    invoiceDate: DateTime(2026, 9, 20),
    expectedDeliveryDate: DateTime(2026, 9, 24),
    notes: 'Entregar en almacén.',
  ),
  Order(
    id: 'order-2',
    invoiceNumber: 'B50001',
    clientId: '2',
    invoiceDate: DateTime(2026, 9, 21),
    status: OrderStatus.inRoute,
  ),
  Order(
    id: 'order-3',
    invoiceNumber: 'A1',
    clientId: '1',
    invoiceDate: DateTime(2026, 9, 18),
    status: OrderStatus.postponed,
    postponementReason: 'El cliente solicitó recibir la próxima semana.',
  ),
];
