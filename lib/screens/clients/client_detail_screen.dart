import 'package:flutter/material.dart';

import '../../models/client.dart';
import '../../models/contact.dart';
import '../../models/reception_day.dart';
import 'client_form_screen.dart';
import 'contact_form_screen.dart';

class ClientDetailScreen extends StatefulWidget {
  const ClientDetailScreen({
    required this.client,
    required this.onClientUpdated,
    super.key,
  });

  final Client client;
  final ValueChanged<Client> onClientUpdated;

  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen> {
  late Client client;

  @override
  void initState() {
    super.initState();
    client = widget.client;
  }

  void _update(Client updated) {
    setState(() => client = updated);
    widget.onClientUpdated(updated);
  }

  Future<void> _edit() async {
    final updated = await Navigator.of(context).push<Client>(
      MaterialPageRoute(builder: (_) => ClientFormScreen(client: client)),
    );
    if (updated != null && mounted) _update(updated);
  }

  Future<void> _addContact() async {
    final contact = await Navigator.of(context).push<Contact>(
      MaterialPageRoute(builder: (_) => const ContactFormScreen()),
    );
    if (contact != null && mounted) {
      _update(client.copyWith(contacts: [...client.contacts, contact]));
    }
  }

  static const _days = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  String _time(int minutes) =>
      '${(minutes ~/ 60).toString().padLeft(2, '0')}:${(minutes % 60).toString().padLeft(2, '0')}';

  String _scheduleText(ReceptionDay day) => switch (day.status) {
    ReceptionStatus.unknown => 'Sin definir',
    ReceptionStatus.closed => 'No recibe',
    ReceptionStatus.open =>
      '${_time(day.startMinutes!)} - ${_time(day.endMinutes!)}',
  };

  String _date(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    return '$day/$month/${value.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(client.commercialName)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OutlinedButton.icon(
              onPressed: _edit,
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Editar cliente'),
            ),
          ),
          _Section(
            title: 'Datos generales',
            children: [
              _Detail(label: 'Nombre comercial', value: client.commercialName),
              _Detail(label: 'Razón social', value: client.businessName),
            ],
          ),
          _Section(
            title: 'Contactos',
            children: [
              ...(client.contacts.isEmpty
                  ? const [Text('Sin contactos registrados')]
                  : client.contacts
                        .map(
                          (contact) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Detail(label: 'Nombre', value: contact.name),
                                _Detail(
                                  label: 'Puesto/área',
                                  value: contact.position,
                                ),
                                _Detail(
                                  label: 'Teléfono',
                                  value: contact.phone,
                                ),
                                _Detail(label: 'Correo', value: contact.email),
                              ],
                            ),
                          ),
                        )
                        .toList()),
              OutlinedButton.icon(
                onPressed: _addContact,
                icon: const Icon(Icons.person_add_outlined),
                label: const Text('Agregar contacto'),
              ),
            ],
          ),
          _Section(
            title: 'Horario de recepción de entregas',
            children: [
              for (final day in client.receptionSchedule)
                _Detail(
                  label: _days[day.weekday - 1],
                  value: _scheduleText(day),
                ),
            ],
          ),
          _Section(
            title: 'Ubicación',
            children: [
              _Detail(label: 'Estado', value: client.state),
              _Detail(label: 'Municipio', value: client.municipality),
              _Detail(label: 'Dirección', value: client.address),
              if (client.latitude != null && client.longitude != null)
                _Detail(
                  label: 'Coordenadas',
                  value: '${client.latitude}, ${client.longitude}',
                ),
            ],
          ),
          _Section(
            title: 'Condiciones comerciales',
            children: [
              _Detail(label: 'Descuento', value: '${client.discount}%'),
              _Detail(label: 'Crédito', value: client.hasCredit ? 'Sí' : 'No'),
            ],
          ),
          _Section(
            title: 'Observaciones',
            children: [
              Text(client.notes.isEmpty ? 'Sin observaciones' : client.notes),
            ],
          ),
          _Section(
            title: 'Historial de compras',
            children: client.purchases.isEmpty
                ? const [Text('Sin compras registradas')]
                : client.purchases
                      .map(
                        (purchase) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.receipt_long_outlined),
                          title: Text(
                            '\$${purchase.amount.toStringAsFixed(2)}',
                          ),
                          subtitle: Text(
                            purchase.invoiceNumber == null
                                ? _date(purchase.date)
                                : '${_date(purchase.date)} · Factura ${purchase.invoiceNumber}',
                          ),
                        ),
                      )
                      .toList(),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const Divider(),
          ...children,
        ],
      ),
    ),
  );
}

class _Detail extends StatelessWidget {
  const _Detail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text('$label: $value'),
  );
}
