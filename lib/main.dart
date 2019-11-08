import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:uiplay/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uiplay/screens/login/login.dart';
import 'package:uiplay/screens/profile/profile.dart';
import 'package:uiplay/services/parser.dart';
import 'msg-container.dart';
import './model/msg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './env.dart';

void main() => runApp(MyApp());

// List listData = [{'msg': 'Helo vinay, Good evening, how are you doing?', 'type': 'text', 'from': 'bot'}, {'msg': 'hello', 'type': 'text', 'from': 'user'}];

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: Color(0xFFb82e30),
      ),
      // home: MyHomePage(title: 'Assistance'),
      home: Login(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List list = [];
  List<IMsg> msgs = [];
  List<String> suggestions = [];
  String fieldValue = '';
  IUser user;
  bool loading = true;
  SharedPreferences prefs;
  ScrollController _scrollController = new ScrollController();
  TextEditingController _textEditingController = new TextEditingController();
  Parser msgParser = new Parser();
  final String _baseUrl = environment['baseUrl'];

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    this.initApp();
  }

  initApp() async {
    prefs = await SharedPreferences.getInstance();
    String loggedEmail = prefs.getString('user');
    print("loggedEmail");
    print(loggedEmail);
    if(loggedEmail?.isEmpty ?? true) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      this.user = IUser.fromJson(json.decode(loggedEmail));
    }
    this.connectToServer();
    setState(() {
      list = list;
    });
  }


  initBot() async {
    
  }


  onSendQuery(query) {
    print(_baseUrl + 'query');
    Map data = {
      "emailId": "vinay.bv@accionlabs.com",
      "empId": "393858000000126653",
      "msg": query,
      "uuid": "ssssss",

      "headers": {
        "employeeId": "1698",
        "role": "Admin"
      }
    };
    setState(() {
      loading = true;
    });
    http.post(_baseUrl + 'query', 
              headers: {"Content-Type": "application/json"},
              body: json.encode(data)).then((onValue) {
        print("Response send query");
        print(onValue.body);
        String _msg = onValue.body;
        _msg = this.msgParser.parseMsgVars(_msg, user);
        IMsg msg = IMsg.fromJson(json.decode(_msg));
        this.pushMsgs(msg);
        // this.msgs.add(msg);
        // setState(() {
        //   msgs = msgs;
        // });
        setState(() {
          loading = false;
        });
        this.scrollToBottom();
      },
    );
  }

  onSendButton() {
    print('on{ressed');
    print(fieldValue);
    this.pushMsgs(IMsg(msg: fieldValue, type: 'text', from: 'user'));
    // this.msgs.add(IMsg(msg: fieldValue, type: 'text', from: 'user'));
    //
    // setState(() {
    //   fieldValue = '';
    //   msgs = msgs;
    // });
    this.onSendQuery(fieldValue);
    this.scrollToBottom();

    // googleSignIn.signIn().then((result) {
    //   result.authentication.then((googleAuth) {
    //     final AuthCredential credential = GoogleAuthProvider.getCredential(
    //       accessToken: googleAuth.accessToken,
    //       idToken: googleAuth.idToken,
    //     );
    //     FirebaseAuth.instance.signInWithCredential(credential).then((user) {
    //       print(user);
    //     }).catchError((e) {
    //       print(e);
    //     });
    //   }).catchError((e) {
    //     print(e);
    //   });
    // }).catchError((e) {
    //   print(e);
    // });
  }

  pushMsgs(IMsg msg) {
    this.msgs.add(msg);
    setState(
      () {
        msgs = msgs;
        suggestions = msg.suggestions;
      },
    );
  }

  sendQuery(query) {
    this.pushMsgs(IMsg(msg: query, type: 'text', from: 'user'));
    // this.msgs.add(IMsg(msg: query, type: 'text', from: 'user'));
    // setState(() {
    //   msgs = msgs;
    // });
    this.scrollToBottom();
    this.onSendQuery(query);
  }

  scrollToBottom() {
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        _textEditingController.clear();
        this._scrollController.animateTo(
            this._scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300));
      },
    );
  }

  connectToServer() {
    http.get(_baseUrl + 'connect').then(
      (onValue) {
        print(onValue.body);
        IMsg msg = IMsg.fromJson(json.decode(onValue.body));
        // this.msgs.add(msg);
        // setState(() {
        //   msgs = msgs;
        // });
        setState(() {
          loading = false;
        });
        this.pushMsgs(msg);
      },
    );
  }

  navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Profile(user: this.user)),
    );
  }

  putSuggestions() {
    var listView = new ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: suggestions != null ? suggestions.length : 0,
      itemBuilder: (BuildContext context, int index) {
        return new InkWell(
          onTap: () {
            sendQuery(suggestions[index]);
          },
          child: new Container(
            margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
            padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
            // height: 30,
            decoration: BoxDecoration(
                border: Border.all(width: 0.8, color: Colors.black12),
                borderRadius: BorderRadius.all(Radius.circular(19))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  suggestions[index],
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    // fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if(suggestions != null && suggestions.length > 0) return new Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: listView,
    );
    return new Container(
      height: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: new Row(
          children: <Widget>[
            Image.asset(
              'assets/logo.png',
              width: 30,
            ),
            new Container(
              margin: EdgeInsets.fromLTRB(9, 0, 0, 0),
              child: Text(
                widget.title,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          new Row(
            children: <Widget>[
              GestureDetector(
                onTap: this.navigateToProfile,
                child: 
                  Hero(
                    tag: 'profile-avtar',
                    child:
                      new Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 11, 0),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            image: DecorationImage(
                              // fit: BoxFit.fitHeight,
                              image: NetworkImage((user != null ? user.photoUrl : ""))
                            ),
                          )
                      ),
                  ),
              )
              
            ],
          ),
        ],
        backgroundColor: Colors.white,
        toolbarOpacity: 0.7,
        elevation: 1.6,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: new ListView.builder(
                  controller: _scrollController,
                  itemCount: (msgs != null ? msgs.length : 0),
                  itemBuilder: (BuildContext context, int index) {
                    return new MsgContainer(
                      msgs[index], 
                      sendQuery, 
                      (index == msgs.length-1 && loading)
                    );
                  },
                ),
              )
            ),
            Container(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 0.5, color: Colors.black26)),
                ),
                child: Column(
                  children: <Widget>[
                    this.putSuggestions(),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Color(0xFFe9e9e9),
                                  //     offset: Offset(0, 0),
                                  //     spreadRadius: 1.0,
                                  //     blurRadius: 1.0
                                  //   ),
                                  // ]
                                ),
                                height: 50,
                                padding: EdgeInsets.fromLTRB(13, 0, 13, 0),
                                child: TextField(
                                  controller: _textEditingController,
                                  onChanged: (text) {
                                    fieldValue = text;
                                    setState(
                                      () {
                                        fieldValue = fieldValue;
                                      },
                                    );
                                  },
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: 'Ask something..',
                                    hintStyle:
                                        TextStyle(color: Color(0xFFBBBBBB)),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              new Positioned(
                                right: 0,
                                child: IconButton(
                                  disabledColor: Colors.black12,
                                  icon: Icon(
                                    Icons.send,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed:
                                      fieldValue == '' || fieldValue == null
                                          ? null
                                          : onSendButton,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
