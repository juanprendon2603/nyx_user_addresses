import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyx_user_addresses/domain/entities/address.dart';
import 'package:nyx_user_addresses/domain/entities/user.dart';
import 'package:nyx_user_addresses/presentation/providers/user_notifier.dart';

void main() {
  group('userProvider (usuario seleccionado)', () {
    test('setName y setBirthDate crean/actualizan el seleccionado', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(userProvider).id, '');

      final ctrl = container.read(userProvider.notifier);
      ctrl.setName(first: 'Ana', last: 'García');

      final selectedId = container.read(selectedUserIdProvider);
      expect(selectedId, isNotNull);
      expect(container.read(userProvider).firstName, 'Ana');
      expect(container.read(userProvider).lastName, 'García');

      ctrl.setBirthDate(DateTime(2000, 1, 1));
      expect(container.read(userProvider).birthDate, DateTime(2000, 1, 1));
    });

    test('addOrUpdateAddress y removeAddress', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final ctrl = container.read(userProvider.notifier);
      ctrl.setName(first: 'Ana', last: 'García');

      final a1 = Address(
        id: 'a1',
        line1: 'Calle 1 #2-3',
        country: 'Colombia',
        department: 'Antioquia',
        municipality: 'Medellín',
      );

      ctrl.addOrUpdateAddress(a1);
      expect(container.read(userProvider).addresses.length, 1);

      ctrl.addOrUpdateAddress(a1.copyWith(line2: 'Apto 101'));
      expect(container.read(userProvider).addresses.first.line2, 'Apto 101');

      ctrl.removeAddress('a1');
      expect(container.read(userProvider).addresses, isEmpty);
    });

    test('reset mantiene id pero limpia campos', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final ctrl = container.read(userProvider.notifier);
      ctrl.setName(first: 'Ana', last: 'García');
      final idAntes = container.read(selectedUserIdProvider);

      ctrl.reset();
      final u = container.read(userProvider);
      expect(container.read(selectedUserIdProvider), idAntes);
      expect(u.firstName, '');
      expect(u.lastName, '');
      expect(u.addresses, isEmpty);
    });
  });

  test('NyxUser.fullName', () {
    final u1 = NyxUser(id: '1', firstName: 'Ana', lastName: 'García');
    final u2 = NyxUser(id: '2', firstName: 'Ana');
    final u3 = NyxUser(id: '3', lastName: 'García');
    final u4 = NyxUser(id: '4');

    expect(u1.fullName, 'Ana García');
    expect(u2.fullName, 'Ana');
    expect(u3.fullName, 'García');
    expect(u4.fullName, '');
  });
}
