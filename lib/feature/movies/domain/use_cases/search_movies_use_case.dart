import 'package:movie_app/feature/movies/domain/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/domain/entities/movie_entity.dart';

class SearchMoviesUseCase {
  final MovieRepository movieRepository;

  SearchMoviesUseCase({required this.movieRepository});

  Future<List<MovieEntity>> execute(String query) async {
    return await movieRepository.searchMoviesByTitle(query);
  }
}
