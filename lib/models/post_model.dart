

import 'post_extend_model.dart';

class PostModel{
  int id;
  String title;
  String content;
  String extend;
  String userid;
  String head;
  String nickname;
  int lovenum;
  int commentnum;
  int starnum;
  int mylove;
  int mystar;
  int time;
  PostExtendModel postExtend;
  PostModel(data){
    print('PostModel');
    print(data);
    id = data['id'];
    title = data['title'];
    content = data['content'];
    extend = data['extend'];
    userid = data['userid'];
    head = data['head'];
    nickname = data['nickname'];
    lovenum = data['lovenum'];
    commentnum = data['commentnum'];
    mylove = data['mylove'];
    starnum = data['starnum'];
    mystar = data['mystar'];
    time = data['time'];
    postExtend = PostExtendModel(extend);
  }

  @override
  String toString() {
    return {
      'id':id,
      'extend':extend,
      'mylove':mylove,
    }.toString();
  }
}