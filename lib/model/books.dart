import 'package:bookstore/database/database.dart';




class Books {
  int? id;
  String? bookName;
  String? authorName;
  String? coverURL;

  Books({
    this.id,
    required this.bookName,
    required this.authorName,
    required this.coverURL,
  });

  Books.fromMap(Map<String , dynamic> map) {
    if(map[columnId] != null) id = map[columnId];
    bookName = map[columnBookName];
    authorName = map[columnAuthorName];
    coverURL = map[columnCoverURL];
  }

  Map <String , dynamic> toMap(){
    Map<String , dynamic> map = {};
    if (id != null) map[columnId] = id;
    map[columnBookName] = bookName;
    map[columnAuthorName] = authorName;
    map[columnCoverURL] = coverURL ;
    return map;
  }

}
