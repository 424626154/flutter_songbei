
class ClassifyModel {
  int id;
  String title;
  String brief;
  String logo;
  String type;
  ClassifyModel(data){
    try{
      id = data['id'];
      title = data['title'];
      brief = data['brief'];
      logo = data['logo'];
      type = data['type'];
    }catch(e){
      print(e.toString());
    }
  }

  @override
  String toString() {
    return {
      'id':id,
      'title':title,
      'brief':brief,
      'logo':logo,
      'type':type
    }.toString();
  }

}