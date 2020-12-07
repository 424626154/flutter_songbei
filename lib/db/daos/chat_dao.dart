import 'package:flutter_songbei/models/chat_model.dart';
import 'package:sqflite_common/sqlite_api.dart';

import '../base_db_provider.dart';

class ChatDao extends BaseDBProvider {
  ///表名
  static final String table = 'chat';

  static final String columnId = 'id';
  static final String columnCId = 'cid';
  static final String columnAccount = 'account';
  static final String columnChatuid = 'chatuid';
  static final String columnFuserid = 'fuserid';
  static final String columnTuserid = 'tuserid';
  static final String columnMsg = 'msg';
  static final String columnExtend = 'extend';
  static final String columnStyle = 'style';
  static final String columnSend = 'send';
  static final String columnRead = 'b_read';
  static final String columnTime = 'time';

  @override
  createTableString() {
    var sql = 'CREATE TABLE $table (' +
        '$columnId  INTEGER PRIMARY KEY,' +
        '$columnCId INTEGER,' +
        '$columnAccount TEXT ,' +
        '$columnChatuid TEXT ,' +
        '$columnFuserid TEXT ,' +
        '$columnTuserid TEXT ,' +
        '$columnMsg TEXT ,' +
        '$columnExtend TEXT ,' +
        '$columnStyle INTEGER DEFAULT 0,' +
        '$columnSend INTEGER DEFAULT 0,' +
        '$columnRead INTEGER DEFAULT 0,' +
        '$columnTime INTEGER DEFAULT 0' +
        ')';
    print(sql);
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

  Future<ChatModel> insertChat(ChatModel chat) async{
    Database db = await getDataBase();
    print(db);
    var sql = 'INSERT INTO $table ($columnAccount,$columnChatuid,$columnFuserid,$columnTuserid,$columnMsg,$columnExtend,$columnStyle,$columnRead,$columnTime) values (?,?,?,?,?,?,?,?,?)';
    var id = await db.rawInsert(sql,[chat.account,chat.chatuid,chat.fuserid,chat.tuserid,chat.msg,chat.extend,chat.style,chat.read,chat.time]);
    chat.id = id;
    return chat;
  }

  Future<List<ChatModel>> queryChats(String chatuid) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> list =
//    await db.rawQuery('SELECT * FROM $table WHERE $columndUserId = $user_id');
    await db.query(table,columns: [columnId,columnCId,columnAccount,columnChatuid,columnFuserid,columnTuserid,columnMsg,columnExtend,
      columnStyle,columnSend,columnRead,columnTime],
        where: '$columnChatuid = ? ORDER BY $columnId ASC',whereArgs: [chatuid]);
    print('queryChats list:${list}');
    List<ChatModel> chats = List<ChatModel>();
    for(var i = 0 ; i < list.length ; i ++){
      var  chat = ChatModel.initDb(list[i]);
      chats.add(chat);
    }
    return chats;
  }

  /**
   * 批量插入
   */
  Future<List<ChatModel>> insertChats(List<ChatModel> chats) async {
    Database db = await getDataBase();
    for(var i = 0 ; i < chats.length ; i ++){
      var id = await db.insert(table, chats[i].toDbMap());
      chats[i].id = id;
    }
    return chats;
  }

  Future<int> queryNotReadCount(String account,String chatuid) async{
    Database db = await getDataBase();
    var sql = 'SELECT COUNT(*) AS count FROM $table WHERE $columnAccount = ? AND $columnChatuid = ? AND $columnRead = ?';
    List<Map<String, dynamic>> counts = await db.rawQuery(sql,[account,chatuid,1]);
    print(sql);
    print('count:${counts[0]}');
    return counts[0]['count'];
  }

  Future<int> queryAllNotReadCount(String account) async{
    Database db = await getDataBase();
    var sql = 'SELECT COUNT(*) AS count FROM $table WHERE $columnAccount = ? AND $columnRead = ?';
    List<Map<String, dynamic>> counts = await db.rawQuery(sql,[account,1]);
    print(sql);
    print('count:${counts[0]}');
    return counts[0]['count'];
  }

  Future<int>  upAllRead(String account,String chatuid ,int read) async {
    Database db = await getDataBase();
    var res  = await db.update(table, {'$columnRead':read},where: '$columnAccount = ? AND $columnChatuid',whereArgs: [read,account,chatuid]);
    print('-----upAllRead account:${account} chatuid:${chatuid}  read:${read} res:${res}');
  }

  Future<int>  deleteChat(String account,String chatuid) async {
    Database db = await getDataBase();
    var row = await db.delete(table,where: '$columnAccount = ? AND $columnChatuid',whereArgs: [account,chatuid]);
    print('---deleteChat account:${account} chatuid:${chatuid} row:${row}');
    return row;
  }

}
