
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/models/menu_model.dart';

class HomeMenuItem extends StatelessWidget{
  MenuModel item;
  HomeMenuItem(this.item);

  @override
  Widget build(BuildContext context) {
    var item_w = MediaQuery.of(context).size.width/4-40;
    return GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(item_w/2),
                child: CachedNetworkImage(
                  width: item_w,
                  height: item_w,
                  imageUrl:item.cover,
                  fit: BoxFit.cover,
                ),
              ),
              Container(height: 5,),
              Text(item.title,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
        ),
        onTap: () {
          UIManager.goMenuItem(context,item);
        }
    );
  }

}