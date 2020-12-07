import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/models/message_model.dart';

import '../../app_theme.dart';

class MessageListItem extends StatelessWidget {
  MessageModel item;

  Function onIconItem;

  Function onDelete;

  Function onItem;

  MessageListItem(this.item, this.onIconItem, this.onDelete, this.onItem);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: _buildChild(),
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

  _buildChild() {
    return GestureDetector(
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: item.red == 1?Colors.white:Colors.white54,
            border: Border(
              bottom: BorderSide(color: Colors.grey[200], width: 1.0)
            )
          ),
          child: Row(
            children: <Widget>[
              InkWell(
                child: _buildCover(),
                onTap: (){
                  if(onIconItem != null)onIconItem(item);
                },
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      alignment: Alignment.centerLeft,
                      child: _buildMessageTitle(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          child: Text(UIManager.getTime(item.time),style: TextStyle(color: AppTheme.grayColor),),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        onTap: () {
//        print('-----onTap');
          if (onItem != null) {
            onItem(item);
          }
        });
  }

  Widget _buildCover() {
    if (item.type == 0 || item.type == 4 || item.type == 9) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image(
          image: AssetImage('assets/icon.png'),
          width: 40,
          height: 40,
        ),
      );
    } else if (item.type == 1 ||
        item.type == 2 ||
        item.type == 3 ||
        item.type == 5 ||
        item.type == 6 ||
        item.type == 7 ||
        item.type == 8) {
//      print('----head:${UIManager.getHeadurl(item.extendModel.head)}');
//      print(item.extendModel.head);
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          width: 40,
          height: 40,
          imageUrl: UIManager.getHeadurl(item.extendModel.head),
          fit: BoxFit.fill,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildMessageTitle(){
    Widget widgetTitle = Container(
      child: Text(item.title,style: TextStyle(fontSize: 16,
          color: Colors.grey),),
    );
    if (item.type == 1 ||
        item.type == 2 ||
        item.type == 3 ||
        item.type == 5 ||
        item.type == 6 ||
        item.type == 7 ||
        item.type == 8 ||
        item.type == 9) {
      var extendModel = item.extendModel;
//      print('------extendModel:${extendModel}');
      if (item.type == 1) {
        widgetTitle = RichText(
          text: TextSpan(
              text: extendModel.pseudonym,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87),
              children: <TextSpan>[
                TextSpan(
                    text: '赞了你的作品',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey)),
                TextSpan(
                    text: '[${extendModel.title}]',
                    style: TextStyle(color: Colors.lightBlueAccent)),
              ]),
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        );
      } else if (item.type == 2) {
        var op_str = '评论了你的作品';
        if (extendModel.cid != null && extendModel.cid > 0) {
          op_str = '回复了你的作品';
        }
        widgetTitle = RichText(
          text: TextSpan(
              text: extendModel.pseudonym,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87),
              children: <TextSpan>[
                TextSpan(
                    text: op_str,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey)),
                TextSpan(
                    text: '[${extendModel.comment}]',
                    style: TextStyle(color: Colors.lightBlueAccent)),
              ]),
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        );
      } else if (item.type == 3) {
        widgetTitle = RichText(
          text: TextSpan(
              text: extendModel.pseudonym,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87),
              children: <TextSpan>[
                TextSpan(
                    text: '关注了你',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey)),
              ]),
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        );
      } else if (item.type == 5) {
        widgetTitle = RichText(
          text: TextSpan(
              text: extendModel.pseudonym,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87),
              children: <TextSpan>[
                TextSpan(
                    text: '发布了新作品',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey)),
                TextSpan(
                    text: '[${extendModel.title}]',
                    style: TextStyle(color: Colors.lightBlueAccent)),
              ]),
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        );
      } else if (item.type == 6) {
        widgetTitle = RichText(
          text: TextSpan(
              text: extendModel.pseudonym,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87),
              children: <TextSpan>[
                TextSpan(
                    text: '发布了新想法',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey)),
                TextSpan(
                    text: '[${extendModel.title}]',
                    style: TextStyle(color: Colors.lightBlueAccent)),
              ]),
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        );
      } else if (item.type == 7) {
        widgetTitle = RichText(
          text: TextSpan(
              text: extendModel.pseudonym,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87),
              children: <TextSpan>[
                TextSpan(
                    text: '赞了你的想法',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey)),
                TextSpan(
                    text: '[${extendModel.title}]',
                    style: TextStyle(color: Colors.lightBlueAccent)),
              ]),
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        );
      }else if(item.type == 8){
        var op_str = '评论了你的想法';
        if(extendModel.cid != null && extendModel.cid > 0){
          op_str = '回复了你的想法';
        }
        widgetTitle = RichText(
          text: TextSpan(
              text: extendModel.pseudonym,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87),
              children: <TextSpan>[
                TextSpan(
                    text: op_str,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey)),
                TextSpan(
                    text: '[${extendModel.comment}]',
                    style: TextStyle(color: Colors.lightBlueAccent)),
              ]),
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        );
      }else if(item.type == 9){
        widgetTitle = RichText(
          text: TextSpan(
              text: extendModel.pseudonym,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87),
              children: <TextSpan>[
                TextSpan(
                    text: '恭喜您获得',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey)),
                TextSpan(
                    text: '[${extendModel.title}]',
                    style: TextStyle(color: Colors.lightBlueAccent)),
              ]),
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        );
      }
    }else{

    }
    return widgetTitle;
  }
}
