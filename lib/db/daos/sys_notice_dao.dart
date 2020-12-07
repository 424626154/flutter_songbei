

import 'package:common_utils/common_utils.dart';
import 'package:flutter_songbei/models/sys_notice_model.dart';
import 'package:sqflite/sqflite.dart';

import '../base_db_provider.dart';

class SysNoticeDao extends BaseDBProvider {

  ///表名
  static final String table = 'sys_notice';

  static final String columnId='id';
  static final String columnNId='nid';
  static final String columnTitle='title';
  static final String columnContent='content';
  static final String columnType = 'type';
  static final String columnExtend = 'extend';
  static final String columndUserId = 'user_id';
  static final String columndTime = 'time';
  static final String columndRead = 'b_read';


  @override
  createTableString() {
    var sql = 'CREATE TABLE $table ('+
        '$columnId  INTEGER PRIMARY KEY,'+
        '$columnNId INTEGER,'
            '$columnTitle TEXT ,'+
        '$columnContent TEXT ,'+
        '$columnType INTEGER ,'+
        '$columnExtend TEXT ,'+
        '$columndUserId TEXT ,'+
        '$columndTime INTEGER ,'+
        '$columndRead INTEGER DEFAULT false'+
        ')';

    return sql;
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

  @override
  tableName() {
    return  table;
  }

  ///查询数据库
  Future queryNotices(String user_id) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> list =
//    await db.rawQuery('SELECT * FROM $table WHERE $columndUserId = $user_id');
    await db.query(table,columns: [columnId,columnNId,columndUserId,columnTitle,columnContent,columnType,columnExtend,columndTime,columndRead],
        where: '$columndUserId = ? ORDER BY $columnNId DESC',whereArgs: [user_id]);
    print('queryNotices list:${list}');
    List<SysNoticeModel> notices = List<SysNoticeModel>();
    for(var i = 0 ; i < list.length ; i ++){
      var  notice = SysNoticeModel.initDb(list[i]);
      notices.add(notice);
    }
    return notices;
  }

  Future<int> queryNotReadCount(String user_id) async{
    Database db = await getDataBase();
    var sql = 'SELECT COUNT(*) AS count FROM $table WHERE $columndUserId = ? AND $columndRead = ? ';
    List<Map<String, dynamic>> counts = await db.rawQuery(sql,[user_id,false]);
//    print('count:${counts[0]['count']}');
    return counts[0]['count'];
  }


  ///插入到数据库
  Future insertNotice(SysNoticeModel notice) async {
    Database db = await getDataBase();
    var sql = 'INSERT INFO $table ($columnNId,$columnTitle,$columnContent,$columnType,$columnExtend,$columndUserId,$columndTime) values (?,?,?,?,?,?,?)';
    var id = await db.rawInsert(sql,[notice.id,notice.title,notice.content,notice.type,notice.extend,notice.userid,notice.time]);
    notice.id = id;
    return notice;
  }

  /**
   * 批量插入
   */
  Future<List<SysNoticeModel>> insertNotices(List<SysNoticeModel> notices) async {
    Database db = await getDataBase();
    for(var i = 0 ; i < notices.length ; i ++){
      var id = await db.insert(table, notices[i].toDbMap());
      notices[i].id = id;
    }
    return notices;
  }

  deleteNotice(int id) async{
    Database db = await getDataBase();
    var row = db.delete(table,where: '$columnId = ? ',whereArgs: [id]);
    LogUtil.v('---row:${row}');
  }

  deleteAllNotice(String user_id) async{
    Database db = await getDataBase();
    var row = db.delete(table,where: '$columndUserId = ? ',whereArgs: [user_id]);
    LogUtil.v('---row:${row}');
  }


  upRead(int id,bool read) async {
    Database db = await getDataBase();
    db.update(table, {'$columndRead':read},where: '$columnId = ? ',whereArgs: [id]);
  }

  upAllRead(String user_id,bool read) async {
    Database db = await getDataBase();
    var res  = await db.update(table, {'$columndRead':read},where: '$columndUserId = ? ',whereArgs: [user_id]);
    print('-----upAllRead user_id:${user_id}  read:${read} res:${res}');
  }

}