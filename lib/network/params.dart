import 'dart:io' show Platform;

import 'package:flutter/widgets.dart';

///base params
abstract class Params{
  String os;
  Params(){
//    LogUtil.e('---Params');
    if(Platform.isIOS){
      os = 'ios';
    }
    if(Platform.isAndroid){
      os = 'android';
    }
    if(Platform.isMacOS){
      os = 'macos';
    }
    if(Platform.isWindows){
      os = 'windows';
    }
  }

  Map<String, dynamic> toJson();
}


///请求验证码
class PUserVerifyCode extends Params{
  String country_code;
  String phone ;
  int type ;//1 注册 2 忘记 3 修改
  PUserVerifyCode(country_code,phone,type){
    this.country_code = country_code;
    this.phone = phone;
    this.type = type;
  }
  //dynamic
  Map<String, dynamic> toJson() =>
      {
        'country_code':country_code,
        'phone': phone,
        'type':type.toString(),
        'os':os,
      };
}

/**
 * 用户 忘记密码
 */
class PUserForgot extends Params {
  String country_code;
  String phone;
  String password;
  String code;

  PUserForgot(country_code,phone, password, code) {
    this.country_code = country_code;
    this.phone = phone;
    this.password = password;
    this.code = code;
  }

  Map<String, dynamic> toJson() => {
    'country_code':country_code,
    'phone': phone,
    'password': password,
    'code': code,
    'os': os,
  };
}
/**
 * 用户注册
 */
class PUserSignup extends Params {
  String country_code;
  String phone;
  String password;
  String code;
  PUserSignup(country_code,phone,password,code){
    this.country_code = country_code;
    this.phone = phone;
    this.password = password;
    this.code = code;
  }
  Map<String, dynamic> toJson() =>
      {
        'country_code':country_code,
        'phone': phone,
        'password':password,
        'code':code,
        'os':os,
      };
}
class PUpUser extends Params {
  String userid ;
  String head;
  String nickname;
  String profile;
  int gender;
  String birth_date;
  PUpUser(this.userid,this.head,this.nickname,this.profile,this.gender,this.birth_date);
  //dynamic
  Map<String, dynamic> toJson() =>
      {
        'userid':userid,
        'head': head,
        'nickname':nickname,
        'profile':profile,
        'gender':gender,
        'birth_date':birth_date,
        'os':os,
      };
}
/**
 * 登录
 */
class PUserLogin extends Params{
  String phone;
  String password;
  PUserLogin(phone,password){
    this.phone = phone;
    this.password = password;
  }
  Map<String, dynamic> toJson() =>
      {
        'phone': phone,
        'password':password,
        'os':os,
      };

}

class PUserid extends Params{
  String userid;
  PUserid(this.userid);
  @override
  Map<String, dynamic> toJson() {
    return {
      'os':os,
      'userid':userid,
    };
  }
}

class PUID extends Params{
  String userid ;
  int id;
  PUID(this.userid,this.id);
  //dynamic
  Map<String, dynamic> toJson() =>
      {
        'userid':userid,
        'id': id,
        'os':os,
      };
}

class POther extends Params{
  String userid ;
  String myid;
  POther(this.myid,this.userid);
  //dynamic
  Map<String, dynamic> toJson() =>
      {
        'userid':userid,
        'myid': myid,
        'os':os,
      };
}

class PPerson extends Params{
  String userid ;
  String myid;
  PPerson(this.myid,this.userid);
  //dynamic
  Map<String, dynamic> toJson() =>
      {
        'userid':userid,
        'myid': myid,
        'os':os,
      };
}

class PSetPri extends Params {
  String userid = '';
  String type = '';
  bool b_value = false;

  PSetPri(this.userid, this.type, this.b_value);

  @override
  Map<String, dynamic> toJson() {
    return {
      'os': os,
      'userid': userid,
      'type': type,
      'b_value': b_value,
    };
  }
}

class PPoem extends Params{
  String userid ;
  int pid;
  PPoem(this.userid,this.pid);
  //dynamic
  Map<String, dynamic> toJson() =>
      {
        'userid':userid,
        'pid': pid,
        'os':os,
      };
}

class PDelPoem extends Params{
  String userid ;
  int id;
  PDelPoem(this.userid,this.id);
  //dynamic
  Map<String, dynamic> toJson() =>
      {
        'userid':userid,
        'id': id,
        'os':os,
      };
}

