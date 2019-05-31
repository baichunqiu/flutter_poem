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

  _open() async {
    // 获取数据库文件的存储路径
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _Db_Name);
    _db = await openDatabase(path);
  }

  ///获取表记录离数
  Future<int> count(String table) async {
    if (null == _db) {
      await _open();
    }
    String sql = "SELECT COUNT(*) FROM $table";
    List<Map<String, dynamic>> counts = await _db.rawQuery(sql, null);
    if (null != counts && counts.isNotEmpty) {
      Map<String, dynamic> count = counts[0];
      return count["COUNT(*)"];
    }
    return 0;
  }

  /// 根据id查询唐诗
  Future<Poem> getPoemById(int id) async {
    if (null == _db) await _open();
    String sql = "SELECT * FROM " + Tab_Poem + " WHERE id = ?";
    List<Map<String, dynamic>> dataMap = await _db.rawQuery(sql, [id]);
    List<Poem> result = Poem.fromMapList(dataMap);
    return null == result && result.isNotEmpty ? null : result[0];
  }

  /// 根据id查询宋词
  Future<SongCi> getSongCiById(int id) async {
    if (null == _db) await _open();
    String sql = "SELECT * FROM " + Tab_Ci + " WHERE id = ?";
    List<Map<String, dynamic>> dataMap = await _db.rawQuery(sql, [id]);
    List<SongCi> result = SongCi.fromMapList(dataMap);
    return null == result || result.isEmpty ? null : result[0];
  }

  /// 根据作者查询唐诗
  Future<List<Poem>> getPoemByAuthor(String author) async {
    if (null == _db) await _open();
    String sql = "SELECT * FROM " + Tab_Poem + " WHERE author like ?";
    List<Map<String, dynamic>> dataMap = await _db.rawQuery(sql, ["%$author%"]);
    return Poem.fromMapList(dataMap);
  }

  /// 根据作者查询宋词
  Future<List<SongCi>> getSongCiByAuthor(String author) async {
    if (null == _db) await _open();
    String sql = "SELECT * FROM " + Tab_Ci + " WHERE author like ?";
    List<Map<String, dynamic>> dataMap = await _db.rawQuery(sql, ["%$author%"]);
    return SongCi.fromMapList(dataMap);
  }

  /// 根据作者名称 查询 作者的详细描述信息
  Future<Author> getAuthorByName(String name) async {
    if (null == _db) await _open();
    String sql = "SELECT * FROM " + Tab_Author + " WHERE name like ?";
    List<Map<String, dynamic>> dataMap = await _db.rawQuery(sql, ["%$name%"]);
    List<Author> result = Author.fromMapList(dataMap);
    return null == result || result.isEmpty ? null : result[0];
  }

  /// 分页获取唐诗
  Future<List<Poem>> getPoemByTag(String tag) async {
    if (null == _db) await _open();
    String sql = "SELECT * FROM " + Tab_Poem + " WHERE tag like ?";
    List<Map<String, dynamic>> dataMap = await _db.rawQuery(sql, ["%$tag%"]);
    return Poem.fromMapList(dataMap);
  }

  ///分页获取宋词
  Future<List<SongCi>> getSongCiByTag(String tag) async {
    if (null == _db) await _open();
    String sql = "SELECT * FROM " + Tab_Ci + " WHERE tag like ?";
    List<Map<String, dynamic>> dataMap = await _db.rawQuery(sql, ["%$tag%"]);
    return SongCi.fromMapList(dataMap);
  }

  Future<List<Poem>> getPoemByPage(int page) async {
    if (null == _db) await _open();
    String sql = "SELECT * FROM " + Tab_Poem + " WHERE id >= ? AND id < ?";
    List<Map<String, dynamic>> dataMap =
        await _db.rawQuery(sql, [page * _page_seize, (page + 1) * _page_seize]);
    return Poem.fromMapList(dataMap);
  }

  Future<List<SongCi>> getSongCiByPage(int page) async {
    if (null == _db) await _open();
    String sql = "SELECT * FROM " + Tab_Ci + " WHERE id >= ? AND id < ?";
    List<Map<String, dynamic>> dataMap =
        await _db.rawQuery(sql, [page * _page_seize, (page + 1) * _page_seize]);
    return SongCi.fromMapList(dataMap);
  }

  /// 搜索唐诗：对标题、内容、作者、tag 模糊查询 ，
  Future<List<Poem>> searchPeotry(String search) async {
    if (null == _db) await _open();
    String sql = "SELECT * FROM " +
        Tab_Poem +
        " WHERE author like ? or title like ? or txt like ? or tag like ?";
    List<Map<String, dynamic>> dataMap = await _db
        .rawQuery(sql, ["%$search%", "%$search%", "%$search%", "%$search%"]);
    return Poem.fromMapList(dataMap);
  }

  /// 搜索宋词：对标题、内容、作者、tag 模糊查询 ，
  Future<List<SongCi>> searchSongCi(String search) async {
    if (null == _db) await _open();
    String sql = "SELECT * FROM " +
        Tab_Ci +
        " WHERE author like ? or title like ? or txt like ? or tag like ?";
    List<Map<String, dynamic>> dataMap = await _db
        .rawQuery(sql, ["%$search%", "%$search%", "%$search%", "%$search%"]);
    return SongCi.fromMapList(dataMap);
  }

  /// 搜索Tag表：tag 模糊查询 ，
  Future<List<String>> searchTag(String search) async {
    if (null == _db) await _open();
    String sql = "SELECT * FROM " + Tab_Tag + " WHERE name like ?";
    List<Map<String, dynamic>> dataMap = await _db.rawQuery(sql, ["%$search%"]);
    List<String> tagList = new List();
    dataMap.forEach((data) {
      tagList.add(data["name"]);
    });
    return tagList;
  }

  /// 根据tag 搜索唐诗和宋词
  Future<List<Base>> searchByTag(String tag) async {
    if (null == _db) await _open();
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

  ///外部使用的  封装：删除唐诗和宋词表中的tag ，同步删除Tag表中的tag
  Future<bool> deleteTag(String tag) async {
    if (null == _db) await _open();
    String sql_poem = "UPDATE " + Tab_Poem + " SET tag = ? WHERE tag = ?";
    String sql_ci = "UPDATE " + Tab_Ci + " SET tag = ? WHERE tag = ?";
    int d1 = await _db.rawUpdate(sql_poem, [null, tag]);
    int d2 = await _db.rawUpdate(sql_ci, [null, tag]);
    int d3 = await _deleteTag(tag);
    return d1 + d2 > 0 && d3 > 0;
  }

  /// 外部使用的  封装：更新唐诗/宋词表中的tag 并同步更新Tag表中的tag
  Future<int> updateTag(String table, String tag, int id) async {
    if (id == null) {
      return -1;
    }
    if (null == _db) await _open();
    String oldTag = await _getTagById(table, id);
    await _deleteTag(oldTag);
    await _insertTag(tag);
    String sql = "UPDATE $table SET tag = ? WHERE id = ?";
    return _db.rawUpdate(sql, [tag, id]);
  }

  ///根据id 获取 宋词/唐诗表中的tag
  Future<String> _getTagById(String table, int id) async {
    if (null == _db) await _open();
    String sql = "SELECT tag FROM $table WHERE id = ?";
    List<Map<String, dynamic>> dataMap = await _db.rawQuery(sql, [id]);
    return null != dataMap && dataMap.isNotEmpty ? dataMap[0]["tag"] : "";
  }

  /// Tag表 插入tag
  Future<int> _insertTag(String tag) async {
    String sql = "SELECT * FROM " + Tab_Tag + " WHERE name = ?";
    List<Map<String, dynamic>> dataMap = await _db.rawQuery(sql, [tag]);
    if (dataMap == null || dataMap.isEmpty) {
      return _db.insert(Tab_Tag, {"name": tag});
    }
    return -1;
  }

  /// 删除Tag 表中的tag
  Future<int> _deleteTag(String tag) async {
    return _db.delete(Tab_Tag, where: "name = ?", whereArgs: [tag]);
  }

  /// 获取Tag 表中所有的tag
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
