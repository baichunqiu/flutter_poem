import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'load/animated_rotation_box.dart';

enum Type { Loading, NoData }

///加载动画
class LoadPage extends StatelessWidget {
  static final double def_radius = ScreenUtil.getInstance().setHeight(60);
  static final double def_fort_size = ScreenUtil.getInstance().setSp(30);
  static final Color err_color = Colors.blueGrey[300];

  ///半径缩放比 参照：42 默认：1.0
  final double radiusScale;

  ///进度条颜色渐变数组
  final Color color;

  /// 文字字号缩放比例  参照 21 默认 1.0
  final double fontScale;

  ///加载状态
  final Type type;

  LoadPage({
    Key key,
    this.color = Colors.blue,
    this.radiusScale = 1.0,
    this.fontScale = 1.0,
    this.type = Type.Loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ScreenUtil.getInstance().setHeight(150)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          type == Type.Loading
              ? AnimatedRotationBox(
                  duration: Duration(milliseconds: 800),
                  child: Icon(
                    PadIcons.loading0,
                    size: def_radius * radiusScale,
                    color: color,
                  ),
                )
              : Icon(
                  Icons.info_outline,
                  color: err_color,
                  size: def_radius * radiusScale * radiusScale * 1.3,
                ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              type == Type.Loading ? "加载中..." : "没有数据 !",
              style: TextStyle(
                  color: type == Type.Loading ? color : err_color,
                  fontSize: def_fort_size * fontScale),
            ),
          ),
        ],
      ),
    );
  }
}

class PadIcons {
  /// 自定义load iconData
  static const IconData loading0 =
      const IconData(0xe65e, fontFamily: 'PadIcon', matchTextDirection: true);
  static const IconData loading1 =
      const IconData(0xe61c, fontFamily: 'PadIcon', matchTextDirection: true);
  static const IconData loading2 =
      const IconData(0xe61f, fontFamily: 'PadIcon', matchTextDirection: true);
  static const IconData loading3 =
      const IconData(0xe68f, fontFamily: 'PadIcon', matchTextDirection: true);
}
