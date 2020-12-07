class MenuModel {
  String type;
  int id;
  String cover;
  String title;
  var extend;
  MenuModel(data){
    try{
      print(data['type']);
      type = data['type'];
      id = data['id'];
      cover = data['cover'];
      title = data['title'];
      extend = data['extend'];
    }catch(e){
      print(e.toString());
    }
  }
  @override
  String toString() {
    return {
      "type":type,
      "id":id,
      "cover":cover,
      "title":title,
      "extend":extend,
    }.toString();
  }
}