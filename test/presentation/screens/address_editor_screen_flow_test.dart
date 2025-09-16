import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nyx_user_addresses/domain/entities/user.dart';
import 'package:nyx_user_addresses/presentation/providers/locations_notifier.dart';
import 'package:nyx_user_addresses/presentation/providers/user_notifier.dart';
import 'package:nyx_user_addresses/presentation/screens/address_editor_screen.dart';

import '../../fakes/fake_locations_repository.dart';

void main() {
  testWidgets('AddressEditorScreen: selecciona depto/municipio y guarda',
      (tester) async {
    final router = GoRouter(
      initialLocation: '/address',
      routes: [
        GoRoute(
          path: '/address',
          builder: (context, state) => const AddressEditorScreen(),
        ),
        GoRoute(
          path: '/summary',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Summary OK'))),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          locationsRepositoryProvider
              .overrideWithValue(FakeLocationsRepository()),
          selectedUserIdProvider.overrideWith((ref) => 'u1'),
          usersProvider.overrideWith((ref) {
            return UsersNotifier()..add(NyxUser(id: 'u1'));
          }),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('País'), findsOneWidget);
    await tester.tap(find.byType(DropdownButtonFormField<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Colombia').last);
    await tester.pumpAndSettle();

    expect(find.text('Departamento'), findsOneWidget);
    await tester.tap(find.text('Departamento'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Antioquia').last);
    await tester.pumpAndSettle();

    expect(find.text('Municipio'), findsOneWidget);
    await tester.tap(find.text('Municipio'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Medellín').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'Calle 1 #2-3');

    await tester.tap(find.text('Guardar dirección'));
    await tester.pumpAndSettle();

    expect(find.text('Summary OK'), findsOneWidget);
  });
}
