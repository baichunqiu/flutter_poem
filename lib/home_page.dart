import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poetry/poem_page.dart';
import 'package:poetry/songci_page.dart';
import 'package:poetry/tag_page.dart';
import 'package:poetry/utils/db.dart';
import 'package:poetry/widget/event_bus.dart';
import 'package:poetry/widget/style.dart';
import 'package:provider/provider.dart';

class AppModel with ChangeNotifier {
  int _countSi = 0;
  int _countCi = 0;

  int get count_si => _countSi;

  int get count_ci => _countCi;

  count({int si, int ci}) {
    _countCi = ci;
    _countSi = si;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  var _pageController = new PageController(initialPage: 0);

  final AppModel model = AppModel();

  @override
  void initState() {
    super.initState();
    db.count(Tab_Poem).then((count) {
      db.count(Tab_Ci).then((ci) {
        model.count(si: count, ci: ci);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 720, height: 1280)..init(context);
    return ChangeNotifierProvider.value(
      value: model,
      child: Scaffold(
        appBar: AppBar(
          title: _selectedIndex == 2
              ? Text("标签")
              : Consumer<AppModel>(
                  builder: (c, model, _) {
                    print("Consumer build");
                    return Text.rich(
                      TextSpan(children: [
                        TextSpan(text: _selectedIndex == 0 ? "唐诗 " : "宋词 "),
                        TextSpan(
                            text: _selectedIndex == 0
                                ? model.count_si == 0
                                    ? ""
                                    : "（共 ${model.count_si}首）"
                                : model.count_ci == 0
                                    ? ""
                                    : "（共 ${model.count_ci}篇）",
                            style: Style.style_white18),
                      ]),
                    );
                  },
                ),
        ),
        body: PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            itemCount: 3,
            itemBuilder: (con, index) {
              switch (index) {
                case 0:
                  return PoemPage();
                case 1:
                  return SongCiPage();
                case 2:
                  return TagPage();
              }
            }),
        bottomNavigationBar: BottomNavigationBar(
          // 底部导航
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.movie_filter), title: Text('唐诗')),
            BottomNavigationBarItem(
                icon: Icon(Icons.translate), title: Text('宋词')),
            BottomNavigationBarItem(
                icon: Icon(Icons.turned_in_not), title: Text('标签')),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.blue,
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showEditDialog(),
          child: Text(
              "搜索\n${_selectedIndex == 2 ? "标签" : _selectedIndex == 0 ? "唐诗" : "宋词"}",
              style: Style.style_white18),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  TextEditingController _controller = new TextEditingController();

  void _showEditDialog() {
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
                title: Text(
                  "搜索${_selectedIndex == 2 ? "标签" : _selectedIndex == 0 ? "唐诗" : "宋词"}",
                ),
                content: TextFormField(
                  style: Style.style_blue24,
                  controller: _controller,
                  maxLength: 10,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: _selectedIndex == 2 ? "标签" : "作者、名称、诗文、标签",
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
                      bus.emit(
                          _selectedIndex == 2
                              ? EventTag.Event_Search_Tag
                              : _selectedIndex == 0
                                  ? EventTag.Event_Search_Poem
                                  : EventTag.Event_Search_Ci,
                          info);
                      _controller.text = "";
                    },
                  )
                ]));
  }
}
