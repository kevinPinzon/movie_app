part of 'movie_bloc.dart';

abstract class MovieEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMovies extends MovieEvent {
  @override
  List<Object?> get props => [];
}

class LoadMoreMovies extends MovieEvent {}

class SearchMovies extends MovieEvent {
  final String query;

  SearchMovies({required this.query});

  @override
  List<Object?> get props => [query];
}

class FetchMovieDetail extends MovieEvent {
  final int movieId;

  FetchMovieDetail({required this.movieId});

  @override
  List<Object> get props => [movieId];
}
