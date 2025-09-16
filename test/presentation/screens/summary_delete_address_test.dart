import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nyx_user_addresses/domain/entities/address.dart';
import 'package:nyx_user_addresses/domain/entities/user.dart';
import 'package:nyx_user_addresses/presentation/providers/user_notifier.dart';
import 'package:nyx_user_addresses/presentation/screens/summary_screen.dart';

void main() {
  testWidgets('SummaryScreen elimina una dirección tras confirmar',
      (tester) async {
    final seededUser = NyxUser(
      id: 'u1',
      firstName: 'Ana',
      lastName: 'García',
      birthDate: DateTime(2000, 1, 1),
      addresses: [
        Address(
          id: 'a1',
          line1: 'Calle 1 #2-3',
          country: 'Colombia',
          department: 'Antioquia',
          municipality: 'Medellín',
        ),
      ],
    );

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => const SummaryScreen()),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedUserIdProvider.overrideWith((ref) => 'u1'),
          usersProvider.overrideWith((ref) {
            return UsersNotifier()..add(seededUser);
          }),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    expect(find.text('Calle 1 #2-3'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline).first);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Eliminar'));
    await tester.pumpAndSettle();

    expect(find.text('Calle 1 #2-3'), findsNothing);

    expect(find.textContaining('Direcciones (0)'), findsOneWidget);
  });
}
