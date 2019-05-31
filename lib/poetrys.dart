import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poetry/module/poem.dart';
import 'package:poetry/string_utils.dart';
import 'package:poetry/widget/Indicator.dart';
import 'package:poetry/widget/base_item.dart';
import 'package:poetry/widget/event_bus.dart';
import 'package:poetry/widget/single_line.dart';
import 'package:poetry/widget/smart_listview.dart';
import 'package:poetry/widget/style.dart';
import 'package:poetry/widget/toast.dart';

import 'db.dart';
import 'details.dart';

class Poetrys extends StatefulWidget {
  Poetrys({Key key}) : super(key: key);

  @override
  State createState() => _PoemState();
}

class _PoemState extends State<Poetrys> {
  static final double itemHeight = ScreenUtil.getInstance().setHeight(120);

  @override
  void dispose() {
    super.dispose();
    bus.off(EventTag.Event_Search_Poem);
  }

  String _search = "";
  int _page = 1;

  @override
  void initState() {
    super.initState();
    bus.on(EventTag.Event_Search_Poem, (e) {
      _search = e.arg0;
      print("search poem = ${e.arg0}");
      bus.emit(SmartListView.Refresh_Event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SmartListView(
      itemBuilder: (int index, dynamic item) => BaseItem(
            data: item,
            height: itemHeight,
            onTapRoute: (data) => Details(data: data),
            onTagTap: (tag) => showDialog(
                  context: context,
                  builder: (c) => AlertDialog(
                        title: Text("搜索提示"),
                        content:
                            Text("确认搜索标签 $tag ?", style: Style.style_blue24),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("确定"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _search = tag;
                              bus.emit(SmartListView.Refresh_Event);
                            },
                          )
                        ],
                      ),
                ),
          ),
      onComplete: (data) {
        if (null != _search && _search.isNotEmpty) {
          ToastManager.showAndroid(
              "$_search 检索到唐诗 ${null == data ? 0 : data.length} 条数据！");
        }
        _search = "";
      },
      dataBuilder: (refresh) async {
        List<Poem> ps;
        if (_search == null || _search.isEmpty) {
          _page = refresh == DataType.refresh ? 0 : _page + 1;
          ps = await db.getPoemByPage(_page);
        } else {
          ps = await db.searchPeotry(_search);
        }
        return Future.value(ps);
      },
    ));
  }
}
