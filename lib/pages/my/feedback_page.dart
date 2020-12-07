import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:provider/provider.dart';

class FeedbackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<FeedbackPage> {
  TextEditingController _feedbackController = TextEditingController();
  TextEditingController _contactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('意见反馈'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text('提交',style: TextStyle(color: Colors.white),),
            onPressed: () {
              _onSubmit();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
              child: TextField(
                controller: _feedbackController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: '请输入产品意见，我们将不断优化体验',
                    filled: true,
                    border: InputBorder.none,
                    fillColor: Colors.grey.shade200),
                minLines: 3,
                maxLines: 10,
              ),
            ),
            Container(
              height: 20,
            ),
            Container(
              child: TextField(
                controller: _contactController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: '可输入您的手机/邮箱等(选填)',
                    filled: true,
                    border: InputBorder.none,
                    fillColor: Colors.grey.shade200),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit() {
    if (_feedbackController.text.length == 0) {
      ToastUtil.showToast(context, '请输入您的宝贵意见');
      return;
    }
    _requestFeedback();
  }

  void _requestFeedback() {
    var params = PFeedback(
            userid: Provider.of<App>(context, listen: false).userid,
            feedback: _feedbackController.text,
            contact: _contactController.text)
        .toJson();
    CHttp.post(
        CHttp.MESSAGE_FEEDBACK,
        (data) {
          if (!mounted) {
            return;
          }
          LogUtil.e('-----data:${data}');
          ToastUtil.showToast(context, '感谢您的宝贵意见!');
          Navigator.of(context).pop();
        },
        params: params,
        errorCallback: (err) {
          LogUtil.e('-----err:${err}');
          ToastUtil.showToast(context, err);
        });
  }
}
