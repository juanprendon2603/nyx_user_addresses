import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nyx_user_addresses/presentation/screens/user_form_screen.dart';

void main() {
  testWidgets('UserFormScreen muestra SnackBar si falta fecha', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => const UserFormScreen()),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nombre'),
      'Ana',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Apellido'),
      'García',
    );

    await tester.tap(find.text('Guardar y agregar dirección'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Selecciona la fecha de nacimiento'), findsOneWidget);
  });
}
