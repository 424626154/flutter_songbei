
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/models/love_model.dart';

class DLoveListItem extends StatelessWidget {
  LoveModel item;
  DLoveListItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          width: 40,
          height: 40,
          imageUrl: item.head,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

}