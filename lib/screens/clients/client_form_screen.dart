import 'package:flutter/material.dart';

import '../../models/client.dart';
import '../../models/contact.dart';
import '../../models/reception_day.dart';
import 'widgets/reception_schedule_editor.dart';

class ClientFormScreen extends StatefulWidget {
  const ClientFormScreen({this.client, super.key});

  final Client? client;

  @override
  State<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commercialName = TextEditingController();
  final _businessName = TextEditingController();
  final _state = TextEditingController();
  final _municipality = TextEditingController();
  final _address = TextEditingController();
  final _contactName = TextEditingController();
  final _position = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _discount = TextEditingController(text: '0');
  final _notes = TextEditingController();
  bool _hasCredit = false;
  late final List<ReceptionDay> _initialSchedule;
  late List<ReceptionDay> _schedule;

  @override
  void initState() {
    super.initState();
    final client = widget.client;
    _commercialName.text = client?.commercialName ?? '';
    _businessName.text = client?.businessName ?? '';
    _state.text = client?.state ?? '';
    _municipality.text = client?.municipality ?? '';
    _address.text = client?.address ?? '';
    _discount.text = client?.discount.toString() ?? '0';
    _notes.text = client?.notes ?? '';
    _hasCredit = client?.hasCredit ?? false;
    _initialSchedule =
        client?.receptionSchedule ?? ReceptionDay.undefinedWeek();
    _schedule = _initialSchedule;
  }

  @override
  void dispose() {
    for (final controller in [
      _commercialName,
      _businessName,
      _state,
      _municipality,
      _address,
      _contactName,
      _position,
      _phone,
      _email,
      _discount,
      _notes,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Campo obligatorio' : null;

  String? _validateDiscount(String? value) {
    final number = double.tryParse(value?.trim() ?? '');
    return number == null || !number.isFinite || number < 0 || number > 100
        ? 'Ingresa un valor entre 0 y 100'
        : null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final existing = widget.client;
    if (existing != null) {
      Navigator.of(context).pop(
        existing.copyWith(
          commercialName: _commercialName.text.trim(),
          businessName: _businessName.text.trim(),
          state: _state.text.trim(),
          municipality: _municipality.text.trim(),
          address: _address.text.trim(),
          discount: double.parse(_discount.text.trim()),
          hasCredit: _hasCredit,
          notes: _notes.text.trim(),
          receptionSchedule: _schedule,
        ),
      );
      return;
    }
    Navigator.of(context).pop(
      Client(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        commercialName: _commercialName.text.trim(),
        businessName: _businessName.text.trim(),
        state: _state.text.trim(),
        municipality: _municipality.text.trim(),
        address: _address.text.trim(),
        discount: double.parse(_discount.text.trim()),
        hasCredit: _hasCredit,
        notes: _notes.text.trim(),
        receptionSchedule: _schedule,
        contacts: [
          Contact(
            name: _contactName.text.trim(),
            position: _position.text.trim(),
            phone: _phone.text.trim(),
            email: _email.text.trim(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.client == null ? 'Nuevo cliente' : 'Editar cliente'),
      ),
      body: Form(
        key: _formKey,
        // Formulario acotado: mantener campos y borrador semanal montados
        // permite validar todos sus valores aunque estén fuera de pantalla.
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _heading('Datos generales'),
              _field(_commercialName, 'Nombre comercial'),
              _field(_businessName, 'Razón social'),
              _field(_state, 'Estado'),
              _field(_municipality, 'Municipio'),
              _field(_address, 'Dirección', maxLines: 2),
              if (widget.client == null) ...[
                _heading('Primer contacto'),
                _field(_contactName, 'Nombre de contacto'),
                _field(_position, 'Puesto/área'),
                _field(_phone, 'Teléfono', keyboardType: TextInputType.phone),
                _field(
                  _email,
                  'Correo',
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
              _heading('Condiciones comerciales'),
              _field(
                _discount,
                'Descuento (%)',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: _validateDiscount,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Tiene crédito'),
                value: _hasCredit,
                onChanged: (value) => setState(() => _hasCredit = value),
              ),
              _field(_notes, 'Observaciones', maxLines: 3, isRequired: false),
              _heading('Horario de recepción de entregas'),
              ReceptionScheduleEditor(
                initialSchedule: _initialSchedule,
                onChanged: (schedule) => _schedule = schedule,
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Guardar cliente'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heading(String text) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 12),
    child: Text(text, style: Theme.of(context).textTheme.titleLarge),
  );

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool isRequired = true,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator ?? (isRequired ? _required : null),
    ),
  );
}
