import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/core/routes/navigation.dart';
import 'package:movie_app/feature/movies/data/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/domain/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/presentation/blocs/movie_bloc.dart';
import 'package:movie_app/core/network/server_api_client.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/core/network/network_info.dart';

final GetIt getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  getIt
    ..registerLazySingleton(() => http.Client())
    ..registerLazySingleton<NetworkInfoRepository>(
        () => NetworkInfoRepositoryImpl())
    ..registerLazySingleton<ServerApiClient>(
        () => ServerApiClient(networkInfoRepository: getIt()))
    ..registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(
          serverApiClient: getIt(),
          networkInfoRepository: getIt(),
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
          routerConfig: _appRouter.router,
        ),
      ),
    );
  }
}
