import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/custom/item/post_item.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/models/post_model.dart';
import 'package:flutter_songbei/pages/post/post_page.dart';

import '../../app_theme.dart';
import '../list_user.dart';

class StarPostListItem extends StatelessWidget {
  PostModel post;

  StarPostListItem(this.post);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PostItem(post),
          Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            alignment: Alignment.bottomRight,
            child: Text(UIManager.getTime(post.time),style: TextStyle(color: Colors.grey),),
          )
        ],
      ),
    );
  }

}
