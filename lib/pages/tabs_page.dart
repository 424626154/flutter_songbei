import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sbb_tools/flutter_sbb_tools.dart';
import 'package:flutter_songbei/custom/buttom_bat_item.dart';
import 'package:flutter_songbei/db/daos/chat_dao.dart';
import 'package:flutter_songbei/db/daos/chat_list_dao.dart';
import 'package:flutter_songbei/db/daos/message_dao.dart';
import 'package:flutter_songbei/models/chat_list_model.dart';
import 'package:flutter_songbei/models/chat_model.dart';
import 'package:flutter_songbei/models/message_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/network/tag.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/provider/user.dart';
import 'package:flutter_songbei/shared/app_shared.dart';
import 'package:flutter_songbei/utils/app_util.dart';
import 'package:flutter_songbei/utils/firim.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:flutter_umeng_analytics/flutter_umeng_analytics.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import '../app_config.dart';
import '../app_theme.dart';
import 'post/add_post_page.dart';
import 'tabs/found_tab.dart';
import 'tabs/home_tab.dart';
import 'tabs/message_tab.dart';
import 'tabs/my_tab.dart';
import 'user/login_page.dart';

Future<dynamic> myBackgroundMessageHandler(
    Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

class TabsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TabsState();
  }
}

class _TabsState extends State<TabsPage> {
  int _selectedIndex = 0;
  List<Widget> pages = List<Widget>();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    pages..add(HomeTab())..add(FoundTab())..add(MessageTab())..add(MyTab());

    /// 自动登录
    Future future = AppShared.getUserid();
    future.then((user_id) {
      user_id = user_id == null ? '' : user_id;
      print('-----user_id:${user_id}');
      Provider.of<App>(context, listen: false).saveUserId(user_id);
      if (user_id.length > 0) {
        _reqUserInfo(user_id);
      }
    });

