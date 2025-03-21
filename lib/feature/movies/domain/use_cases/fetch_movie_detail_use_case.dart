import 'package:movie_app/feature/movies/domain/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/domain/entities/movie_entity.dart';

class FetchMovieDetailUseCase {
  final MovieRepository movieRepository;

  FetchMovieDetailUseCase({required this.movieRepository});

  Future<MovieEntity> execute(int movieId) async {
    return await movieRepository.fetchMovieDetail(movieId);
  }
}
