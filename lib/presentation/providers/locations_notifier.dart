import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/locations_asset_datasource.dart';
import '../../data/repositories/locations_repository_impl.dart';
import '../../domain/repositories/locations_repository.dart';

final locationsRepositoryProvider = Provider<LocationsRepository>((_) {
  return LocationsRepositoryImpl(LocationsAssetDataSource());
});

final countriesProvider = FutureProvider<List<String>>((ref) {
  return ref.watch(locationsRepositoryProvider).getCountries();
});

final departmentsProvider =
    FutureProvider.family<List<String>, String>((ref, country) {
  return ref.watch(locationsRepositoryProvider).getDepartments(country);
});

final municipalitiesProvider =
    FutureProvider.family<List<String>, (String, String)>((ref, key) {
  final (country, department) = key;
  return ref
      .watch(locationsRepositoryProvider)
      .getMunicipalities(country, department);
});
