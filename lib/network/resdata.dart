import 'dart:convert';

///响应数据
abstract class Res{

}
///{phone: 13671172337, type: 1, code: 2463, time: 10, max: 10}
class ResUserVerifyCode extends Res{
  String phone;
  int type;
  String code;
  int time;
  int max ;
  ResUserVerifyCode.fromJson(Map<String, dynamic> json){
    phone = json['phone'];
    type = int.parse(json['type']);
    code = json['code'];
    time = json['time'];
    max = json['time'];
  }
  @override
  String toString() {
    var to_json = {
      'phone':phone,
      'type':type,
      'code':code,
      'time':time,
      'max':max,
    };
    String to_str = json.encode(to_json);
    return to_str;
  }
}

class ResUserPhoneLogin extends Res {

}


class ResPage extends Res {
  int total = 0;
  int current_page = 1;
  int per_page = 0;

  ResPage.init(){

  }

  ResPage(page){
    total = page['total'];
    current_page = page['current_page'];
    per_page = page['per_page'];
  }
}