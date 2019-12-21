// import 'package:uiplay/model/menu.dart';

import 'package:uiplay/model/list-view.dart';
import 'package:uiplay/model/people-list.dart';

import 'menu.dart';

class IMsg {
  String msg;
  String type;
  String from;
  bool isCall;
  bool resetSession;
  IMsgAction action;
  List<String> phoneNumber;
  List<IMenu> menu;
  List<String> suggestions;
  List<String> list;
  List<IPoepleList> peopleList;
  List<IListView> listView;
  IMsg({
    this.msg, 
    this.type, 
    this.from, 
    this.menu, 
    this.suggestions, 
    this.list, 
    this.peopleList, 
    this.listView, 
    this.isCall, 
    this.phoneNumber, 
    this.resetSession, 
    this.action
  });

  factory IMsg.fromJson(Map<String, dynamic> json) {
    var menu = json['menu'] as List;
    var suggestions = json['suggestions'] as List;
    var phoneNumbers = json['phoneNumber'] as List;
    var peopleLists = json['peopleList'] as List;
    var listViews = json['listView'] as List;
    var list = json['list'] as List;
    List<IMenu> menuList = [];
    if(menu != null) menuList = menu.map((i) => IMenu.fromJson(i)).toList();
    List<IPoepleList> peopleList = [];
    if(peopleLists != null) peopleList = peopleLists.map((i) => IPoepleList.fromJson(i)).toList();
    List<IListView> listView = [];
    if(listViews != null) listView = listViews.map((i) => IListView.fromJson(i)).toList();
    return IMsg(
      msg: json['msg'],
      type: json['type'],
      from: json['from'],
      menu: menuList,
      suggestions: suggestions != null ? new List<String>.from(suggestions) : [],
      list: list != null ? new List<String>.from(list) : [],
      peopleList: peopleList,
      listView: listView,
      resetSession: json['resetSession'] != null ? json['resetSession'] : false,
      phoneNumber: phoneNumbers != null ? new List<String>.from(phoneNumbers) : [],
      isCall: json['isCall'] != null ? json['isCall'] : false,
      action: json['action'] != null ? IMsgAction.fromJson(json['action']) : null,
    );
  }
  
}

class IMsgAction {
  String type;
  String linkType;
  String linkUrl;
  IMsgAction({this.type, this.linkType, this.linkUrl});

  factory IMsgAction.fromJson(Map<String, dynamic> json) {
    return IMsgAction(
      linkType: json['linkType'],
      linkUrl: json['linkUrl'],
      type: json['type'],
    );
  }
}