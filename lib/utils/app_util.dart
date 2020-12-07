import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/provider/user.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class AppUtil {
  static bool isLogin(BuildContext context) {
    var isLogin = false;
    String user_id = Provider.of<App>(context, listen: false).userid;
    if (user_id != null && user_id.length > 0) {
      isLogin = true;
    }
    return isLogin;
  }

  static bool isCheckAdd(BuildContext context) {
    var isCheck = false;
    User user = Provider.of<User>(context, listen: false);
    if (user.nickname != null &&
        user.nickname.length > 0 &&
        user.head != null &&
        user.head.length > 0) {
      isCheck = true;
    }
    return isCheck;
  }


  static String getUserid(BuildContext context) {
    return Provider.of<App>(context).userid == null ? '' : '';
  }

  static String getChannel() {
    String channel = '';
    if (Platform.isAndroid) {
      channel = 'fir.im';
    } else if (Platform.isIOS) {
      channel = 'app store';
    }
    return channel;
  }

  static String dateStr(int date) {
    if(date == null){
      return  '';
    }
    //获取js 时间戳
    var time = DateTime.now().millisecondsSinceEpoch;
    //去掉 js 时间戳后三位，与php 时间戳保持一致
    time = ((time - date * 1000) / 1000).round();
    print('----time:${time}');
    //存储转换值
    var s;
    if (time < 60 * 10) {
      //十分钟内
      return '刚刚';
    } else if ((time < 60 * 60) && (time >= 60 * 10)) {
      //超过十分钟少于1小时
      s = (time / 60).floor().toString();
      return s + "分钟前";
    } else if ((time < 60 * 60 * 24) && (time >= 60 * 60)) {
      //超过1小时少于24小时
      s = (time / 60 / 60).floor().toString();
      return s + "小时前";
    } else if ((time < 60 * 60 * 24 * 3) && (time >= 60 * 60 * 24)) {
      //超过1天少于3天内
      s = (time / 60 / 60 / 24).floor().toString();
      return s + "天前";
    } else {
      print('----tag 3 time:${time}');
      //超过3天
      var date1 = DateTime.fromMillisecondsSinceEpoch(date * 1000);
      return date1.year.toString() +
          "/" +
          date1.month.toString() +
          "/" +
          date1.day.toString();
    }
  }

  static String getTime(int time){
    if(time == null){
      return '';
    }
    var date1 = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    return date1.year.toString() +
        "/" +
        (date1.month < 10?'0${date1.month.toString()}':date1.month.toString())+
        "/" +
        (date1.day < 10?'0${date1.day.toString()}':date1.day.toString());
  }
}
