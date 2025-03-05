part of 'movie_bloc.dart';

abstract class MovieState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<MovieEntity> movies;

  MovieLoaded({required this.movies});

  @override
  List<Object?> get props => [movies];
}

class MovieError extends MovieState {
  final String message;

  MovieError({required this.message});

  @override
  List<Object?> get props => [message];
}
