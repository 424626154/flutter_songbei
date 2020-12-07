
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'daos/chat_dao.dart';
import 'daos/chat_list_dao.dart';
import 'daos/message_dao.dart';
import 'daos/sys_notice_dao.dart';

class DBManager {
  static const _VERSION = 1;
  static const _NAME = 'poem.db';
  static Database _database;

  static init() async {
    var db_path = await getDatabasesPath();
    var path = join(db_path, _NAME);
    _database = await openDatabase(path,version: _VERSION,onCreate:(Database db,int version) async {


    },onUpgrade: (Database db, int oldVersion, int newVersion) async{
      if(newVersion > oldVersion){
        ChatDao chatDao = ChatDao();
        chatDao.onUpgrade(db,oldVersion,newVersion);
        ChatListDao chatListDao = ChatListDao();
        chatListDao.onUpgrade(db,oldVersion,newVersion);
        MessageDao messageDao = MessageDao();
        messageDao.onUpgrade(db,oldVersion,newVersion);
        SysNoticeDao sysNoticeDao = SysNoticeDao();
        sysNoticeDao.onUpgrade(db,oldVersion,newVersion);
      }
    });
  }

  ///判断表是否存在
  static isTableExits(String tableName) async {
    await getCurrentDatabase();
    var res=await _database.rawQuery("select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res!=null && res.length >0;
  }

  ///获取当前数据库对象
  static Future<Database> getCurrentDatabase() async {
    if(_database == null){
      await init();
    }
    return _database;
  }

  ///关闭
  static close() {
    _database?.close();
    _database = null;
  }

}