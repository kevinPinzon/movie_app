import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/routes/navigation.dart';
import 'package:movie_app/core/services/dependency_injection.dart';
import 'package:movie_app/core/services/firebase_service.dart';
import 'package:movie_app/core/theme/theme.dart';
import 'package:movie_app/feature/movies/domain/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/presentation/blocs/movie_bloc.dart';

import 'package:movie_app/feature/theme/presentation/bloc/theme_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase y variables de entorno
  await initFirebase();

  // Inicializar dependencias
  initDependencies();

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
