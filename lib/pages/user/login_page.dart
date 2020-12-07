import 'dart:ui';

import 'package:common_utils/common_utils.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/custom/login_head.dart';
import 'package:flutter_songbei/custom/network_loading.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/provider/user.dart';
import 'package:flutter_songbei/shared/app_shared.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import 'forgot_password_page.dart';
import 'modify_info_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  String country_code = '+86';

  /**
   * 登录方式 0 密码登录 1 验证码登录
   */
  int login_type = 0;

  String _verifyCodeTips = '发送验证码';

  TimerUtil timerCountDown;

  ///倒计时
  int _verifyCodeCD = 0;

  bool b_visible = false;
  bool b_clear = false;
  bool b_phone_clear = false;

  @override
  void dispose() {
    super.dispose();
    if (timerCountDown != null) timerCountDown.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
        centerTitle: true,
      ),
      body: Container(
          decoration: BoxDecoration(),
          padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                LoginHead(),
                Column(
                  children: <Widget>[
//                    Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                        children: <Widget>[
//                          FlatButton(
//                            child: Text(
//                              '密码登录',
//                              style: TextStyle(
//                                color: login_type == 0
//                                    ? AppTheme.mainColor
//                                    : AppTheme.grayColor,
//                                decoration: TextDecoration.underline,
//                                decorationStyle: TextDecorationStyle.solid,
//                                fontSize: 16.0,
//                              ),
//                            ),
//                            onPressed: () {
//                              setState(() {
//                                login_type = 0;
//                                phoneController.text = '';
//                                pwdController.text = '';
//                              });
//                            },
//                          ),
//                          FlatButton(
//                            child: Text(
//                              '验证码登录',
//                              style: TextStyle(
//                                color: login_type == 1
//                                    ? AppTheme.mainColor
//                                    : AppTheme.grayColor,
//                                decoration: TextDecoration.underline,
//                                decorationStyle: TextDecorationStyle.solid,
//                                fontSize: 16.0,
//                              ),
//                            ),
//                            onPressed: () {
//                              setState(() {
//                                login_type = 1;
//                                phoneController.text = '';
//                                pwdController.text = '';
//                              });
//                            },
//                          ),
//                        ]
//                    ),
                    _buildLoginType(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          child: Text(
                            '注册',
                            style: TextStyle(
                              color: AppTheme.mainColor,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.solid,
                              fontSize: 16.0,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SignupPage()));
                          },
                        ),
//                        FlatButton(
//                          child: Text(
//                            '邮箱注册',
//                            style: TextStyle(
//                              color: AppTheme.mainColor,
//                              decoration: TextDecoration.underline,
//                              decorationStyle: TextDecorationStyle.solid,
//                              fontSize: 16.0,
//                            ),
//                          ),
//                          onPressed: () {
////                            Navigator.of(context).push(MaterialPageRoute(
////                                builder: (BuildContext context) => EmailSignupPage()));
//                          },
//                        ),
                        FlatButton(
                          child: Text(
                            '忘记密码',
                            style: TextStyle(
                              color: AppTheme.mainColor,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.solid,
                              fontSize: 16.0,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ForgotPasswordPage()));
                          },
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }

  void _onCountryChange(CountryCode countryCode) {
    //TODO : manipulate the selected country code here
    print("New Country selected: " + countryCode.toString());
    country_code = countryCode.toString();
  }

  _buildLoginType() {
    if (login_type == 0) {
      return Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Row(children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        hintText: '手机号',
                        filled: true,
                        fillColor: AppTheme.loginFillColor),
                    onChanged: (String text) {
                      //new  通过onChanged事件更新_isComposing 标志位的值
                      setState(() {
                        //new  调用setState函数重新渲染受到_isComposing变量影响的IconButton控件
                        b_phone_clear =
                            text.length > 0; //new  如果文本输入框中的字符串长度大于0则允许发送消息
                      }); //new
                    },
                  ),
                )
              ]),
              Positioned(
                right: 0,
                child: Offstage(
                  offstage: !b_phone_clear,
                  child: IconButton(
                    iconSize: 20.0,
                    icon: ImageIcon(
                      AssetImage('assets/user/qingchu.png'),
                      color: AppTheme.mainColor,
                    ),
                    onPressed: () {
                      phoneController.text = '';
                      setState(() {
                        b_phone_clear = false;
                      });
                    },
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Stack(
              children: <Widget>[
                TextField(
                  controller: pwdController,
                  obscureText: !b_visible,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      hintText: '请输入密码',
                      filled: true,
                      fillColor: AppTheme.loginFillColor),
                  onChanged: (value) {
                    setState(() {
                      b_clear = value.length > 0;
                    });
                  },
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    iconSize: 25.0,
                    icon: ImageIcon(
                      AssetImage(b_visible
                          ? 'assets/user/kejian.png'
                          : 'assets/user/bukejian.png'),
                      color: AppTheme.mainColor,
                    ),
                    onPressed: () {
                      setState(() {
                        b_visible = !b_visible;
                      });
                    },
                  ),
                ),
                Positioned(
                  right: 35,
                  child: Offstage(
                    offstage: !b_clear,
                    child: IconButton(
                      iconSize: 20.0,
                      icon: ImageIcon(
                        AssetImage('assets/user/qingchu.png'),
                        color: AppTheme.mainColor,
                      ),
                      onPressed: () {
                        setState(() {
                          pwdController.text = '';
                          b_clear = false;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              width: 260,
              child: RaisedButton(
                color: AppTheme.mainColor,
                child: Text(
                  '登录',
                  style: AppTheme.loginButtonStyle,
                ),
                onPressed: () {
                  _onLogin(context);
                },
              )),
        ],
      );
    } else if (login_type == 1) {
      return Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Row(children: <Widget>[
                Container(
                  color: Colors.white,
                  child: CountryCodePicker(
                    onChanged: _onCountryChange,
                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                    initialSelection: 'CN',
                    favorite: ['+86', 'china'],
                    // optional. Shows only country name and flag
                    showCountryOnly: false,
                    // optional. Shows only country name and flag when popup is closed.
                    showOnlyCountryWhenClosed: false,
                    // optional. aligns the flag and the Text left
                    alignLeft: false,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        hintText: '请输入手机号',
                        filled: true,
                        fillColor: AppTheme.loginFillColor),
                    onChanged: (String text) {
                      //new  通过onChanged事件更新_isComposing 标志位的值
                      setState(() {
                        //new  调用setState函数重新渲染受到_isComposing变量影响的IconButton控件
                        b_phone_clear =
                            text.length > 0; //new  如果文本输入框中的字符串长度大于0则允许发送消息
                      }); //new
                    },
                  ),
                )
              ]),
              Positioned(
                right: 0,
                child: Offstage(
                  offstage: !b_phone_clear,
                  child: IconButton(
                    iconSize: 20.0,
                    icon: ImageIcon(
                      AssetImage('assets/user/qingchu.png'),
                      color: AppTheme.mainColor,
                    ),
                    onPressed: () {
                      phoneController.text = '';
                      setState(() {
                        b_phone_clear = false;
                      });
                    },
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: TextField(
                      controller: codeController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          hintText: '请输入验证码',
//                                        helperText: '验证码'
                          filled: true,
                          fillColor: AppTheme.loginFillColor)),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: OutlineButton(
                    borderSide: BorderSide(color: AppTheme.mainColor),
                    child: Text(
                      _verifyCodeTips,
                      style: TextStyle(color: AppTheme.mainColor),
                    ),
                    onPressed: _onVeriCode,
                  ),
                )
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              width: 260,
              child: RaisedButton(
                color: AppTheme.mainColor,
                child: Text(
                  '登录',
                  style: AppTheme.loginButtonStyle,
                ),
                onPressed: () {
                  _onPhoneLogin(context);
                },
              )),
        ],
      );
    }
  }

  void _onLogin(BuildContext context) {
    if (phoneController.text.length == 0) {
      ToastUtil.showToast(context, '请输入手机号');
      return;
    }
    if (pwdController.text.length == 0) {
      ToastUtil.showToast(context, '请输入密码');
      return;
    }
    _reqLogin();
  }

  ///密码登录
  _reqLogin() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return NetworkLoading();
        });
    CHttp.post(
        CHttp.USER_LOGIN,
        (data) {
          if (!mounted) {
            return;
          }
          LogUtil.v(data);
          Navigator.pop(context);
          onLoginSuccess(data);
        },
        params: PUserLogin(phoneController.text, pwdController.text).toJson(),
        errorCallback: (err) {
//      Fluttertoast.showToast(msg:err);
          Navigator.pop(context);
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {
//          Navigator.pop(context);
        });
  }

  _onPhoneLogin(BuildContext context) {
    if (phoneController.text.length == 0) {
      ToastUtil.showToast(context, '请输入手机号');
      return;
    }
    if (codeController.text.length == 0) {
      ToastUtil.showToast(context, '请输入验证码');
      return;
    }
    _reqPhoneLogin();
  }

  /**
   * 手机验证码登录
   */
  _reqPhoneLogin() {
//    CHttp.post(
//        CHttp.USER_PHONELOGIN,
//            (data) {
//          LogUtil.v(data);
//          onLoginSuccess(data);
//        },
//        params:
//        PUserPhoneLogin(country_code,phoneController.text, codeController.text).toJson(),
//        errorCallback: (err) {
//          ToastUtil.showToast(context, err);
//        });
  }

  void _onVeriCode() {
    if (phoneController.text.length == 0) {
      ToastUtil.showToast(context, '请输入手机号');
      return;
    }
    if (_verifyCodeCD > 0) {
      ToastUtil.showToast(context, _verifyCodeCD.toString() + '秒后可重新发送');
      return;
    }
    _reqVerifyCode();
  }

  ///请求验证码 verifycode
  _reqVerifyCode() {
//    CHttp.post(
//        CHttp.USER_VERIFYCODE,
//            (data) {
//          ResUserVerifyCode resUserVerifyCode =
//          ResUserVerifyCode.fromJson(data);
//          setState(() {
//            _verifyCodeTips = resUserVerifyCode.time.toString() + '秒后重新发送';
//          });
//          _verifyCodeCD = resUserVerifyCode.time;
//          //倒计时test
//          timerCountDown =
//          new TimerUtil(mInterval: 1000, mTotalTime: _verifyCodeCD * 1000);
//          timerCountDown.setOnTimerTickCallback((int value) {
//            double tick = (value / 1000);
////      LogUtil.e("CountDown: " + tick.toInt().toString());
//            if (value == 0) {
//              setState(() {
//                _verifyCodeCD = tick.toInt();
//                _verifyCodeTips = '发送验证码';
//              });
//            } else {
//              setState(() {
//                _verifyCodeCD = tick.toInt();
//                _verifyCodeTips = tick.toInt().toString() + '秒后重新发送';
//              });
//            }
//          });
//          timerCountDown.startCountDown();
//        },
//        params: PUserVerifyCode(country_code,phoneController.text, 2).toJson(),
//        errorCallback: (err) {
//          ToastUtil.showToast(context, err);
//        });
  }

  _reqPushId(userid, rid) {
//    CHttp.post(CHttp.NOTICE_PUSHID, (data) {},
//        params: PPush(userid, rid).toJson(), errorCallback: (err) {
//          ToastUtil.showToast(context, err);
//        });
  }

  onLoginSuccess(data) {
    print('----data:${data}');
    String userid = data['userid'];
    print('----userid:${userid}');
    AppShared.saveUserid(userid);
    AppShared.getRid().then((rid) {
      if (rid != null && rid.length > 0) {
//        JPush jpush = new JPush();
//        jpush.resumePush();
        _reqPushId(userid, rid);
      }
    });
    Provider.of<App>(context, listen: false).saveUserId(userid);
    Provider.of<User>(context, listen: false).upUser(data);
    var perfect = data['perfect'] != null && data['perfect'] == 1 ? 1 : 0;
    ToastUtil.showToast(context, '登录成功');
    print('perfect:${perfect}');
    Navigator.of(context).pop(perfect);
   if (perfect == 0) {
     Navigator.of(context).push(MaterialPageRoute(
         builder: (BuildContext context) => ModifyInfoPage()));
   } else {
     ToastUtil.showToast(context, '登录成功');
   }
  }
}
