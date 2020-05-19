import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Movie.dart';


class MyDatabase{
  Database database;

  Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'movies.db');

    database= await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Popular (id INTEGER PRIMARY KEY, voteCount INTEGER, posterPath TEXT, backdropPath TEXT, title TEXT, overview TEXT)');
      await db.execute(
          'CREATE TABLE Favorites (id INTEGER PRIMARY KEY, voteCount INTEGER, posterPath TEXT, backdropPath TEXT, title TEXT, overview TEXT)');
    });
  }

  Future<List<Movie>> getPopular() async{
    List<Map> list = await database.rawQuery('SELECT * FROM Popular');
    print(list);
    List<Movie> finalList = new List<Movie>();
    for (var movie in list) {
      Movie m = new Movie();
      m.title = movie["title"];
      m.voteCount = movie["voteCount"];
      m.posterPath = movie["posterPath"];
      m.backdropPath = movie["backdropPath"];
      m.overview = movie["overview"];
      finalList.add(m);
    }
    return finalList;
  }

  Future<List<Movie>> getFavorites() async{
    List<Map> list = await database.rawQuery('SELECT * FROM Favorites');
    print(list);
    List<Movie> finalList = new List<Movie>();
    for (var movie in list) {
      Movie m = new Movie();
      m.title = movie["title"];
      m.voteCount = movie["voteCount"];
      m.posterPath = movie["posterPath"];
      m.backdropPath = movie["backdropPath"];
      m.overview = movie["overview"];
      finalList.add(m);
    }
    return finalList;
  }

  Future<void> savePopular(movies) async{

  // Delete a record
    await database.rawDelete('DELETE FROM Popular WHERE 1 = 1');
    for (var movie in movies) {
      await database.rawInsert('INSERT INTO Popular(id, voteCount, posterPath, backdropPath, title, overview) VALUES(?, ?, ?, ?, ?, ?)',
      [movie.id, movie.voteCount, movie.posterPath, movie.backdropPath, movie.title, movie.overview]);
    }
    return;
  }

  Future<void> saveFavorites(movies) async{

  // Delete a record
    await database.rawDelete('DELETE FROM Favorites WHERE 1 = 1');
    for (var movie in movies) {
      await database.rawInsert('INSERT INTO Favorites(id, voteCount, posterPath, backdropPath, title, overview) VALUES(?, ?, ?, ?, ?, ?)',
      [movie.id, movie.voteCount, movie.posterPath, movie.backdropPath, movie.title, movie.overview]);
    }
    return;
  }

  Future<void> closeDatabase() async{
    await database.close();
  }

}