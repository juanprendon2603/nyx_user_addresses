import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/address.dart';
import '../../domain/entities/user.dart';

class UsersNotifier extends StateNotifier<List<NyxUser>> {
  UsersNotifier() : super(const []);

  void add(NyxUser user) => state = [...state, user];

  void update(NyxUser user) => state = [
        for (final u in state)
          if (u.id == user.id) user else u
      ];

  void remove(String id) => state = [
        for (final u in state)
          if (u.id != id) u
      ];
}

final usersProvider =
    StateNotifierProvider<UsersNotifier, List<NyxUser>>((ref) {
  return UsersNotifier();
});

final selectedUserIdProvider = StateProvider<String?>((_) => null);

NyxUser? _byId(String? id, List<NyxUser> list) {
  if (id == null) return null;
  for (final u in list) {
    if (u.id == id) return u;
  }
  return null;
}

final selectedUserProvider = Provider<NyxUser?>((ref) {
  final id = ref.watch(selectedUserIdProvider);
  final users = ref.watch(usersProvider);
  return _byId(id, users);
});

final userProvider = StateNotifierProvider<UserController, NyxUser>((ref) {
  return UserController(ref);
});

class UserController extends StateNotifier<NyxUser> {
  UserController(this.ref) : super(NyxUser.empty()) {
    ref.listen<String?>(selectedUserIdProvider, (_, __) => _sync());
    ref.listen<List<NyxUser>>(usersProvider, (_, __) => _sync());
    _sync();
  }

  final Ref ref;

  void _sync() {
    final id = ref.read(selectedUserIdProvider);
    final users = ref.read(usersProvider);
    state = _byId(id, users) ?? NyxUser.empty();
  }

  String _ensureSelected() {
    var id = ref.read(selectedUserIdProvider);
    if (id == null) {
      id = DateTime.now().millisecondsSinceEpoch.toString();
      ref.read(selectedUserIdProvider.notifier).state = id;
      ref.read(usersProvider.notifier).add(NyxUser(id: id));
    }
    return id;
  }

  void setName({required String first, required String last}) {
    final id = _ensureSelected();
    final current = _byId(id, ref.read(usersProvider)) ?? NyxUser(id: id);
    ref.read(usersProvider.notifier).update(
          current.copyWith(firstName: first, lastName: last),
        );
  }

  void setBirthDate(DateTime? dob) {
    final id = _ensureSelected();
    final current = _byId(id, ref.read(usersProvider)) ?? NyxUser(id: id);
    ref.read(usersProvider.notifier).update(
          current.copyWith(birthDate: dob),
        );
  }

  void addOrUpdateAddress(Address addr) {
    final id = _ensureSelected();
    final current = _byId(id, ref.read(usersProvider)) ?? NyxUser(id: id);
    final list = [...current.addresses];
    final i = list.indexWhere((a) => a.id == addr.id);
    if (i == -1) {
      list.add(addr);
    } else {
      list[i] = addr;
    }
    ref.read(usersProvider.notifier).update(
          current.copyWith(addresses: list),
        );
  }

  void removeAddress(String addressId) {
    final id = ref.read(selectedUserIdProvider);
    if (id == null) return;
    final current = _byId(id, ref.read(usersProvider));
    if (current == null) return;
    final list = current.addresses.where((a) => a.id != addressId).toList();
    ref.read(usersProvider.notifier).update(
          current.copyWith(addresses: list),
        );
  }

  void reset() {
    final id = ref.read(selectedUserIdProvider);
    if (id == null) return;
    ref.read(usersProvider.notifier).update(NyxUser(id: id));
  }
}
