import 'package:flutter/material.dart';
import 'package:movie_app/feature/movies/domain/entities/movie_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MovieItem extends StatelessWidget {
  final MovieEntity movie;

  const MovieItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
        placeholder: (context, url) => const CircularProgressIndicator(),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.overview),
    );
  }
}
