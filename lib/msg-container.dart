import 'package:flutter/material.dart';
import 'package:uiplay/msg-types/list.dart';
import 'package:uiplay/msg-types/menu.dart';
import './msg-types/text.dart';
import './model/msg.dart';

class MsgContainer extends StatelessWidget {
  IMsg item;
  var sendQuery; 
  MsgContainer(IMsg item, sendQuery) {
    this.item = item;
    this.sendQuery = sendQuery;
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
    }
    return msgs;
  }
  
  @override
  Widget build (BuildContext context) {
    return(
      Container(
        margin: EdgeInsets.fromLTRB(9.0, 13.0, 9.0, 5.0),
        child: Column(
          children: selectMsgType(),
        ),
      )
    );
  }
}