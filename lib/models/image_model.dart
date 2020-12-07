
import 'package:uuid/uuid.dart';

class ImageModel{
  String id;
  int type;//0 1 添加
  int state;//0上传中 1 已完成
  String path;
  String url;

  ImageModel(){
    this.id = Uuid().v4();
  }

  toServerJson(int id){
    return {
      'id':id,
      'photo':url
    };
  }
  @override
  String toString() {
    return {
      'id':id,
      'type':type,
      'state':state,
      'path':path,
      'url':url
    }.toString();
  }
}