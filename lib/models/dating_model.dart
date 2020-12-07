
class DatingModel {
  int id;
  String userid;
  int gender = -1;
  String birth_date;
  int height;
  int weight;
  String degree;
  String location;
  int state;
  String self_describe;

  String nickname;
  String head;

  DatingModel(Map data){
    try{
      id = data['id'];
      userid = data['userid'];
      gender = data['gender'];
      birth_date = data['birth_date'];
      height = data['height'];
      weight = data['weight'];
      degree = data['degree'];
      location = data['location'];
      state = data['state'];
      self_describe = data['self_describe'];
    }catch(e){
      print(e.toString());
    }
  }

  DatingModel.initUser(Map data){
    try{
      id = data['id'];
      userid = data['userid'];
      gender = data['gender'];
      birth_date = data['birth_date'];
      height = data['height'];
      weight = data['weight'];
      degree = data['degree'];
      location = data['location'];
      state = data['state'];
      self_describe = data['self_describe'];
      nickname = data['nickname'];
      head = data['head'];
    }catch(e){
      print(e.toString());
    }
  }
  DatingModel.init(){

  }

  @override
  String toString() {
    return {
      'userid':userid,
    }.toString();
  }

}