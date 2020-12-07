import 'package:flutter/material.dart';
import 'package:flutter_songbei/models/comment_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/provider/user.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:provider/provider.dart';

import '../../AppEnums.dart';
import '../../app_theme.dart';

class SecondhandCommentPage extends StatefulWidget {

  int id;
  int cid;
  String cuserid;
  String chead;
  String cnickname;
  String hintText;
  SecondhandCommentPage(this.id,this.cid,this.cuserid,this.chead,this.cnickname,this.hintText);

  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<SecondhandCommentPage> {
  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('留言'),
        centerTitle: true,
        actions: [
          FlatButton(
              onPressed: () {
                _onRelease();
              },
              child: Text(
                '发送',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: TextField(
          controller: _commentController,
          keyboardType: TextInputType.text,
          minLines: 5,
          maxLines: 10,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            enabledBorder: OutlineInputBorder(
              /*边角*/
              borderRadius: BorderRadius.all(
                Radius.circular(5), //边角为5
              ),
              borderSide: BorderSide(
                color: Colors.white, //边线颜色为白色
                width: 1, //边线宽度为2
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white, //边框颜色为白色
                width: 1, //宽度为5
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(5), //边角为30
              ),
            ),
            hintText: widget.hintText,
            filled: true,
            fillColor: AppTheme.loginFillColor,
          ),
        ),
      ),
    );
  }

  void _onRelease() {
    if (_commentController.text.length == 0) {
      ToastUtil.showToast(context, '请输入内容');
      return;
    }
    var params = PCommentAddV2(PostType.Secondhand.index, Provider.of<App>(context, listen: false).userid,
        widget.id, widget.cid,widget.cuserid,widget.chead,widget.cnickname, _commentController.text)
        .toJson();
    CHttp.post(
        CHttp.COMMENT_ADDV2,
            (data) {
          if (!mounted) {
            return;
          }
          var temp_comment = CommentModel.initV2(data,Provider.of<User>(context, listen: false).nickname,Provider.of<User>(context, listen: false).head);
          setState(() {});
          ToastUtil.showToast(context, '留言成功');
          Navigator.of(context).pop(temp_comment);
        },
        params: params,
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        });
  }
}
