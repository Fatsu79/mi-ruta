import 'package:flutter/material.dart';

import '../../models/client.dart';
import '../../models/contact.dart';
import '../../models/purchase.dart';
import 'client_detail_screen.dart';
import 'client_form_screen.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final _searchController = TextEditingController();
  final List<Client> _clients = [
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
      contacts: [
        Contact(
          name: 'Carlos Ruiz',
          position: 'Propietario',
          phone: '33 9876 5432',
          email: 'carlos@example.com',
        ),
      ],
    ),
  ];
  String _query = '';

  List<Client> get _filteredClients {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return _clients;
    return _clients
        .where(
          (client) =>
              client.commercialName.toLowerCase().contains(query) ||
              client.businessName.toLowerCase().contains(query) ||
              client.municipality.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openForm() async {
    final client = await Navigator.of(context).push<Client>(
      MaterialPageRoute(builder: (context) => const ClientFormScreen()),
    );
    if (client != null && mounted) setState(() => _clients.add(client));
  }

  void _openDetail(Client client) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ClientDetailScreen(
          client: client,
          onClientUpdated: (updated) {
            if (!mounted) return;
            final index = _clients.indexWhere((item) => item.id == updated.id);
            if (index != -1) setState(() => _clients[index] = updated);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clients = _filteredClients;
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              key: const Key('clientsSearchField'),
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar clientes',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Limpiar búsqueda',
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.clear),
                      ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: clients.isEmpty
                ? const Center(child: Text('No se encontraron clientes'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
                    itemCount: clients.length,
                    itemBuilder: (context, index) {
                      final client = clients[index];
                      return Card(
                        child: ListTile(
                          title: Text(client.commercialName),
                          subtitle: Text(
                            '${client.municipality}, ${client.state}',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _openDetail(client),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('addClientButton'),
        onPressed: _openForm,
        icon: const Icon(Icons.add),
        label: const Text('Agregar cliente'),
      ),
    );
  }
}
