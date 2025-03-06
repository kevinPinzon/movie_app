import 'package:go_router/go_router.dart';
import 'package:movie_app/feature/init/presentation/screens/welcome_screen.dart';
import 'package:movie_app/feature/movies/presentation/screens/movie_detail_screen.dart';
import 'package:movie_app/feature/movies/presentation/screens/movie_list_screen.dart';

class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
          path: '/movieList',
          builder: (context, state) => const MovieListScreen(),
          routes: [
            GoRoute(
              path: '/movieDetail/:movieId',
              builder: (context, state) {
                final movieId = int.parse(state.pathParameters['movieId']!);
                return MovieDetailScreen(movieId: movieId);
              },
            ),
          ]),
    ],
  );
}
