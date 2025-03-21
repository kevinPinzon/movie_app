import 'dart:convert';
import 'package:movie_app/feature/movies/domain/entities/movie_entity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/core/services/network/server_api_client.dart';

class MovieRemoteService {
  final ServerApiClient serverApiClient;

  MovieRemoteService({required this.serverApiClient});

  Future<List<MovieEntity>> fetchMovies(int page) async {
    const path = '/3/discover/movie';
    final queryParameters = {'page': page.toString()};

    try {
      final authToken = dotenv.env['AUTH_TOKEN'] ?? '';
      final headers = {
        'accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      };

      final response = await serverApiClient.get(
        path,
        queryParameters: queryParameters,
        headers: headers,
      );

      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results
          .map((movieJson) => MovieEntity.fromJson(movieJson))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch movies: $e");
    }
  }

  Future<MovieEntity> fetchMovieDetail(int movieId) async {
    final path = '/3/movie/$movieId';

    try {
      final authToken = dotenv.env['AUTH_TOKEN'] ?? '';
      final headers = {
        'accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      };

      final response = await serverApiClient.get(path, headers: headers);
      final data = json.decode(response.body);

      return MovieEntity.fromJson(data);
    } catch (e) {
      throw Exception("Failed to fetch movie details: $e");
    }
  }
}
