import 'package:flutter/material.dart';

import '../../models/contact.dart';

class ContactFormScreen extends StatefulWidget {
  const ContactFormScreen({super.key});

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _position = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();

  @override
  void dispose() {
    for (final controller in [_name, _position, _phone, _email]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      Contact(
        name: _name.text.trim(),
        position: _position.text.trim(),
        phone: _phone.text.trim(),
        email: _email.text.trim(),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Campo obligatorio' : null,
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Nuevo contacto')),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _field(_name, 'Nombre'),
          _field(_position, 'Puesto/área'),
          _field(_phone, 'Teléfono', keyboardType: TextInputType.phone),
          _field(_email, 'Correo', keyboardType: TextInputType.emailAddress),
          FilledButton(onPressed: _save, child: const Text('Guardar contacto')),
        ],
      ),
    ),
  );
}
