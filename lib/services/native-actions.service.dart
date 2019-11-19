import 'package:uiplay/model/msg.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class NativeActions {
  doAction(IMsg msg) async {
    if(msg.isCall == true && msg.phoneNumber.length > 0) {
      String url = "tel:8197600944";
      try {
        if(await UrlLauncher.canLaunch(url))
        await UrlLauncher.launch(url);
      } catch(err) {
        print(err);
      }
      
    }
  }
}