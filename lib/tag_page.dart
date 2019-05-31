import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poetry/module/poem.dart';
import 'package:poetry/string_utils.dart';
import 'package:poetry/tag_search.dart';
import 'package:poetry/widget/Indicator.dart';
import 'package:poetry/widget/event_bus.dart';
import 'package:poetry/widget/single_line.dart';
import 'package:poetry/widget/smart_listview.dart';
import 'package:poetry/widget/style.dart';
import 'package:poetry/widget/toast.dart';

import 'db.dart';
import 'details.dart';

class TagPage extends StatefulWidget {
  TagPage({Key key}) : super(key: key);

  @override
  State createState() => _TagState();
}

class _TagState extends State<TagPage> {
  static final double itemHeight = ScreenUtil.getInstance().setHeight(90);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SmartListView(
      itemBuilder: _buildItemWidget,
      dataBuilder: (refresh) async {
        if (refresh == DataType.load) return Future.value();
        List<String> tags = await db.getAllTag();
        if (tags == null || tags.isEmpty) {
          ToastManager.showAndroid("您还没有添加标签，快去添加吧！");
        } else {
          ToastManager.showAndroid("共 ${tags.length} 个标签");
        }
        return Future.value(tags);
      },
    ));
  }

  Widget _buildItemWidget(int index, dynamic item) {
    String tag = item;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
          return TagSearchPage(tag: tag);
        }));
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (c) => AlertDialog(
                title: Text("删除提示"),
                content: Text("确认删除标签 $tag ?", style: Style.style_blue24),
                actions: <Widget>[
                  new FlatButton(
                      child: new Text("取消"),
                      onPressed: () => Navigator.of(context).pop()),
                  new FlatButton(child: new Text("确定"), onPressed: (){
                    Navigator.of(context).pop();
                   db.deleteTag(tag).then((success){
                     if(success){
                       setState(() {
                         bus.emit(SmartListView.Refresh_Event);
                       });
                     }
                   });
                  })
                ],
              ),
        );
      },
      child: Container(
        height: itemHeight,
        color: Colors.blue[50],
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(
            horizontal: itemHeight * 0.15, vertical: itemHeight * 0.07),
        child: Text(
          "标签：$tag",
          style: Style.style_blue22,
        ),
      ),
    );
  }
}
