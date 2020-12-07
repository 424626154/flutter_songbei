
import 'package:flutter_songbei/models/chat_list_model.dart';
import 'package:sqflite_common/sqlite_api.dart';

import '../base_db_provider.dart';

class ChatListDao extends BaseDBProvider {

  ///表名
  static final String table = 'chat_list';

  static final String columnId = 'id';
//  static final String columnCId = 'rid';
  static final String columnAccount = 'account';
  static final String columnChatuid = 'chatuid';
//  static final String columnFuserid = 'fuserid';
//  static final String columnTuserid = 'tuserid';
  static final String columnHead = 'head';
  static final String columnNickname = 'nickname';
  static final String columnMsg = 'msg';
  static final String columnExtend = 'extend';
  static final String columnNum = 'num';
  static final String columnTime = 'time';

  @override
  createTableString() {
    var sql = 'CREATE TABLE $table (' +
        '$columnId  INTEGER PRIMARY KEY,' +
//        '$columnCId INTEGER,' +
        '$columnAccount TEXT ,' +
        '$columnChatuid TEXT ,' +
//        '$columnFuserid TEXT ,' +
//        '$columnTuserid TEXT ,' +
        '$columnHead TEXT ,' +
        '$columnNickname TEXT ,' +
        '$columnMsg TEXT ,' +
        '$columnExtend TEXT ,' +
        '$columnNum INTEGER DEFAULT 0,' +
        '$columnTime INTEGER DEFAULT 0' +
        ')';

    return sql;
  }

  @override
  tableName() {
    return  table;
  }

  @override
  upgradeTableString(int oldVersion) {
    var sql = '';
    switch(oldVersion){
      case 1:
        sql = '';
        break;
    }
    return sql;
  }

  Future<List<ChatListModel>> queryChatList(String account,String chatuid) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> list =
//    await db.rawQuery('SELECT * FROM $table WHERE $columndUserId = $user_id');
    await db.query(table,columns: [columnId,columnAccount,columnChatuid,columnHead,columnNickname,columnMsg,columnExtend,
      columnNum,columnTime],
        where: '$columnAccount = ? AND $columnChatuid = ? ORDER BY $columnId DESC',whereArgs: [account,chatuid]);
    print('queryChatList:${list}');
    List<ChatListModel> chats = List<ChatListModel>();
    for(var i = 0 ; i < list.length ; i ++){
      var  chat = ChatListModel.initDb(list[i]);
      chats.add(chat);
    }
    return chats;
  }

  Future<List<ChatListModel>> queryAllChatList(String account) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> list =
//    await db.rawQuery('SELECT * FROM $table WHERE $columndUserId = $user_id');
    await db.query(table,columns: [columnId,columnAccount,columnChatuid,columnHead,columnNickname,columnMsg,columnExtend,
      columnNum,columnTime],
        where: '$columnAccount = ? ORDER BY $columnId DESC',whereArgs: [account]);
    print('queryChatList:${list}');
    List<ChatListModel> chats = List<ChatListModel>();
    for(var i = 0 ; i < list.length ; i ++){
      var  chat = ChatListModel.initDb(list[i]);
      chats.add(chat);
    }
    return chats;
  }

  Future<ChatListModel> insertChatList(ChatListModel chatListModel) async {
    print('------insertChatList');
    print(chatListModel);
    Database db = await getDataBase();
    var sql = 'INSERT INTO $table ($columnAccount,$columnChatuid,$columnHead,$columnNickname,$columnMsg,$columnExtend,$columnNum,$columnTime) values (?,?,?,?,?,?,?,?)';
    var id = await db.rawInsert(sql,[chatListModel.account,chatListModel.chatuid,chatListModel.head,chatListModel.nickname,chatListModel.msg,chatListModel.nickname,chatListModel.cnum,chatListModel.time]);
    chatListModel.id = id;
    return chatListModel;
  }

  Future<ChatListModel> updateChatList(ChatListModel chatListModel) async {
    print('updateChatList');
    print(chatListModel);
    Database db = await getDataBase();
    var res  = await db.update(table,
        {'$columnHead':chatListModel.head,'$columnNickname':chatListModel.nickname,'$columnMsg':chatListModel.msg,'$columnExtend':chatListModel.extend,'$columnNum':chatListModel.cnum,'$columnTime':chatListModel.time},
        where: '$columnAccount = ? AND $columnChatuid = ?',whereArgs: [chatListModel.account,chatListModel.chatuid]);
    return chatListModel;
  }

  Future<int> upNum(String account,String chatuid ,int num) async {
    Database db = await getDataBase();
    var res  = await db.update(table, {'$columnNum':num},where: '$columnAccount = ? AND $columnChatuid',whereArgs: [account,chatuid]);
    print('-----upNum account :${account} chatuid:${chatuid}  num:${num} res:${res}');
  }

  Future<int> deleteChatList(String account,String chatuid) async {
    Database db = await getDataBase();
    var row = await db.delete(table,where: '$columnAccount = ? AND $columnChatuid',whereArgs: [account,chatuid]);
    print('---deleteChatList account:${account} chatuid:${chatuid} row:${row}');
    return row;
  }

}