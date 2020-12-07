import 'package:common_utils/common_utils.dart';
import 'package:flutter_songbei/models/message_model.dart';
import 'package:sqflite/sqflite.dart';

import '../base_db_provider.dart';

class MessageDao extends BaseDBProvider {
  ///表名
  static final String table = 'message';

  static final String columnId = 'id';
  static final String columnMId = 'mid';
  static final String columnTitle = 'title';
  static final String columnContent = 'content';
  static final String columnType = 'type';
  static final String columnExtend = 'extend';
  static final String columndUserId = 'user_id';
  static final String columnTime = 'time';
  static final String columnRead = 'b_read';

  @override
  createTableString() {
    var sql = 'CREATE TABLE $table (' +
        '$columnId  INTEGER PRIMARY KEY,' +
        '$columnMId INTEGER,' +
        '$columnTitle TEXT ,' +
        '$columnContent TEXT ,' +
        '$columnType INTEGER ,' +
        '$columnExtend TEXT ,' +
        '$columndUserId TEXT ,' +
        '$columnTime INTEGER ,' +
        '$columnRead INTEGER DEFAULT 0' +
        ')';

    return sql;
  }

  @override
  upgradeTableString(int oldVersion) {
    var sql = '';
    switch (oldVersion) {
      case 1:
        sql = '';
        break;
    }
    return sql;
  }

  @override
  tableName() {
    return table;
  }

  ///查询数据库
  Future queryMessages(String user_id) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> list =
//    await db.rawQuery('SELECT * FROM $table WHERE $columndUserId = $user_id');
        await db.query(table,
            columns: [
              columnId,
              columnMId,
              columndUserId,
              columnTitle,
              columnContent,
              columnType,
              columnExtend,
              columnTime,
              columnRead
            ],
            where: '$columndUserId = ? ORDER BY $columnMId DESC',
            whereArgs: [user_id]);
    print('queryMessages user_id:${user_id} list:${list}');
    List<MessageModel> messages = List<MessageModel>();
    for (var i = 0; i < list.length; i++) {
      var message = MessageModel.initDb(list[i]);
      messages.add(message);
    }
    return messages;
  }

  Future<int> queryNotReadCount(String user_id) async {
    Database db = await getDataBase();
    var sql =
        'SELECT COUNT(*) AS count FROM $table WHERE $columndUserId = ? AND $columnRead = ? ';
    List<Map<String, dynamic>> counts =
        await db.rawQuery(sql, [user_id, false]);
//    print('count:${counts[0]['count']}');
    return counts[0]['count'];
  }

  ///插入到数据库
  Future insertNotice(MessageModel notice) async {
    Database db = await getDataBase();
    var sql =
        'INSERT INFO $table ($columnMId,$columnTitle,$columnContent,$columnType,$columnExtend,$columndUserId,$columnTime) values (?,?,?,?,?,?,?)';
    var id = await db.rawInsert(sql, [
      notice.id,
      notice.title,
      notice.content,
      notice.type,
      notice.extend,
      notice.userid,
      notice.time
    ]);
    notice.id = id;
    return notice;
  }

  /**
   * 批量插入
   */
  Future<List<MessageModel>> insertMessages(List<MessageModel> notices) async {
    Database db = await getDataBase();
    for (var i = 0; i < notices.length; i++) {
      var id = await db.insert(table, notices[i].toDbMap());
      notices[i].id = id;
    }
    return notices;
  }

  deleteMessage(int id) async {
    Database db = await getDataBase();
    var row = db.delete(table, where: '$columnId = ? ', whereArgs: [id]);
    LogUtil.v('---row:${row}');
  }

  deleteAllNotice(String user_id) async {
    Database db = await getDataBase();
    var row =
        db.delete(table, where: '$columndUserId = ? ', whereArgs: [user_id]);
    LogUtil.v('---row:${row}');
  }

  upRead(int id, int read) async {
    Database db = await getDataBase();
    db.update(table, {'$columnRead': read},
        where: '$columnId = ? ', whereArgs: [id]);
  }

  upAllRead(String user_id, bool read) async {
    Database db = await getDataBase();
    var res = await db.update(table, {'$columnRead': read},
        where: '$columndUserId = ? ', whereArgs: [user_id]);
    print('-----upAllRead user_id:${user_id}  read:${read} res:${res}');
  }
}
