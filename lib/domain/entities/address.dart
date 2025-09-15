class Address {
  final String id;
  final String line1;
  final String? line2;
  final String country;
  final String department;
  final String municipality;

  Address({
    required this.id,
    required this.line1,
    this.line2,
    required this.country,
    required this.department,
    required this.municipality,
  });

  Address copyWith({
    String? id,
    String? line1,
    String? line2,
    String? country,
    String? department,
    String? municipality,
  }) {
    return Address(
      id: id ?? this.id,
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      country: country ?? this.country,
      department: department ?? this.department,
      municipality: municipality ?? this.municipality,
    );
  }
}
