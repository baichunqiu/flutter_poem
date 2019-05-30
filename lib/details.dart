import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poetry/string_utils.dart';
import 'package:poetry/widget/style.dart';
import 'package:poetry/widget/toast.dart';

import 'db.dart';
import 'module/base.dart';
import 'module/ci.dart';

class Details extends StatefulWidget {
  Base data;

  Details({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  State createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Author _author;

  @override
  void initState() {
    super.initState();
    db.getAuthorByName(widget.data.author).then((author) {
      print(widget.data);
      print(author);
      setState(() {
        _author = author;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.width * 0.1;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.title),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: height * 0.5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "✒ ${widget.data.author} ✍",
                        style: Style.style_blue22,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: height * 0.2),
                        child: Text(
                          widget.data.type == type_poem ? widget.data.txt : widget.data.txt.replaceAll("，", "，\n"),
                          style: TextStyle(
                              color: Style.color_blue,
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil.getInstance().setSp(40)),
                        ),
                      ),
                      Offstage(
                        offstage: (widget.data.type == type_songci &&
                                null != _author &&
                                StringUtils.isNoEmpty(_author.describe)) ==
                            false,
                        child: Text(
                            "       ${null == _author ? "" : _author.describe.replaceAll(" ", "")}",
                            style: Style.style_gray20),
                      ),
                    ]),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 15, top: 10),
            alignment: Alignment.topRight,
            child: Text(
                "标签：${StringUtils.isEmpty(widget.data.tag) ? "未添加" : widget.data.tag}",
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontSize: Style.font_16, color: Colors.pinkAccent[200])),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditDialog(),
        child: Text(StringUtils.isEmpty(widget.data.tag) ? "添加\n标签" : "修改\n标签",
            style: Style.style_white18),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  TextEditingController _controller = new TextEditingController();

  void _showEditDialog() {
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
                title: Text(
                  StringUtils.isEmpty(widget.data.tag) ? "添加标签" : "修改标签",
                ),
                content: TextFormField(
                  style: Style.style_blue24,
                  controller: _controller,
                  maxLength: 6,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "请输入标记",
                    hintStyle: TextStyle(color: Style.color_gray),
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("取消"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text("确定"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      String info = _controller.text;
                      db
                          .updateTag(
                              widget.data.type == type_poem ? Tab_Poem : Tab_Ci,
                              info,
                              widget.data.id)
                          .then((count) {
                        if (count > 0) {
                          ToastManager.showAndroid(
                              "${StringUtils.isEmpty(widget.data.tag) ? "标签添加" : "标签修改"}成功！");
                          setState(() {
                            widget.data.tag = info;
                          });
                        }
                      });
                      _controller.text = "";
                    },
                  )
                ]));
  }
}
