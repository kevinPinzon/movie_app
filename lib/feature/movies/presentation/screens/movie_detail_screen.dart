import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/core/common/resource_images.dart';
import 'package:movie_app/core/services/dependency_injection.dart';
import 'package:movie_app/feature/movies/domain/repositories/movie_repository.dart';
import 'package:movie_app/feature/movies/presentation/blocs/movie_bloc.dart';

class MovieDetailScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movie Details',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: BlocProvider(
        create: (context) => MovieBloc(
          movieRepository: RepositoryProvider.of<MovieRepository>(context),
          networkInfoRepository: getIt(),
        )..add(FetchMovieDetail(movieId: movieId)),
        child: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieDetailLoaded) {
              final movie = state.movie;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                          height: 400,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // En caso de error, mostramos una imagen de error personalizada
                            return Image.asset(
                              noPicture, // Ruta de la imagen de error
                              height: 200,
                              fit: BoxFit.fitWidth,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        movie.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Genres: ${movie.genres.join(', ')}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Release Date: ${_formatReleaseDate(movie.releaseDate)}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        movie.overview,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is MovieError) {
              return Center(
                  child: Text(state
                      .message)); // Mostrar el mensaje de error si hay fallo
            }
            return const Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }

  String _formatReleaseDate(String releaseDate) {
    final DateTime date = DateTime.parse(releaseDate);
    return DateFormat('dd MMMM yyyy').format(date);
  }
}
