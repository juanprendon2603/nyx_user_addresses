import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nyx_user_addresses/presentation/screens/users_screen.dart';

import '../domain/entities/address.dart';
import '../presentation/screens/address_editor_screen.dart';
import '../presentation/screens/summary_screen.dart';
import '../presentation/screens/user_form_screen.dart';
import '../presentation/screens/welcome_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/welcome',
    routes: [
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (_, __) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'user-form',
        builder: (_, __) => const UserFormScreen(),
      ),
      GoRoute(
        path: '/address',
        name: 'address-editor',
        builder: (_, state) =>
            AddressEditorScreen(initial: state.extra as Address?),
      ),
      GoRoute(
        path: '/summary',
        name: 'summary',
        builder: (_, __) => const SummaryScreen(),
      ),
      GoRoute(
        path: '/users',
        builder: (context, state) => const UsersScreen(),
      ),
    ],
  );
});
