import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/core/theme/sizes.dart';
import 'package:movie_app/feature/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/core/theme/colors.dart';

class MovieItem extends StatelessWidget {
  final MovieEntity movie;

  const MovieItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final String formattedDate = _formatReleaseDate(movie.releaseDate);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Theme.of(context).cardColor, // Usando color del tema
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
              placeholder: (context, url) => _buildLoader(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            _buildTitleText(context, movie.title),
            const SizedBox(height: 4),
            _buildReleaseDateText(context, formattedDate),
            const SizedBox(height: 6),
            _buildVoteAverageRow(context, movie.voteAverage),
            const SizedBox(height: 6),
            _buildOverviewText(context, movie.overview),
          ],
        ),
      ),
    );
  }

  String _formatReleaseDate(String releaseDate) {
    final DateTime date = DateTime.parse(releaseDate);
    return DateFormat('dd MMMM yyyy').format(date);
  }

  Widget _buildLoader() {
    return const Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(
          strokeWidth: 5,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.yellow),
        ),
      ),
    );
  }

  Widget _buildTitleText(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildReleaseDateText(BuildContext context, String formattedDate) {
    return Text(
      'Release Date: $formattedDate',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _buildVoteAverageRow(BuildContext context, double voteAverage) {
    final formattedVoteAverage = NumberFormat('0.0').format(voteAverage);

    return Row(
      children: [
        const Icon(
          Icons.star,
          color: AppColors.yellow,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          formattedVoteAverage,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildOverviewText(BuildContext context, String overview) {
    return Text(
      overview,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
