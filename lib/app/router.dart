import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/screens/address_editor_screen.dart';
import '../presentation/screens/summary_screen.dart';
import '../presentation/screens/user_form_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'user-form',
        builder: (_, __) => const UserFormScreen(),
      ),
      GoRoute(
        path: '/address',
        name: 'address-editor',
        builder: (_, __) => const AddressEditorScreen(),
      ),
      GoRoute(
        path: '/summary',
        name: 'summary',
        builder: (_, __) => const SummaryScreen(),
      ),
    ],
  );
});
