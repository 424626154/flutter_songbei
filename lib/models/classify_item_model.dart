
class ClassifyItemModel {
  int id;
  int cid;
  String title;
  String brief;
  String logo;
  int type;
  ClassifyItemModel(data){
    try{
      id = data['id'];
      cid = data['cid'];
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
      'cid':cid,
      'title':title,
      'brief':brief,
      'logo':logo,
      'type':type
    }.toString();
  }

}