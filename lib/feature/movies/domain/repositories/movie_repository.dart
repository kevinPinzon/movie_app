import 'package:movie_app/feature/movies/domain/entities/movie_entity.dart';

abstract class MovieRepository {
  Future<List<MovieEntity>> fetchMovies();
}
