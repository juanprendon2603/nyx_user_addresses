import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nyx_user_addresses/domain/entities/user.dart';

import '../providers/user_notifier.dart';

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (users.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                'Aún no hay usuarios. Crea uno nuevo para empezar.',
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
            ),
          ...users.map(
            (u) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: cs.secondaryContainer,
                  child: Text(
                    _initials(u.firstName, u.lastName),
                    style: TextStyle(color: cs.onSecondaryContainer),
                  ),
                ),
                title: Text(
                  u.fullName.isEmpty ? 'Sin nombre' : u.fullName,
                ),
                subtitle: Text(
                  u.birthDate != null
                      ? 'Nació: ${u.birthDate!.toLocal().toString().split(' ').first}'
                      : 'Sin fecha de nacimiento',
                ),
                onTap: () {
                  ref.read(selectedUserIdProvider.notifier).state = u.id;
                  context.go('/summary');
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Eliminar usuario'),
                        content: Text(
                          '¿Eliminar a "${u.fullName.isEmpty ? 'Sin nombre' : u.fullName}"?',
                        ),
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
                      final sel = ref.read(selectedUserIdProvider);
                      if (sel == u.id) {
                        ref.read(selectedUserIdProvider.notifier).state = null;
                      }
                      ref.read(usersProvider.notifier).remove(u.id);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Nuevo usuario'),
        onPressed: () {
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          ref.read(usersProvider.notifier).add(NyxUser(id: id));
          ref.read(selectedUserIdProvider.notifier).state = id;
          context.go('/');
        },
      ),
    );
  }

  String _initials(String first, String last) {
    final f = first.trim().isNotEmpty ? first.trim()[0] : '';
    final l = last.trim().isNotEmpty ? last.trim()[0] : '';
    final s = (f + l).toUpperCase();
    return s.isEmpty ? 'U' : s;
  }
}
