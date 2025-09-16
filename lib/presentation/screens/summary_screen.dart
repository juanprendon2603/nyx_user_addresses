import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/user_notifier.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/pressable.dart';

class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final cs = Theme.of(context).colorScheme;

    String fullName() {
      final s = '${user.firstName} ${user.lastName}'.trim();
      return s.isEmpty ? '—' : s;
    }

    return AppScaffold(
      title: 'Resumen',
      fallbackRoute: '/',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: cs.primaryContainer,
              child: Icon(Icons.person, color: cs.onPrimaryContainer),
            ),
            title: Text(fullName()),
            subtitle: Text(
              user.birthDate != null
                  ? 'Nacimiento: ${user.birthDate!.toLocal().toString().split(' ').first}'
                  : 'Nacimiento: —',
            ),
            trailing: OutlinedButton(
              onPressed: () => context.go('/'),
              child: const Text('Editar'),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Direcciones (${user.addresses.length})',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          if (user.addresses.isEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Aún no has agregado direcciones.',
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
            ),
          ...user.addresses.map(
            (a) => Pressable(
              onTap: () => context.go('/address', extra: a),
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: cs.secondaryContainer,
                    child: Icon(Icons.home_outlined,
                        color: cs.onSecondaryContainer),
                  ),
                  title: Text(a.line1),
                  subtitle: Text(
                    '${a.country} / ${a.department} / ${a.municipality}'
                    '${a.line2 != null ? '\n${a.line2}' : ''}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Eliminar dirección'),
                          content: Text('¿Eliminar "${a.line1}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancelar'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );
                      if (ok == true) {
                        ref.read(userProvider.notifier).removeAddress(a.id);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Agregar nueva dirección'),
              onPressed: () => context.go('/address'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reiniciar'),
              onPressed: () => ref.read(userProvider.notifier).reset(),
            ),
          ),
        ],
      ),
    );
  }
}
