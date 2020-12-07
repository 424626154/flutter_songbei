
class LoveModel {
  int id = 0;
  String userid = '';
  String head = '';
  String nickname = '';
  String profile = '';
  LoveModel(data){
    id = data[id];
    userid = data['userid'];
    head = data['head'];
    nickname = data['nickname'];
    profile = data['profile'];
  }

  @override
  String toString() {
    return {
      'id':id,
      'userid':userid,
      'head':head,
      'profile':profile
    }.toString();
  }
}