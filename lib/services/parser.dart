import 'package:uiplay/model/user.dart';

class Parser {
  parseMsgVars(String str, IUser user) {
    return str.replaceAllMapped(
      new RegExp(r"(\[\[([A-Za-z0-9]+)\]\])"),
      (Match m)  {
        print(m[0]);
        if(m[0] == '[[firstName]]') return user.firstName;
        return "";
      }
    );
  }
}