class PPoemComments extends Params {
  int id ;
  int pid;
  PPoemComments(this.id,this.pid);
  //dynamic
  Map<String, dynamic> toJson() =>
      {
        'id':id,
        'pid': pid,
        'os':os,
      };
}

class PPost extends Params {
  String userid ;
  int id;
  PPost(this.userid,this.id);
  //dynamic
  Map<String, dynamic> toJson() =>
      {
        'userid':userid,
        'id': id,
        'os':os,
      };
}

class PStars extends Params {
  String userid ;
  int type;
  int id;
  PStars(this.userid,this.type,this.id);
  //dynamic
  Map<String, dynamic> toJson() =>
      {
        'userid':userid,
        'type':type,
        'id': id,
        'os':os,
      };
}

class PLCNum extends Params {
  int type = 0; //2 讨论 评论
  int id = 0;

  PLCNum(this.type, this.id);

  @override
  Map<String, dynamic> toJson() {
    return {
      'os': os,
      'type': type,
      'id': id,
    };
  }
}


class PLove extends Params {
  String userid ;
  int type;
  int id;
  int love;
  PLove(this.userid,this.type,this.id,this.love);
  //dynamic
  Map<String, dynamic> toJson() =>
      {
        'userid':userid,
        'type':type,
        'id': id,
        'love':love,
        'os':os,
      };
}


class PLoveComment extends Params {
  int type = 0;
  String userid = '';
  int iid = 0;
  int icid = 0;
  int love = 0;

  PLoveComment(this.type, this.userid, this.iid, this.icid, this.love);

  @override
  Map<String, dynamic> toJson() {
    return {
      'os': os,
      'type': type,
      'userid': userid,
      'iid': iid,
      'icid': icid,
      'love': love
    };
  }
}

class PCommentDel extends Params {
  int type = 0; //2 讨论 评论
  String userid = '';
  int id = 0;
  int iid = 0;

  PCommentDel(this.type, this.userid, this.id, this.iid);

  @override
  Map<String, dynamic> toJson() {
    return {
      'os': os,
      'type': type,
      'userid': userid,
      'id': id,
      'iid': iid,
    };
  }
}

class PPoemLove extends Params {
  String userid ;
  int id;
  int love;
  PPoemLove(this.userid,this.id,this.love);
  //dynamic
  Map<String, dynamic> toJson() =>
      {
        'userid':userid,
        'id': id,
        'love':love,
        'os':os,
      };
}

class PPostLove extends Params {
  String userid ;
  int type;
  int id;
  int love;
  PPostLove(this.userid,this.type,this.id,this.love);
  //dynamic
  Map<String, dynamic> toJson() =>
      {
        'userid':userid,
        'type':type,
        'id': id,
        'love':love,
        'os':os,
      };
}


class PStar extends Params {
  static int STAR_POEM = 1;
  static int STAR_POEM_LIBRARY = 2;
  static int STAR_POST = 3;
  String userid ;
  int type;//1 诗 2 文库 3 想法
  int sid;
  int star;
  PStar(this.userid,this.type,this.sid,this.star);
  //dynamic
  Map<String, dynamic> toJson() =>
      {
        'userid':userid,
        'type':type,
        'sid': sid,
        'star':star,
        'os':os,
      };
}

class PDiscuss extends Params {
  String userid;
  int id;
  PDiscuss(this.userid,this.id);
  @override
  Map<String, dynamic> toJson() {
    return {
      'os':os,
      'userid':userid,
      'id':id,
    };
  }
}

class PCDiscuss extends Params {
  String userid;
  int c_type;
  int ciid;
  int id;
  PCDiscuss(this.userid,this.c_type,this.ciid,this.id);
  @override
  Map<String, dynamic> toJson() {
    return {
      'os':os,
      'userid':userid,
      'c_type':c_type,
      'ciid':ciid,
      'id':id,
    };
  }
}



class PHDiscuss extends Params {
  String userid;
  int id;
  int c_type;
  PHDiscuss(this.userid,this.id,this.c_type);
  @override
  Map<String, dynamic> toJson() {
    return {
      'os':os,
      'userid':userid,
      'id':id,
      'c_type':c_type,
    };
  }
}

class PCommentNum extends Params {
  int type ;
  int id;
  PCommentNum(this.type,this.id);
  //dynamic
  Map<String, dynamic> toJson() =>
      {
        'type':type,
        'id': id,
        'os':os,
      };
}

class PPoemCommentNum extends Params {
  int pid;
  PPoemCommentNum(this.pid);
  //dynamic
  Map<String, dynamic> toJson() =>
      {
        'pid': pid,
        'os':os,
      };
}

