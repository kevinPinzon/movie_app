import 'package:movie_app/core/network/network_info.dart';
import 'package:movie_app/core/services/movie_local_service.dart';
import 'package:movie_app/core/services/movie_remote_service.dart';
import 'package:movie_app/feature/movies/domain/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/domain/entities/movie_entity.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteService movieRemoteService;
  final MovieLocalService movieLocalService;
  final NetworkInfoRepository networkInfoRepository;

  MovieRepositoryImpl({
    required this.movieRemoteService,
    required this.movieLocalService,
    required this.networkInfoRepository,
  });

  @override
  Future<List<MovieEntity>> fetchMovies(int page) async {
    try {
      final isConnected = await networkInfoRepository.hasConnection;

      if (isConnected) {
        final movies = await movieRemoteService.fetchMovies(page);
        await movieLocalService.saveMovies(movies);
        return movies;
      } else {
        return await movieLocalService.getMoviesFromLocal();
      }
    } catch (e) {
      throw Exception("Failed to fetch movies: $e");
    }
  }

  @override
  Future<MovieEntity> fetchMovieDetail(int movieId) async {
    try {
      final isConnected = await networkInfoRepository.hasConnection;

      if (isConnected) {
        return await movieRemoteService.fetchMovieDetail(movieId);
      } else {
        final movie = await movieLocalService.getMovieById(movieId);
        if (movie != null) {
          return movie;
        } else {
          throw Exception("Movie not found locally");
        }
      }
    } catch (e) {
      throw Exception("Failed to fetch movie detail: $e");
    }
  }

  @override
  Future<List<MovieEntity>> searchMoviesByTitle(String query) async {
    try {
      final isConnected = await networkInfoRepository.hasConnection;

      if (isConnected) {
        final movies = await movieRemoteService.fetchMovies(1);
        return movies
            .where((movie) =>
                movie.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        final movies = await movieLocalService.getMoviesFromLocal();
        return movies
            .where((movie) =>
                movie.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    } catch (e) {
      throw Exception("Failed to search movies: $e");
    }
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
