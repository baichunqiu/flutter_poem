///事件
class Event {
  Event(this.arg0, this.arg1);

  var arg0;
  var arg1;
}

///订阅者回调签名
typedef void EventCallback(Event e);

///定义一个top-level变量，页面引入该文件后可以直接使用bus
var bus = new EventBus();

class EventBus {
  //私有构造
  EventBus._internal();

  //单例
  static EventBus _singleton = new EventBus._internal();

  ///工厂构造函数
  factory EventBus() => _singleton;

  ///保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  var _emap = new Map<Object, List<EventCallback>>();

  //添加订阅者
  void on(eventName, EventCallback f) {
    if (eventName == null || f == null) return;
    _emap[eventName] ??= new List<EventCallback>();
    _emap[eventName].add(f);
  }

  ///移除订阅者
  void off(eventName, [EventCallback f]) {
    var list = _emap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _emap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  ///提交事件，事件触发后该事件所有订阅者会被调用
  void emit(eventName, [arg0, arg1]) {
    var list = _emap[eventName];
    if (list == null) return;
    int len = list.length - 1;
    //反向遍历，防止在订阅者在回调中移除自身带来的下标错位
    for (var i = len; i > -1; --i) {
      list[i](Event(arg0, arg1));
    }
  }
}


class EventTag {
  ///详情 会控
  static const String Event_Manager = "event_manager";

  ///标题栏 搜索事件
  static const String Event_Search_Poem = "event_search_poem";
  static const String Event_Search_Tag = "event_search_tag";
  static const String Event_Search_Ci = "event_search_songci";

  ///标题栏 日期事件
  static const String Event_Date = "event_date";

  ///详情 删除事件
  static const String Event_Delete = "event_delete";

  /// 详情 会议实体事件
  static const String Event_Details = "event_meet_details";

  ///Menu 切换事件
  static const String Event_Menu = "event_menu";

  ///home page select
  static const String Event_Page_Select = "event_Page_selected";

  /// 选择 会场
  static const String Event_Room = "event_room";

  /// 选择联系人
  static const String Event_Contact = "event_contact";

  ///选择 模板
  static const String Event_Module = "event_module";

  /// 会议创建 选择
  static const String Event_Create_Select = "event_create_selecte";

  /// 虚拟会议详情 事件
  static const String Event_Virtual_Details = "event_virtual_details";
}