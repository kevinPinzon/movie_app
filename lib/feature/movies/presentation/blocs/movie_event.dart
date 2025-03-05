part of 'movie_bloc.dart';

abstract class MovieEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMovies extends MovieEvent {
  @override
  List<Object?> get props => [];
}

class LoadMoreMovies extends MovieEvent {
  @override
  List<Object?> get props => [];
}
