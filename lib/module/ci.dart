import 'base.dart';

class SongCi extends Base{
//  int id;
//  String title;
//  String author;
//  String txt;
//  String tag;
//  String type;

  static SongCi fromMap(Map<String, dynamic> map) {
    SongCi ci = new SongCi();
    ci.id = map['id'];
    ci.title = map['title'];
    ci.author = map['author'];
    ci.txt = map['txt'];
    ci.tag = map['tag'];
    ci.type = type_songci;
    return ci;
  }

  static List<SongCi> fromMapList(dynamic mapList) {
    List<SongCi> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

  @override
  String toString() {
    return 'SongCi{id: $id, title: $title, author: $author, txt: $txt, tag: $tag, type: $type}';
  }
}

class Author {
  int id;
  String name;
  String describe;

  static Author fromMap(Map<String, dynamic> map) {
    Author author = new Author();
    author.id = map['id'];
    author.name = map['name'];
    author.describe = map['describe'];
    return author;
  }

  static List<Author> fromMapList(dynamic mapList) {
    List<Author> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

  @override
  String toString() {
    return 'Author{id: $id, name: $name, describe: $describe}';
  }
}
