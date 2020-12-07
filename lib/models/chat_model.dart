

import 'package:dash_chat/dash_chat.dart';
import 'package:flutter_songbei/db/daos/chat_dao.dart';
import 'package:flutter_songbei/db/db_model.dart';

class ChatModel extends DbModel {
  int id;
  int cid;
  String account;
  String chatuid;
  String fuserid;
  String tuserid;
  String msg;
  String extend;
  int style; //布局样式 0 左 1右
  int send;
  int read;
  int time;
  int type;
  int state;
  String head;
  String nickname;

  ChatModel(data, account) {
    cid = data['id'];
    fuserid = data['fuserid'];
    tuserid = data['tuserid'];
    msg = data['msg'];
    extend = data['extend'];
    state = data['state'];
    time = data['time'];
    head = data['head'];
    nickname = data['nickname'];
    this.account = account;
    chatuid = fuserid == account ? tuserid : fuserid;
    style = fuserid == account ? 1 : 0;
  }

  ChatModel.initDb(data) {
    id = data['id'];
    cid = data['cid'];
    account = data['account'];
    chatuid = data['chatuid'];
    fuserid = data['fuserid'];
    tuserid = data['tuserid'];
    msg = data['msg'];
    extend = data['extend'];
    style = data['style'];
    send = data['send'];
    read = data['b_read'];
    time = data['time'];
  }

  ChatModel.initMessage(ChatMessage chatMessage, String account, String chatuid,
      int style, int read) {
    this.account = account;
    this.chatuid = chatuid;
    fuserid = account;
    tuserid = chatuid;
    msg = chatMessage.text;
    extend = '';
    this.style = style;
    this.read = read;
    time = (DateTime.now().millisecondsSinceEpoch / 1000).round();
  }

  ChatMessage toChatMessage(ChatUser user, ChatUser otherUser) {
    ChatMessage chatMessage;
    ChatUser chatUser;
    if (style == 1) {
      chatUser = user;
    }
    if (style == 0) {
      chatUser = otherUser;
    }
    if (chatUser != null) {
      chatMessage = ChatMessage(
          id: id.toString(),
          user: chatUser,
          text: msg,
          createdAt: DateTime.fromMillisecondsSinceEpoch(time * 1000));
    }
    return chatMessage;
  }

  @override
  Map<String, dynamic> toDbMap() {
    var map = <String, dynamic>{
      ChatDao.columnId: id,
      ChatDao.columnCId: cid,
      ChatDao.columnAccount: account,
      ChatDao.columnChatuid: chatuid,
      ChatDao.columnFuserid: fuserid,
      ChatDao.columnTuserid: tuserid,
      ChatDao.columnMsg: msg,
      ChatDao.columnExtend: extend,
      ChatDao.columnStyle: style,
      ChatDao.columnSend: send,
      ChatDao.columnRead: read,
      ChatDao.columnTime: time,
    };
    return map;
  }

  @override
  String toString() {
    return {
      'id': id,
      'cid': cid,
      'account': account,
      'chatuid': chatuid,
      'fuserid': fuserid,
      'tuserid': tuserid,
      'head':head,
      'nickname':nickname,
      'msg': msg
    }.toString();
  }
}
