import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/shared/app_shared.dart';
import 'package:flutter_songbei/utils/app_util.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../app_web_page.dart';
import 'about_page.dart';
import 'cancellation_page.dart';
import 'feedback_page.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingState();
  }
}

class _SettingState extends State<SettingPage> {
  String version;

  @override
  void initState() {
    super.initState();
    Future<PackageInfo> future = PackageInfo.fromPlatform();
    future.then((packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '设置',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: ListView(
              children: <Widget>[
                _buildItem('assets/my/fankui.png', '意见反馈', _onFeedback),
                AppUtil.isLogin(context)
                    ? _buildItem(
                        'assets/my/zhuxiao.png', '注销账号', _onCancellation)
                    : Container(),
                _buildItem('assets/my/guanyu.png', '关于', _onAbout),
                _buildLogout(),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    child: Text(
                      '服务协议',
                      style: TextStyle(
                        color: Theme.of(context).toggleableActiveColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => AppWebPage(
                              '服务协议', CHttp.getAppWeb(CHttp.APPH5_AGREEMENT))));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      color: Theme.of(context).toggleableActiveColor,
                      width: 1.0,
                      height: 10,
                    ),
                  ),
                  InkWell(
                    child: Text(
                      '隐私政策',
                      style: TextStyle(
                        color: Theme.of(context).toggleableActiveColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => AppWebPage('隐私政策',
                              CHttp.getAppWeb(CHttp.APPH5_PRIVACY_POLICY))));
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(icon, title, func) {
    return GestureDetector(
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300], width: 1.0)),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image(
                    image: AssetImage(icon),
                    width: 30,
                    height: 30,
                    color: Colors.black87,
                  ),
                  Container(
                    width: 10,
                  ),
                  Text(
                    title,
                    style: TextStyle(color: Colors.black87, fontSize: 18.0),
                  )
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
              )
            ],
          ),
        ),
      ),
      onTap: () {
        func();
      },
    );
  }

  Widget _buildLogout() {
    if (AppUtil.isLogin(context)) {
      return Container(
          margin: EdgeInsets.fromLTRB(40, 20, 40, 0),
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            color: Colors.red[300],
            child: Text(
              '退出登录',
              style: AppTheme.loginButtonStyle,
            ),
            onPressed: () {
              _onLogout();
            },
          ));
    } else {
      return Container();
    }
  }

  void _onLogout() {
//    JPush jpush = new JPush();
//    jpush.stopPush();
    AppShared.getUserid().then((userid) {
      if (userid != null && userid.length > 0) {
        _reqPushId(userid, '');
      }
      Provider.of<App>(context, listen: false).saveUserId('');
      AppShared.saveUserid('');
      ToastUtil.showToast(context, '退出登录成功！');
      Navigator.pop(context);
    });
  }

  void _onFeedback() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FeedbackPage()));
  }

  void _onCancellation() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CancellationPage()));
  }

  void _onAbout() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AboutPage()));
  }

  void _reqPushId(userid, rid) {
    CHttp.post(CHttp.MESSAGE_PUSHID, (data) {},
        params: PPush(userid, rid).toJson(), errorCallback: (err) {
      ToastUtil.showToast(context, err);
    }, completeCallback: () {});
  }
}
