import 'package:uiplay/model/user.dart';

class Parser {
  parseMsgVars(String str, IUser user, IZohoUser zohoUser) {
    String result = str;
    result =  result.replaceAllMapped(
      new RegExp(r"(\[\[([A-Za-z0-9]+)\]\])"),
      (Match m)  {
        print(m[0]);
        if(m[0] == '[[firstName]]') return user.firstName;
        return m[0];
      }
    );
    print('parse msgs');
    print(result);
    result =  result.replaceAllMapped(
      new RegExp(r"(\[\[([A-Za-z0-9]+)\]\])"),
      (Match m)  {
        print(m[0]);
        if(m[0] == '[[reportingHr]]') return zohoUser.Business_HR;
        return "";
      }
    );
    return result;
  }
}