import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/feature/movies/domain/entities/movie_entity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/core/network/server_api_client.dart';

/// Servicio que maneja las solicitudes HTTP relacionadas con las películas desde la API.
class MovieRemoteService {
  final ServerApiClient serverApiClient;

  /// Constructor del servicio que recibe la dependencia de `ServerApiClient`.
  MovieRemoteService({required this.serverApiClient});

  /// Obtiene las películas de la API y las convierte en entidades `MovieEntity`.
  Future<List<MovieEntity>> fetchMovies(int page) async {
    const path = '/3/discover/movie'; // Ruta de la API para descubrir películas
    final queryParameters = {'page': page.toString()}; // Parámetros de consulta

    try {
      // Token de autenticación cargado desde el archivo .env
      final authToken = dotenv.env['AUTH_TOKEN'] ?? '';
      final headers = {
        'accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      };

      // Hacemos la solicitud HTTP GET
      final response = await serverApiClient.get(
        path,
        queryParameters: queryParameters,
        headers: headers,
      );

      // Decodificamos la respuesta y mapeamos los resultados a `MovieEntity`
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results
          .map((movieJson) => MovieEntity.fromJson(movieJson))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch movies: $e");
    }
  }

  /// Obtiene los detalles de una película a partir de su ID.
  Future<MovieEntity> fetchMovieDetail(int movieId) async {
    final path =
        '/3/movie/$movieId'; // Ruta para obtener detalles de una película

    try {
      final authToken = dotenv.env['AUTH_TOKEN'] ?? '';
      final headers = {
        'accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      };

      // Solicitud para obtener los detalles de la película
      final response = await serverApiClient.get(path, headers: headers);
      final data = json.decode(response.body);

      // Extraemos y retornamos los detalles de la película
      return MovieEntity.fromJson(data);
    } catch (e) {
      throw Exception("Failed to fetch movie details: $e");
    }
  }
}
