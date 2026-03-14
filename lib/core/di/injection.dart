import 'package:get_it/get_it.dart';
import 'package:what_to_wear_flutter/infrastructure/datasources/image_data_source.dart';
import 'package:what_to_wear_flutter/infrastructure/repositories/wardrobe_repository_impl.dart';
import 'package:what_to_wear_flutter/domain/repositories/wardrobe_repository.dart';
import 'package:what_to_wear_flutter/services/storage_service.dart';
import 'package:what_to_wear_flutter/services/weather_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // ═══════ Services ═══════
  final storageService = StorageService();
  await storageService.init();
  getIt.registerSingleton<StorageService>(storageService);

  final weatherService = WeatherService();
  getIt.registerSingleton<WeatherService>(weatherService);

  // ═══════ Data Sources ═══════
  getIt.registerSingleton<ImageDataSource>(ImageDataSource());

  // ═══════ Repositories (Either pattern) ═══════
  getIt.registerSingleton<WardrobeRepository>(
    WardrobeRepositoryImpl(
      getIt<StorageService>(),
      getIt<ImageDataSource>(),
    ),
  );
}
