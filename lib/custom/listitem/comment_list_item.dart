import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/models/comment_model.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/utils/app_util.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';

typedef CommentCallback = Function(CommentModel);

class CommentLstItem extends StatelessWidget {

  CommentModel item;

  CommentLstItem(this.item,{this.onComment,this.onLove,this.onDel,this.showLove});

  CommentCallback onComment;
  CommentCallback onLove;
  CommentCallback onDel;

  bool showLove = false;

  @override
  Widget build(BuildContext context) {
    print('-----item:${item}');
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(item.nickname,style: TextStyle(fontWeight: FontWeight.bold),),
                        item.cid > 0 ?RichText(
                            text: TextSpan(
                                text: '回复[',
                                style: TextStyle(color: Colors.black87),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '${item.cnickname}',
                                      style: TextStyle(color: Colors.black45)),
                                  TextSpan(
                                      text: ']',
                                      style: TextStyle(color: Colors.black87))
                                ]),
                            textAlign: TextAlign.center):Container()
                      ],
                    ),
                    Text(AppUtil.dateStr(item.time))
                  ],
                ),
//                Padding(
//                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
//                  child: Row(
//                    children: <Widget>[
//                      item.cid > 0 ?RichText(
//                          text: TextSpan(
//                              text: '回复',
//                              style: TextStyle(color: Colors.black87),
//                              children: <TextSpan>[
//                                TextSpan(
//                                    text: '${item.cnickname}',
//                                    style: TextStyle(color: Colors.black45)),
//                                TextSpan(
//                                    text: ':',
//                                    style: TextStyle(color: Colors.black87))
//                              ]),
//                          textAlign: TextAlign.center):Container(),
//                      Text(item.comment,style: TextStyle(fontSize: 18),),
//                    ],
//                  )
//                ),
                Text(item.comment,style: TextStyle(fontSize: 18),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                        width: 60,
                        height: 30,
                        child: FlatButton.icon(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              if(this.onComment != null)this.onComment(item);
                            },
                            icon: Icon(
                              Icons.comment,
                              size: 20,
                              color: Colors.black45,
                            ),
                            label: Text(''),
                        )
                    ),
                    showLove == true ?SizedBox(
                      width: 60,
                      height: 30,
                      child: FlatButton.icon(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            if(this.onLove != null)this.onLove(item);
                          },
                          icon: Icon(
                            Icons.favorite,
                            size: 20,
                            color: item.love != null&&item.love > 0 ? AppTheme.mainColor:Colors.black45,
                          ),
                          label: Text(item.lovenum != null&&item.lovenum > 0 ?'${item.lovenum}':'',style: TextStyle(color:Colors.black45),)),
                    ):Container(),
                    item.userid == Provider.of<App>(context).userid
                        ? SizedBox(
                        width: 60,
                        height: 30,
                        child: FlatButton.icon(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            if (this.onDel != null)
                              this.onDel(item);
                          },
                          icon: Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.black45,
                          ),
                          label: Text(''),
                        ))
                        : Container(),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
