import 'package:movie_app/feature/movies/domain/entities/movie_entity.dart';

abstract class MovieRepository {
  Future<List<MovieEntity>> fetchMovies(int page);
  Future<List<MovieEntity>> searchMoviesByTitle(String query);
  Future<void> saveMovies(List<MovieEntity> movies);
  Future<List<MovieEntity>> getMoviesFromLocal();
  Future<MovieEntity> fetchMovieDetail(int movieId);
  Future<MovieEntity?> getMovieById(int movieId);
}
