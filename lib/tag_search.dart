import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poetry/module/poem.dart';
import 'package:poetry/string_utils.dart';
import 'package:poetry/widget/Indicator.dart';
import 'package:poetry/widget/base_item.dart';
import 'package:poetry/widget/event_bus.dart';
import 'package:poetry/widget/load/animated_rotation_box.dart';
import 'package:poetry/widget/load_page.dart';
import 'package:poetry/widget/single_line.dart';
import 'package:poetry/widget/smart_listview.dart';
import 'package:poetry/widget/style.dart';
import 'package:poetry/widget/toast.dart';

import 'db.dart';
import 'details.dart';
import 'module/base.dart';

class TagSearchPage extends StatefulWidget {
  TagSearchPage({Key key, this.tag}) : super(key: key);
  final String tag;

  @override
  State createState() => _State();
}

class _State extends State<TagSearchPage> {
  static final double itemHeight = ScreenUtil.getInstance().setHeight(120);

  List<Base> _data;

  @override
  void initState() {
    super.initState();
    db.searchByTag(widget.tag).then((data) {
      setState(() {
        _data = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text.rich(TextSpan(children: [
            TextSpan(text: widget.tag),
            TextSpan(text: "（标签）", style: Style.style_white18),
          ])),
        ),
        body: null == _data
            ? LoadPage(
                type: Type.Loading,
              )
            : ListView.separated(
                shrinkWrap: true,
                itemCount: _data.length,
                itemBuilder: (BuildContext context, int index) => BaseItem(
                      data: _data[index],
                      tagVisiable: false,
                      height: itemHeight,
                      onTapRoute: (data) => Details(data: data),
                    ),
                separatorBuilder: (BuildContext context, int index) =>
                    Container(
                      color: Colors.blue[200],
                      height: Style.divide,
                    ),
              ));
  }
}
