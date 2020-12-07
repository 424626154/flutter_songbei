import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/models/sys_notice_model.dart';

class SysNoticeListItem extends StatelessWidget {
  SysNoticeModel notice;

  Function onDelete;

  Function onItem;

  SysNoticeListItem(this.notice, this.onDelete, this.onItem);

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
          onTap: () => {onDelete(notice)},
        ),
      ],
    );
  }

  _buildChild() {
    return GestureDetector(
        child: Container(
          padding: EdgeInsets.all(10.0),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              _buildCover(),
              Expanded(
                child: Row(
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                        child: Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              notice.title,
                              style: TextStyle(fontSize: 20.0),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                              child: Text(
                                notice.content,
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    UIManager.getTime(notice.time),
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        onTap: () {
//        print('-----onTap');
          if (onItem != null) {
            onItem(notice);
          }
        });
  }

  Widget _buildCover() {
    if (notice.red) {
      return Container(
        child: Container(
          margin: EdgeInsets.all(2.0),
          child: _buildCoverImage(),
        ),
      );
    } else {
      return Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(2.0),
            child: _buildCoverImage(),
          ),
          Positioned(
            right: 0.0,
            top: 0.0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              width: 10,
              height: 10,
            ),
          )
        ],
      );
    }
  }

  Widget _buildCoverImage() {
    return Image(
      image: AssetImage('assets/icon.png'),
      width: 40,
      height: 40,
    );
  }
}
