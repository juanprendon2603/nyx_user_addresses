import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

final userRepositoryProvider =
    Provider<UserRepository>((_) => UserRepositoryImpl());

final userProvider = StateNotifierProvider<UserNotifier, NyxUser>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return UserNotifier(repo);
});

class UserNotifier extends StateNotifier<NyxUser> {
  final UserRepository _repo;
  UserNotifier(this._repo) : super(_repo.current ?? NyxUser.empty());

  void setName({required String first, required String last}) {
    state = state.copyWith(firstName: first, lastName: last);
    _repo.save(state);
  }

  void setBirthDate(DateTime? date) {
    state = state.copyWith(birthDate: date);
    _repo.save(state);
  }

  void addOrUpdateAddress(Address addr) {
    final list = [...state.addresses];
    final idx = list.indexWhere((a) => a.id == addr.id);
    if (idx == -1) {
      list.add(addr);
    } else {
      list[idx] = addr;
    }
    state = state.copyWith(addresses: list);
    _repo.save(state);
  }

  void removeAddress(String id) {
    final list = state.addresses.where((a) => a.id != id).toList();
    state = state.copyWith(addresses: list);
    _repo.save(state);
  }

  void reset() {
    state = NyxUser.empty();
    _repo.clear();
  }
}
