import 'package:flutter/material.dart';

import '../../models/client.dart';
import '../../models/order.dart';

class OrderFormScreen extends StatefulWidget {
  const OrderFormScreen({required this.clients, this.order, super.key});

  final List<Client> clients;
  final Order? order;

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _invoiceNumberController;
  late final TextEditingController _notesController;
  late String? _clientId;
  late DateTime _invoiceDate;
  DateTime? _expectedDeliveryDate;

  bool get _isEditing => widget.order != null;

  @override
  void initState() {
    super.initState();
    final order = widget.order;
    _invoiceNumberController = TextEditingController(
      text: order?.invoiceNumber ?? '',
    );
    _notesController = TextEditingController(text: order?.notes ?? '');
    _clientId = order?.clientId;
    _invoiceDate = order?.invoiceDate ?? DateTime.now();
    _expectedDeliveryDate = order?.expectedDeliveryDate;
  }

  @override
  void dispose() {
    _invoiceNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _selectInvoiceDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _invoiceDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected != null && mounted) setState(() => _invoiceDate = selected);
  }

  Future<void> _selectExpectedDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _expectedDeliveryDate ?? _invoiceDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected != null && mounted) {
      setState(() => _expectedDeliveryDate = selected);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final existing = widget.order;
    final order = existing == null
        ? Order(
            id: 'order-${DateTime.now().microsecondsSinceEpoch}',
            invoiceNumber: _invoiceNumberController.text,
            clientId: _clientId!,
            invoiceDate: _invoiceDate,
            expectedDeliveryDate: _expectedDeliveryDate,
            notes: _notesController.text,
          )
        : existing.copyWith(
            invoiceNumber: _invoiceNumberController.text,
            clientId: _clientId,
            invoiceDate: _invoiceDate,
            expectedDeliveryDate: _expectedDeliveryDate,
            clearExpectedDeliveryDate: _expectedDeliveryDate == null,
            notes: _notesController.text,
          );
    Navigator.of(context).pop(order);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar pedido' : 'Nuevo pedido'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              key: const Key('invoiceNumberField'),
              controller: _invoiceNumberController,
              decoration: const InputDecoration(
                labelText: 'Folio de factura',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Ingresa el folio de factura'
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              key: const Key('orderClientDropdown'),
              initialValue: _clientId,
              decoration: const InputDecoration(
                labelText: 'Cliente',
                border: OutlineInputBorder(),
              ),
              items: widget.clients
                  .map(
                    (client) => DropdownMenuItem(
                      value: client.id,
                      child: Text(client.commercialName),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _clientId = value),
              validator: (value) =>
                  value == null ? 'Selecciona un cliente' : null,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              key: const Key('invoiceDateButton'),
              onPressed: _selectInvoiceDate,
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text('Fecha de factura: ${_formatDate(_invoiceDate)}'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              key: const Key('expectedDeliveryDateButton'),
              onPressed: _selectExpectedDate,
              icon: const Icon(Icons.event_outlined),
              label: Text(
                _expectedDeliveryDate == null
                    ? 'Fecha prevista de entrega: Sin definir'
                    : 'Fecha prevista de entrega: ${_formatDate(_expectedDeliveryDate!)}',
              ),
            ),
            if (_expectedDeliveryDate != null)
              TextButton(
                key: const Key('clearExpectedDeliveryDateButton'),
                onPressed: () => setState(() => _expectedDeliveryDate = null),
                child: const Text('Quitar fecha prevista'),
              ),
            const SizedBox(height: 8),
            TextFormField(
              key: const Key('orderNotesField'),
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Observaciones generales (opcional)',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              key: const Key('saveOrderButton'),
              onPressed: _save,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Guardar pedido'),
            ),
          ],
        ),
      ),
    );
  }
}
