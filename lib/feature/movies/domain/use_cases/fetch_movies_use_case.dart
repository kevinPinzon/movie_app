import 'package:movie_app/feature/movies/domain/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/domain/entities/movie_entity.dart';

class FetchMoviesUseCase {
  final MovieRepository movieRepository;

  FetchMoviesUseCase({required this.movieRepository});

  Future<List<MovieEntity>> execute(int page) async {
    return await movieRepository.fetchMovies(page);
  }
}
