import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uiplay/constants/colors.dart';
import 'package:uiplay/msg-types/list-view.dart';
import 'package:uiplay/msg-types/list.dart';
import 'package:uiplay/msg-types/menu.dart';
import 'package:uiplay/msg-types/people-list.dart';
import 'package:url_launcher/url_launcher.dart';
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

  selectMsgType(context) {
    final msgs = <Widget>[];
    if (item.msg != null && item.type != 'text') {
      msgs.add(new TextMsg(item));
    }
    switch (item.type) {
      case 'text':
        msgs.add(new TextMsg(item));
        break;
      case 'menu':
        msgs.add(new MenuMsg(item, sendQuery));
        break;
      case 'list':
        msgs.add(new ListMsg(item, sendQuery));
        break;
      case 'listView':
        msgs.add(new ListViewMsg(item, sendQuery));
        break;
      case 'people-list':
        msgs.add(new PeopleListMsg(item, sendQuery));
        break;
    }
    if(item.from == 'bot') {
      Widget links = this.addLinks(item, context);
      if(links != null) msgs.add(links);
    }
    return msgs;
  }

  addLinks(IMsg msg, context) {
    List<Widget> widgets = [];
    // phone number match
    var phoneMatch = new RegExp(r'(?:[+0]9)?[0-9]{10}').stringMatch(msg.msg);
    if(phoneMatch != null) {
      widgets.add(InkWell(
        child: Row(
          children: <Widget>[
            Icon(Icons.phone_forwarded, color: Colors.blue, size: 15,),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(phoneMatch, style: TextStyle(
                color: Colors.blue
              ),),
            )
          ],
        ),
        onTap: () async {
          String url = 'tel:$phoneMatch';
          if(await canLaunch(url)) {
            launch(url);
          }
        },
      ));
    }
    if(msg.phoneNumber.length != 0) {
      print('phoneNumber match-->$msg.phoneNumber');
      for(var i=0; i<msg.phoneNumber.length; i++) {
        print('phoneNumber-->$msg.phoneNumber[i]');
        widgets.add(InkWell(
        child: Row(
          children: <Widget>[
            Icon(Icons.phone_forwarded, color: Colors.blue, size: 15,),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(msg.phoneNumber[i], style: TextStyle(
                color: Colors.blue
              ),),
            )
          ],
        ),
        onTap: () async {
          String url = 'tel:$msg.phoneNumber[i]';
          if(await canLaunch(url)) {
            launch(url);
          }
        },
      ));
      };
    }
    var urlMatch = new RegExp(r'(http|https)\:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?').stringMatch(msg.msg);
    if(urlMatch != null) {
      widgets.add(InkWell(
        child: Row(
          children: <Widget>[
            Icon(Icons.exit_to_app, color: Colors.blue, size: 15,),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(urlMatch, style: TextStyle(
                color: Colors.blue
              ),),
            )
          ],
        ),
        onTap: () async {
          String url = '$urlMatch';
          if(await canLaunch(url)) {
            launch(url);
          }
        },
      ));
    }
    return widgets.length > 0 ? 
      new Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.77,
          padding: EdgeInsets.fromLTRB(14.0, 11.0, 14.0, 11.0),
          // decoration: BoxDecoration(
          //     border: Border.all(
          //         width: 0.7,
          //         color: Colors.black12),
          //     borderRadius: BorderRadius.all(Radius.circular(19.0))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          ),
        )
      ) : null;
  }

  showLoader() {
    // return (loading ? new Container(
    //         child: new Row(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: <Widget>[
    //             new Container(
    //               decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.all(Radius.circular(30)),
    //                 border: Border.all(
    //                   color: Color(0xFFf1f1f1),
    //                   width: 0.7
    //                 )
    //               ),
    //               child: new Row(
    //                 // crossAxisAlignment: CrossAxisAlignment.center,
    //                 // mainAxisAlignment: MainAxisAlignment.center,
    //                 children: <Widget>[
    //                   new Container(
    //                     padding: EdgeInsets.fromLTRB(13, 12, 13, 12),
    //                     // child: new Text('. . .', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),),
    //                     child: MsgLoader(),
    //                   )
    //                 ],
    //               ),
    //             )
    //           ],
    //         ),
    //     ) : new Container()
    //   );
    return (loading ? new Container(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border: Border.all(
                      color: Color(0xFFf8f8f8),
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
                        child: SpinKitChasingDots(
                          size: 20,
                          color: COLORS['primary'],
                        ),
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
              children: selectMsgType(context),
            ),
            this.showLoader(),
          ],
        ),
      )
    );
  }
}
