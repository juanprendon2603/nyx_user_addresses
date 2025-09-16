import 'package:nyx_user_addresses/domain/repositories/locations_repository.dart';

class FakeLocationsRepository implements LocationsRepository {
  @override
  Future<List<String>> getCountries() async => ['Colombia'];

  @override
  Future<List<String>> getDepartments(String country) async {
    if (country != 'Colombia') return [];
    return ['Antioquia', 'Cundinamarca'];
  }

  @override
  Future<List<String>> getMunicipalities(
      String country, String department) async {
    if (country != 'Colombia') return [];
    if (department == 'Antioquia') return ['Medellín', 'Rionegro'];
    if (department == 'Cundinamarca') return ['Bogotá', 'Chía'];
    return [];
  }
}
