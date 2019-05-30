import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

///数据构建器
typedef DataBuilder = Future<List<dynamic>> Function(DataType type);

/// item widget 构建器
typedef ItemBuilder = Widget Function(int index, dynamic item);

/// 数据加载完毕回调
typedef OnComplete = Future<void> Function(List<dynamic>);

enum DataType {
  /// 刷新获取  需要更新缓存
  refresh,

  ///加载更多 数据
  load,

  ///可以使用缓存
  cache
}

class Indicator {
  static const double height = 48.0;
  static const Color def_color = Colors.blue;

  static final GlobalKey<RefreshFooterState> key_def_footer =
      new GlobalKey<RefreshFooterState>();
  static final GlobalKey<RefreshHeaderState> key_def_header =
      new GlobalKey<RefreshHeaderState>();
  static final GlobalKey<EasyRefreshState> key_easy_def =
      new GlobalKey<EasyRefreshState>();

  static final ClassicsFooter loadFooter = new ClassicsFooter(
      key: key_def_footer,
      loadHeight: height,
      loadText: "上拉加载",
      loadReadyText: "松开加载",
      loadingText: "正在加载...",
      loadedText: "加载完成",
      noMoreText: "加载完成",
      moreInfo: "更新时间：",
      bgColor: Colors.blue);

  static final ClassicsHeader refreshHeader = new ClassicsHeader(
    key: key_def_header,
    refreshHeight: height,
    bgColor: def_color,
    refreshText: "下拉刷新",
    refreshReadyText: "松开刷新",
    refreshingText: "正在刷新...",
    refreshedText: "刷新完成",
    moreInfo: "更新时间：",
  );
}
