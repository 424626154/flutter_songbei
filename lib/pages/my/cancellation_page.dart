import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/shared/app_shared.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../app_web_page.dart';

class CancellationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<CancellationPage> {

  bool _checkboxSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('申请注销账号'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '为保证您的账号安全，在您提交注销申请生效前，需同时满足以下条件',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0,5,0,0),
                  child: Text(
                    '1.账号处于安全状态',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0,5,0,0),
                  child: Text(
                    '2.账号财产已结清',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0,5,0,0),
                  child: Text(
                    '3.账号权限解除',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0,5,0,0),
                  child: Text(
                    '4.账号无任何九分，包括投诉举报',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Checkbox(
                    value: _checkboxSelected,
                    activeColor: AppTheme.mainColor, //选中时的颜色
                    onChanged: (value) {
                      setState(() {
                        _checkboxSelected = value;
                      });
                    },
                  ),
                  Text('已阅读并同意'),
                  GestureDetector(
                    child: Text(
                      '《注销协议》',
                      style: TextStyle(color: AppTheme.mainColor),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AppWebPage('注销协议',CHttp.getAppWeb(CHttp.APPH5_CANCELLATION))));
                    },
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                alignment: Alignment.center,
                child: RaisedButton(
                  color: Colors.redAccent,
                  child: Text(
                    '申请注销',
                    style: AppTheme.loginButtonStyle,
                  ),
                  onPressed: () {
                      _onCancellation();
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _onCancellation(){
    if(_checkboxSelected == false){
      ToastUtil.showToast(context, '请阅读并同意注销协议');
      return;
    }
    _requestCancellation();
  }

  _requestCancellation(){
    CHttp.post(CHttp.USER_CANCALLATION, (data) {
      if (!mounted) {
        return;
      }
      LogUtil.e('-----data:${data}');
      ToastUtil.showToast(context, '申请已发出');
//      _requestLogout();
    }, params:PUserid(Provider.of<App>(context, listen: false).userid).toJson(),errorCallback: (err) {
      LogUtil.e('-----err:${err}');
      ToastUtil.showToast(context, err);
    });
  }
  _requestLogout(){
    CHttp.post(CHttp.USER_LOGOUT, (data) {
      if (!mounted) {
        return;
      }
      LogUtil.e('-----data:${data}');
      Provider.of<App>(context,listen: false).saveUserId('');
      AppShared.saveUserid('');
    }, params:PUserid(Provider.of<App>(context, listen: false).userid).toJson(),errorCallback: (err) {
      LogUtil.e('-----err:${err}');
      ToastUtil.showToast(context, err);
    });
  }
}
