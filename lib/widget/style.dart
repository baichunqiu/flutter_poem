import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Style {
  /// px -> sp
  static sp(double px) => ScreenUtil.getInstance().setSp(px);

  //分割线粗细
  static const double divide = .5;
  static const double divide_1 = 1.0;
  static final Color color_divide = Colors.blue[100];
  static final Widget divider = Container(color: color_divide, height: divide);
  static final Widget divider_1 =
      Container(color: color_divide, height: divide_1);
  static final Widget divider_v = Container(color: color_divide, width: divide);

  static final double font_16 = sp(26);
  static final double font_17 = sp(27);
  static final double font_18 = sp(28);
  static final double font_19 = sp(29);
  static final double font_20 = sp(30);
  static final double font_22 = sp(32);
  static final double font_24 = sp(34);

  static final Color color_blue = Color(0xFF2196F3);
  static final Color color_black = Color(0xFF333333);
  static final Color color_white = Color(0xFFFFFFFF);
  static final Color color_gray = Color(0xFF999999);

//  static final Color color_divider = Color(0xFFCCCCCC);

  static final TextStyle style_blue18 =
      TextStyle(fontSize: font_18, color: color_blue);
  static final TextStyle style_blue20 =
      TextStyle(fontSize: font_20, color: color_blue);
  static final TextStyle style_blue22 =
      TextStyle(fontSize: font_22, color: color_blue);
  static final TextStyle style_blue24 =
      TextStyle(fontSize: font_24, color: color_blue);

  static final TextStyle style_white18 =
      TextStyle(fontSize: font_18, color: color_white);
  static final TextStyle style_white20 =
      TextStyle(fontSize: font_20, color: color_white);
  static final TextStyle style_white22 =
      TextStyle(fontSize: font_22, color: color_white);
  static final TextStyle style_white24 =
      TextStyle(fontSize: font_24, color: color_white);

  static final TextStyle style_black18 =
      TextStyle(fontSize: font_18, color: color_black);
  static final TextStyle style_black20 =
      TextStyle(fontSize: font_20, color: color_black);
  static final TextStyle style_black22 =
      TextStyle(fontSize: font_22, color: color_black);
  static final TextStyle style_black24 =
      TextStyle(fontSize: font_24, color: color_black);

  static final TextStyle style_gray16 =
      TextStyle(fontSize: font_16, color: color_gray);
  static final TextStyle style_gray18 =
      TextStyle(fontSize: font_18, color: color_gray);
  static final TextStyle style_gray19 =
      TextStyle(fontSize: font_19, color: color_gray);
  static final TextStyle style_gray20 =
      TextStyle(fontSize: font_20, color: color_gray);
}
