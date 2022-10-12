import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/books.dart';

final String columnId = 'id';
final String columnBookName = 'bookName';
final String columnAuthorName = 'authorName';
final String columnCoverURL = 'coverURL';
final String tableBooks = 'books';

class BooksProvider {
  late Database db;

  static final BooksProvider instance = BooksProvider._internal();

  factory BooksProvider() {
    return instance;
  }

  BooksProvider._internal();

  Future open() async {
    db = await openDatabase(join(await getDatabasesPath(), 'books.db'),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableBooks ( 
  $columnId integer primary key autoincrement, 
  $columnBookName text not null,
  $columnAuthorName text not null,
  $columnCoverURL text not null
  )
''');
    });
  }

  Future<Books> insert(Books books) async {
    books.id = await db.insert(tableBooks, books.toMap());
    return books;
  }

  Future<List<Books>> getBooks() async {
    List<Map<String, dynamic>> taskMaps = await db.query(tableBooks);
    if (taskMaps.isEmpty) {
      return [];
    } else {
      List<Books> books = [];
      taskMaps.forEach((element) {
        books.add(Books.fromMap(element));
      });
      return books;
    }
  }

  Future<int> delete(int id) async {
    return await db.delete(tableBooks, where: '$columnId = ?', whereArgs: [id]);
  }

  Future close() async => db.close();

}
