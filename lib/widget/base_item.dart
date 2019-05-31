import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poetry/module/base.dart';
import 'package:poetry/widget/single_line.dart';
import 'package:poetry/widget/style.dart';
import 'package:poetry/widget/tag.dart';

typedef OnTapRoute = Widget Function(Base data);

class BaseItem extends StatelessWidget {
  final Base data;
  final OnTapRoute onTapRoute;
  final double height;
  final bool tagVisiable;
  final OnTap onTagTap;

  BaseItem(
      {Key key,
      this.data,
      this.onTapRoute,
      this.height,
      this.onTagTap,
      this.tagVisiable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => null == onTapRoute(data)
          ? null
          : Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
              return onTapRoute(data);
            })),
      child: Container(
        height: height,
        color: Colors.blue[50],
        padding: EdgeInsets.symmetric(
            horizontal: height * 0.15, vertical: height * 0.07),
        child: Column(
          children: <Widget>[
            Container(
              height: height * 0.45,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: height * 0.1),
                    color: Colors.blue,
                    width: height * 0.05,
                    height: height * 0.24,
                  ),
                  Expanded(
                    child: SingleLine("名称：" + data.title,
                        textAlign: TextAlign.start, style: Style.style_blue22),
                  ),
                  Offstage(
                    offstage: tagVisiable == false,
                    child: Tag(
                      height: height * 0.35,
                      width: height * 0.8,
                      tag: "${null == data.tag ? "无" : data.tag}",
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      onTap: null == data.tag ? null : onTagTap,
                    ),
                  ),
                  Text(
                    "✍ ${data.author}",
                    style: Style.style_blue18,
                  ),
                ],
              ),
            ),
            Container(
              height: height * 0.41,
              alignment: Alignment.centerLeft,
              child: SingleLine(
                "诗文：${data.txt.replaceAll("\n", "")}",
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
