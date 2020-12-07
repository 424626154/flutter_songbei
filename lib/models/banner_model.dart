class BannerModel {
  String type;
  int id;
  String cover;
  String title;
  String brief;
  String extend;
  BannerModel(data){
    type = data['type'];
    id = data['id'];
    cover = data['cover'];
    title = data['title'];
    brief = data['brief'];
    extend = data['extend'];
  }
  @override
  String toString() {
    return {
      "type":type,
      "id":id,
      "cover":cover,
      "title":title,
      "brief":brief,
      "extend":extend,
    }.toString();
  }
}