import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/client.dart';
import '../models/order.dart';
import 'clients/clients_screen.dart';
import 'orders/orders_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<Client> _clients = createSampleClients();
  late final List<Order> _orders = createSampleOrders();

  static const _sections = [
    (label: 'Clientes', icon: Icons.people_outline),
    (label: 'Pedidos', icon: Icons.shopping_bag_outlined),
    (label: 'Rutas', icon: Icons.route_outlined),
    (label: 'Entregas', icon: Icons.local_shipping_outlined),
  ];

  void _openSection(BuildContext context, String label) {
    if (label == 'Clientes') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => ClientsScreen(clients: _clients),
        ),
      );
    } else if (label == 'Pedidos') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) =>
              OrdersScreen(clients: _clients, orders: _orders),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Ruta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 260,
            mainAxisExtent: 150,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _sections.length,
          itemBuilder: (context, index) {
            final section = _sections[index];

            return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => _openSection(context, section.label),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      section.icon,
                      size: 44,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      section.label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
