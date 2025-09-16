import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/address.dart';
import '../providers/locations_notifier.dart';
import '../providers/user_notifier.dart';
import '../widgets/app_scaffold.dart';

class AddressEditorScreen extends ConsumerStatefulWidget {
  const AddressEditorScreen({super.key, this.initial});
  final Address? initial;

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
  void initState() {
    super.initState();
    _country = 'Colombia';
    final a = widget.initial;
    if (a != null) {
      _country = a.country;
      _department = a.department;
      _municipality = a.municipality;
      _line1.text = a.line1;
      if (a.line2 != null) _line2.text = a.line2!;
    }
  }

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

    return AppScaffold(
      title: widget.initial == null ? 'Agregar dirección' : 'Editar dirección',
      actions: [
        IconButton(
          tooltip: 'Refrescar ubicaciones',
          icon: const Icon(Icons.refresh),
          onPressed: () {
            ref.invalidate(locationsRepositoryProvider);
            ref.invalidate(countriesProvider);
            if (_country != null) {
              ref.invalidate(departmentsProvider(_country!));
            }
            if (_country != null && _department != null) {
              ref.invalidate(municipalitiesProvider((_country!, _department!)));
            }
          },
        ),
      ],
      child: Form(
        key: _formKey,
        child: Column(
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
              decoration: const InputDecoration(
                labelText: 'Dirección (línea 1)',
                hintText: 'Cra 7 # 12-34',
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Ingresa la dirección'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _line2,
              decoration: const InputDecoration(
                labelText: 'Complemento (opcional)',
                hintText: 'Apto 502, Torre B',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.save),
                label: Text(
                  widget.initial == null
                      ? 'Guardar dirección'
                      : 'Guardar cambios',
                ),
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  final addr = Address(
                    id: widget.initial?.id ??
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    line1: _line1.text.trim(),
                    line2:
                        _line2.text.trim().isEmpty ? null : _line2.text.trim(),
                    country: _country!,
                    department: _department!,
                    municipality: _municipality!,
                  );
                  ref.read(userProvider.notifier).addOrUpdateAddress(addr);
                  context.go('/summary');
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.list_alt),
                label: const Text('Ver resumen'),
                onPressed: () => context.go('/summary'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
