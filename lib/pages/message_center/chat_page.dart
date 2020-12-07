import 'dart:async';

import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/db/daos/chat_dao.dart';
import 'package:flutter_songbei/db/daos/chat_list_dao.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/models/chat_list_model.dart';
import 'package:flutter_songbei/models/chat_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/provider/user.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  String tuserid;
  String head;
  String nickname;

  ChatPage({
    @required this.tuserid,
    @required this.head,
    @required this.nickname,
  })  : assert(tuserid != null),
        assert(head != null),
        assert(nickname != null);

  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<ChatPage> {
  String tuserid;
  String head;
  String nickname;

  GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  ChatUser user;

  ChatUser otherUser;

  List<ChatModel> chats = List<ChatModel>();
  List<ChatMessage> messages = List<ChatMessage>();

  @override
  void initState() {
    super.initState();
    tuserid = widget.tuserid;
    head = widget.head;
    nickname = widget.nickname;
    var temp_user = Provider.of<User>(context, listen: false);
    user = ChatUser(
      name: temp_user.nickname,
      uid: temp_user.userid,
      avatar: UIManager.getHeadurl(temp_user.head),
    );
    otherUser = ChatUser(
      name: nickname,
      uid: tuserid,
      avatar: UIManager.getHeadurl(head),
    );
    ChatDao chatDao = ChatDao();
    chatDao.queryChats(tuserid).then((db_chats) => {initDBChats(db_chats)});
  }

  initDBChats(db_chats) {
    print('initDBChats');
    print(db_chats);
    print('otherUser');
    print(otherUser);
    chats = db_chats;
    chats.forEach((element) {
      print(element);
      ChatMessage chatMessage = element.toChatMessage(user, otherUser);
      print('chatMessage');
      print(chatMessage);
      if (chatMessage != null) messages.add(chatMessage);
    });
    print('-----messages');
    print(messages);
    setState(() {});
    _requestChats();
    _setRead(db_chats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nickname != null ? nickname : '私信'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    print(user.toString());
    return DashChat(
      key: _chatViewKey,
      inverted: false,
      onSend: onSend,
      sendOnEnter: true,
      textInputAction: TextInputAction.send,
      user: user,
      inputDecoration: InputDecoration.collapsed(hintText: "编辑内容..."),
      dateFormat: DateFormat('yyyy-MMM-dd'),
      timeFormat: DateFormat('HH:mm'),
      messages: messages,
      showUserAvatar: true,
      showAvatarForEveryMessage: true,
      scrollToBottom: true,
      onPressAvatar: (ChatUser user) {
        print("OnPressAvatar: ${user.name}");
      },
      onLongPressAvatar: (ChatUser user) {
        print("OnLongPressAvatar: ${user.name}");
      },
      inputMaxLines: 5,
      messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
      alwaysShowSend: true,
      inputTextStyle: TextStyle(fontSize: 16.0),
      inputContainerStyle: BoxDecoration(
        border: Border.all(width: 0.0),
        color: Colors.white,
      ),
      onQuickReply: (Reply reply) {
//        setState(() {
//          messages.add(ChatMessage(
//              text: reply.value, createdAt: DateTime.now(), user: user));
//
//          messages = [...messages];
//        });
//
//        Timer(Duration(milliseconds: 300), () {
//          _chatViewKey.currentState.scrollController
//            ..animateTo(
//              _chatViewKey
//                  .currentState.scrollController.position.maxScrollExtent,
//              curve: Curves.easeOut,
//              duration: const Duration(milliseconds: 300),
//            );
//
////          if (i == 0) {
////            systemMessage();
////            Timer(Duration(milliseconds: 600), () {
////              systemMessage();
////            });
////          } else {
////            systemMessage();
////          }
//        });
      },
      onLoadEarlier: () {
        print("laoding...");
      },
      shouldShowLoadEarlier: false,
      showTraillingBeforeSend: true,
      trailing: <Widget>[
//        IconButton(
//          icon: Icon(Icons.photo),
//          onPressed: () async {
////            File result = await ImagePicker.pickImage(
////              source: ImageSource.gallery,
////              imageQuality: 80,
////              maxHeight: 400,
////              maxWidth: 400,
////            );
////
////            if (result != null) {
////              final StorageReference storageRef =
////                  FirebaseStorage.instance.ref().child("chat_images");
////
////              StorageUploadTask uploadTask = storageRef.putFile(
////                result,
////                StorageMetadata(
////                  contentType: 'image/jpg',
////                ),
////              );
////              StorageTaskSnapshot download = await uploadTask.onComplete;
////
////              String url = await download.ref.getDownloadURL();
////
////              ChatMessage message =
////                  ChatMessage(text: "", user: user, image: url);
////
////              var documentReference = Firestore.instance
////                  .collection('messages')
////                  .document(DateTime.now().millisecondsSinceEpoch.toString());
////
////              Firestore.instance.runTransaction((transaction) async {
////                await transaction.set(
////                  documentReference,
////                  message.toJson(),
////                );
////              });
////            }
//          },
//        )
      ],
    );
  }

  onSend(ChatMessage message) {
    print(message);
    messages.add(message);
    ChatDao chatDao = ChatDao();
    ChatModel chatModel = ChatModel.initMessage(message,
        Provider.of<App>(context, listen: false).userid, tuserid, 1, 1);
    Future future = chatDao.insertChat(chatModel);
    future.then((dbChatModel) => {upChatList(dbChatModel), _requestSendChat(dbChatModel)});
  }

  upChatList(ChatModel chatModel) async {
    ChatListDao chatListDao = ChatListDao();
    List<ChatListModel> temp_chat_list = await chatListDao.queryChatList(
        Provider.of<App>(context, listen: false).userid, tuserid);
    ChatDao chatDao = ChatDao();
    int cnum = await chatDao.queryNotReadCount(Provider.of<App>(context, listen: false).userid, tuserid);
    print('--------cnum:$cnum');
    ChatListModel chatListModel = ChatListModel.initChat(chatModel,cnum,otherUser);
    if(temp_chat_list.length > 0){
      chatListDao.updateChatList(chatListModel);
    }else{
      chatListDao.insertChatList(chatListModel);
    }
  }

  _setRead(List<ChatModel> chats) {
    ChatDao chatDao = ChatDao();
    chatDao.upAllRead(Provider.of<App>(context, listen: false).userid, tuserid, 1);
    ChatListDao chatListDao = ChatListDao();
    chatListDao.upNum(Provider.of<App>(context, listen: false).userid, tuserid, 0);
  }

  _requestChats() {
    CHttp.post(
        CHttp.CHAT_CHATS,
        (data) {
          if (!mounted) {
            return;
          }
          print(data);
          if (data.length > 0) {
            List<ChatModel> temp_chats = List<ChatModel>();
            for (var i = 0; i < data.length; i++) {
              temp_chats.add(ChatModel(
                  data[i], Provider.of<App>(context, listen: false).userid));
            }
            ChatDao chatDao = ChatDao();
            chatDao.insertChats(temp_chats);
            List<ChatMessage> temp_chat_messages = List<ChatMessage>();
            List<int> reads = List<int>();
            temp_chats.forEach((element) {
              reads.add(element.cid);
              ChatMessage chatMessage = element.toChatMessage(user, otherUser);
              if (chatMessage != null) temp_chat_messages.add(chatMessage);
            });
            if (temp_chat_messages.length > 0) {
              messages.addAll(temp_chat_messages);
              setState(() {});
            }
            if (reads.length > 0) {
              _requestReads(reads);
            }
          }
        },
        params: PUserid(Provider.of<App>(context, listen: false).userid)
            .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {});
  }

  _requestReads(List<int> reads) {
    CHttp.post(
        CHttp.CHAT_READ,
        (data) {
          if (!mounted) {
            return;
          }
          print(data);
        },
        params:
            PChatReads(Provider.of<App>(context, listen: false).userid, reads)
                .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {});
  }

  _requestSendChat(ChatModel chatModel) {
    print('_requestSendChat');
    print(chatModel);
    CHttp.post(
        CHttp.CHAT_SEND,
        (data) {
          if (!mounted) {
            return;
          }
          print(data);
        },
        params: PChatSend(0, chatModel.fuserid, chatModel.tuserid,
                chatModel.msg, chatModel.id)
            .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {});
  }
}
