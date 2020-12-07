import 'package:flutter_songbei/db/daos/message_dao.dart';
import 'package:flutter_songbei/db/db_model.dart';

import 'message_extend_model.dart';

class MessageModel extends DbModel {

  int id = 0;
  int mid = 0;
  String title = '';
  String content = '';
  int type = 0; // 1 作品点赞 2 作品评论 3关注 5发布作品 6添加讨论 7点赞讨论 8评论讨论 9 成就
  String extend = '';
  int state = 0;
  int time = 0;
  String userid = '';
  int red = 0;

  MessageExtendModel extendModel;

  MessageModel(data){
    mid = data['id'];
    userid = data['userid'];
    title = data['title'];
    content = data['content'];
    type = data['type'];
    extend = data['extend'];
    state = data['state'];
    time = data['time'];
    extendModel = MessageExtendModel(extend);
  }

  MessageModel.initDb(data){
    id = data['id'];
    mid = data['mid'];
    title = data['title'];
    content = data['content'];
    type = data['type'];
    extend = data['extend'];
    state = data['state'];
    time = data['time'];
    userid = data['userid'];
    red = data['b_read'];
    extendModel = MessageExtendModel(extend);
  }

  @override
  String toString() {
    return {
      'id':id,
      'mid':mid,
      'title':title,
      'content':content,
      'type':type,
      'extend':extend,
      'state':state,
      'time':time,
      'userid':userid,
      'red':red,
    }.toString();
  }

  @override
  Map<String, dynamic> toDbMap() {
    var map = <String, dynamic>{
      MessageDao.columnMId: mid,
      MessageDao.columnTitle:title,
      MessageDao.columnContent:content,
      MessageDao.columnType:type,
      MessageDao.columnExtend:extend,
      MessageDao.columndUserId:userid,
      MessageDao.columnTime:time,

    };
    return map;
  }
}