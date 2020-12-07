
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/models/secondhand_model.dart';

import '../list_sh_user.dart';
typedef SecondhandCallbeck = Function(SecondhandModel);
class SecondhandGridItem extends StatelessWidget {

  SecondhandModel item;
  SecondhandCallbeck onItem;
  SecondhandGridItem(this.item,this.onItem);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          padding: EdgeInsets.all(5),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item.postExtend.photos.length > 0
                  ? Container(
                child: CachedNetworkImage(
                  imageUrl: item.postExtend.photos[0].photo,
                ),
              )
                  : Container(),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Text(
                  '${item.content}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Text('¥${item.price}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.deepOrange),),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: ListSHUser(item.userid,item.head,item.nickname,item.time),
              )
            ],
          )),
      onTap: (){
        if(onItem != null)onItem(item);
      },
    );
  }

}