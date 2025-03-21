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

  /// Método de fábrica para crear una instancia de `MovieEntity` desde un `Map` (utilizado para convertir JSON).
  factory MovieEntity.fromJson(Map<String, dynamic> json) {
    return MovieEntity(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      releaseDate: json['release_date'] ??
          '', // Si 'release_date' es nulo, se asigna una cadena vacía.
      posterPath: json['poster_path'] ??
          '', // Si 'poster_path' es nulo, se asigna una cadena vacía.
      voteAverage: json['vote_average']?.toDouble() ??
          0.0, // Si 'vote_average' es nulo, se asigna 0.0.
      genres: json['genre_ids'] != null
          ? List<String>.from(json['genre_ids'].map((e) =>
              e.toString())) // Ajustado para manejar 'genre_ids' como un array.
          : [],
    );
  }
}
