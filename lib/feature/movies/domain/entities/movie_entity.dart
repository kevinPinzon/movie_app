class MovieEntity {
  final int id;
  final String title;
  final String overview;
  final String releaseDate;
  final String posterPath;
  final double voteAverage;
  final List<String> genres;

  MovieEntity({
    required this.id,
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.posterPath,
    required this.voteAverage,
    required this.genres,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'releaseDate': releaseDate,
      'posterPath': posterPath,
      'voteAverage': voteAverage,
      'genres': genres.join(','),
    };
  }

  factory MovieEntity.fromMap(Map<String, dynamic> map) {
    return MovieEntity(
      id: map['id'],
      title: map['title'],
      overview: map['overview'],
      releaseDate: map['releaseDate'],
      posterPath: map['posterPath'],
      voteAverage: map['voteAverage'],
      genres: map['genres'] != null
          ? List<String>.from(map['genres'].split(','))
          : [],
    );
  }
}
