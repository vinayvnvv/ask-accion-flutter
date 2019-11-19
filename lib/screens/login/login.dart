import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uiplay/main.dart';
import 'package:uiplay/model/user.dart';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uiplay/services/http.service.dart';
import './start.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginAppState();
  }
}

class _LoginAppState extends State<Login> {
  IUser user;
  bool isLoggenIn = true;
  bool loading = false;
  SharedPreferences prefs;
  HttpService http = new HttpService();
  GoogleSignIn _googleSignIn = new GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    initApp();
  }

  initApp() async {
    prefs = await SharedPreferences.getInstance();
    String loggedEmail = prefs.getString('user');
    print("loggedEmail");
    print(loggedEmail);
    if(!(loggedEmail?.isEmpty ?? true)) {
      navigateToHome();
      setState(() {
        isLoggenIn = false;
      });
    } else {
      setState(() {
        isLoggenIn = false;
      });
    }
  }

  navigateToHome() {
    setState(() {
      isLoggenIn = true;
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(
      title: 'Assistance',
    )));
  }

  Future<FirebaseUser> _signIn(context) async {
    setState(() {
      loading = true;
    });

    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    _auth.signInWithCredential(credential).then((onValue) {
      String domain = onValue.email.split('@')[1];
      if(domain != 'accionlabs.com') {
        showDialog(
          context: context,
          builder: (BuildContext ctxt) {
            return AlertDialog(
              title: Text('Invalid Mail!'),
              content: Text('Email domain should be @accionlabs.com'),
            );
          }
        );
        setState(() {
          loading = false;
        });
        return;
      }
      print("onValue -> ${onValue}");
      IUser _user = IUser(
            displayName: onValue.displayName, 
            photoUrl: onValue.photoUrl,
            email: onValue.email,
            firstName: onValue.displayName.substring(0, onValue.displayName.indexOf(" "))
          );
      prefs.setString('user', json.encode(_user.toJson()));
      print('set auth--> ${_user.toJson().toString()}');
      getEmpDetails(onValue.email, context);
      print("end login");
      setState(() {
        user = _user;
      });

    }).catchError((onError) {
      print(onError);
      setState(() {
        loading = false;
      });
    });
  }

  getEmpDetails(String email, context) async {
    this.http.getEmp(email).then((onValue){
      print("onValue");
      print(onValue.body);
      IZohoUser zohoUser = IZohoUser.fromJson(json.decode(onValue.body));
      prefs.setString('zoho-user', json.encode(zohoUser.toJson()));
      setState(() {
        loading = false;
      });
      finishLogin(context, zohoUser);
    });
  }


  finishLogin(context, IZohoUser zohoUser) {
    navigateToStartPage(zohoUser);
  }

  navigateToStartPage(IZohoUser zohoUser) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartAppPage(
      zohoUser: zohoUser,
      googleUser: this.user,
    )));
  }

  createInputLayout() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: EdgeInsets.only(top: 19),
        padding: EdgeInsets.all(13),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFFf0f0f0)
          ),
          borderRadius: BorderRadius.all(Radius.circular(27))
        ),
        child: TypewriterAnimatedTextKit(
          onTap: () {
              print("Tap Event");
            },
          text: [
            "Apply Working from home today",
            "My Sick Leave Balance?",
            "My Attendence of last month",
            "My Applied Leaves",
          ],
          textStyle: TextStyle(
              fontSize: 12.0,
              fontFamily: "Agne",
          ),
          textAlign: TextAlign.start,
          alignment: AlignmentDirectional.topStart // or Alignment.topLeft
        ),
      ),
    );
  }
  msgLayout() {
    List<Widget> layout = [];
    for(var i=0;i<5;i++) {
      layout.add(
        new Row(
          mainAxisAlignment: (i%2) == 0 ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: <Widget>[
            new Container(
              width: 60,
              height: 38,
              decoration: BoxDecoration(
                color: Color(0xFFf4f4f4),
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
            )
          ],
        )
      );
    }
    layout.add(createInputLayout());
    return layout;
  }
  createChatLayout() {
    return new Container(
      padding: EdgeInsets.fromLTRB(17, 23, 17, 23),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFFe9e9e9)
        ),
        borderRadius: BorderRadius.all(Radius.circular(11))
      ),
      child: Column(
              children: msgLayout(),
            ),
    );
  }
  mainLayout(context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          Image.asset(
            'assets/logo.png',
            width: 50,
          ),
          Container(
            margin: EdgeInsets.only(top: 3),
            child: Text('Ask Accion', style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 23,
                letterSpacing: -0.99
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(30),
            child: createChatLayout()
          ),
          Container(
            margin: EdgeInsets.only(top: 11),
            child: FlatButton(
                padding: EdgeInsets.fromLTRB(21, 13, 21, 13),
                child: this.loading ? CircularProgressIndicator() : Text('Sign In with Google'),
                color:Color(0xFF000000),
                textColor: Colors.white,
                onPressed: this.loading ? null : (){_signIn(context);},
            ),
          )
          
        ],),
      ));
  }
  loaderLayout() {
    return new Container(
      color: Colors.white,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text('Loading..', style: TextStyle(
            color: Colors.black54,
            decoration: TextDecoration.none,
            fontSize: 12,
          ),)
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext _context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return !isLoggenIn ? this.mainLayout(context) : this.loaderLayout();
        }
      )
    );
  }
}