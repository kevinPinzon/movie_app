import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:movie_app/feature/movies/domain/entities/movie_entity.dart';

class MovieDatabase {
  static late Database _db;
  static const String _dbName = 'movie_database.db';
  static bool _isDbInitialized = false;

  Future<void> init() async {
    if (_isDbInitialized) return;

    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, _dbName);
      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          return db.execute(
            '''
            CREATE TABLE movies(
              id INTEGER PRIMARY KEY,
              title TEXT,
              overview TEXT,
              releaseDate TEXT,
              posterPath TEXT,
              voteAverage REAL
            )
            ''',
          );
        },
      );
      _isDbInitialized = true;
    } catch (e) {
      throw Exception("Failed to initialize the database: $e");
    }
  }

  Future<Database> get db async {
    if (!_isDbInitialized) {
      await init();
    }
    return _db;
  }

  Future<void> insertMovies(List<MovieEntity> movies) async {
    final dbClient = await db;

    await dbClient.transaction((txn) async {
      for (var movie in movies) {
        try {
          await txn.insert(
            'movies',
            movie.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        } catch (e) {
          print('Error inserting movie: $e');
        }
      }
    });
  }

  Future<List<MovieEntity>> getMovies() async {
    final dbClient = await db;

    try {
      final result = await dbClient.query('movies');
      return result.map((e) => MovieEntity.fromMap(e)).toList();
    } catch (e) {
      throw Exception("Failed to fetch movies: $e");
    }
  }
}
