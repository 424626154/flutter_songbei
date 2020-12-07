
import 'package:flutter_songbei/models/post_model.dart';

class FollowModel {
  int id = 0 ;
  String head = '';
  String nickname = '';
  String profile = '';
  String fansid = '';
  int fstate = 0;
  int tstate = 0;
  String userid = '';
  FollowModel(data){
    id = data['id'];
    head = data['head'];
    nickname = data['nickname'];
    profile = data['profile'];
    fansid = data['fansid'];
    fstate = data['fstate'];
    tstate = data['tstate'];
    userid = data['userid'];
  }

  FollowModel.initDiscuss(PostModel post,fansid,data){
    userid = post.userid;
    head = post.head;
    nickname = post.nickname;
    this.fansid = fansid;
    fstate = data['fstate'] != null?data['fstate']:0;
  }

  String getBut(){
    var follow = '关注';
    if(fansid == userid){
      return '自己';
    }
    if(fstate == 1&&tstate == 1){
      follow = '互相关注';
    }else if(fstate == 1){
      follow = '已关注';
    }else if(tstate == 1){
      follow = '关注我的';
    }
    return follow;
  }

  @override
  String toString() {
    return {
      'id':id,
      'head':head,
      'nickname':nickname,
      'profile':profile,
      'fansid':fansid,
      'fstate':fstate,
      'tstate':tstate,
    }.toString();
  }
}