    if (Platform.isAndroid)
      UMengAnalytics.init(AppConfig.UMENG_ANDROID_KEY,
          policy: Policy.BATCH, encrypt: true, reportCrash: false);
    else if (Platform.isIOS)
      UMengAnalytics.init(AppConfig.UMENG_IOS_KEY,
          policy: Policy.BATCH, encrypt: true, reportCrash: false);
    initPush();
    UMengAnalytics.beginPageView('TabsPage');
    //检测更新
    _checkFirImUpdate();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            BottomBarItem(_selectedIndex == 0, 'assets/tabs/home.png', '首页',
                    () {
                  _onItemTapped(0);
                }),
            BottomBarItem(_selectedIndex == 1, 'assets/tabs/found.png', '发现',
                    () {
                  _onItemTapped(1);
                }),
            SizedBox(
              width: 30,
            ),
            BottomBarItem(_selectedIndex == 2, 'assets/tabs/message.png', '消息',
                    () {
                  _onItemTapped(2);
                }),
            BottomBarItem(_selectedIndex == 3, 'assets/tabs/my.png', '我的', () {
              _onItemTapped(3);
            })
          ],
        ),
      ),
      body: pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        heroTag: 'circleTag',
        backgroundColor: AppTheme.mainColor,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image(
            image: AssetImage('assets/tabs/add.png'),
            width: 30,
            height: 30,
            color: Colors.white,
          ),
        ]),
        onPressed: () {
          if (AppUtil.isLogin(context) == false) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginPage()));
            return;
          }
          if(AppUtil.isCheckAdd(context) == false){
            ToastUtil.showToast(context, '请先完善资料!');
            return;
          }
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPostPage()))
              .then((res) {});
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void initPush(){
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
      AppShared.saveRid(token);
      AppShared.getUserid().then((userid) {
        if (userid != null && userid.length > 0) {
          _reqPushId(userid, token);
        }
      });
    });
    var topic = '';
    if(Platform.isAndroid)topic = 'os_android';
    if(Platform.isIOS)topic = 'os_ios';
    _firebaseMessaging
        .subscribeToTopic(topic);
    // _firebaseMessaging
    // .unsubscribeFromTopic(topic);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _checkFirImUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String appVersion = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    if (Platform.isAndroid &&
        AppConfig.ANDROID_CHANNEL == AppConfig.ANDROID_CHANNEL_FIR_IM) {
      var url =
          '${FirIm.VERSION_QUERY}${AppConfig.FIT_IM_ID}?api_token=${AppConfig.FIT_IM_API_TOKEN}';
      CHttp.get(url, (data) {
        if (!mounted) {
          return;
        }
        var version = data['version'];
        var changelog = data['changelog'];
        var update_url = data['update_url'];
        if (int.tryParse(buildNumber) < int.tryParse(version)) {
          showDialog(
              context: context,
              barrierDismissible: false,
              //点击对话框barrier(遮罩)时是否关闭它
              builder: (context) {
                return AlertDialog(
                    title: Text('版本更新'),
                    content: Text('${changelog}'),
                    actions: <Widget>[
                      FlatButton(
                          child: Text("稍后升级"),
                          onPressed: () => {Navigator.of(context).pop()}),
                      FlatButton(
                          child: Text("立即升级"),
                          onPressed: () {
                            FlutterSbbTools.openURL(update_url);
                            Navigator.of(context).pop();
                          }),
                    ]);
              });
        }
      });
    }
  }

  void _reqUserInfo(String userid) {
    CHttp.post(
        CHttp.USER_INFO,
            (data) {
          if (data != null) {
            Provider.of<User>(context, listen: false).upInfo(data);
//            orderTab.reqOrders();
            _requestMessages();
            _requestChats();
          }
        },
        params: {'userid': userid},
        errorCallback: (err) {
          LogUtil.e(err, tag: Tag.TAG_ERROR);
        });
  }
  void _reqPushId(userid, rid) {
    CHttp.post(
        CHttp.MESSAGE_PUSHID,
            (data) {
          if (data != null) {}
        },
        params: PPush(userid, rid).toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        });
  }

  void _requestMessages() {
    if (Provider
        .of<App>(context, listen: false)
        .userid
        .length == 0) {
      return;
    }
    var params =
    PUserid(Provider
        .of<App>(context, listen: false)
        .userid).toJson();
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
            _requestMsgRead(ids);
          }
        },
        params: params,
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {});
  }

  void _requestMsgRead(List<int> ids) {
    if (Provider
        .of<App>(context, listen: false)
        .userid
        .length == 0) {
      return;
    }
    var params =
    PRead(Provider
        .of<App>(context, listen: false)
        .userid, ids).toJson();
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

  void _requestChats() {
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
                  data[i], Provider
                  .of<App>(context, listen: false)
                  .userid));
            }
            ChatDao chatDao = ChatDao();
            chatDao.insertChats(temp_chats);
            List<int> reads = List<int>();
            temp_chats.forEach((element) {
              reads.add(element.cid);
              upChatList(element);
            });
            if (reads.length > 0) {
              _requestChatRead(reads);
            }
          }
        },
        params:
        PUserid(Provider
            .of<App>(context, listen: false)
            .userid).toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {});
  }

  void _requestChatRead(List<int> reads) {
    CHttp.post(
        CHttp.CHAT_READ,
            (data) {
          if (!mounted) {
            return;
          }
          print(data);
        },
        params:
        PChatReads(Provider
            .of<App>(context, listen: false)
            .userid, reads)
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
        Provider
            .of<App>(context, listen: false)
            .userid, chatModel.chatuid);
    ChatDao chatDao = ChatDao();
    int cnum = await chatDao.queryNotReadCount(
        Provider
            .of<App>(context, listen: false)
            .userid, chatModel.chatuid);
    print('--------cnum:$cnum');
    ChatListModel chatListModel = ChatListModel.initFromChat(chatModel, cnum);
    print(chatListModel);
    if (temp_chat_list.length > 0) {
      chatListDao.updateChatList(chatListModel);
    } else {
      chatListDao.insertChatList(chatListModel);
    }
  }
}
