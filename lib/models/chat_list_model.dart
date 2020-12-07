

import 'package:dash_chat/dash_chat.dart';
import 'package:flutter_songbei/db/daos/chat_list_dao.dart';
import 'package:flutter_songbei/db/db_model.dart';

import 'chat_model.dart';

class ChatListModel extends DbModel {

  int id;
//  int cid;
  String account;
  String chatuid;
//  String fuserid;
//  String tuserid;
  String head;
  String nickname;
  String msg;
  String extend;
  int cnum;
  int time;

  ChatListModel.initDb(data) {
    id = data['id'];
//    cid = data['cid'];
    account = data['account'];
    chatuid = data['chatuid'];
//    fuserid = data['fuserid'];
//    tuserid = data['tuserid'];
    head = data['head'];
    nickname = data['nickname'];
    msg = data['msg'];
    extend = data['extend'];
    cnum = data['num'];
    time = data['time'];
  }

  ChatListModel.initChat(ChatModel chatModel,int cnum,ChatUser chatUser){
    account = chatModel.account;
    chatuid = chatModel.chatuid;
    msg = chatModel.msg;
    extend = chatModel.extend;
    this.cnum = cnum;
    time = chatModel.time;
    if(chatUser != null){
      head = chatUser.avatar;
      nickname = chatUser.name;
    }
  }

  ChatListModel.initFromChat(ChatModel chatModel,int cnum){
    account = chatModel.account;
    chatuid = chatModel.chatuid;
    msg = chatModel.msg;
    extend = chatModel.extend;
    this.cnum = cnum;
    time = chatModel.time;
    head = chatModel.head;
    nickname = chatModel.nickname;
  }

  @override
  Map<String, dynamic> toDbMap() {
    var map = <String, dynamic>{
      ChatListDao.columnId: id,
//      ChatListDao.columnCId: cid,
      ChatListDao.columnAccount: account,
      ChatListDao.columnChatuid: chatuid,
//      ChatListDao.columnFuserid: fuserid,
//      ChatListDao.columnTuserid: tuserid,
      ChatListDao.columnHead: head,
      ChatListDao.columnNickname: nickname,
      ChatListDao.columnMsg: msg,
      ChatListDao.columnExtend: extend,
      ChatListDao.columnNum: cnum,
      ChatListDao.columnTime: time,
    };
    return map;
  }

  @override
  String toString() {
    return {
      'id':id,
      'account':account,
      'chatuid':chatuid,
      'head':head,
      'nickname':nickname,
      'msg':msg,
      'extend':extend,
      'cnum':cnum,
      'time':time
    }.toString();
  }

}