import 'package:path/path.dart';
import 'package:poetry/module/poem.dart';
import 'package:sqflite/sqflite.dart';

import 'module/base.dart';
import 'module/ci.dart';

Db db = new Db();

const String Tab_Poem = "poem";
const String Tab_Ci = "songci";
const String Tab_Author = "author";
const String Tab_Tag = "tag";

class Db {
  Db._internal();

  static const String _Db_Name = "shici.db";

  static const int _page_seize = 20;
  static Db _singleton = new Db._internal();

  factory Db() => _singleton;
  Database _db;

  close() async {
    await _db.close();
  }

  open() async {
    // 获取数据库文件的存储路径
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _Db_Name);
    _db = await openDatabase(path);
  }

  Future<int> count(String table) async {
    if (null == _db) {
      await open();
    }
    String sql = "SELECT COUNT(*) FROM $table";
    List<Map<String, dynamic>> counts = await _db.rawQuery(sql, null);
    if (null != counts && counts.isNotEmpty) {
      Map<String, dynamic> count = counts[0];
      return count["COUNT(*)"];
    }
    return 0;
  }

  Future<Poem> getPoemById(int id) async {
    if (null == _db) await open();
    String sql = "SELECT * FROM " + Tab_Poem + " WHERE id = ?";
    List<Map<String, dynamic>> dataMap = await _db.rawQuery(sql, [id]);
    List<Poem> result = Poem.fromMapList(dataMap);
    return null == result && result.isNotEmpty ? null : result[0];
  }

  Future<SongCi> getSongCiById(int id) async {
    if (null == _db) await open();
    String sql = "SELECT * FROM " + Tab_Ci + " WHERE id = ?";
    List<Map<String, dynamic>> dataMap = await _db.rawQuery(sql, [id]);
    List<SongCi> result = SongCi.fromMapList(dataMap);
    return null == result || result.isEmpty ? null : result[0];
  }

  Future<List<Poem>> getPoemByAuthor(String author) async {
    if (null == _db) await open();
    String sql = "SELECT * FROM " + Tab_Poem + " WHERE author like ?";
    List<Map<String, dynamic>> dataMap = await _db.rawQuery(sql, ["%$author%"]);
    return Poem.fromMapList(dataMap);
  }

  Future<List<SongCi>> getSongCiByAuthor(String author) async {
    if (null == _db) await open();
    String sql = "SELECT * FROM " + Tab_Ci + " WHERE author like ?";
    List<Map<String, dynamic>> dataMap = await _db.rawQuery(sql, ["%$author%"]);
    return SongCi.fromMapList(dataMap);
  }

  Future<Author> getAuthorByName(String name) async {
    if (null == _db) await open();
    String sql = "SELECT * FROM " + Tab_Author + " WHERE name like ?";
    List<Map<String, dynamic>> dataMap = await _db.rawQuery(sql, ["%$name%"]);
    List<Author> result = Author.fromMapList(dataMap);
    return null == result || result.isEmpty ? null : result[0];
  }

  Future<List<Poem>> getPoemByTag(String tag) async {
    if (null == _db) await open();
    String sql = "SELECT * FROM " + Tab_Poem + " WHERE tag like ?";
    List<Map<String, dynamic>> dataMap = await _db.rawQuery(sql, ["%$tag%"]);
    return Poem.fromMapList(dataMap);
  }

  Future<List<SongCi>> getSongCiByTag(String tag) async {
    if (null == _db) await open();
    String sql = "SELECT * FROM " + Tab_Ci + " WHERE tag like ?";
    List<Map<String, dynamic>> dataMap = await _db.rawQuery(sql, ["%$tag%"]);
    return SongCi.fromMapList(dataMap);
  }

  Future<List<Poem>> getPoemByPage(int page) async {
    if (null == _db) await open();
    String sql = "SELECT * FROM " + Tab_Poem + " WHERE id >= ? AND id < ?";
    List<Map<String, dynamic>> dataMap =
        await _db.rawQuery(sql, [page * _page_seize, (page + 1) * _page_seize]);
    return Poem.fromMapList(dataMap);
  }

  Future<List<SongCi>> getSongCiByPage(int page) async {
    if (null == _db) await open();
    String sql = "SELECT * FROM " + Tab_Ci + " WHERE id >= ? AND id < ?";
    List<Map<String, dynamic>> dataMap =
        await _db.rawQuery(sql, [page * _page_seize, (page + 1) * _page_seize]);
    return SongCi.fromMapList(dataMap);
  }

  Future<List<Poem>> searchPeotry(String search) async {
    if (null == _db) await open();
    String sql = "SELECT * FROM " +
        Tab_Poem +
        " WHERE author like ? or title like ? or txt like ? or tag like ?";
    List<Map<String, dynamic>> dataMap = await _db
        .rawQuery(sql, ["%$search%", "%$search%", "%$search%", "%$search%"]);
    return Poem.fromMapList(dataMap);
  }

  Future<List<SongCi>> searchSongCi(String search) async {
    if (null == _db) await open();
    String sql = "SELECT * FROM " +
        Tab_Ci +
        " WHERE author like ? or title like ? or txt like ? or tag like ?";
    List<Map<String, dynamic>> dataMap = await _db
        .rawQuery(sql, ["%$search%", "%$search%", "%$search%", "%$search%"]);
    return SongCi.fromMapList(dataMap);
  }

  Future<List<Base>> searchByTag(String tag) async {
    if (null == _db) await open();
    print("searchByTag: tag = $tag");
    String sql_ci = "SELECT * FROM " + Tab_Ci + " WHERE tag = ?";
    String sql_poem = "SELECT * FROM " + Tab_Poem + " WHERE tag = ?";
    List<Map<String, dynamic>> poemMap = await _db.rawQuery(sql_poem, [tag]);
    List<Map<String, dynamic>> ciMap = await _db.rawQuery(sql_ci, [tag]);
    List<Base> tagAll = new List();
    if (null != poemMap && poemMap.isNotEmpty) {
      tagAll.addAll(Poem.fromMapList(poemMap));
    }
    if (null != ciMap && ciMap.isNotEmpty) {
      tagAll.addAll(SongCi.fromMapList(ciMap));
    }
    return tagAll;
  }

  Future<int> updateTag(String table, String tag, int id) async {
    if (id == null) {
      return -1;
    }
    if (null == _db) await open();
    String oldTag = await getTagById(table, id);
    await _deleteTag(oldTag);
    await _insertTag(tag);
    String sql = "UPDATE $table SET tag = ? WHERE id = ?";
    return _db.rawUpdate(sql, [tag, id]);
  }

  Future<String> getTagById(String table, int id) async {
    if (null == _db) await open();
    String sql = "SELECT tag FROM $table WHERE id = ?";
    List<Map<String, dynamic>> dataMap = await _db.rawQuery(sql, [id]);
    return null != dataMap && dataMap.isNotEmpty ? dataMap[0]["tag"] : "";
  }

  Future<int> _insertTag(String tag) async {
    String sql = "SELECT * FROM " + Tab_Tag + " WHERE name = ?";
    List<Map<String, dynamic>> dataMap = await _db.rawQuery(sql, [tag]);
    if (dataMap == null || dataMap.isEmpty) {
      return _db.insert(Tab_Tag, {"name": tag});
    }
    return -1;
  }

  Future<int> _deleteTag(String tag) async {
    return _db.delete(Tab_Tag, where: "name = ?", whereArgs: [tag]);
  }

  Future<List<String>> getAllTag() async {
    String sql = "SELECT * FROM " + Tab_Tag;
    List<Map<String, dynamic>> dataMap = await _db.rawQuery(sql, null);
    List<String> tagList = new List();
    dataMap.forEach((data) {
      tagList.add(data["name"]);
    });
    print("getTag : size = ${tagList.length}");
    return tagList;
  }
}
