import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poetry/module/poem.dart';
import 'package:poetry/string_utils.dart';
import 'package:poetry/widget/Indicator.dart';
import 'package:poetry/widget/event_bus.dart';
import 'package:poetry/widget/single_line.dart';
import 'package:poetry/widget/smart_listview.dart';
import 'package:poetry/widget/style.dart';
import 'package:poetry/widget/toast.dart';

import 'db.dart';
import 'details.dart';
import 'module/ci.dart';

class SongCiPage extends StatefulWidget {
  SongCiPage({Key key}) : super(key: key);

  @override
  State createState() => _SongCiState();
}

class _SongCiState extends State<SongCiPage> {
  static final double itemHeight = ScreenUtil.getInstance().setHeight(120);

  @override
  void dispose() {
    super.dispose();
    bus.off(EventTag.Event_Search_Ci);
  }

  String _search = "";
  int _page = 1;

  @override
  void initState() {
    super.initState();
    bus.on(EventTag.Event_Search_Ci, (e) {
      _search = e.arg0;
      print("search songci = ${e.arg0}");
      bus.emit(SmartListView.Refresh_Event, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SmartListView(
      itemBuilder: _buildItemWidget,
      onComplete: (data) {
        if (StringUtils.isNoEmpty(_search)) {
          ToastManager.showAndroid(
              "$_search 检索到宋词 ${null == data ? 0 : data.length} 条数据！");
        }
        _search = "";
      },
      dataBuilder: (refresh) async {
        List<SongCi> ps;
        if (StringUtils.isEmpty(_search)) {
          _page = refresh == DataType.refresh ? 0 : _page + 1;
          ps = await db.getSongCiByPage(_page);
        } else {
          ps = await db.searchSongCi(_search);
        }
        return Future.value(ps);
      },
    ));
  }

  Widget _buildItemWidget(int index, dynamic item) {
    if (item == null) return Text("null");
    SongCi ci = item;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
          return new Details(data: ci);
        }));
      },
      child: Container(
        height: itemHeight,
        color: Colors.blue[50],
        padding: EdgeInsets.symmetric(
            horizontal: itemHeight * 0.15, vertical: itemHeight * 0.07),
        child: Column(
          children: <Widget>[
            Container(
              height: itemHeight * 0.45,
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    color: Colors.blue,
                    width: itemHeight * 0.05,
                    height: itemHeight * 0.22,
                  ),
                  Expanded(
                    child:
                        SingleLine("名称：" + ci.title, style: Style.style_blue22),
                  ),
                  Text(
                    "✍ ${ci.author}",
                    style: Style.style_blue18,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (StringUtils.isEmpty(ci.tag)) return;
                      showDialog(
                          context: context,
                          builder: (c) => AlertDialog(
                              title: Text("搜索提示"),
                              content: Text("确认搜索标签 ${ci.tag} ?",
                                  style: Style.style_blue24),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text("确定"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _search = ci.tag;
                                    bus.emit(SmartListView.Refresh_Event, null);
                                  },
                                )
                              ]));
                    },
                    child: Text(
                        "  标签：${StringUtils.isEmpty(ci.tag) ? "无" : ci.tag}",
                        style: TextStyle(
                            fontSize: Style.font_16,
                            color: Colors.pinkAccent[100])),
                  )

                ],
              ),
            ),
            Container(
              height: itemHeight * 0.41,
              width: ScreenUtil.getInstance().setWidth(720),
              alignment: Alignment.centerLeft,
              child: SingleLine(
                "诗文：${ci.txt}",
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: Style.style_gray18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
