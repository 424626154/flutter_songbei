import 'package:common_utils/common_utils.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/custom/login_head.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/network/resdata.dart';
import 'package:flutter_songbei/utils/toast_util.dart';

import '../../app_theme.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForgotPasswordState();
  }
}

class _ForgotPasswordState extends State<ForgotPasswordPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  String country_code = '+86';
  String _verifyCodeTips = '发送验证码';

  TimerUtil timerCountDown;

  ///倒计时
  int _verifyCodeCD = 0;

  bool b_phone_clear = false;
  bool b_pwd_clear = false;
  bool b_code_clear = false;
  bool b_pwd_visible = false; //密码是否可见

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('忘记密码'),
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
                                  b_phone_clear = text.length >
                                      0; //new  如果文本输入框中的字符串长度大于0则允许发送消息
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
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Stack(
                        children: <Widget>[
                          TextField(
                            controller: pwdController,
                            obscureText: !b_pwd_visible,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: '请输入新密码',
                                filled: true,
                                fillColor: AppTheme.loginFillColor),
                            onChanged: (value) {
                              setState(() {
                                b_pwd_clear = value.length > 0;
                              });
                            },
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              iconSize: 25.0,
                              icon: ImageIcon(
                                AssetImage(b_pwd_visible
                                    ? 'assets/user/kejian.png'
                                    : 'assets/user/bukejian.png'),
                                color: AppTheme.mainColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  b_pwd_visible = !b_pwd_visible;
                                });
                              },
                            ),
                          ),
                          Positioned(
                            right: 35,
                            child: Offstage(
                              offstage: !b_pwd_clear,
                              child: IconButton(
                                iconSize: 20.0,
                                icon: ImageIcon(
                                  AssetImage('assets/user/qingchu.png'),
                                  color: AppTheme.mainColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    pwdController.text = '';
                                    b_pwd_clear = false;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Stack(
                              children: <Widget>[
                                TextField(
                                  controller: codeController,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      hintText: '请输入验证码',
//                                        helperText: '验证码'
                                      filled: true,
                                      fillColor: AppTheme.loginFillColor),
                                  onChanged: (String text) {
                                    setState(() {
                                      b_code_clear = text.length > 0;
                                    });
                                  },
                                ),
                                Positioned(
                                  right: 0,
                                  child: Offstage(
                                    offstage: !b_code_clear,
                                    child: IconButton(
                                      iconSize: 20.0,
                                      icon: ImageIcon(
                                        AssetImage('assets/user/qingchu.png'),
                                        color: AppTheme.mainColor,
                                      ),
                                      onPressed: () {
                                        codeController.text = '';
                                        setState(() {
                                          b_code_clear = false;
                                        });
                                      },
                                    ),
                                  ),
                                )
                              ],
                            )),
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
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        width: 260,
                        child: RaisedButton(
                          color: AppTheme.mainColor,
                          child: Text(
                            '确定',
                            style: AppTheme.loginButtonStyle,
                          ),
                          onPressed: () {
                            _onForgot(context);
                          },
                        )),
                  ],
                )
              ],
            ),
          )),
    );
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

  void _onCountryChange(CountryCode countryCode) {
    //TODO : manipulate the selected country code here
    print("New Country selected: " + countryCode.toString());
    country_code = countryCode.toString();
  }

  ///请求验证码 verifycode
  _reqVerifyCode() {
    CHttp.post(
        CHttp.USER_VALIDATE,
        (data) {
          ResUserVerifyCode resUserVerifyCode =
              ResUserVerifyCode.fromJson(data);
          if (!mounted) {
            return;
          }
          setState(() {
            _verifyCodeTips = resUserVerifyCode.time.toString() + '秒后重新发送';
          });
          _verifyCodeCD = resUserVerifyCode.time;
          //倒计时test
          timerCountDown =
              TimerUtil(mInterval: 1000, mTotalTime: _verifyCodeCD * 1000);
          timerCountDown.setOnTimerTickCallback((int value) {
            double tick = (value / 1000);
//      LogUtil.e("CountDown: " + tick.toInt().toString());
            if (value == 0) {
              setState(() {
                _verifyCodeCD = tick.toInt();
                _verifyCodeTips = '发送验证码';
              });
            } else {
              setState(() {
                _verifyCodeCD = tick.toInt();
                _verifyCodeTips = tick.toInt().toString() + '秒后重新发送';
              });
            }
          });
          timerCountDown.startCountDown();
        },
        params: PUserVerifyCode(country_code, phoneController.text, 2).toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        });
  }

  _onForgot(BuildContext context) {
    if (phoneController.text.length == 0) {
      ToastUtil.showToast(context, '请输入手机号');
      return;
    }
    if (pwdController.text.length == 0) {
      ToastUtil.showToast(context, '请输入新密码');
      return;
    }
    if (codeController.text.length == 0) {
      ToastUtil.showToast(context, '请输入验证码');
      return;
    }
    _reqForgot();
  }

  void _reqForgot() {
    CHttp.post(
        CHttp.USER_FORGET,
        (data) {
          LogUtil.e(data);
          String userid = data['userid'];
          Navigator.of(context).pop(userid);
          ToastUtil.showToast(context, '请前往登录页进行登录');
        },
        params: PUserForgot(country_code, phoneController.text,
                pwdController.text, codeController.text)
            .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        });
  }
}
