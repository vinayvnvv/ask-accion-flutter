import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uiplay/constants/icons.dart';
import 'package:uiplay/model/menu.dart';
import 'package:uiplay/model/people-list.dart';
import './../model/msg.dart';
class PeopleListMsg extends StatelessWidget {
  IMsg msg;
  var sendQuery;
  PeopleListMsg(IMsg msg, sendQuery) {
    this.msg = msg;
    this.sendQuery = sendQuery;
    print(this.msg);
  }

  listItem(List<IPoepleList> peoples, BuildContext context) {
    final lists = <Widget>[];
    for(var i=0;i<peoples.length;i++) {
      IPoepleList peopleItem = peoples[i];
      lists.add(
        new Material(
          color: Colors.white,
          child: new InkWell(
            onTap: () {
              sendQuery(peopleItem.EmailID);
            },
            child: new Container(
              padding: EdgeInsets.fromLTRB(17, 5, 13, 5),
              width: MediaQuery.of(context).size.width,

              decoration: new BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: (peoples.length == (i+1) ? 0 : 0.4),
                    color: (peoples.length != (i+1) ? Color(0xFFe3e3e3) : Colors.transparent)
                  )
                ),
                // borderRadius: BorderRadius.all(Radius.circular(11.0))
              ),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 11, 0),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            image: DecorationImage(
                              // fit: BoxFit.fitHeight,
                              image: NetworkImage((peopleItem.Photo != null ? peopleItem.Photo : ""))
                            ),
                          )
                        ),
                    ],
                  ),
                  new Container(
                    padding: EdgeInsets.all(11),
                    child: 
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                              child: new Text(peopleItem.FirstName + " " + peopleItem.LastName, 
                                style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          new Container(
                            margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                            width: MediaQuery.of(context).size.width*0.67,
                            child: new Text(
                                peopleItem.EmailID,
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 12,
                                ),
                              ),
                          )
                        ],
                      ),
                  )
                ],
              )
            )
          )
        )
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
            children: listItem(msg.peopleList, context),
          )
        )
      ),
    );
    
    
  }
}