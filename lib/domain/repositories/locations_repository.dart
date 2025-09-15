abstract class LocationsRepository {
  Future<List<String>> getCountries();
  Future<List<String>> getDepartments(String country);
  Future<List<String>> getMunicipalities(String country, String department);
}
