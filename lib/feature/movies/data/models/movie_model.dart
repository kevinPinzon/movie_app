class MovieModel {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;

  MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      voteAverage: json['vote_average'].toDouble(),
    );
  }
}
