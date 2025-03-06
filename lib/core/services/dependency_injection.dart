import 'package:get_it/get_it.dart';
import 'package:movie_app/core/network/network_info.dart';
import 'package:movie_app/core/network/server_api_client.dart';
import 'package:movie_app/core/database/movie_database.dart';
import 'package:movie_app/core/services/theme_storage_service.dart';
import 'package:movie_app/feature/movies/data/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/domain/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/presentation/blocs/movie_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/feature/theme/presentation/bloc/theme_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> initDependencies() async {
  final themeStorageService = await ThemeStorageService.init();
  final networkInfoRepository = NetworkInfoRepositoryImpl();

  getIt
    ..registerLazySingleton(() => ThemeBloc(themeStorageService))
    ..registerLazySingleton(() => http.Client())
    ..registerLazySingleton<ServerApiClient>(() => ServerApiClient())
    ..registerLazySingleton<MovieDatabase>(() => MovieDatabase())
    ..registerLazySingleton<NetworkInfoRepository>(() => networkInfoRepository)
    ..registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(
          serverApiClient: getIt(),
          movieDatabase: getIt(),
          networkInfoRepository: getIt(),
        ))
    ..registerFactory(() => MovieBloc(
          movieRepository: getIt(),
          networkInfoRepository: getIt(),
        ));
}
