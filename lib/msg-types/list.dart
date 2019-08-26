import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './../model/msg.dart';

class ListMsg extends StatelessWidget {
  IMsg msg;
  var sendQuery;

  ListMsg(IMsg msg, sendQuery) {
    this.msg = msg;
    this.sendQuery = sendQuery;
    print(this.msg);
  }

  listItem(List<String> list, BuildContext context) {
    final lists = <Widget>[];
    for (var i = 0; i < list.length; i++) {
      String listItem = list[i];
      lists.add(
        new Material(
          color: Colors.white,
          child: new InkWell(
              onTap: () {
                sendQuery(listItem);
              },
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
                  child: new Text(listItem))),
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
            children: listItem(msg.list, context),
          ),
        ),
      ),
    );
  }
}
