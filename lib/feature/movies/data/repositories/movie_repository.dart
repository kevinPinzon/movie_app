import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/core/network/server_api_client.dart';
import 'package:movie_app/feature/movies/domain/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/core/network/network_info.dart';

class MovieRepositoryImpl implements MovieRepository {
  final ServerApiClient serverApiClient;
  final NetworkInfoRepository networkInfoRepository;

  MovieRepositoryImpl({
    required this.serverApiClient,
    required this.networkInfoRepository,
  });

  @override
  Future<List<MovieEntity>> fetchMovies(int page) async {
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

      return results
          .map((movieJson) => MovieEntity(
                id: movieJson['id'],
                title: movieJson['title'],
                overview: movieJson['overview'],
                releaseDate: movieJson['release_date'],
                posterPath: movieJson['poster_path'],
                voteAverage: movieJson['vote_average'].toDouble(),
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to load movies: $e');
    }
  }
}
