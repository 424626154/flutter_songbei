import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:package_info/package_info.dart';

import '../../app_config.dart';
import '../../app_theme.dart';
import '../app_web_page.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AboutState();
  }
}

class _AboutState extends State<AboutPage> {
  String version = '';

  @override
  void initState() {
    super.initState();
    Future<PackageInfo> future = PackageInfo.fromPlatform();
    future.then((packageInfo) {
      setState(() {
        version = _getVersion() +
            ' V' +
            packageInfo.version +
            ' build' +
            packageInfo.buildNumber;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 10.0),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/icon.png',
                    width: 80,
                    height: 80,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Text(
                    AppConfig.APP_NAME,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.mainColor),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Text(
                    version,
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[400]),
                  )
                ],
              ),
            ),
//            GestureDetector(
//              child: Container(
//                alignment: Alignment.centerLeft,
//                padding: EdgeInsets.all(10.0),
//                decoration: BoxDecoration(
//                    border: Border(
//                        top: BorderSide(color: Colors.grey[400], width: 1),
//                        bottom: BorderSide(color: Colors.grey[400], width: 1))),
//                child: Text('检测更新'),
//              ),
//              onTap: () {
//                _reqUpgread();
//              },
//            ),
            GestureDetector(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.grey[400], width: 1),
                        bottom: BorderSide(color: Colors.grey[400], width: 1))),
                child: Text('历史更新'),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AppWebPage('历史更新',CHttp.getAppWeb(CHttp.APPH5_UPINFOLIST))));
              },
            ),
            GestureDetector(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.grey[400], width: 1),
                        bottom: BorderSide(color: Colors.grey[400], width: 1))),
                child: Text('帮助中心'),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AppWebPage('帮助中心',CHttp.getAppWeb(CHttp.APPH5_HELP))));
              },
            ),
//            GestureDetector(
//              child: Container(
//                alignment: Alignment.centerLeft,
//                padding: EdgeInsets.all(10.0),
//                margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
//                decoration: BoxDecoration(
//                    border: Border(
//                        top: BorderSide(color: Colors.grey[400], width: 1),
//                        bottom: BorderSide(color: Colors.grey[400], width: 1))),
//                child: Text('服务协议'),
//              ),
//              onTap: () {
//                Navigator.of(context).push(MaterialPageRoute(
//                    builder: (BuildContext context) => AppWebPage('服务协议',CHttp.getAppWep(CHttp.APP_WEB_SERVICE_AGREEMENT))));
//              },
//            ),
//            GestureDetector(
//              child: Container(
//                alignment: Alignment.centerLeft,
//                padding: EdgeInsets.all(10.0),
//                margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
//                decoration: BoxDecoration(
//                    border: Border(
//                        top: BorderSide(color: Colors.grey[400], width: 1),
//                        bottom: BorderSide(color: Colors.grey[400], width: 1))),
//                child: Text('隐私政策'),
//              ),
//              onTap: () {
//                Navigator.of(context).push(MaterialPageRoute(
//                    builder: (BuildContext context) => AppWebPage('隐私政策',CHttp.getAppWep(CHttp.APP_WEB_PRIVACY_POLICY))));
//              },
//            ),
//            Padding(
//              padding: EdgeInsets.all(10.0),
//              child: Row(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  GestureDetector(
//                    child: Text(
//                      '服务协议',
//                      style: TextStyle(
//                        color: AppTheme.mainColor,
//                        decoration: TextDecoration.underline,
//                      ),
//                    ),
//                    onTap: () {
//                      Navigator.of(context).push(MaterialPageRoute(
//                          builder: (BuildContext context) => AppWebPage('服务协议',CHttp.getAppWeb(CHttp.APPH5_AGREEMENT))));
//                    },
//                  ),
//                  Padding(
//                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//                    child: Container(
//                      width: 1,
//                      height: 20,
//                      color: AppTheme.mainColor ,
//                    ),
//                  ),
//                  GestureDetector(
//                    child: Text('隐私政策',
//                      style: TextStyle(
//                        color: AppTheme.mainColor,
//                        decoration: TextDecoration.underline,
//                      ),
//                    ),
//                    onTap: () {
//                      Navigator.of(context).push(MaterialPageRoute(
//                          builder: (BuildContext context) => AppWebPage('隐私政策',CHttp.getAppWeb(CHttp.APPH5_PRIVACY_POLICY))));
//                    },
//                  ),
//                ],
//              ),
//            )
          ],
        ),
      ),
    );
  }

  _getVersion() {
    String info = '';
    if (Platform.isAndroid) {
      info = 'For Android';
    }
    if (Platform.isIOS) {
      info = 'For Ios';
    }
    return info;
  }

  _onCheckUp(data) {
    int b_update = data['b_update'];
    int b_forced = data['b_forced'];
    String url = data['url'];
    String op_type = data['op_type'];
    String up_log = data['up_log'];
    if (b_update == 1) {
      showDialog(
          context: context,
          barrierDismissible: b_forced == 1 ? false : true,
          //点击对话框barrier(遮罩)时是否关闭它
          builder: (context) {
            return AlertDialog(
              content: Text('${up_log}'),
              actions: _buildUpActions(b_forced, op_type, url),
            );
          });
    } else {
      ToastUtil.showToast(context, '已是最新版本!');
    }
  }

  _reqUpgread() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

//    CHttp.post(CHttp.UPGRADE_CHECK, (data) {
//      if (data != null) {
//        _onCheckUp(data);
//      }
//    },
//        params: PUpgrade(version, buildNumber, AppUtil.getChannel()).toJson(),
//        errorCallback: (err) {});
  }

  _buildUpActions(b_forced, op_type, url) {
    if (b_forced == 1) {
      return <Widget>[
        FlatButton(
          child: Text("升级"),
          onPressed: () {
            //关闭对话框并返回true
            Navigator.of(context).pop(true);
            _onOpUp(op_type, url);
          },
        ),
      ];
    } else {
      return <Widget>[
        FlatButton(
          child: Text("稍后升级"),
          onPressed: () => Navigator.of(context).pop(), // 关闭对话框
        ),
        FlatButton(
          child: Text("立即升级"),
          onPressed: () {
            //关闭对话框并返回true
            Navigator.of(context).pop(true);
            _onOpUp(op_type, url);
          },
        ),
      ];
    }
  }

  _onOpUp(op_type, url) {
    if (Platform.isAndroid) {
      if (op_type == 'D') {
//        _doDownloadOperation(url);
      }
    }

    if (op_type == 'O') {
      print('------openURL:${url}');
//      SbbTools.openURL(url);
    }
  }
}
