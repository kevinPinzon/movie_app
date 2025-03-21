import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/core/services/network/network_info.dart';
import 'package:movie_app/core/services/network/server_api_client.dart';
import 'package:movie_app/core/database/movie_database.dart';
import 'package:movie_app/core/services/theme_storage_service.dart';
import 'package:movie_app/core/services/movie/movie_remote_service.dart';
import 'package:movie_app/core/services/movie/movie_local_service.dart';
import 'package:movie_app/feature/movies/data/repositories/movie_repository_impl.dart';
import 'package:movie_app/feature/movies/domain/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/presentation/blocs/movie_bloc.dart';
import 'package:movie_app/feature/theme/presentation/bloc/theme_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> initDependencies() async {
  final movieDatabase = MovieDatabase();
  await movieDatabase.init();

  final themeStorageService = await ThemeStorageService.init();

  final networkInfoRepository = NetworkInfoRepositoryImpl();

  getIt
    ..registerLazySingleton(() => themeStorageService)
    ..registerLazySingleton(() => http.Client())
    ..registerLazySingleton<ServerApiClient>(() => ServerApiClient())
    ..registerLazySingleton<MovieDatabase>(() => movieDatabase)
    ..registerLazySingleton<NetworkInfoRepository>(() => networkInfoRepository)

    // Registrar los servicios para interactuar con los datos (API y Base de datos)
    ..registerLazySingleton(() => MovieRemoteService(serverApiClient: getIt()))
    ..registerLazySingleton(() => MovieLocalService(movieDatabase: getIt()))

    // Registrar el repositorio que coordina entre los servicios locales y remotos
    ..registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(
          movieLocalService: getIt(),
          movieRemoteService: getIt(),
          networkInfoRepository: getIt(),
        ))
    ..registerFactory(() => MovieBloc(
          movieRepository: getIt(),
        ))
    ..registerFactory(() => ThemeBloc(getIt()));
}
