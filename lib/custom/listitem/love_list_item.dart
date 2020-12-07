
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/models/love_model.dart';

class LoveLstItem extends StatelessWidget {
  LoveModel item;

  LoveLstItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
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
          Container(width: 10,),
          Column(
            children: <Widget>[
              Text(item.nickname,style: TextStyle(fontWeight: FontWeight.bold),),
              Divider(height: 5,),
              Text(item.profile,style: TextStyle(color: Colors.black45),),
            ],
          )
        ],
      ),
    );
  }

}