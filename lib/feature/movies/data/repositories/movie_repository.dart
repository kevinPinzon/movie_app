import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/core/network/server_api_client.dart';
import 'package:movie_app/feature/movies/domain/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/core/database/movie_database.dart';

class MovieRepositoryImpl implements MovieRepository {
  final ServerApiClient serverApiClient;
  final MovieDatabase movieDatabase;

  MovieRepositoryImpl({
    required this.serverApiClient,
    required this.movieDatabase,
  });

  Future<void> initializeDatabase() async {
    await movieDatabase.init();
  }

  @override
  Future<List<MovieEntity>> fetchMovies(int page) async {
    await initializeDatabase();
    const path = '/3/discover/movie';
    final queryParameters = {'page': page.toString()};

    try {
      final authToken = dotenv.env['AUTH_TOKEN'] ?? '';
      final headers = <String, String>{
        'accept': 'application/json',
      };
      headers['Authorization'] = 'Bearer $authToken';

      final response = await serverApiClient.get(
        path,
        queryParameters: queryParameters,
        headers: headers,
      );

      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      List<MovieEntity> movieEntities = results
          .map((movieJson) => MovieEntity(
                id: movieJson['id'],
                title: movieJson['title'],
                overview: movieJson['overview'],
                releaseDate: movieJson['release_date'],
                posterPath: movieJson['poster_path'],
                voteAverage: movieJson['vote_average'].toDouble(),
                genres: [],
              ))
          .toList();

      await movieDatabase.insertMovies(movieEntities);
      return movieEntities;
    } catch (e) {
      return await movieDatabase.getMovies();
    }
  }

  @override
  Future<List<MovieEntity>> searchMoviesByTitle(String query) async {
    return movieDatabase.getMovies().then((movies) {
      return movies.where((movie) {
        return movie.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Future<void> saveMovies(List<MovieEntity> movies) async {
    await movieDatabase.insertMovies(movies);
  }

  @override
  Future<List<MovieEntity>> getMoviesFromLocal() async {
    await initializeDatabase();
    return await movieDatabase.getMovies();
  }

  @override
  Future<MovieEntity> fetchMovieDetail(int movieId) async {
    final path = '/3/movie/$movieId';

    try {
      final authToken = dotenv.env['AUTH_TOKEN'] ?? '';
      final headers = <String, String>{
        'accept': 'application/json',
      };
      headers['Authorization'] = 'Bearer $authToken';
      final response = await serverApiClient.get(path, headers: headers);
      final data = json.decode(response.body);

      final genres = List<String>.from(data['genres'].map((e) => e['name']));

      final movie = MovieEntity(
        id: data['id'],
        title: data['title'],
        overview: data['overview'],
        releaseDate: data['release_date'],
        posterPath: data['poster_path'],
        voteAverage: data['vote_average'].toDouble(),
        genres: genres,
      );

      return movie;
    } catch (e) {
      throw Exception("Failed to load movie detail");
    }
  }
}
