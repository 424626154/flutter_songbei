
import 'post_extend_model.dart';

class SecondhandModel {
  int id;
  String title;
  String content;
  String extend;
  double price;
  String userid;
  String head;
  String nickname;
  int lovenum;
  int commentnum;
  int starnum;
  int mylove;
  int mystar;
  int time;
  PostExtendModel postExtend;
  SecondhandModel(data){
    try{
      print('SecondhandModel');
      print(data);
      id = data['id'];
      title = data['title'];
      content = data['content'];
      extend = data['extend'];
      price = getPrice(data['price']);
      userid = data['userid'];
      head = data['head'];
      nickname = data['nickname'];
      lovenum = data['lovenum'];
      commentnum = data['commentnum'];
      mylove = data['mylove'];
      starnum = data['starnum'];
      mystar = data['mystar'];
      time = data['time'];
      postExtend = PostExtendModel(extend);
    }catch(e){
      print(e.toString());
    }
  }

  double getPrice(data_price){
    double to_price = 0;
    if(data_price is int){
      to_price = data_price.toDouble();
    }else if(data_price is double){
      to_price = data_price;
    }
    return to_price;
  }

  @override
  String toString() {
    return {
      'id':id,
      'title':title,
      'content':content,
      'extend':extend,
      'mylove':mylove,
    }.toString();
  }
}