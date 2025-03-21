import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/feature/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/feature/movies/domain/use_cases/movies_use_cases.dart';
part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final FetchMoviesUseCase fetchMoviesUseCase =
      GetIt.instance<FetchMoviesUseCase>();
  final FetchMovieDetailUseCase fetchMovieDetailUseCase =
      GetIt.instance<FetchMovieDetailUseCase>();
  final LoadMoreMoviesUseCase loadMoreMoviesUseCase =
      GetIt.instance<LoadMoreMoviesUseCase>();
  final SearchMoviesUseCase searchMoviesUseCase =
      GetIt.instance<SearchMoviesUseCase>();

  int currentPage = 1;
  bool hasMoreMovies = true;

  MovieBloc() : super(MovieInitial()) {
    on<FetchMovies>((event, emit) async {
      emit(MovieLoading());

      try {
        final movies = await fetchMoviesUseCase.execute(currentPage);

        if (movies.isNotEmpty) {
          currentPage++;
        } else {
          hasMoreMovies = false;
        }

        emit(MovieLoaded(movies: movies));
      } catch (e) {
        emit(MovieError(message: 'Failed to fetch movies: $e'));
      }
    });

    on<LoadMoreMovies>((event, emit) async {
      if (hasMoreMovies) {
        try {
          final currentMovies = (state as MovieLoaded).movies;
          final moreMovies = await loadMoreMoviesUseCase.execute(currentPage);

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

    on<SearchMovies>((event, emit) async {
      try {
        final filteredMovies = await searchMoviesUseCase.execute(event.query);
        emit(MovieLoaded(movies: filteredMovies));
      } catch (e) {
        emit(MovieError(message: 'Failed to search movies: $e'));
      }
    });

    on<FetchMovieDetail>((event, emit) async {
      emit(MovieLoading());

      try {
        final movie = await fetchMovieDetailUseCase.execute(event.movieId);
        emit(MovieDetailLoaded(movie: movie));
      } catch (e) {
        emit(MovieError(message: 'Failed to load movie details.'));
      }
    });
  }
}
