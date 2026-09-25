import 'package:flutter/material.dart';

import '../../models/client.dart';
import '../../models/order.dart';
import '../clients/client_detail_screen.dart';
import 'order_form_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({
    required this.order,
    required this.clients,
    required this.onOrderUpdated,
    required this.onClientsChanged,
    super.key,
  });

  final Order order;
  final List<Client> clients;
  final ValueChanged<Order> onOrderUpdated;
  final VoidCallback onClientsChanged;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Order _order;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  Client? get _client {
    for (final client in widget.clients) {
      if (client.id == _order.clientId) return client;
    }
    return null;
  }

  void _updateOrder(Order order) {
    setState(() => _order = order);
    widget.onOrderUpdated(order);
  }

  Future<void> _editOrder() async {
    final updated = await Navigator.of(context).push<Order>(
      MaterialPageRoute(
        builder: (_) => OrderFormScreen(clients: widget.clients, order: _order),
      ),
    );
    if (updated != null && mounted) _updateOrder(updated);
  }

  Future<void> _openClient() async {
    final client = _client;
    if (client == null) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => ClientDetailScreen(
          client: client,
          onClientUpdated: (updated) {
            final index = widget.clients.indexWhere(
              (item) => item.id == updated.id,
            );
            if (index == -1) return;
            widget.clients[index] = updated;
            widget.onClientsChanged();
            if (mounted) setState(() {});
          },
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _changeStatus() async {
    const manualStatuses = [
      OrderStatus.withoutRoute,
      OrderStatus.delivered,
      OrderStatus.postponed,
      OrderStatus.cancelled,
    ];
    OrderStatus? selected = manualStatuses.contains(_order.status)
        ? _order.status
        : null;
    var reason = _order.postponementReason ?? '';
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<(OrderStatus, String?)>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Cambiar estado'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<OrderStatus>(
                    key: const Key('changeOrderStatusDropdown'),
                    initialValue: selected,
                    decoration: const InputDecoration(
                      labelText: 'Estado',
                      border: OutlineInputBorder(),
                    ),
                    items: manualStatuses
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status.label),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setDialogState(() => selected = value),
                    validator: (value) =>
                        value == null ? 'Selecciona un estado' : null,
                  ),
                  if (selected == OrderStatus.postponed) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('postponementReasonField'),
                      initialValue: reason,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Motivo de posposición',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Ingresa el motivo de posposición'
                          : null,
                      onChanged: (value) => reason = value,
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              key: const Key('confirmOrderStatusButton'),
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                Navigator.of(dialogContext).pop((
                  selected!,
                  selected == OrderStatus.postponed ? reason.trim() : null,
                ));
              },
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
    if (result == null || !mounted) return;

    final (status, resultReason) = result;
    _updateOrder(
      _order.copyWith(status: status, postponementReason: resultReason),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final client = _client;
    return Scaffold(
      appBar: AppBar(title: Text('Pedido ${_order.invoiceNumber}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                key: const Key('editOrderButton'),
                onPressed: _editOrder,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar pedido'),
              ),
              OutlinedButton.icon(
                key: const Key('changeOrderStatusButton'),
                onPressed: _changeStatus,
                icon: const Icon(Icons.sync_alt_outlined),
                label: const Text('Cambiar estado'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'Datos del pedido',
            children: [
              _Detail(label: 'ID interno', value: _order.id),
              _Detail(label: 'Folio de factura', value: _order.invoiceNumber),
              _Detail(label: 'Estado', value: _order.status.label),
              _Detail(
                label: 'Fecha de factura',
                value: _formatDate(_order.invoiceDate),
              ),
              _Detail(
                label: 'Fecha prevista de entrega',
                value: _order.expectedDeliveryDate == null
                    ? 'Sin definir'
                    : _formatDate(_order.expectedDeliveryDate!),
              ),
              if (_order.status == OrderStatus.postponed)
                _Detail(
                  label: 'Motivo de posposición',
                  value: _order.postponementReason!,
                ),
            ],
          ),
          _Section(
            title: 'Cliente relacionado',
            children: [
              Text(client?.commercialName ?? 'Cliente no disponible'),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                key: const Key('openRelatedClientButton'),
                onPressed: client == null ? null : _openClient,
                icon: const Icon(Icons.person_outline),
                label: const Text('Ver cliente'),
              ),
            ],
          ),
          _Section(
            title: 'Observaciones generales',
            children: [
              Text(_order.notes.isEmpty ? 'Sin observaciones' : _order.notes),
            ],
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
