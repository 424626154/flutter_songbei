import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/custom/item/post_item.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/models/post_model.dart';
import 'package:flutter_songbei/pages/post/post_page.dart';

import '../../app_theme.dart';
import '../list_user.dart';

typedef OnItemCallback = void Function(PostModel item);

class PostListItem extends StatelessWidget {
  PostModel item;
  int index;
  OnItemCallback onItem;
  OnItemCallback onDelete;
  OnItemCallback onStar;
  OnItemCallback onLove;

  PostListItem(this.item, this.index, this.onItem,{this.onDelete,this.onStar,this.onLove});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(5),
        // color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border:  Border.all(color: Colors.black12, width: 0.5),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListUser(item.userid, item.head, item.nickname,item.time),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Text(
                  item.title,
                  style: TextStyle(fontSize: 22, color: Colors.black87),
                ),
              ),
              PostItem(item),
              _buildMenu(context,item),
            ],
          ),
        ),
      ),
      onTap: () {
        this.onItem(item);
      },
    );
  }

  Widget _buildMenu(BuildContext context, PostModel item){
      return Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Row(
          children: <Widget>[
            InkWell(
              child: Row(
                children: <Widget>[
                  Image(
                    image: AssetImage(
                        UIManager.getStarAssetImage(item.mystar)),
                    width: 25,
                    height: 25,
                    color: UIManager.getStarColor(item.mystar),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      UIManager.getNumStr(item.starnum),
                      style: TextStyle(
                          fontSize: 14,
                          color: UIManager.getStarColor(item.mystar)),
                    ),
                  )
                ],
              ),
              onTap: () {
                if (onStar != null) onStar(item);
              },
            ),
            InkWell(
              child: Row(
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/post/pinglun.png'),
                    width: 25,
                    height: 25,
                    color: AppTheme.grayColor,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      UIManager.getNumStr(item.commentnum),
                      style: TextStyle(
                          fontSize: 14, color: AppTheme.grayColor),
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        PostPage(item.id)))
                    .then((res) => {
                  if (res != null &&
                      res['action'] != null &&
                      res['action'] == 'del')
                    {if (onDelete != null) onDelete(item)}
                });
              },
            ),
            InkWell(
              child: Row(
                children: <Widget>[
                  Image(
                    image: AssetImage(
                        UIManager.getLoveAssetImage(item.mylove)),
                    width: 25,
                    height: 25,
                    color: UIManager.getLoveColor(item.mylove),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      UIManager.getNumStr(item.lovenum),
                      style: TextStyle(
                          fontSize: 14,
                          color: UIManager.getLoveColor(item.mylove)),
                    ),
                  )
                ],
              ),
              onTap: () {
                if (onLove != null) onLove(item);
              },
            ),
          ],
        ),
      );
  }

//  Widget _buildAd() {
//    if (Platform.isIOS) {
//      if (index != 0 && index % 4 == 0) {
//        return GDTNativeExpressView(
//            posId: AdManager.getNativeExpressAdUnitId());
//      } else {
//        return Container();
//      }
//    } else {
//      return Container();
//    }
//  }
}
