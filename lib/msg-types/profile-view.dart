import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uiplay/model/user.dart';
import './../model/msg.dart';

class ProfileViewMsg extends StatelessWidget {
  IMsg msg;

  ProfileViewMsg(IMsg msg) {
    this.msg = msg;
    print(this.msg);
  }

  generateRow(String key, String value, context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 9, 0, 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 33),
            width: MediaQuery.of(context).size.width * 0.35,
            child: Text(key.toUpperCase(),textAlign: TextAlign.left, style: TextStyle(
              color: Colors.black45,
            ),),
          ),
          Expanded(
            child: new GestureDetector(
              onLongPress: () {
                Clipboard.setData(new ClipboardData(text: value));
                final snackBar = SnackBar(
                    content: Text('Copied ' + key + ': ' + value),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
              },
              child: 
                Text(value, style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500
                ),
              )
            ),
          )
        ],
      ),
    );
  }

  getDivider() {
    return Divider(color: Color(0xFFe5e5e5));
  }

  createView(IZohoUser zohoUser, BuildContext context) {
    return new Column(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.fromLTRB(9, 9, 9, 27),
          child: new Text(zohoUser.FirstName + ' ' + zohoUser.LastName, style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600
          ),),
        ),
        generateRow('name', zohoUser.FirstName + " " + zohoUser.LastName, context),
        getDivider(),
        generateRow('Email ID', zohoUser.EmailID, context),
        getDivider(),
        generateRow('emp id', zohoUser.EmployeeID, context),
        getDivider(),
        generateRow('Project', zohoUser.Department, context),
        getDivider(),
        generateRow('Role', zohoUser.Role, context),
        getDivider(),
        generateRow('Birth Date', zohoUser.Birth_Date_as_per_Records, context),
        getDivider(),
        generateRow('Blood group', zohoUser.Bloodgroup, context),
        getDivider(),
        generateRow('Business HR', zohoUser.Business_HR, context),
        getDivider(),
        generateRow('location', zohoUser.LocationName, context),
        getDivider(),
        generateRow('Reporting To', zohoUser.Reporting_To, context),
        getDivider(),
        generateRow('Designation', zohoUser.Designation, context),
        getDivider(),
        generateRow('Mobile', zohoUser.Mobile, context),
        getDivider(),
        generateRow('Work Location', zohoUser.Work_location, context),
        getDivider(),
        generateRow('Experience', zohoUser.Experience + ' years', context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      margin: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
      padding: EdgeInsets.all(11),
      decoration: BoxDecoration(
        border: Border.all(
            width: 1.0,
            color: Color(0xFFd7d7d7)
          ),
        borderRadius: BorderRadius.all(Radius.circular(7))
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
        child: this.createView(this.msg.profileCard, context)
      ),
    );
  }
}
