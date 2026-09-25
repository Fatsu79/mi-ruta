import 'package:flutter/material.dart';

import '../../models/client.dart';
import '../../models/order.dart';
import 'order_detail_screen.dart';
import 'order_form_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({required this.clients, required this.orders, super.key});

  final List<Client> clients;
  final List<Order> orders;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _statusFilter = 'all';

  String _clientName(String clientId) {
    for (final client in widget.clients) {
      if (client.id == clientId) return client.commercialName;
    }
    return 'Cliente no disponible';
  }

  List<Order> get _filteredOrders {
    final query = _query.trim().toLowerCase();
    return widget.orders.where((order) {
      final matchesQuery =
          query.isEmpty ||
          order.invoiceNumber.toLowerCase().contains(query) ||
          _clientName(order.clientId).toLowerCase().contains(query);
      final matchesStatus =
          _statusFilter == 'all' || order.status.name == _statusFilter;
      return matchesQuery && matchesStatus;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _addOrder() async {
    final order = await Navigator.of(context).push<Order>(
      MaterialPageRoute(
        builder: (_) => OrderFormScreen(clients: widget.clients),
      ),
    );
    if (order != null && mounted) setState(() => widget.orders.add(order));
  }

  void _openDetail(Order order) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => OrderDetailScreen(
          order: order,
          clients: widget.clients,
          onOrderUpdated: (updated) {
            final index = widget.orders.indexWhere(
              (item) => item.id == updated.id,
            );
            if (index != -1 && mounted) {
              setState(() => widget.orders[index] = updated);
            }
          },
          onClientsChanged: () {
            if (mounted) setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = _filteredOrders;
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              key: const Key('ordersSearchField'),
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar por folio o cliente',
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: DropdownButtonFormField<String>(
              key: const Key('ordersStatusFilter'),
              initialValue: _statusFilter,
              decoration: const InputDecoration(
                labelText: 'Filtrar por estado',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: 'all',
                  child: Text('Todos los estados'),
                ),
                ...OrderStatus.values.map(
                  (status) => DropdownMenuItem(
                    value: status.name,
                    child: Text(status.label),
                  ),
                ),
              ],
              onChanged: (value) =>
                  setState(() => _statusFilter = value ?? 'all'),
            ),
          ),
          Expanded(
            child: orders.isEmpty
                ? const Center(child: Text('No se encontraron pedidos'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Card(
                        child: ListTile(
                          title: Text('Factura ${order.invoiceNumber}'),
                          subtitle: Text(
                            '${_clientName(order.clientId)}\n${order.status.label}',
                          ),
                          isThreeLine: true,
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _openDetail(order),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('addOrderButton'),
        onPressed: widget.clients.isEmpty ? null : _addOrder,
        icon: const Icon(Icons.add),
        label: const Text('Agregar pedido'),
      ),
    );
  }
}
