import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/core/network/network_info.dart';
import 'package:movie_app/core/network/server_api_client.dart';
import 'package:movie_app/core/database/movie_database.dart';
import 'package:movie_app/core/services/theme_storage_service.dart';
import 'package:movie_app/core/services/movie_remote_service.dart';
import 'package:movie_app/core/services/movie_local_service.dart';
import 'package:movie_app/feature/movies/data/repositories/movie_repository_impl.dart';
import 'package:movie_app/feature/movies/domain/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/presentation/blocs/movie_bloc.dart';
import 'package:movie_app/feature/theme/presentation/bloc/theme_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Inicializar la base de datos y los servicios relacionados
  final movieDatabase = MovieDatabase();
  await movieDatabase.init();

  // Inicializar el servicio de almacenamiento de temas
  final themeStorageService = await ThemeStorageService.init();

  // Crear una instancia del repositorio de información de red
  final networkInfoRepository = NetworkInfoRepositoryImpl();

  // Registrar los servicios necesarios para la aplicación
  getIt
    ..registerLazySingleton(
        () => themeStorageService) // Tema (modo oscuro/claro)
    ..registerLazySingleton(() => http.Client()) // Cliente HTTP
    ..registerLazySingleton<ServerApiClient>(
        () => ServerApiClient()) // Cliente de la API
    ..registerLazySingleton<MovieDatabase>(
        () => movieDatabase) // Base de datos local
    ..registerLazySingleton<NetworkInfoRepository>(
        () => networkInfoRepository) // Información de la red

    // Registrar los servicios para interactuar con los datos (API y Base de datos)
    ..registerLazySingleton(() => MovieRemoteService(
        serverApiClient: getIt())) // Servicio remoto para la API
    ..registerLazySingleton(() => MovieLocalService(
        movieDatabase: getIt())) // Servicio local para la base de datos

    // Registrar el repositorio que coordina entre los servicios locales y remotos
    ..registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(
          movieLocalService: getIt(),
          movieRemoteService: getIt(),
        ))

    // Registrar los bloques necesarios
    ..registerFactory(() => MovieBloc(
          movieRepository: getIt(),
          networkInfoRepository: getIt(),
        ))
    ..registerFactory(() =>
        ThemeBloc(getIt())); // Bloque para gestionar el tema de la aplicación
}
