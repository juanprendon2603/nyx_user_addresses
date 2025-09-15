import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/user_notifier.dart';

class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Resumen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Usuario', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: Text('${user.firstName} ${user.lastName}'.trim().isEmpty
                  ? '—'
                  : '${user.firstName} ${user.lastName}'),
              subtitle: Text(user.birthDate != null
                  ? 'Nacimiento: ${user.birthDate!.toLocal().toString().split(' ').first}'
                  : 'Nacimiento: —'),
              trailing: OutlinedButton(
                onPressed: () => context.go('/'),
                child: const Text('Editar'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Direcciones (${user.addresses.length})',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (user.addresses.isEmpty)
            const Text('Aún no has agregado direcciones.'),
          ...user.addresses.map((a) => Card(
                child: ListTile(
                  title: Text(a.line1),
                  subtitle: Text(
                    '${a.country} / ${a.department} / ${a.municipality}'
                    '${a.line2 != null ? '\n${a.line2}' : ''}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () =>
                        ref.read(userProvider.notifier).removeAddress(a.id),
                  ),
                ),
              )),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Agregar nueva dirección'),
            onPressed: () => context.go('/address'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.restart_alt),
            label: const Text('Reiniciar'),
            onPressed: () => ref.read(userProvider.notifier).reset(),
          ),
        ],
      ),
    );
  }
}
