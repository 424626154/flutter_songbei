
import 'dart:convert';

class MessageExtendModel{
  String title;
  String userid;
  String head;
  String pseudonym;
  int pid;
  int id;
  int cid;
  String comment;
  MessageExtendModel(String extend){
    print(extend);
    if(!extend.isEmpty){
      try {
        var extendMap = json.decode(extend);
        title = extendMap['title'];
        userid = extendMap['userid'];
        head = extendMap['head'];
        pseudonym = extendMap['pseudonym'];
        pid = extendMap['pid'];
        id = extendMap['id'];
        cid = extendMap['cid'] is int ? extendMap['cid']:0;
        comment = extendMap['comment'];
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  String toString() {
    return {
      'comment':comment
    }.toString();
  }
}