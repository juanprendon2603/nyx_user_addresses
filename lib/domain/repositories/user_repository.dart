import 'package:nyx_user_addresses/domain/entities/user.dart';

abstract class UserRepository {
  NyxUser? get current;
  void save(NyxUser user);
  void clear();
}
