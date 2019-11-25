import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uiplay/constants/colors.dart';
import 'package:uiplay/main.dart';
import 'package:uiplay/model/user.dart';
import 'package:uiplay/services/common.service.dart';

class StartAppPage extends StatefulWidget {
  IZohoUser zohoUser;
  IUser googleUser;
  StartAppPage({Key key, @required this.zohoUser, @required this.googleUser}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _StartAppPage()  ;
  }
}

class _StartAppPage extends State<StartAppPage> {
  CommonService commonService = new CommonService();
  firstPage(BuildContext context) {
    return Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 11, 0),
            height: 90,
            width: 90,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                image: DecorationImage(
                  // fit: BoxFit.fitHeight,
                  image: NetworkImage((widget.googleUser.photoUrl != null ? widget.googleUser.photoUrl : ''))
                ),
              )
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 21, 0, 5),
            child: Text('Welcome ' + widget.zohoUser.FirstName, style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500
            ),),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 21),
            child: Text( widget.zohoUser.EmailID, style: TextStyle(
              fontSize: 16,
              color: Colors.black45,
              fontWeight: FontWeight.w400
            ),),
          ),
          this.widget.zohoUser.accessType == 'Admin' ?
            Padding(
              padding: EdgeInsets.fromLTRB(0, 21, 0, 21),
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                decoration: BoxDecoration(
                  color: Color(0xFF52c41a),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Text('Logged In As Admin', style: TextStyle(
                  color: Color(0xFFffffff),
                  fontWeight: FontWeight.w600,
                  fontSize: 12
                ),),
              )
            ) : (
              Container()
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 41, 0, 21),
            child: RaisedButton(
              color: COLORS['secondary'],
              child: Text('Next'),
              textColor: COLORS['primary-invert'],
              onPressed: ()  {
                final TabController ctrl = DefaultTabController.of(context);
                if(!ctrl.indexIsChanging) {
                  ctrl.animateTo(1);
                }
              },
            )
          ),
        ],
      ),
    );
  }
  getTextStyle(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
      child: Row(
        children: <Widget>[
          Icon(Icons.arrow_right),
          Expanded(
            child: Text(text, style: TextStyle(
              color: Colors.black45
            ),),
          ),
          
        ],
      )
    );
  }
  secondPage(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(11, 11, 11, 11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: Colors.black12
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/logo.png',
            width: 50,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 21, 0, 21),
            child: Text('What You can Do?', style: TextStyle(
              fontSize: 26
            ),),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                getTextStyle("All FAQ's related queries to hr/it/project"),
                getTextStyle("Applying Leave"),
                getTextStyle('Leave related queries'),
                getTextStyle('Many Zoho related queries'),
                getTextStyle('Attendence informations'),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 101, 0, 21),
            child: RaisedButton(
              color: COLORS['secondary'],
              child: Text('Next'),
              textColor: COLORS['primary-invert'],
              onPressed: ()  {
                final TabController ctrl = DefaultTabController.of(context);
                if(!ctrl.indexIsChanging) {
                  ctrl.animateTo(2);
                }
              },
            )
          ),
        ],
      ),
    );
  }
  thirdPage() {
    return Container(
      padding: EdgeInsets.all(21),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.done_outline,
            color: Colors.black54,
            size: 64,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 31, 0, 11),
            child: Text("All Set Done!", style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500
             ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 31),
            child: Text("You Are now Ready to start the Assistance!", style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black45,
             ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 51, 0, 21),
            child: RaisedButton(
              color: COLORS['secondary'],
              child: Text('Start'),
              textColor: COLORS['primary-invert'],
              onPressed: ()  {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(
                  title: "Assistance",
                )));
              },
            )
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: DefaultTabController(
      length: 3,
      child: Builder(
        builder: (BuildContext context) => Padding(
          padding: EdgeInsets.fromLTRB(8.0, 38.0, 8.0, 38.0),
          child: Column(
            children: <Widget>[
              TabPageSelector(),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    this.firstPage(context),
                    this.secondPage(context),
                    this.thirdPage(),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
    
  }

}