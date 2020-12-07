
import 'dart:convert';

class PostExtendModel {

  List<Photo> photos = List<Photo>();

  PostExtendModel(String extend){
    print('----PostExtendModel');
    if(extend == null){
      return;
    }
    var eObj = json.decode(extend);
    if(eObj != null){
      var temp_photos = eObj['photos'];
      if(temp_photos != null){
        temp_photos.forEach((element) {
          photos.add(Photo(element));
        });
      }
    }
  }
}

class Photo{
  int id;
  String photo;
  double pw;
  double ph;
  Photo.init(this.id,this.photo,this.pw,this.ph);
  Photo(data){
//    print('----data');
    id = data['id'];
    photo = data['photo'];
    try {
      if(data['pw'] != null)pw = data['pw'] is double?data['pw']:double.parse(data['pw'].toString());
      if(data['ph'] != null)ph = data['ph'] is double?data['ph']:double.parse(data['ph'].toString());
    } catch (e) {
      print(e);
    }
  }
}