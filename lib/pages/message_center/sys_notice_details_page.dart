

import 'package:flutter/material.dart';
import 'package:flutter_songbei/models/sys_notice_model.dart';

class SysNoticeDetailsPage extends StatefulWidget {

  SysNoticeModel notice;

  SysNoticeDetailsPage(this.notice);

  @override
  State<StatefulWidget> createState() {
    return _NoticeDetailsState(notice);
  }

}

class _NoticeDetailsState extends State<SysNoticeDetailsPage> {

  SysNoticeModel notice;

  _NoticeDetailsState(this.notice);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('系统消息'),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10.0),
        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.center,
//          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(notice.title,style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0
            ),),
            Container(
              width: MediaQuery.of(context).size.width-20.0,
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child:Text(
                  notice.content,
                  style: TextStyle(
                  color:Colors.black45,
                  fontSize: 18.0
              )),
            )
          ],
        ),
      ),
    );
  }

}