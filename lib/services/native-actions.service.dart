import 'package:uiplay/model/msg.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class NativeActions {
  doAction(IMsg msg) async {
    if(msg.isCall == true && msg.phoneNumber.length > 0) {
      String url = "tel:" + msg.phoneNumber[0];
      try {
        if(await UrlLauncher.canLaunch(url))
        await UrlLauncher.launch(url);
      } catch(err) {
        print(err);
      }
      
    }
    print('msg action type-->');
    if(msg.action != null) {
      switch(msg.action.type) {
        case 'link': 
          this.lanchLink(msg.action);
          break;
      }
    }
  }
  lanchLink(IMsgAction action) async {
    print('Lanching link....');
    String url = '';
    if(action.linkType == 'url') url = action.linkUrl;
    try {
        if(await UrlLauncher.canLaunch(url))
        await UrlLauncher.launch(url);
      } catch(err) {
        print(err);
    }
  }
}