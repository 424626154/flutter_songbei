import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/models/chat_list_model.dart';
import 'package:flutter_songbei/pages/message_center/chat_page.dart';

import '../../app_theme.dart';

class ChatListItem extends StatelessWidget {
  ChatListModel item;
  Function onDelete;
  ChatListItem(this.item,{@required this.onDelete}):assert(onDelete != null);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: _buildChild(context),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: '删除',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => {onDelete(item)},
        ),
      ],
    );
  }

  Widget _buildChild(BuildContext context){
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          children: <Widget>[
            _buildHead(),
            Container(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        item.nickname != null?Text(
                          item.nickname,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ):Container(),
                        Text(
                          UIManager.getTime(item.time),
                          style: TextStyle(color: AppTheme.grayColor),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    item.msg,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppTheme.mainColor),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                  tuserid: item.chatuid,
                  head: item.head,
                  nickname: item.nickname,
                )));
      },
    );
  }

  Widget _buildHead(){
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            width: 40,
            height: 40,
            imageUrl: UIManager.getHeadurl(item.head),
            fit: BoxFit.fill,
          ),
        ),
        item.cnum > 0?Positioned(
          right: 0.0,
          top: 0.0,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(9.0))),
            width: 18,
            height: 18,
            child: Text(
              item.cnum > 99 ? '99' : '${item.cnum}',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ):Container()
      ],
    );
  }
}
