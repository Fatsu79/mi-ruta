import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _sections = [
    (label: 'Clientes', icon: Icons.people_outline),
    (label: 'Pedidos', icon: Icons.shopping_bag_outlined),
    (label: 'Rutas', icon: Icons.route_outlined),
    (label: 'Entregas', icon: Icons.local_shipping_outlined),
  ];

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
                onTap: () {},
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
