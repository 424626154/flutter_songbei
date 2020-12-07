import 'package:flutter/material.dart';
import 'package:flutter_songbei/custom/item/message_top_item.dart';
import 'package:flutter_songbei/custom/listitem/message_list_item.dart';
import 'package:flutter_songbei/db/daos/chat_list_dao.dart';
import 'package:flutter_songbei/db/daos/message_dao.dart';
import 'package:flutter_songbei/db/daos/sys_notice_dao.dart';
import 'package:flutter_songbei/models/chat_list_model.dart';
import 'package:flutter_songbei/models/message_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/pages/post/post_page.dart';
import 'package:flutter_songbei/pages/user/person_page.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import 'chats_page.dart';
import 'message_details_page.dart';

class MessageCenterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<MessageCenterPage>
    with SingleTickerProviderStateMixin {
  int notSysNum = 0;
  int notChatNum = 0;

  List<MessageModel> messageList = List<MessageModel>();

  @override
  void initState() {
    super.initState();
    initMessages();
    initChats();
  }

  initMessages() async {
    MessageDao messageDao = MessageDao();
    messageDao
        .queryMessages(Provider.of<App>(context, listen: false).userid)
        .then((db_messages) {
      setState(() {
        messageList = db_messages;
      });
      _reqNotices();
    });
  }

  initChats() async {
    List<ChatListModel> chatList = List<ChatListModel>();
    ChatListDao chatListDao = ChatListDao();
    List<ChatListModel> temp = await chatListDao
        .queryAllChatList(Provider.of<App>(context, listen: false).userid);
    if (temp != null) {
      chatList = temp;
      int temp_num = 0;
      chatList.forEach((element) {
        temp_num += element.cnum;
      });
      setState(() {
        notChatNum = temp_num;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('消息中心'),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: _buildHead(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return MessageListItem(
                    messageList[index], _onIconItem, _onDelItem, _onItem);
              },
              childCount: messageList.length,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHead() {
//    return Container(
//      padding: EdgeInsets.all(10),
//      decoration: BoxDecoration(
//          color: Colors.white,
//          border:
//              Border(bottom: BorderSide(color: Colors.grey[400], width: 1.0))),
//      child: Row(
//        children: <Widget>[
//          MessageTopItem(
//              icon: 'assets/my/sys_notice.png',
//              title: '系统通知',
//              color: Colors.blue,
//              num: notSysNum,
//              onItem: () {
//                Navigator.push(context,
//                    MaterialPageRoute(builder: (context) => SysNoticePage()))
//                    .then((value) => {
//                  upSysNum()
//                });
//              }),
//          MessageTopItem(
//              icon: 'assets/my/chat.png',
//              title: '私信',
//              color: Colors.orange,
//              num: notChatNum,
//              onItem: () {
//                Navigator.of(context).push(MaterialPageRoute(
//                    builder: (BuildContext context) => ChatsPage()));
//              }),
//        ],
//      ),
//    );
    return MessageTopItem(
        icon: 'assets/my/chat.png',
        title: '私信',
        color: Colors.orange,
        num: notChatNum,
        onItem: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ChatsPage()));
        });
  }

  void _onIconItem(MessageModel message) {
    if (message.type == 1 ||
        message.type == 2 ||
        message.type == 3 ||
        message.type == 5 ||
        message.type == 6 ||
        message.type == 7 ||
        message.type == 8) {
      var userid = message.extendModel.userid;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PersonPage(userid)));
    }
  }

  void _onDelItem(MessageModel message) {
    print('${message}');
    MessageDao messageDao = MessageDao();
    messageDao.deleteMessage(message.id);
    var temp_messages = messageList;
    for (var i = temp_messages.length - 1; i >= 0; i--) {
      if (temp_messages[i].id == message.id) {
        temp_messages.removeAt(i);
      }
    }
    setState(() {
      messageList = temp_messages;
    });
  }

  void _onItem(MessageModel message) {
    MessageDao messageDao = MessageDao();
    messageDao.upRead(message.id, 1);
    var temp_messages = messageList;
    for (var i = 0; i < temp_messages.length; i++) {
      if (temp_messages[i].id == message.id) {
        temp_messages[i].red = 1;
      }
    }
    setState(() {
      messageList = temp_messages;
    });
    if (message.type == 1 || message.type == 2 || message.type == 5) {
      var pid = message.extendModel.pid;
    } else if (message.type == 3) {
      var userid = message.extendModel.userid;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PersonPage(userid)));
    } else if (message.type == 6 || message.type == 7 || message.type == 8) {
      var id = message.extendModel.id;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PostPage(id)));
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MessageDetailsPage(message)));
    }
  }

  void upSysNum() {
    SysNoticeDao sysNoticeDao = SysNoticeDao();
    sysNoticeDao
        .queryNotReadCount(Provider.of<App>(context, listen: false).userid)
        .then((count) {
      setState(() {
        notSysNum += count;
      });
    });
  }

  void _reqNotices() {
    if (Provider.of<App>(context, listen: false).userid.length == 0) {
      return;
    }
    var params =
        PUserid(Provider.of<App>(context, listen: false).userid).toJson();
    CHttp.post(
        CHttp.MESSAGE_MESSAGES,
        (data) async {
          if (!mounted) {
            return;
          }
          print(data);
          List<MessageModel> temp_messages = List<MessageModel>();
          List<int> ids = List<int>();
          for (var i = 0; i < data.length; i++) {
            var message = MessageModel(data[i]);
            print(message);
            temp_messages.add(message);
            ids.add(message.mid);
          }
          MessageDao messageDao = MessageDao();
          List<MessageModel> db_messages =
              await messageDao.insertMessages(temp_messages);
          print('------db_messages');
          print(db_messages);
          if (ids.length > 0) {
            _reqRead(ids);
          }
          if (db_messages.length > 0) {
            messageList.insertAll(0, db_messages);
            setState(() {});
          }
        },
        params: params,
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {});
  }

  void _reqRead(List<int> ids) {
    if (Provider.of<App>(context, listen: false).userid.length == 0) {
      return;
    }
    var params =
        PRead(Provider.of<App>(context, listen: false).userid, ids).toJson();
    CHttp.post(
        CHttp.MESSAGE_READ,
        (data) async {
          if (!mounted) {
            return;
          }
        },
        params: params,
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {});
  }
}
