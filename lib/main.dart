import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poetry/songcis.dart';
import 'package:poetry/tag_page.dart';
import 'package:poetry/widget/event_bus.dart';
import 'package:poetry/poetrys.dart';
import 'package:poetry/widget/style.dart';

import 'db.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '唐诗宋词'),
    );
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

  int _countPoem = 0;
  int _countSongCi = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db.count(Tab_Poem).then((count) {
      db.count(Tab_Ci).then((ci) {
        setState(() {
          _countPoem = count;
          _countSongCi = ci;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 720, height: 1280)..init(context);
    return Scaffold(
      appBar: AppBar(
        title: _selectedIndex == 2
            ? Text("标签")
            : Text.rich(TextSpan(children: [
                TextSpan(text: _selectedIndex == 0 ? "唐诗 " : "宋词 "),
                TextSpan(
                    text: _selectedIndex == 0
                        ? _countPoem == 0 ? "" : "（共 $_countPoem首）"
                        : _countSongCi == 0 ? "" : "（共 $_countSongCi篇）",
                    style: Style.style_white18),
              ])),
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
                return Poetrys();
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
        child: Text("搜索", style: Style.style_white24),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  TextEditingController _controller = new TextEditingController();

  void _showEditDialog() {
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
                title: Text(
                  "搜索${_selectedIndex == 0 ? "唐诗" : "宋词"} ",
                ),
                content: TextFormField(
                  style: Style.style_blue24,
                  controller: _controller,
                  maxLength: 10,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "作者、名称、诗文、标签",
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
                          _selectedIndex == 0
                              ? EventTag.Event_Search_Poem
                              : EventTag.Event_Search_Ci,
                          info);
                      _controller.text = "";
                    },
                  )
                ]));
  }
}
