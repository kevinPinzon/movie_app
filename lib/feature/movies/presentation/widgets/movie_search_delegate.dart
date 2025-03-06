import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/feature/movies/presentation/blocs/movie_bloc.dart';
import 'package:movie_app/feature/movies/presentation/widgets/empty_state.dart';
import 'package:movie_app/feature/movies/presentation/widgets/movie_item.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Search Movies';

  @override
  TextInputType get keyboardType => TextInputType.text;

  InputDecorationTheme? getSearchFieldDecorationTheme(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InputDecorationTheme(
      filled: true,
      fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black45),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final movieBloc = BlocProvider.of<MovieBloc>(context);
    movieBloc.add(SearchMovies(query: query));

    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        if (state is MovieLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MovieLoaded) {
          if (state.movies.isEmpty) {
            return const EmptyState(message: 'No Movies Found');
          }
          final movies = state.movies;
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = state.movies[index];
              return GestureDetector(
                onTap: () {
                  context.go('/movieList/movieDetail/${movie.id}');
                },
                child: MovieItem(movie: movie),
              );
            },
          );
        } else if (state is MovieError) {
          return Center(child: Text(state.message));
        }
        return const EmptyState(message: 'Start typing to search');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final movieBloc = BlocProvider.of<MovieBloc>(context);
    movieBloc.add(SearchMovies(query: query));

    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        if (state is MovieLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MovieLoaded) {
          if (state.movies.isEmpty) {
            movieBloc.add(FetchMovies());
            return const EmptyState(message: 'No Movies Found');
          }
          final movies = state.movies;
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = state.movies[index];
              return GestureDetector(
                onTap: () {
                  context.go('/movieList/movieDetail/${movie.id}');
                },
                child: MovieItem(movie: movie),
              );
            },
          );
        } else if (state is MovieError) {
          return Center(child: Text(state.message));
        }
        return const EmptyState(message: 'Start typing to search');
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }
}
