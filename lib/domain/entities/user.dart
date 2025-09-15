import 'address.dart';

class NyxUser {
  final String firstName;
  final String lastName;
  final DateTime? birthDate;
  final List<Address> addresses;

  NyxUser({
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.addresses,
  });

  NyxUser copyWith({
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    List<Address>? addresses,
  }) {
    return NyxUser(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      addresses: addresses ?? this.addresses,
    );
  }

  static NyxUser empty() => NyxUser(
        firstName: '',
        lastName: '',
        birthDate: null,
        addresses: const [],
      );
}
