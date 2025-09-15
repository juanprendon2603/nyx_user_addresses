import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/address.dart';
import '../providers/locations_notifier.dart';
import '../providers/user_notifier.dart';

class AddressEditorScreen extends ConsumerStatefulWidget {
  const AddressEditorScreen({super.key});

  @override
  ConsumerState<AddressEditorScreen> createState() =>
      _AddressEditorScreenState();
}

class _AddressEditorScreenState extends ConsumerState<AddressEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _line1 = TextEditingController();
  final _line2 = TextEditingController();

  String? _country;
  String? _department;
  String? _municipality;

  @override
  void dispose() {
    _line1.dispose();
    _line2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final countriesAsync = ref.watch(countriesProvider);
    final depsAsync = ref.watch(departmentsProvider(_country ?? ''));
    final munAsync =
        ref.watch(municipalitiesProvider((_country ?? '', _department ?? '')));

    return Scaffold(
      appBar: AppBar(title: const Text('Agregar dirección')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            countriesAsync.when(
              data: (countries) => DropdownButtonFormField<String>(
                initialValue: _country,
                items: countries
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _country = v;
                    _department = null;
                    _municipality = null;
                  });
                },
                decoration: const InputDecoration(labelText: 'País'),
                validator: (v) => v == null ? 'Selecciona un país' : null,
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 12),
            if (_country != null)
              depsAsync.when(
                data: (deps) => DropdownButtonFormField<String>(
                  initialValue: _department,
                  items: deps
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      _department = v;
                      _municipality = null;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Departamento'),
                  validator: (v) =>
                      v == null ? 'Selecciona un departamento' : null,
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
              ),
            const SizedBox(height: 12),
            if (_department != null)
              munAsync.when(
                data: (muns) => DropdownButtonFormField<String>(
                  initialValue: _municipality,
                  items: muns
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (v) => setState(() => _municipality = v),
                  decoration: const InputDecoration(labelText: 'Municipio'),
                  validator: (v) =>
                      v == null ? 'Selecciona un municipio' : null,
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
              ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _line1,
              decoration:
                  const InputDecoration(labelText: 'Dirección (línea 1)'),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Ingresa la dirección'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _line2,
              decoration:
                  const InputDecoration(labelText: 'Complemento (opcional)'),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.add_location_alt_outlined),
              label: const Text('Guardar dirección'),
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                final addr = Address(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  line1: _line1.text.trim(),
                  line2: _line2.text.trim().isEmpty ? null : _line2.text.trim(),
                  country: _country!,
                  department: _department!,
                  municipality: _municipality!,
                );
                ref.read(userProvider.notifier).addOrUpdateAddress(addr);
                context.go('/summary');
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.list_alt),
        label: const Text('Ver resumen'),
        onPressed: () => context.go('/summary'),
      ),
    );
  }
}
