import 'dart:core';
import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';

import 'tag.dart';

class CHttp {
  static String BASE_URL = 'http://192.168.1.4:9401/';
  // static String BASE_URL = 'http://songbei.zanzhe580.com/';
  static String USER_LOGIN = 'user/login';
  static String USER_LOGOUT = 'user/logout';
  static String USER_REGISTER = 'user/register';
  static String USER_FORGET = 'user/forget';
  static String USER_UPINFO = 'user/upinfo';
  static String USER_INFO = 'user/info';
  static String USER_VALIDATE = 'user/validate';
  static String USER_FOLLOWS = 'user/follows';
  static String USER_OTHERINFO = 'user/otherinfo';
  static String USER_FOLLOW = 'user/follow';
  static String USER_FOLLOWINFO = 'user/followinfo';
  static String USER_PER = 'user/permission';
  static String USER_REPORT = 'user/report';
  static String USER_CANCALLATION = 'user/cancallation';
  ///发帖权限
  static String USER_PRIVILEGES = 'user/privileges';
  static String USER_SETPRI = 'user/setpri';
  static String REPORT = 'user/report';



  static String STATR = 'star/star';
  static String NSTARS = 'star/nstars';
  static String HSTARS = 'star/hstars';

  // 想法
  static String DISCUSS_ADD = 'discuss/add';
  static String DISCUSS_NDISCUSS = 'discuss/ndiscuss';
  static String DISCUSS_HDISCUSS = 'discuss/hdiscuss';
  static String DISCUSS_INFO = 'discuss/info';
  static String DISCUSS_DEL = 'discuss/del';
  static String DISCUSS_NMYDISCUSS = 'discuss/nmydiscuss';
  static String DISCUSS_HMYDISCUSS = 'discuss/hmydiscuss';
  static String DISCUSS_MYDISCUSS = 'discuss/mydiscuss';
  //分栏帖子
  static String DISCUSS_ADD_CLASSIFY = 'discuss/addclassify';
  static String DISCUSS_CDISCUSS = 'discuss/cdiscuss';
  static String DISCUSS_HOME = 'discuss/home';

  //评论
  static String COMMENT_LATEST = 'comment/latest';
  static String COMMENT_HISTORY = 'comment/history';
  static String COMMENT_ADD = 'comment/add';
  static String COMMENT_DEL = 'comment/del';
  static String COMMENT_ADDV2 = 'comment/addv2';
  static String COMMENT_DELV2 = 'comment/delv2';

  //点赞
  static String LOVE_LOVE = 'love/love';
  static String LOVE_LCNUM = 'love/lcnum';
  static String LOVE_LOVES = 'love/loves';
  static String LOVE_LOVECOMMENT = 'love/lovecomment';

  static String CHAT_SEND = 'chat/send';
  static String CHAT_CHATS = 'chat/chats';
  static String CHAT_READ = 'chat/read';

  static String MESSAGE_PUSHID = 'message/pushid';
  static String MESSAGE_MESSAGES = 'message/messages';
  static String MESSAGE_READ = 'message/read';
  static String MESSAGE_FEEDBACK = 'message/feedback';

  static String HOME_HOME = 'home/home';
  static String HOME_CLASSIFYS = 'home/classifys';
  static String HOME_CLASSIFY_ITEM = 'home/classifyitem';

  static String SECONDHAND_ADD = 'secondhand/add';
  static String SECONDHAND_SECONDHANDS = 'secondhand/secondhands';
  static String SECONDHAND_INFO = 'secondhand/info';
  static String SECONDHAND_DEL = 'secondhand/del';

  static String DATING_MYINFO = 'dating/myinfo';
  static String DATING_UPINFO = 'dating/upinfo';
  static String DATING_UPSTATE = 'dating/upstate';
  static String DATING_DATINGS = 'dating/datings';
  static String DATING_OTHERINFO = 'dating/otherinfo';

  ///七牛 token
  static String QINIU_UPTOKEN = '/qiniu/uptoken';

  ///七牛 客户端上传文件，服务器转存七牛
  static String QINIUS_UPFILE = '/app/qinius/upfile';

  static String APPH5_ABOUT = 'apph5/about';
  static String APPH5_AGREEMENT = 'apph5/agreement';
  static String APPH5_PRIVACY_POLICY = 'apph5/privacy_policy';
  static String APPH5_UPINFOLIST = 'apph5/upinfolist';
  static String APPH5_HELP = 'apph5/help';
  static String APPH5_CANCELLATION = 'apph5/cancellation';

  //徽章
  static String BADGE = 'badge';

