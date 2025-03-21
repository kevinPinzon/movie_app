import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/core/services/dependency_injection.dart';
import 'package:movie_app/feature/movies/domain/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/presentation/blocs/movie_bloc.dart';
import 'package:movie_app/feature/movies/presentation/widgets/empty_state.dart';
import 'package:movie_app/feature/movies/presentation/widgets/movie_item.dart';
import 'package:movie_app/feature/movies/presentation/widgets/movie_search_delegate.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movie List',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: MovieSearchDelegate());
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.go('/movieList/profile');
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => MovieBloc(
          movieRepository: RepositoryProvider.of<MovieRepository>(context),
        )..add(FetchMovies()),
        child: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieLoaded) {
              return ListView.builder(
                itemCount: state.movies.length + 1,
                itemBuilder: (context, index) {
                  if (index == state.movies.length) {
                    context.read<MovieBloc>().add(LoadMoreMovies());
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    final movie = state.movies[index];
                    return GestureDetector(
                      onTap: () {
                        context.go('/movieList/movieDetail/${movie.id}');
                      },
                      child: MovieItem(movie: movie),
                    );
                  }
                },
              );
            } else if (state is MovieError) {
              // Mostrar EmptyState si hay un error debido a la falta de conexión
              if (state.message == 'No internet and no local data available.') {
                return const EmptyState(
                  message:
                      'No internet and no local data available.\nPlease try again later.',
                );
              }
              return Center(child: Text(state.message));
            }
            return const EmptyState();
          },
        ),
      ),
    );
  }
}
