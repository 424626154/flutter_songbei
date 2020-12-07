
import 'package:flutter/foundation.dart';

class App with ChangeNotifier, DiagnosticableTreeMixin {
  String userid = '';

  void saveUserId(userid){
    this.userid = userid == null?'':userid;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('userid',userid));
  }
}