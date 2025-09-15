import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/validators.dart';
import '../providers/user_notifier.dart';

class UserFormScreen extends ConsumerStatefulWidget {
  const UserFormScreen({super.key});

  @override
  ConsumerState<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends ConsumerState<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstCtrl = TextEditingController();
  final _lastCtrl = TextEditingController();
  DateTime? _dob;

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    _firstCtrl.text = user.firstName;
    _lastCtrl.text = user.lastName;

    return Scaffold(
      appBar: AppBar(title: const Text('Crear Usuario')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _firstCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (v) => Validators.requiredText(v, field: 'Nombre'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lastCtrl,
              decoration: const InputDecoration(labelText: 'Apellido'),
              validator: (v) => Validators.requiredText(v, field: 'Apellido'),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Fecha de nacimiento'),
              subtitle: Text(
                _dob != null
                    ? _dob!.toLocal().toString().split(' ').first
                    : 'Sin seleccionar',
              ),
              trailing: ElevatedButton(
                onPressed: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(now.year, now.month, now.day),
                    initialDate: _dob ?? DateTime(now.year - 18),
                  );
                  if (picked != null) setState(() => _dob = picked);
                },
                child: const Text('Seleccionar'),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Guardar y agregar dirección'),
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                if (Validators.dateNotNull(_dob) != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Selecciona la fecha de nacimiento')),
                  );
                  return;
                }
                ref.read(userProvider.notifier).setName(
                      first: _firstCtrl.text.trim(),
                      last: _lastCtrl.text.trim(),
                    );
                ref.read(userProvider.notifier).setBirthDate(_dob);
                context.go('/address');
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.go('/summary'),
              child: const Text('Ir al resumen'),
            ),
          ],
        ),
      ),
    );
  }
}
