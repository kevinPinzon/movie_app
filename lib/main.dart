import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/core/network/network_info.dart';
import 'package:movie_app/core/routes/navigation.dart';
import 'package:movie_app/core/services/theme_storage_service.dart';
import 'package:movie_app/core/theme/theme.dart';
import 'package:movie_app/feature/movies/data/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/domain/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/presentation/blocs/movie_bloc.dart';
import 'package:movie_app/core/network/server_api_client.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/core/database/movie_database.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:movie_app/feature/theme/presentation/bloc/theme_bloc.dart';
import 'firebase_options.dart';

final GetIt getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/.env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final movieDatabase = MovieDatabase();
  await movieDatabase.init();

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

  runApp(App());
}

class App extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (context) => getIt<ThemeBloc>(),
      child: RepositoryProvider<MovieRepository>(
        create: (context) => getIt<MovieRepository>(),
        child: BlocProvider<MovieBloc>(
          create: (context) => getIt<MovieBloc>(),
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                routerConfig: _appRouter.router,
              );
            },
          ),
        ),
      ),
    );
  }
}
