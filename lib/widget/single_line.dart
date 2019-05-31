import 'package:flutter/material.dart';
import 'package:poetry/widget/style.dart';

///单行显示 Text
class SingleLine extends StatelessWidget {
  final String data;
  final TextOverflow overflow;
  final TextStyle style;
  final TextAlign textAlign;

  const SingleLine(
    this.data, {
    Key key,
    this.style,
    this.textAlign = TextAlign.center,
    this.overflow = TextOverflow.ellipsis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: 1,
      textAlign: textAlign,
      overflow: overflow,
      style: style ?? Style.style_blue20,
    );
  }
}
