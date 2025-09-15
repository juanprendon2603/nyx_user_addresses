import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  NyxUser? _current;

  @override
  NyxUser? get current => _current;

  @override
  void save(NyxUser user) {
    _current = user;
  }

  @override
  void clear() {
    _current = null;
  }
}
