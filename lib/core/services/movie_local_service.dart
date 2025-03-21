import 'package:movie_app/feature/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/core/database/movie_database.dart';

class MovieLocalService {
  final MovieDatabase movieDatabase;

  MovieLocalService({required this.movieDatabase});

  Future<List<MovieEntity>> getMoviesFromLocal() async {
    return await movieDatabase.getMovies();
  }

  Future<void> saveMovies(List<MovieEntity> movies) async {
    await movieDatabase.insertMovies(movies);
  }

  Future<MovieEntity?> getMovieById(int movieId) async {
    return await movieDatabase.getMovieById(movieId);
  }
}
