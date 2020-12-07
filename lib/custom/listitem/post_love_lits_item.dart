
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/models/love_model.dart';

class PostLoveListItem extends StatelessWidget {
  LoveModel item;
  PostLoveListItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          width: 40,
          height: 40,
          imageUrl: UIManager.getHeadurl(item.head),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

}