class PComment extends Params {
  int type ;
  int id;
  int iid;
  PComment(this.type,this.id,this.iid);
  //dynamic
  Map<String, dynamic> toJson() =>
      {
        'type':type,
        'id': id,
        'iid':iid,
        'os':os,
      };
}

class PFamous extends Params {
  int type ;
  int id;
  String label;
  PFamous(this.type,this.id,this.label);
  //dynamic
  Map<String, dynamic> toJson() =>
      {
        'type':type,
        'id': id,
        'label':label,
        'os':os,
      };
}


class PFamou extends Params {
  String userid ;
  int id;
  PFamou(this.userid,this.id);
  //dynamic
  Map<String, dynamic> toJson() =>
      {
        'userid':userid,
        'id': id,
        'os':os,
      };
}

class PAddPost extends Params {

  String userid;
  String title;
  String content;
  int type;
  String extend;

  PAddPost(this.userid,this.title,this.content,this.type,this.extend);

  @override
  Map<String,dynamic > toJson() {
    return {
      'userid':userid,
      'title':title,
      'content':content,
      'type':type,
      'extend':extend
    };
  }

}

class PAddClassifyPost extends Params {

  String userid;
  int c_type;
  int ciid;
  String title;
  String content;
  int type;
  String extend;

  PAddClassifyPost(this.userid,this.type,this.c_type,this.ciid,this.title,this.content,this.extend);

  @override
  Map<String,dynamic > toJson() {
    return {
      'userid':userid,
      'c_type':c_type,
      'ciid':ciid,
      'title':title,
      'content':content,
      'type':type,
      'extend':extend
    };
  }

}

class PCommentAdd extends Params {
  int type = 0;//3 想法 评论
  String userid = '';
  int id = 0 ;
  int cid = 0 ;
  String comment = '';

  PCommentAdd(this.type,this.userid,this.id,this.cid,this.comment);

  @override
  Map<String,dynamic > toJson() {
    return {
      'os':os,
      'type':type,
      'userid':userid,
      'id':id,
      'cid':cid,
      'comment':comment
    };
  }
}

class PCommentAddV2 extends Params {
  int type = 0;//3 想法 评论
  String userid = '';
  int id = 0 ;
  int cid = 0 ;
  String cuserid = '';
  String chead = '';
  String cnickname = '';
  String comment = '';

  PCommentAddV2(this.type,this.userid,this.id,this.cid,this.cuserid,this.chead,this.cnickname,this.comment);

  @override
  Map<String,dynamic > toJson() {
    return {
      'os':os,
      'type':type,
      'userid':userid,
      'id':id,
      'cid':cid,
      'cuserid':cuserid,
      'chead':chead,
      'cnickname':cnickname,
      'comment':comment
    };
  }
}

class PLibrary extends Params {
  int fromid ;
  int type;
  PLibrary(this.fromid,this.type);
  //dynamic
  Map<String, dynamic> toJson() =>
      {
        'fromid':fromid,
        'type': type,
        'os':os,
      };
}


class PFollowUser extends Params {
  String userid = '';
  String fansid = '';

  PFollowUser(this.userid, this.fansid);

  @override
  Map<String, dynamic> toJson() {
    return {
      'os': os,
      'userid': userid,
      'fansid': fansid,
    };
  }
}

class PFollow extends Params {
  String userid = '';
  String myid = '';
  int type = 0;

  PFollow(this.userid,this.myid,this.type);

  @override
  Map<String, dynamic> toJson() {
    return {
      'os':os,
      'userid':userid,
      'myid':myid,
      'type':type
    };
  }
}

class PFollowOp extends Params {
  String userid = '';
  String fansid = '';
  int op = 0;

  PFollowOp(this.userid,this.fansid,this.op);

  @override
  Map<String, dynamic> toJson() {
    return {
      'os':os,
      'userid':userid,
      'fansid':fansid,
      'op':op,
    };
  }
}

class PReport extends Params{
  String userid = '';
  String ruserid = '';
  int rid = 0;
  int type ;
  String report;
  String custom;

  PReport(this.userid,this.ruserid,this.rid,this.type,this.report,this.custom);

  @override
  Map<String, dynamic> toJson() {
    return {
      'os':os,
      'userid':userid,
      'ruserid':ruserid,
      'rid':rid,
      'type':type,
      'report':report,
      'custom':custom
    };
  }
}

class PAuthor extends Params{

  String userid;
  String author;

