

import 'package:sqflite/sqflite.dart';
import 'package:meta/meta.dart';
import 'db_manager.dart';

abstract class BaseDBProvider {

  bool isTableExits = false;

  createTableString();

  upgradeTableString(int oldVersion);

  tableName();

  ///创建表sql语句
  tableBaseString(String sql) {
    return sql;
  }

  Future<Database> getDataBase() async {
    return await open();
  }

  ///super 函数对父类进行初始化
  @mustCallSuper
  prepare(name, String createSql) async {
    isTableExits = await DBManager.isTableExits(name);
    if (!isTableExits) {
      Database db = await DBManager.getCurrentDatabase();
      return await db.execute(createSql);
    }
  }

  @mustCallSuper
  open() async {
    if (!isTableExits) {
      await prepare(tableName(), createTableString());
    }
    return await DBManager.getCurrentDatabase();
  }

  @mustCallSuper
  onUpgrade(Database db, int oldVersion, int newVersion) async {
    isTableExits = await DBManager.isTableExits(tableName());
    if(isTableExits){
      var upgradeSql = upgradeTableString(oldVersion);
      db.execute(upgradeSql);
    }
  }
}