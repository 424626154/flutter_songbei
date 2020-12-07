import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_songbei/models/follow_model.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:provider/provider.dart';

class FollowUser extends StatelessWidget{
  FollowModel item ;
  Function onFollow;
  int from_type ;// 0 关注列表 1 帖子
  FollowUser(this.from_type,this.item,this.onFollow);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(color: Colors.grey[200], width: 1.0),
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    width: 40,
                    height: 40,
                    imageUrl: item.head,
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child:
                  Text('${item.nickname}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                )
              ],
            ),
            FlatButton(
              child: Text(item.getBut()),
              onPressed: (){
                if(onFollow != null)onFollow(item);
              },
            )
          ],
        ),
      ),
      onTap: (){
        print(item);
        var userid = item.userid;
        if(userid == Provider.of<App>(context, listen: false).userid){
          userid = item.fansid;
        }
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (BuildContext context) => PersonPage(userid)));
      },
    );
  }

}