  static post(String url, Function successCallback,
      {Map<String, dynamic> params,
      Function errorCallback,
      Function completeCallback}) async {
    StringBuffer sb = new StringBuffer("");
    if (params != null) {
      params.forEach((key, value) {
        sb.write("$key" + "=" + "$value" + "&");
      });
    }
    String paramStr = sb.toString();
    if (paramStr.length > 0) {
      paramStr = paramStr.substring(0, paramStr.length - 1);
    }
    LogUtil.e(url, tag: Tag.TAG_CHTTP);
    LogUtil.e(paramStr, tag: Tag.TAG_CHTTP);
    BaseOptions options = new BaseOptions(
        baseUrl: CHttp.BASE_URL,
        connectTimeout: 10000,
        receiveTimeout: 10000,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json);
    Dio dio = new Dio(options);
    try {
      Response response = await dio.post(url, data: params);
      LogUtil.v('---url :${url}', tag: Tag.TAG_CHTTP);
      LogUtil.v('---paramStr :${paramStr}', tag: Tag.TAG_CHTTP);
      LogUtil.v('---data :${response.data}', tag: Tag.TAG_CHTTP);
      if (response.data['code'] == 0) {
        if (successCallback != null) {
          successCallback(response.data['data']);
        }
        if (completeCallback != null) {
          completeCallback();
        }
      } else {
        if (errorCallback != null) {
          errorCallback(response.data['errmsg']);
        }
        if (completeCallback != null) {
          completeCallback();
        }
      }
    } catch (e) {
      LogUtil.e(url, tag: Tag.TAG_CHTTP);
      LogUtil.e(e, tag: Tag.TAG_CHTTP);
      if (errorCallback != null) {
        errorCallback(e.toString());
      }
      if (completeCallback != null) {
        completeCallback();
      }
    }
  }

  static get(String url, Function successCallback,
      {String params = '',
      Function errorCallback,
      Function completeCallback}) async {
//    StringBuffer sb = new StringBuffer("");
//    if (params != null) {
//      params.forEach((key, value) {
//        sb.write("$key" + "=" + "$value" + "&");
//      });
//    }
//    String paramStr = sb.toString();
//    if (paramStr.length > 0) {
//      paramStr = paramStr.substring(0, paramStr.length - 1);
//    }

    BaseOptions options = new BaseOptions(
        baseUrl: CHttp.BASE_URL,
        connectTimeout: 5000,
        receiveTimeout: 3000,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json);
    Dio dio = new Dio(options);
    try {
      Response response = await dio.get(url);
      LogUtil.v('---url :${url}', tag: Tag.TAG_CHTTP);
      LogUtil.v('---String :${String}', tag: Tag.TAG_CHTTP);
      LogUtil.v('---data :${response.data}', tag: Tag.TAG_CHTTP);
      if (successCallback != null) {
        successCallback(response.data);
      }
      if (completeCallback != null) {
        completeCallback();
      }
    } catch (e) {
      LogUtil.e(url, tag: Tag.TAG_CHTTP);
      LogUtil.e(e, tag: Tag.TAG_CHTTP);
      if (e != null) {
        if (errorCallback != null) {
          errorCallback(e.toString());
        }
        if (completeCallback != null) {
          completeCallback();
        }
      }
    }
  }

  /**
   * 上传图片到服务器 转存到七牛
   */
  static upFileToQiniu(
      File file, ProgressCallback onSendProgress, Function callback,
      {Function errorCallback}) async {
    try {
      var file_path = file.path;
      var name =
          file_path.substring(file_path.lastIndexOf('/') + 1, file_path.length);
      FormData formData = FormData.fromMap(
          {"file": MultipartFile.fromFile(file.path, filename: name)});
      Dio dio = Dio();
      String path = CHttp.BASE_URL + CHttp.QINIUS_UPFILE;
      Response response = await dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
      );
      LogUtil.v('---upFileToQiniu', tag: Tag.TAG_CHTTP);
      LogUtil.v(response.data, tag: Tag.TAG_CHTTP);
      if (response.statusCode == 200) {
        if (callback != null) {
          callback(response.data);
        }
      } else {
        if (errorCallback != null) {
          errorCallback(response.statusCode);
        }
      }
    } catch (e) {
      LogUtil.e(e, tag: Tag.TAG_CHTTP);
      if (errorCallback != null) {
        errorCallback(e.toString());
      }
    }
  }

  static String getAppWeb(String app_web) {
    var web_url = CHttp.BASE_URL + app_web;
    LogUtil.v(web_url, tag: Tag.TAG_CHTTP);
    return web_url;
  }
}
