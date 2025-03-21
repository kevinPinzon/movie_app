import 'package:movie_app/feature/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/core/database/movie_database.dart';

/// Servicio que maneja la interacción con la base de datos SQLite para las películas.
class MovieLocalService {
  final MovieDatabase movieDatabase;

  /// Constructor del servicio que recibe la dependencia de `MovieDatabase`.
  MovieLocalService({required this.movieDatabase});

  /// Obtiene todas las películas almacenadas localmente en la base de datos.
  Future<List<MovieEntity>> getMoviesFromLocal() async {
    return await movieDatabase.getMovies();
  }

  /// Guarda una lista de películas en la base de datos local.
  Future<void> saveMovies(List<MovieEntity> movies) async {
    await movieDatabase.insertMovies(movies);
  }

  /// Obtiene una película específica de la base de datos usando su ID.
  Future<MovieEntity?> getMovieById(int movieId) async {
    return await movieDatabase.getMovieById(movieId);
  }
}
