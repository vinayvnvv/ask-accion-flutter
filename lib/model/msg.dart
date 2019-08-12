// import 'package:uiplay/model/menu.dart';

import 'package:uiplay/model/people-list.dart';

import 'menu.dart';

class IMsg {
  String msg;
  String type;
  String from;
  List<IMenu> menu;
  List<String> suggestions;
  List<String> list;
  List<IPoepleList> peopleList;
  IMsg({this.msg, this.type, this.from, this.menu, this.suggestions, this.list, this.peopleList});

  factory IMsg.fromJson(Map<String, dynamic> json) {
    var menu = json['menu'] as List;
    var suggestions = json['suggestions'] as List;
    var peopleLists = json['peopleList'] as List;
    var list = json['list'] as List;
    List<IMenu> menuList = [];
    if(menu != null) menuList = menu.map((i) => IMenu.fromJson(i)).toList();
    List<IPoepleList> peopleList = [];
    if(peopleLists != null) peopleList = peopleLists.map((i) => IPoepleList.fromJson(i)).toList();
    return IMsg(
      msg: json['msg'],
      type: json['type'],
      from: json['from'],
      menu: menuList,
      suggestions: suggestions != null ? new List<String>.from(suggestions) : [],
      list: list != null ? new List<String>.from(list) : [],
      peopleList: peopleList,
    );
  }
  
}