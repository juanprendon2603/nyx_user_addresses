import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/validators.dart';
import '../providers/user_notifier.dart';
import '../widgets/app_scaffold.dart';

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
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _firstCtrl.text = user.firstName;
    _lastCtrl.text = user.lastName;
    _dob = user.birthDate;
  }

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AppScaffold(
      title: 'Crear Usuario',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _firstCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Tu nombre',
              ),
              validator: (v) => Validators.requiredText(v, field: 'Nombre'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lastCtrl,
              decoration: const InputDecoration(
                labelText: 'Apellido',
                hintText: 'Tu apellido',
              ),
              validator: (v) => Validators.requiredText(v, field: 'Apellido'),
              textInputAction: TextInputAction.done,
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
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Guardar y agregar dirección'),
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  if (Validators.dateNotNull(_dob) != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Selecciona la fecha de nacimiento'),
                      ),
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
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.go('/summary'),
                child: const Text('Ir al resumen'),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tus datos se guardan en memoria para esta sesión.',
              style: TextStyle(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
