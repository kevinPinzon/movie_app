import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_app/feature/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/feature/movies/domain/repositories/movie_repository.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository movieRepository;
  int currentPage = 1;
  bool hasMoreMovies = true;

  MovieBloc({required this.movieRepository}) : super(MovieInitial()) {
    on<FetchMovies>((event, emit) async {
      if (state is MovieLoading) return;

      emit(MovieLoading());

      try {
        final movies = await movieRepository.fetchMovies(currentPage);

        if (movies.isNotEmpty) {
          currentPage++;
        } else {
          hasMoreMovies = false;
        }

        emit(MovieLoaded(movies: movies));
      } catch (e) {
        emit(MovieError(message: e.toString()));
      }
    });

    on<LoadMoreMovies>((event, emit) async {
      if (hasMoreMovies) {
        try {
          final currentMovies = (state as MovieLoaded).movies;
          final moreMovies = await movieRepository.fetchMovies(currentPage);

          if (moreMovies.isNotEmpty) {
            currentPage++;
          } else {
            hasMoreMovies = false;
          }

          emit(MovieLoaded(movies: currentMovies + moreMovies));
        } catch (e) {
          emit(MovieError(message: e.toString()));
        }
      }
    });

    on<SearchMovies>((event, emit) {
      final filteredMovies = movieRepository.searchMoviesByTitle(event.query);
      emit(MovieLoaded(movies: filteredMovies));
    });
  }
}
