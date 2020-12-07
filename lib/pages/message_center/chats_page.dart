
import 'package:flutter/material.dart';
import 'package:flutter_songbei/custom/listitem/chat_list_item.dart';
import 'package:flutter_songbei/db/daos/chat_dao.dart';
import 'package:flutter_songbei/db/daos/chat_list_dao.dart';
import 'package:flutter_songbei/models/chat_list_model.dart';
import 'package:flutter_songbei/models/chat_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';

class ChatsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }

}

class _PageState extends State<ChatsPage>{

  List<ChatListModel> chatList = List<ChatListModel>();
  @override
  void initState() {
    super.initState();
    initChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('私信'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody(){
    if(chatList.length > 0){
      return _buildChats();
    }else{
      return Center(
        child: Text('暂无私信'),
      );
    }
  }


  Widget _buildChats() {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ChatListItem(chatList[index],onDelete: (ChatListModel item){
            ChatDao chatDao = ChatDao();
            chatDao.deleteChat(Provider.of<App>(context, listen: false).userid, item.chatuid);
            ChatListDao chatListDao = ChatListDao();
            chatListDao.deleteChatList(Provider.of<App>(context, listen: false).userid, item.chatuid);
            for (var i = chatList.length - 1; i >= 0; i--) {
              if (chatList[i].id == item.id) {
                chatList.removeAt(i);
              }
            }
            setState(() {

            });
          },);
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 0.5,
            indent: 0,
            color: AppTheme.grayColor,
          );
        },
        itemCount: chatList.length);
  }


  initChats() async {
    ChatListDao chatListDao = ChatListDao();
    List<ChatListModel> temp = await chatListDao
        .queryAllChatList(Provider.of<App>(context, listen: false).userid);
    if (temp != null) {
      chatList = temp;
      setState(() {
      });
    }
    _requestChats();
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
            List<int> reads = List<int>();
            temp_chats.forEach((element) {
              reads.add(element.cid);
              upChatList(element);
            });
            setState(() {});
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

  upChatList(ChatModel chatModel) async {
    print('---upChatList');
    print(chatModel);
    ChatListDao chatListDao = ChatListDao();
    List<ChatListModel> temp_chat_list = await chatListDao.queryChatList(
        Provider.of<App>(context, listen: false).userid, chatModel.chatuid);
    ChatDao chatDao = ChatDao();
    int cnum = await chatDao.queryNotReadCount(Provider.of<App>(context, listen: false).userid, chatModel.chatuid);
    print('--------cnum:$cnum');
    ChatListModel chatListModel = ChatListModel.initFromChat(chatModel,cnum);
    print(chatList);
    print(chatListModel);
    if(temp_chat_list.length > 0){
      chatListDao.updateChatList(chatListModel);
//      chatList.forEach((ChatListModel element) {
//        if(element.chatuid == chatListModel.chatuid){
//          print('----更新');
//          element = chatListModel;
//        }
//      });
      for(var i = 0 ; i < chatList.length ; i ++){
        if(chatList[i].chatuid == chatListModel.chatuid){
          print('----更新');
          chatList[i] = chatListModel;
        }
      }
    }else{
      chatListDao.insertChatList(chatListModel);
      chatList.add(chatListModel);
    }
    setState(() {

    });
  }

}