import 'package:flutter/material.dart';
import './../model/msg.dart';

class TextMsg extends StatelessWidget {
  IMsg msg;

  TextMsg(IMsg msg) {
    this.msg = msg;
    print(this.msg);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment:
          (msg.from == 'bot' ? MainAxisAlignment.start : MainAxisAlignment.end),
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(14.0, 11.0, 14.0, 11.0),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.77),
          decoration: BoxDecoration(
              color: (msg.from == 'bot' ? Colors.white : Color(0xFFF3F3F3)),
              border: Border.all(
                  width: (msg.from == 'bot' ? 0.7 : 0.0),
                  color: (msg.from == 'bot'
                      ? Color(0xFFe3e3e3)
                      : Colors.transparent)),
              borderRadius: BorderRadius.all(Radius.circular(19.0))),
          child: new Text(
            msg.msg,
            style: TextStyle(
                fontSize: 15,
                color: (msg.from == 'bot' ? Colors.black : Color(0xFF444444)),
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
