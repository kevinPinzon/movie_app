import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        title: const Text('Movie List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: MovieSearchDelegate());
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => MovieBloc(
          movieRepository: RepositoryProvider.of<MovieRepository>(context),
        )..add(
            FetchMovies()), // Llamar a fetchMovies que manejará la carga desde API o desde la DB
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
                    return MovieItem(movie: movie);
                  }
                },
              );
            } else if (state is MovieError) {
              return Center(child: Text(state.message));
            }
            return const EmptyState();
          },
        ),
      ),
    );
  }
}
