import 'package:flutter_test/flutter_test.dart';
import 'package:nyx_user_addresses/core/utils/validators.dart';

void main() {
  test('requiredText falla en vacío y pasa con texto', () {
    expect(Validators.requiredText(null, field: 'Nombre'), isNotNull);
    expect(Validators.requiredText('   ', field: 'Nombre'), isNotNull);
    expect(Validators.requiredText('Ana', field: 'Nombre'), isNull);
  });

  test('dateNotNull falla si null y pasa con fecha', () {
    expect(Validators.dateNotNull(null), isNotNull);
    expect(Validators.dateNotNull(DateTime(2000, 1, 1)), isNull);
  });
}
