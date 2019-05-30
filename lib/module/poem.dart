import 'base.dart';

class Poem extends Base {
//  int id;
//  String title;
//  String author;
//  String txt;
//  String tag;
//  String type;
  static Poem fromMap(Map<String, dynamic> map) {
    Poem token = new Poem();
    token.id = map['id'];
    token.title = map['title'];
    token.author = map['author'];
    token.txt = map['txt'];
    token.tag = map['tag'];
    token.type = type_poem;
    return token;
  }

  static List<Poem> fromMapList(dynamic mapList) {
    List<Poem> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

  @override
  String toString() {
    return 'Poem{id: $id, title: $title, author: $author, txt: $txt, tag: $tag, type: $type}';
  }
}
