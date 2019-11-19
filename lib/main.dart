import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:uiplay/constants/colors.dart';
import 'package:uiplay/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uiplay/screens/login/login.dart';
import 'package:uiplay/screens/profile/profile.dart';
import 'package:uiplay/services/common.service.dart';
import 'package:uiplay/services/http.service.dart';
import 'package:uiplay/services/native-actions.service.dart';
import 'package:uiplay/services/parser.dart';
import 'msg-container.dart';
import './model/msg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './env.dart';

void main() {
  runApp(MyApp());
}

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
  HttpService httpService = new HttpService();
  IZohoUser zohoUser;
  bool loading = true;
  String userRoleType = '';
  SharedPreferences prefs;
  ScrollController _scrollController = new ScrollController();
  TextEditingController _textEditingController = new TextEditingController();
  CommonService commonService = new CommonService();
  Parser msgParser = new Parser();
  SpeechRecognition _speech;
  bool _speechRecognitionAvailable;
  bool isBotConnected = false;
  String _currentSpeechLocale;
  var _voiceModalSheetContext;
  bool _isListening;
  String transcription;
  var _controller;
  NativeActions nativeActions = new NativeActions();

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
    String zohoUserRef = prefs.getString('zoho-user');
    print("loggedEmail");
    print(loggedEmail);
    initSpeech();
    if(loggedEmail?.isEmpty ?? true) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      this.user = IUser.fromJson(json.decode(loggedEmail));
      this.zohoUser = IZohoUser.fromJson(json.decode(zohoUserRef));
      this.refreshEmpDetails(user.email);
      initBot();
    }
    this.connectToServer();
    setState(() {
      list = list;
    });
  }


  initSpeech() {
    _speech = SpeechRecognition();
    _speech.setAvailabilityHandler((bool result) {
        print('rwsule voice');
        print(result);
        setState(() => _speechRecognitionAvailable = result);
    });
    _speech.setCurrentLocaleHandler((String locale) =>
        setState(() => _currentSpeechLocale = locale));
    _speech.setRecognitionStartedHandler(() 
      => setState(() => _isListening = true));
    _speech.setRecognitionResultHandler((String text) 
      {
         setState(() => transcription = text);
         print(text);
         
        //  Navigator.pop(context);
      });
    _speech.setRecognitionCompleteHandler(() 
      {
         print('completed-------> $_isListening');
         if(!this._isListening && this.transcription.length > 0) {
            sendQuery(this.transcription);
              setState(() {
                transcription = '';
            });
          }
          setState(() => _isListening = false);
         
         
        //  Navigator.pop(context);
      });
    _speech
      .activate()
      .then((res) => setState(() => _speechRecognitionAvailable = res)).catchError((onError) {
        print('Errr');
        print(onError);
      });
  }


  initBot() async {
    setState(() {
      userRoleType = commonService.getEmpAccessType(this.zohoUser.Department);
    });
  }


  onSendQuery(query) {
    print(_baseUrl + 'query');
    Map data = {
      "emailId": this.user.email,
      "empId": this.zohoUser.empId,
      "msg": query,
      "uuid": "ssssss",

      "headers": {
        "employeeId": this.zohoUser.EmployeeID,
        "role": this.userRoleType,
        // "role": 'Admin',
        "hr": this.zohoUser.Business_HR,
        "version": environment['appVersion']
      }
    };
    setState(() {
      loading = true;
      fieldValue = '';
    });
    http.post(_baseUrl + 'query', 
              headers: {"Content-Type": "application/json"},
              body: json.encode(data)).then((onValue) {
        print("Response send query");
        print(onValue.body);
        String _msg = onValue.body;
        _msg = this.msgParser.parseMsgVars(_msg, user, zohoUser);
        IMsg msg = IMsg.fromJson(json.decode(_msg));
        this.pushMsgs(msg);
        // this.msgs.add(msg);
        // setState(() {
        //   msgs = msgs;
        // });
        this.nativeActions.doAction(msg);
        setState(() {
          loading = false;
        });
        
        if(msg.listView.length > 5)
          this.scrollToBottom(this._scrollController.position.pixels + MediaQuery.of(context).size.height - 200);
        else this.scrollToBottom();
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
    print('sendQuery callled--------_>');
    this.pushMsgs(IMsg(msg: query, type: 'text', from: 'user'));
    // this.msgs.add(IMsg(msg: query, type: 'text', from: 'user'));
    // setState(() {
    //   msgs = msgs;
    // });
    this.scrollToBottom();
    this.onSendQuery(query);
  }

  scrollToBottom([position]) {
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        _textEditingController.clear();
        this._scrollController.animateTo(
            position != null ? position : this._scrollController.position.maxScrollExtent,
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
          isBotConnected = true;
        });
        this.pushMsgs(msg);
      },
    );
  }

  navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Profile(user: this.user, zohoUser: this.zohoUser,)),
    );
  }

  refreshEmpDetails(String email) async {
    this.httpService.getEmp(email).then((onValue){
      print("onValue");
      print(onValue.body);
      IZohoUser zohoUserInstance = IZohoUser.fromJson(json.decode(onValue.body));
      prefs.setString('zoho-user', json.encode(zohoUser.toJson()));
      setState(() {
        loading = false;
        zohoUser = zohoUserInstance;
      });
    });
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

  recordVoice(BuildContext context) {
    print(this._speechRecognitionAvailable);
    print(this._currentSpeechLocale);
    _speech.listen(locale:this._currentSpeechLocale).then((onValue)=>print('result----------->: $onValue'));
    
    // this._controller = showModalBottomSheet(
    //   context: context,
    //   // backgroundColor: Colors.transparent,
    //   builder: (BuildContext bc) {
    //     return Container(
    //       height: 80,
    //       // width: MediaQuery.of(context).size.width,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           Container(
    //             height: 40,
    //             padding: EdgeInsets.only(top: 12),
    //             child: Text(transcription != null ? transcription : 'Say Something...', style: TextStyle(
    //               color: Colors.black26,
    //               fontWeight: FontWeight.w500
    //             ),),
    //           ),
    //           Container(
    //             height: 40,
    //             child: SpinKitRipple(
    //                     color: COLORS['primary'],
    //                     size: 50.0,
    //                     duration: Duration(milliseconds: 1200),
    //                   ),
    //           )
              
    //         ],
    //       ),
    //     );
    //   }
    // ).whenComplete(() {
    //   print('modal closed');
    //   _speech.cancel().then((onValue){
    //     print('result text');
    //     setState(() {
    //       transcription = null;
    //     });
    //     print(onValue);
    //   });
    //   this._speech.stop();
    // });
  }

  getVoiceBtnHandler() {
    if(this._isListening == true) return Container(
      child: SpinKitRipple(
        color: COLORS['primary'],
      )
    );
    else return IconButton(
                  disabledColor: Colors.black12,
                  icon: Icon(
                    Icons.keyboard_voice,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    recordVoice(context);
                    setState(() {
                      _isListening = true;
                    });
                  });
  }

  getInputHandle() {
     return TextField(
                  controller: _textEditingController,
                  onChanged: (text) {
                    fieldValue = text;
                    setState(
                      () {
                        fieldValue = fieldValue;
                      },
                    );
                  },
                  readOnly: this._isListening == true,
                  style: TextStyle(
                      fontSize: 18, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: this._isListening == true ? (this.transcription != null && this.transcription != '') ? this.transcription : 'Say Something...' : 'Ask something..',
                    hintStyle:
                        TextStyle(color: Color(0xFFBBBBBB)),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                );
  }

  @override
  Widget build(BuildContext _context) {
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
                'Ask Accion',
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
      body: Builder(
        builder: (BuildContext context) {
          return Center(
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
                        this.isBotConnected == true ?
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
                                    child: this.getInputHandle(),
                                  ),
                                  new Positioned(
                                    right: 0,
                                    child: (fieldValue != '' && fieldValue != null) ? 
                                              IconButton(
                                                disabledColor: Colors.black12,
                                                icon: Icon(
                                                  Icons.send,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                                onPressed:
                                                    fieldValue == '' || fieldValue == null
                                                        ? null
                                                        : onSendButton,
                                              ) : this.getVoiceBtnHandler()
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ) : (
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SpinKitThreeBounce(
                                  size: 30,
                                  color: Colors.black12,
                                )
                              ],
                            ),
                          ) 
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ); //
        }
      )
    );
  }
}
