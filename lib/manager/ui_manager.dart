

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_songbei/models/banner_model.dart';
import 'package:flutter_songbei/models/dating_model.dart';
import 'package:flutter_songbei/models/menu_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/pages/app_web_page.dart';
import 'package:flutter_songbei/pages/home/classifys_page.dart';
import 'package:flutter_songbei/pages/dating/dating_page.dart';
import 'package:flutter_songbei/pages/secondhand/secondhand_page.dart';
import 'package:flutter_songbei/provider/user.dart';
import 'package:flutter_songbei/utils/qiniu.dart';
import 'package:flutter_songbei/utils/toast_util.dart';

import '../app_theme.dart';

class UIManager {

  static String getHeadurl(String url){
    if (url == null||url.length == 0) {
      return 'http://wx.91niang.com/songbei/not_head.png';
    }
    if(url.indexOf('https://wx.91niang.com/') != -1){
      if(url.indexOf('?imageView2/0/w/200/h/200') != 1){
        return url;
      }else{
        return Qiniu.getThumUrl(url);
      }
    }
    return 'http://wx.91niang.com/songbei/not_head.png';
  }
  static getPhoto(String url){
    if (url == null||url.length == 0) {
      return 'http://wx.91niang.com/songbei/image_error.png';
    }
    if(url.indexOf('https://wx.91niang.com/') != -1){
      return url;
    }
    return 'http://wx.91niang.com/songbei/image_error.png';
  }

  static getNumStr(int num){
    if(num == null || num == 0){
      return '';
    }
    return num.toString();
  }

  static getNum0Str(int num){
    if(num == null || num == 0){
      return '0';
    }
    return num.toString();
  }

  static getLoveColor(int mylove){
    if(mylove == 1){
      return AppTheme.mainColor;
    }else{
      return AppTheme.grayColor;
    }
  }

  static getLoveAssetImage(int mylove){
    if(mylove == 1){
      return 'assets/post/dianzan_1.png';
    }else{
      return 'assets/post/dianzan.png';
    }
  }

  static getStarAssetImage(int mystar){
//    print('getStarAssetImage:$mystar');
    if(mystar != null&&mystar == 1){
      return 'assets/post/shoucang_1.png';
    }else{
      return 'assets/post/shoucang.png';
    }
  }

  static getStarColor(int mystar){
    if(mystar != null&&mystar == 1){
      return AppTheme.mainColor;
    }else{
      return AppTheme.grayColor;
    }
  }

  static isNetwork(String head){
    if(head.indexOf(Qiniu.QINIU_PATH) != -1){
      return true;
    }else{
      return false;
    }
  }

  static getTime(int date){
//    print('------getTime');
//    print(date);
    if(date == null){
      return '';
    }
    //获取js 时间戳
    int millisecond = DateTime.now().millisecondsSinceEpoch;
//    print('-----millisecond:$millisecond');
    //去掉 js 时间戳后三位，与php 时间戳保持一致
    int time = ((millisecond - date * 1000) / 1000).round();
//    print('-----time:$time');
    //存储转换值
    int s;
    if (time < 60 * 10) {
      //十分钟内
      return '刚刚';
    } else if (time < 60 * 60 && time >= 60 * 10) {
      //超过十分钟少于1小时
      s = (time / 60).round();
      return s.toString() + '分钟前';
    } else if (time < 60 * 60 * 24 && time >= 60 * 60) {
      //超过1小时少于24小时
      s = (time / 60 / 60).round();
      return s.toString() + '小时前';
    } else if (time < 60 * 60 * 24 * 3 && time >= 60 * 60 * 24) {
      //超过1天少于3天内
      s = (time / 60 / 60 / 24).round();
      return s.toString() + '天前';
    } else {
      //超过3天
      var date1 =  DateTime.fromMillisecondsSinceEpoch(date*1000);
      return date1.year.toString() + '/' + (date1.month ).toString() + '/' + date1.day.toString();
    }
  }

  static String getAge(String birth_date) {
    var age = 0;
    if (birth_date != null && birth_date.length > 0) {
      var currDate = DateTime.now();
      var cur_year = currDate.year;
      var year = int.parse(birth_date.substring(0, 4));
      print('cur_year:$cur_year');
      print('year:$year');
      age = cur_year - year;
    }
    return age.toString();
  }

  static String getFollowStr(User user) {
    print(user);
    var follow = '关注';
    if (user.fstate == 1 && user.tstate == 1) {
      follow = '互相关注';
    } else if (user.fstate == 1) {
      follow = '已关注';
    } else if (user.tstate == 1) {
      follow = '关注我的';
    }
    return follow;
  }

  static Color getFollowColor(User user) {
    var color = Colors.orange;
    if (user.fstate == 1 && user.tstate == 1) {
    } else if (user.fstate == 1) {
    } else if (user.tstate == 1) {
    } else {
//      color = Colors.grey;
    }
    return color;
  }

  static goMenuItem(BuildContext context,MenuModel item){
    print('item${item}');
    switch(item.type){
      case 'scenic_spot':
      case 'university':
        if(item.extend == null){
          ToastUtil.showToast(context, '类型参数错误');
          return ;
        }
        var cid = item.extend is int?item.extend:int.tryParse(item.extend);
        print('cid:${cid}');
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ClassifysPage(item.title,cid)));
        break;
      case "secondhand":
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => SecondhandPage()));
        break;
      case "dating":
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => DatingPage()));
        break;
    }
  }

  static goBannerItem(BuildContext context,BannerModel item){
    switch(item.type){
      case 'link':
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => AppWebPage(item.title, item.extend)));
        break;
    }
  }


  static String getDatingGenderStr(DatingModel datingModel) {
    String gender_str = '未选择';
    if (datingModel != null) {
      if (datingModel.gender != null) {
        if (datingModel.gender == 0) {
          gender_str = '女';
        } else if (datingModel.gender == 1) {
          gender_str = '男';
        }
      }
    }
    return gender_str;
  }

  static String getDatingAgeStr(DatingModel datingModel) {
    String age_str = '未选择';
    if (datingModel != null) {
      if (datingModel.birth_date != null) {
        var datas = datingModel.birth_date.split('-');
        var temp_year = int.tryParse(datas[0]);
        var cur_yead = DateTime.now().year;
        var temp_age = cur_yead-temp_year;
        age_str = '${temp_age}岁';
      }
    }
    return age_str;
  }

  static String getDatingHeightStr(DatingModel datingModel) {
    String height_str = '未选择';
    if (datingModel != null) {
      if (datingModel.height != null) {
        height_str = '${datingModel.height}cm';
      }
    }
    return height_str;
  }

  static String getDatingWeightStr(DatingModel datingModel) {
    String weight_str = '未选择';
    if (datingModel != null) {
      if (datingModel.weight != null) {
        weight_str = '${datingModel.weight}kg';
      }
    }
    return weight_str;
  }

  static String getDatingDegreeStr(DatingModel datingModel) {
    String degree_str = '未选择';
    if (datingModel != null) {
      if (datingModel.degree != null) {
        degree_str = '${datingModel.degree}';
      }
    }
    return degree_str;
  }

  static String getDatingLocationStr(DatingModel datingModel ) {
    String location_str = '未选择';
    if (datingModel != null) {
      if (datingModel.location != null) {
        var city0 = datingModel.location.split('-')[0];
        var city1 = datingModel.location.split('-')[0];
        location_str = '${city0}${city1}';
      }
    }
    return location_str;
  }
}