import 'package:movie_app/feature/movies/domain/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/domain/entities/movie_entity.dart';

class LoadMoreMoviesUseCase {
  final MovieRepository movieRepository;

  LoadMoreMoviesUseCase({required this.movieRepository});

  Future<List<MovieEntity>> execute(int page) async {
    return await movieRepository.fetchMovies(page);
  }
}
