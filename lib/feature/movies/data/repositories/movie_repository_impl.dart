import 'package:movie_app/core/services/movie_local_service.dart';
import 'package:movie_app/core/services/movie_remote_service.dart';
import 'package:movie_app/feature/movies/domain/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/domain/entities/movie_entity.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieLocalService movieLocalService;
  final MovieRemoteService movieRemoteService;

  MovieRepositoryImpl({
    required this.movieLocalService,
    required this.movieRemoteService,
  });

  @override
  Future<List<MovieEntity>> fetchMovies(int page) async {
    try {
      // Primero intentamos obtener las películas desde la API remota
      final movies = await movieRemoteService.fetchMovies(page);
      // Guardamos las películas en la base de datos local
      await movieLocalService.saveMovies(movies);
      return movies;
    } catch (e) {
      // Si la API falla, obtenemos las películas desde la base de datos local
      return await movieLocalService.getMoviesFromLocal();
    }
  }

  @override
  Future<MovieEntity> fetchMovieDetail(int movieId) async {
    try {
      // Intentamos obtener los detalles desde la API remota
      return await movieRemoteService.fetchMovieDetail(movieId);
    } catch (e) {
      // Si la API falla, obtenemos los detalles desde la base de datos local
      final movie = await movieLocalService.getMovieById(movieId);
      if (movie != null) {
        return movie;
      } else {
        throw Exception("Failed to load movie detail from local storage");
      }
    }
  }

  @override
  Future<List<MovieEntity>> searchMoviesByTitle(String query) async {
    final movies = await movieLocalService.getMoviesFromLocal();
    return movies.where((movie) {
      return movie.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Future<void> saveMovies(List<MovieEntity> movies) async {
    await movieLocalService.saveMovies(movies);
  }

  @override
  Future<List<MovieEntity>> getMoviesFromLocal() async {
    return await movieLocalService.getMoviesFromLocal();
  }

  @override
  Future<MovieEntity?> getMovieById(int movieId) async {
    return await movieLocalService.getMovieById(movieId);
  }
}
