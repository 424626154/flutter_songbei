
import 'package:flutter/foundation.dart';

class User with ChangeNotifier, DiagnosticableTreeMixin  {
  String userid = '';
  String head = '';
  String nickname = '';
  String profile = '';
  int gender = 0;
  String birth_date = '';
  int myfollow = 0;
  int followme = 0;
  int fstate = 0;
  int tstate = 0 ;
  int vip_time = 0;

  User(){

  }
  User.initData(data){
    print(data['exp']);
    userid = data['userid'];
    head = data['head'];
    nickname = data['nickname'];
    profile = data['profile'];
    gender = data['gender'];
    birth_date = data['birth_date'];
    myfollow = data['myfollow'];
    followme = data['followme'];
//    starnum = data['starnum'];
    fstate = data['fstate'];
    tstate = data['tstate'];
//    discussnum = data['discussnum'];
    vip_time = data['vip_time'];
  }

  void upUser(data){
    print(data);
    this.userid = data['userid'];
    this.head = data['head'];
    this.nickname = data['nickname'];
    this.profile = data['profile'];
    this.gender = data['gender'];
    this.birth_date = data['birth_date'];
    this.myfollow = data['myfollow'];
    this.followme = data['followme'];
    notifyListeners();
  }

  void upInfo(data){
    print(data);
    this.head = data['head'];
    this.nickname = data['nickname'];
    this.profile = data['profile'];
    this.gender = data['gender'];
    this.birth_date = data['birth_date'];
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('userid',userid));
    properties.add(StringProperty('head',head));
    properties.add(StringProperty('nickname',nickname));
    properties.add(IntProperty('myfollow',myfollow));
    properties.add(IntProperty('followme',followme));
  }
}