import 'package:flutter/material.dart';
import 'package:uiplay/msg-types/list.dart';
import 'package:uiplay/msg-types/menu.dart';
import 'package:uiplay/msg-types/people-list.dart';
import 'package:uiplay/widgets/jumping-dots.dart';
import 'package:uiplay/widgets/msg-loader.dart';
import './msg-types/text.dart';
import './model/msg.dart';

class MsgContainer extends StatelessWidget {
  IMsg item;
  var sendQuery; 
  var index;
  var msgLength;
  bool loading;
  MsgContainer(IMsg item, sendQuery, loading) {
    this.item = item;
    this.sendQuery = sendQuery;
    this.loading = loading;
  }

  selectMsgType() {
    final msgs = <Widget>[];
    if (item.msg != null && item.type != 'text') {
      msgs.add(new TextMsg(item));
    }
    switch (item.type) {
      case 'text': 
        msgs.add(new TextMsg(item));
        break;
      case 'menu':
        print("Inside menu");
        msgs.add(new MenuMsg(item, sendQuery));
        break;
      case 'list':
        print("Inside List");
        msgs.add(new ListMsg(item, sendQuery));
        break;
      case 'people-list':
        print("Inside People List");
        msgs.add(new PeopleListMsg(item, sendQuery));
        break;
    }
    return msgs;
  }

  showLoader() {
    return (loading ? new Container(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border: Border.all(
                      color: Color(0xFFd9d9d9),
                      width: 0.7
                    )
                  ),
                  child: new Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.fromLTRB(13, 12, 13, 12),
                        // child: new Text('. . .', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),),
                        child: MsgLoader(),
                      )
                      
                    ],
                  ),
                )
              ],
            ),
        ) : new Container()
      );
  }
  
  @override
  Widget build (BuildContext context) {
    return(
      Container(
        margin: EdgeInsets.fromLTRB(9.0, 13.0, 9.0, 5.0),
        child: Column(
          children: <Widget>[
            new Column(
              children: selectMsgType(),
            ),
            this.showLoader(),
          ],
        ),
      )
    );
  }
}