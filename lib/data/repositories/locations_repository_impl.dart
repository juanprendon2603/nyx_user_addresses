import '../../domain/repositories/locations_repository.dart';
import '../datasources/locations_asset_datasource.dart';

class LocationsRepositoryImpl implements LocationsRepository {
  final LocationsAssetDataSource ds;
  LocationsRepositoryImpl(this.ds);

  @override
  Future<List<String>> getCountries() => ds.countries();

  @override
  Future<List<String>> getDepartments(String country) =>
      ds.departments(country);

  @override
  Future<List<String>> getMunicipalities(String country, String department) =>
      ds.municipalities(country, department);
}
