import 'package:flutter/material.dart';

import 'package:uiplay/model/msg.dart';
import 'package:uiplay/model/leave_balance.dart';

class LeaveBalanceListMsg extends StatelessWidget {
  IMsg msg;
  var sendQuery;

  LeaveBalanceListMsg(IMsg msg, sendQuery) {
    this.msg = msg;
    this.sendQuery = sendQuery;
    print(this.msg);
  }

  listViewItem(List<BalanceListView> leaveBalance, BuildContext context) {
    final lists = <Widget>[];
    for (var i = 0; i < leaveBalance.length; i++) {
      BalanceListView levBalance = leaveBalance[i];

      lists.add(
        new Material(
          color: Colors.white,
          child: new InkWell(
            child: new Container(
              padding: EdgeInsets.all(19),
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: (leaveBalance.length == (i + 1) ? 0 : 0.7),
                      color: (leaveBalance.length != (i + 1)
                          ? Color(0xFFe3e3e3)
                          : Colors.transparent)),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        levBalance.title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        levBalance.desc,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return lists;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
      child: Card(
        elevation: 1.5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          child: new Column(
            children: listViewItem(msg.leaveBalance, context),
          ),
        ),
      ),
    );
  }
}
