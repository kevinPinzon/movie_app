import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/core/routes/navigation.dart';
import 'package:movie_app/core/theme/theme.dart';
import 'package:movie_app/feature/movies/data/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/domain/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/presentation/blocs/movie_bloc.dart';
import 'package:movie_app/core/network/server_api_client.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/core/database/movie_database.dart';

final GetIt getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/.env");

  final movieDatabase = MovieDatabase();
  await movieDatabase.init();

  getIt
    ..registerLazySingleton(() => http.Client())
    ..registerLazySingleton<ServerApiClient>(() => ServerApiClient())
    ..registerLazySingleton<MovieDatabase>(() => MovieDatabase())
    ..registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(
          serverApiClient: getIt(),
          movieDatabase: getIt(),
        ))
    ..registerFactory(() => MovieBloc(movieRepository: getIt()));

  runApp(App());
}

class App extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<MovieRepository>(
      create: (context) => getIt<MovieRepository>(),
      child: BlocProvider(
        create: (context) => MovieBloc(
          movieRepository: RepositoryProvider.of<MovieRepository>(context),
        ),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeData(),
          routerConfig: _appRouter.router,
        ),
      ),
    );
  }
}
