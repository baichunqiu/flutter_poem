import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:poetry/widget/style.dart';

import 'Indicator.dart';
import 'event_bus.dart';
import 'load_page.dart';

class SmartListView extends StatefulWidget {
  static const String Refresh_Event = "SmartListPage_EventTa";
  final DataBuilder dataBuilder;
  final ItemBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;
  final OnComplete onComplete;

  SmartListView(
      {Key key,
      @required this.onComplete,
      @required this.dataBuilder,
      @required this.itemBuilder,
      this.separatorBuilder})
      : super(key: key) {
    assert(dataBuilder != null && itemBuilder != null);
  }

  @override
  State createState() => _SmartPageState();
}

class _SmartPageState extends State<SmartListView> {
  List<dynamic> _data = new List();
  bool _loading = false;

  @override
  void dispose() {
    super.dispose();
    bus.off(SmartListView.Refresh_Event, _callback);
  }

  EventCallback _callback;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _getData(DataType.refresh);
    _callback = (e) {
      _getData(DataType.refresh);
    };
    bus.on(SmartListView.Refresh_Event, _callback);
  }

  _getData(DataType refresh) async {
    widget.dataBuilder(refresh).then((arg) {
      if (mounted) {
        _refreshData(arg, refresh);
      }
    });
  }

  void _refreshData(List<dynamic> nets, DataType refrsh) {
    setState(() {
      if (DataType.refresh == refrsh) {
        _data.clear();
      }
      if (null != nets) {
        _data.addAll(nets);
      }
      if (_data.isNotEmpty && null != widget.onComplete) {
        widget.onComplete(_data);
      }
      print("_refreshData _data.length =  ${_data.length}");
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (null == _data || _data.isEmpty) {
      return GestureDetector(
        onTap: () {
          if (!_loading) _getData(DataType.refresh);
        },
        child: LoadPage(
          type: _loading ? Type.Loading : Type.NoData,
        ),
      );
    }
    return Container(
      alignment: Alignment.center,
      child: EasyRefresh(
          refreshHeader: Indicator.refreshHeader,
          refreshFooter: Indicator.loadFooter,
          autoLoad: true,
          onRefresh: () => _getData(DataType.refresh),
          loadMore: () => _getData(DataType.load),
          child: new ListView.separated(
            shrinkWrap: true,
            itemCount: _data.length,
            itemBuilder: (BuildContext context, int index) {
              var data = _data[index];
              return widget.itemBuilder(index, data);
            },
            separatorBuilder: (BuildContext context, int index) =>
                widget.separatorBuilder ??
                new Container(
                  color: Colors.blue[200],
                  height: Style.divide,
                ),
          )),
    );
  }
}
