import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uiplay/model/user.dart';
import 'package:uiplay/screens/login/login.dart';

class Profile extends StatelessWidget {
  IUser user;
  IZohoUser zohoUser;
  Profile({Key key, @required this.user, @required this.zohoUser}) : super(key: key);
  generateRow(String key, String value, context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
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
            child: Text(value, style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500
            ),),
          )
        ],
      ),
    );
  }
  getDivider() {
    return Divider(color: Color(0xFFe5e5e5));
  }
  logout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
  }
  @override
  Widget build(BuildContext context) {
    print('zoho user--->');
    print(this.zohoUser);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              iconTheme: IconThemeData(
                color: Colors.black
              ),
              floating: false,
              pinned: true,
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("Profile",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      )),
                  background: Padding(
                    padding: EdgeInsets.fromLTRB(21, 61, 21, 31),
                    child: Column(children: <Widget>[
                          new Column(
                            children: <Widget>[
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                      Hero(
                                        tag: 'profile-avtar',
                                        child: 
                                          new Container(
                                            margin: EdgeInsets.fromLTRB(0, 0, 11, 0),
                                            height: 90,
                                            width: 90,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                                image: DecorationImage(
                                                  // fit: BoxFit.fitHeight,
                                                  image: NetworkImage((user != null ? user.photoUrl : ""))
                                                ),
                                              )
                                          ),
                                      )
                                      
                                  
                                ],
                              ),
                              new Column(
                                children: <Widget>[
                                  new Container(
                                    margin: EdgeInsets.only(top: 21),
                                    child: new Text(user.displayName, 
                                              style: TextStyle(
                                              fontSize: 22
                                    ),),
                                  ),
                                  new Container(
                                    margin: EdgeInsets.only(top: 2),
                                    child: new Text(user.email, 
                                              style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF777777)
                                    ),),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],)
                  )
                  ),
            ),
          ];
        },
        body: Center(
          child: Container(
            margin: EdgeInsets.all(11),
            padding: EdgeInsets.only(left: 11),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(11))
            ),
            child: ListView(
              children: <Widget>[
                generateRow('name', zohoUser.FirstName + " " + zohoUser.LastName, context),
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
                generateRow('Reporting HR', zohoUser.Business_HR, context),
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
                getDivider(),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 13, 0, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Sign Out'),
                        onPressed: () {
                          logout(context);
                        },
                      )
                    ],
                  ),
                )
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}