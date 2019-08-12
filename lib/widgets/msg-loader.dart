import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MsgLoader extends StatefulWidget {
  MsgLoader({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MsgLoader createState() => _MsgLoader();
}

class _MsgLoader extends State<MsgLoader> {
  @override
  var _opacity = 1.0;
  Timer _timer;

  

  @override
  void initState() {
    this.initAnim();
  }

  initAnim() {
    _timer = new Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _opacity = this._opacity == 1.0 ? 0.0 : 1.0;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  getAnimationWidget(milliseconds) {

    return AnimatedOpacity(
      duration: Duration(milliseconds: milliseconds),
      opacity: _opacity,
      child: new Container(
        width: 10,
        height: 10,
        margin: EdgeInsets.fromLTRB(3, 0, 3, 0),
        decoration: BoxDecoration(
          color: Color(0xFF888888),
          borderRadius: BorderRadius.all(Radius.circular(50))
        ),
      ),
    );
  }
  
  Widget build(BuildContext context) {
    // TODO: implement build
    List<Widget> list = [];
    list.add(this.getAnimationWidget(400));
    list.add(this.getAnimationWidget(500));
    list.add(this.getAnimationWidget(600));
    return Row(children: list);
  }
  
}