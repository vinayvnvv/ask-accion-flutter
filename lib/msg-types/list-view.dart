import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uiplay/model/list-view.dart';
import './../model/msg.dart';

class ListViewMsg extends StatelessWidget {
  IMsg msg;
  var sendQuery;

  ListViewMsg(IMsg msg, sendQuery) {
    this.msg = msg;
    this.sendQuery = sendQuery;
    print(this.msg);
  }

  createViews(IListView item) {
    List<Widget> widget = [];
    if(!(item.title?.isEmpty ?? true)) widget.add(
      new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Text(item.title, textAlign: TextAlign.left, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 16),)
        ],
      )
    );
    if(!(item.desc?.isEmpty ?? true)) widget.add(
      new Container(
        margin: EdgeInsets.only(top: 7),
        child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Text(item.desc, textAlign: TextAlign.left, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w400),)
        ],
      ),
      )
      
    );
    List<Widget> sections = [];
    if(!(item.sections?.isEmpty ?? true)) {
      for(var i=0;i<item.sections.length;i++) {
        String txt = item.sections[i];
        sections.add(
          new Container(
              margin: EdgeInsets.only(top: 7),
              child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Text(txt, textAlign: TextAlign.left, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w300,fontSize: 12),)
              ],
            ),
            )
          );
      }
    }
    if(sections.length > 0) {
      widget.add(new Column(children: sections,));
    }
    return widget;
  }

  listItem(List<IListView> list, BuildContext context) {
    final lists = <Widget>[];
    for (var i = 0; i < list.length; i++) {
      IListView listItem = list[i];
      lists.add(
        new Material(
          color: Colors.white,
          child: new InkWell(
              onTap: null,
              child: new Container(
                  padding: EdgeInsets.all(19),
                  width: MediaQuery.of(context).size.width,
                  decoration: new BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          width: (list.length == (i + 1) ? 0 : 0.7),
                          color: (list.length != (i + 1)
                              ? Color(0xFFe3e3e3)
                              : Colors.transparent)),
                    ),
                    // borderRadius: BorderRadius.all(Radius.circular(11.0))
                  ),
                  child: new Column(
                    children: this.createViews(listItem),
                  ))),
        ),
      );
      // if(menus.length != (i+1)) {
      //   lists.add(
      //     new Divider(
      //       color: Color(0xFFe3e3e3),
      //     )
      //   );
      // }
    }
    return lists;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      margin: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
      child: Card(
        elevation: 1.5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          // margin: EdgeInsets.fromLTRB(0.0, 19.0, 0.0, 8.0),
          // padding: EdgeInsets.fromLTRB(11.0, 0.0, 11.0, 0.0),
          width: MediaQuery.of(context).size.width,
          // decoration: new BoxDecoration(
          //   border: Border.all(
          //     width: 1.0,
          //     color: Color(0xFFe3e3e3)
          //   ),
          // borderRadius: BorderRadius.all(Radius.circular(11.0)),
          //   // boxShadow: [
          //   //   BoxShadow(
          //   //     // color: Color(0xFFe9e9e9),
          //   //     offset: Offset(0, 2),
          //   //     spreadRadius: 1.0,
          //   //     blurRadius: 2.0
          //   //   ),
          //   // ],
          // ),
          child: new Column(
            children: listItem(msg.listView, context),
          ),
        ),
      ),
    );
  }
}
