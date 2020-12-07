
import 'dart:core';

import 'package:flutter_songbei/db/daos/sys_notice_dao.dart';
import 'package:flutter_songbei/db/db_model.dart';


class SysNoticeModel extends DbModel {
  int id = 0;
  int nid = 0;
  String title = '';
  String content = '';
  int type = 0; // 0 系统 2 添加讨论
  String extend = '';
  int state = 0;
  int time = 0;
  String userid = '';
  bool red = false;

  SysNoticeModel(data){
    nid = data['id'];
    userid = data['userid'];
    title = data['title'];
    content = data['content'];
    type = data['type'];
    extend = data['extend'];
    state = data['state'];
    time = data['time'];
  }

  SysNoticeModel.initDb(data){
    print('----initDb');
    print(data);
    id = data['id'];
    nid = data['nid'];
    title = data['title'];
    content = data['content'];
    type = data['type'];
    extend = data['extend'];
//    state = data['state'];
    time = data['time'];
    userid = data['userid'];
    red = data['b_read'] == 1 ? true:false;
  }

  @override
  String toString() {
    return {
      'id':id,
      'nid':nid,
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
      SysNoticeDao.columnNId: nid,
      SysNoticeDao.columnTitle:title,
      SysNoticeDao.columnContent:content,
      SysNoticeDao.columnType:type,
      SysNoticeDao.columnExtend:extend,
      SysNoticeDao.columndUserId:userid,
      SysNoticeDao.columndTime:time,

    };
    return map;
  }

}