  PAuthor(this.userid,this.author);

  @override
  Map<String, dynamic> toJson() {
    return {
      'os':os,
      'userid':userid,
      'author':author,
    };
  }

}

class PFeedback extends Params {
  String userid;
  String feedback;
  String contact;
  PFeedback({
    @required this.userid,
    @required this.feedback,
    this.contact,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'userid':userid,
      'feedback':feedback,
      'contact':contact,
    };
  }
}


class PChatReads extends Params {
  String userid;
  List<int> reads;

  PChatReads(this.userid,this.reads);

  @override
  Map<String, dynamic> toJson() {
    return {
      'userid':userid,
      'reads':reads,
      'os':os
    };
  }
}

class PChatSend extends Params {
  int type;
  String fuserid;
  String tuserid;
  String msg;
  int checkid;

  PChatSend(this.type,this.fuserid,this.tuserid,this.msg,this.checkid);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type':type,
      'fuserid':fuserid,
      'tuserid':tuserid,
      'msg':msg,
      'checkid':checkid,
      'os':os
    };
  }
}

class PPush extends Params {
  String userid;
  String pushid;
  PPush(this.userid,this.pushid);
  @override
  Map<String, dynamic> toJson() {
    return {
      'os':os,
      'userid':userid,
      'pushid':pushid,
    };
  }
}

class PRead extends Params {
  String userid;
  List<int> ids;
  PRead(this.userid,this.ids);
  @override
  Map<String, dynamic> toJson() {
    return {
      'os':os,
      'userid':userid,
      'reads':ids,
    };
  }
}

class PLoves extends Params {
  int type = 0;
  int id = 0;
  PLoves(this.type,this.id);

  @override
  Map<String, dynamic> toJson() {
    return {
      'os':os,
      'type':type,
      'id':id
    };
  }
}


class PDelPoemComment extends Params {
  String userid;
  int id = 0;
  int pid = 0;
  PDelPoemComment(this.userid,this.id,this.pid);

  @override
  Map<String, dynamic> toJson() {
    return {
      'os':os,
      'userid':userid,
      'id':id,
      'pid':pid
    };
  }
}


class PDelComment extends Params {
  int type;
  String userid;
  int id = 0;
  int iid = 0;
  PDelComment(this.type,this.userid,this.id,this.iid);

  @override
  Map<String, dynamic> toJson() {
    return {
      'os':os,
      'type':type,
      'userid':userid,
      'id':id,
      'iid':iid
    };
  }
}

class PDelCommentV2 extends Params {
  int type;
  String userid;
  int id = 0;
  PDelCommentV2(this.type,this.userid,this.id);

  @override
  Map<String, dynamic> toJson() {
    return {
      'os':os,
      'type':type,
      'userid':userid,
      'id':id,
    };
  }
}

class PClassifys extends Params{
  String userid;
  int cid;
  PClassifys(this.userid,this.cid);
  @override
  Map<String, dynamic> toJson() {
    return {
      'os':os,
      'userid':userid,
      'cid':cid.toString(),
    };
  }
}

class PClassifyItem extends Params{
  String userid;
  int cid;
  int ciid;
  PClassifyItem(this.userid,this.cid,this.ciid);
  @override
  Map<String, dynamic> toJson() {
    return {
      'os':os,
      'userid':userid,
      'cid':cid,
      'ciid':ciid,
    };
  }
}


class PAddSecondhand extends Params {

  String userid;
  String title;
  String content;
  String extend;
  double price;

  PAddSecondhand(this.userid,this.title,this.content,this.price,this.extend);

  @override
  Map<String,dynamic > toJson() {
    return {
      'userid':userid,
      'title':title,
      'content':content,
      'price':price,
      'extend':extend
    };
  }

}

class PUpDating extends Params {
  String userid;
  int gender;
  String birth_date;
  int height;
  int weight;
  String degree;
  String location;
  String self_describe;
  PUpDating(this.userid,this.gender,this.birth_date,this.height,this.weight,this.degree,this.location,this.self_describe);

  @override
  Map<String, dynamic> toJson() {
    return {
      'userid':userid,
      'gender':gender,
      'birth_date':birth_date,
      'height':height,
      'weight':weight,
      'degree':degree,
      'location':location,
      'self_describe':self_describe
    };
  }
}

class PUpDatingState extends Params {
  String userid;
  int state;
  PUpDatingState(this.userid,this.state);

  @override
  Map<String, dynamic> toJson() {
    return {
      'userid':userid,
      'state':state,
    };
  }
}