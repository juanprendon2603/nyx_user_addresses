import 'address.dart';

class NyxUser {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime? birthDate;
  final List<Address> addresses;

  NyxUser({
    required this.id,
    this.firstName = '',
    this.lastName = '',
    this.birthDate,
    List<Address>? addresses,
  }) : addresses = addresses ?? const [];

  NyxUser copyWith({
    String? id,
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    List<Address>? addresses,
  }) {
    return NyxUser(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      addresses: addresses ?? this.addresses,
    );
  }

  String get fullName => '${firstName.trim()} ${lastName.trim()}'.trim();

  static NyxUser empty() => NyxUser(id: '');
}
