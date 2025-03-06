import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_app/core/network/network_info.dart';
import 'package:movie_app/feature/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/feature/movies/domain/repositories/movie_repository.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository movieRepository;
  int currentPage = 1;
  bool hasMoreMovies = true;
  final NetworkInfoRepository networkInfoRepository;

  MovieBloc(
      {required this.movieRepository, required this.networkInfoRepository})
      : super(MovieInitial()) {
    on<FetchMovies>((event, emit) async {
      emit(MovieLoading());

      final isConnected = await networkInfoRepository.hasConnection;
      if (!isConnected) {
        final localMovies = await movieRepository.getMoviesFromLocal();
        if (localMovies.isNotEmpty) {
          emit(MovieLoaded(movies: localMovies));
        } else {
          emit(MovieError(message: 'No internet and no local data available.'));
        }
        return;
      }

      try {
        final movies = await movieRepository.fetchMovies(currentPage);
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

    on<SearchMovies>((event, emit) async {
      final filteredMovies =
          await movieRepository.searchMoviesByTitle(event.query);
      emit(MovieLoaded(movies: filteredMovies));
    });

    on<FetchMovieDetail>((event, emit) async {
      emit(MovieLoading());

      try {
        final isConnected = await networkInfoRepository.hasConnection;
        if (isConnected) {
          final movie = await movieRepository.fetchMovieDetail(event.movieId);
          emit(MovieDetailLoaded(movie: movie));
        } else {
          final movie = await movieRepository.getMovieById(event.movieId);
          if (movie != null) {
            emit(MovieDetailLoaded(movie: movie));
          } else {
            emit(MovieError(
                message: 'No internet and no local data available.'));
          }
        }
      } catch (e) {
        emit(MovieError(message: 'Failed to load movie details.'));
      }
    });
  }
}
