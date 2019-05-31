import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poetry/module/base.dart';
import 'package:poetry/widget/single_line.dart';
import 'package:poetry/widget/style.dart';

import '../string_utils.dart';

typedef OnTap = void Function(String data);

class Tag extends StatelessWidget {
  final String tag;
  final OnTap onTap;
  final double height;
  final double width;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  Tag({Key key, this.tag,this.width, this.onTap, this.height, this.margin, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 3),
      margin: margin ?? EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: Colors.pinkAccent[200], width: 1.5),
      ),
      child: StringUtils.isEmpty(tag)
          ? Text(tag,
              style: TextStyle(
                  fontSize: Style.font_16, color: Colors.pinkAccent[200]))
          : GestureDetector(
              onTap: () => null != onTap ? onTap(tag) : null,
              child: SingleLine(tag,
                  style: TextStyle(
                      fontSize: Style.font_16,
                      color: Colors.pinkAccent[200])),
            ),
    );
  }
}
