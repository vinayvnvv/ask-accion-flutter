import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uiplay/model/user.dart';

class Profile extends StatelessWidget {
  IUser user;
  Profile({Key key, @required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        brightness: Brightness.light,
        // title: Text("Second Route", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        child: new Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
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
                    new Container(
                      margin: EdgeInsets.only(top: 2),
                      child: new FlatButton(
                        onPressed: () {},
                        // color: Color(0xFFc9dbfc),
                        highlightColor: Color(0xFFe8f0fe),
                        splashColor: Color(0xFF689eff),
                        child: Text("Logout", style: TextStyle(
                          fontWeight: FontWeight.w800
                        ),),
                      )
                    )
                  ],
                )
              ],
            )
          ],)
          
        )
      )
    );
  }
}