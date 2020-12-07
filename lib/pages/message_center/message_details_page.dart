

import 'package:flutter/material.dart';
import 'package:flutter_songbei/models/message_model.dart';

class MessageDetailsPage extends StatefulWidget {

  MessageModel message;

  MessageDetailsPage(this.message);

  @override
  State<StatefulWidget> createState() {
    return _NoticeDetailsState(message);
  }

}

class _NoticeDetailsState extends State<MessageDetailsPage> {

  MessageModel message;

  _NoticeDetailsState(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('消息'),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10.0),
        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.center,
//          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(message.title,style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0
            ),),
            Container(
              width: MediaQuery.of(context).size.width-20.0,
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child:Text(
                  message.content,
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