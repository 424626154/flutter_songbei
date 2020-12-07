import 'package:dio/dio.dart';

///七牛 工具类
class Qiniu {
  ///基础路径
  static String BASE_PATH = 'songbei';
  ///头像存储路径
  static String FILES_PATH = BASE_PATH+'/files/';
  static String QINIU_PATH = 'https://wx.91niang.com/';
  ////上传路径
  static getUpPath(String path){
    String up_path =  FILES_PATH+DateTime.now().millisecondsSinceEpoch.toString() +
        '.' +
        path.split('.').last;
    return up_path;
  }
  ///上传后的地址
  static getUpUrl (String up_path){
    String up_url = QINIU_PATH+up_path;
    return up_url;
  }
  ///缩略图地址
  static getThumUrl(String base_url){
    String thum_parm = '?imageView2/0/w/200/h/200';
    String thum_url = base_url+thum_parm;
    return thum_url;
  }

  /**
   * 获得图片信息的拼接地址
   */
  static getImageInfo(String base_url){
    String info_parm = '?imageInfo';
    String info_url = base_url+info_parm;
    return info_url;
  }
  static httpGetImageInfo(String base_url,Function callback,{Function errorCallback}){
    String image_url = getImageInfo(base_url);
    Response response;
    Dio dio = new Dio();
    Future<Response> future = dio.get(image_url);
    future.then((response){
      callback(response.data);
    });
  }
}