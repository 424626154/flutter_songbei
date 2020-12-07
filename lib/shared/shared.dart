import 'package:shared_preferences/shared_preferences.dart';

/**
 * 数据持久化-本地缓存
 */
class Shared {
  static setValue(String key,String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }
  static Future<String> getValue(String key) async {
    String value = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    value = await prefs.getString(key);
    return value;
  }
  static clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();//清空键值对
  }
  static remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key); //删除指定键
  }
}