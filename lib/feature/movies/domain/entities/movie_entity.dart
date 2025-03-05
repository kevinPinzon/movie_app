class MovieEntity {
  final int id;
  final String title;
  final String overview;
  final String releaseDate;
  final String posterPath;
  final double voteAverage;

  MovieEntity({
    required this.id,
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.posterPath,
    required this.voteAverage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'releaseDate': releaseDate,
      'posterPath': posterPath,
      'voteAverage': voteAverage,
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
    );
  }
}
