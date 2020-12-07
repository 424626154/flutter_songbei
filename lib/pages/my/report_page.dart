import 'package:flutter/material.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';

class ReportPage extends StatefulWidget {
  int type;
  int rid;
  String title;
  String ruserid;

  ReportPage(this.title, this.ruserid,this.rid, this.type);

  @override
  State<StatefulWidget> createState() {
    return _ReportState(title, ruserid,rid, type);
  }
}

class _ReportState extends State<ReportPage> {
  TextEditingController customController = TextEditingController();
  String ruserid;
  int type;//type 1 举报作品 type 2名言报错
  int rid;
  String title;
  List<String> checks = List<String>();

  _ReportState(this.title, this.ruserid,this.rid, this.type);

  bool isCheck0 = false;
  bool isCheck1 = false;
  bool isCheck2 = false;

  @override
  void initState() {
    super.initState();
    if(type == 1){
      checks = ['侵犯我的权益','内容质量低下','涉及辱骂，歧视，挑衅等'];
    }else if(type == 2){
      checks = ['侵犯我的权益','内容或格式有误','作者信息有误'];
    }else if(type == 3){
      checks = ['侵犯我的权益','内容质量低下','涉及辱骂，歧视，挑衅等'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                if(!(this.isCheck0||this.isCheck1||this.isCheck2)){
                  ToastUtil.showToast(context, '请至少选择一项举报');
                  return ;
                }
                this._onReport();
              },
              child: Text(
                '提交',
                style: TextStyle(color:Colors.white),
              ),
            )
          ],
        ),
        body: Container(
            padding: EdgeInsets.all(10.0),
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                CheckboxListTile(
//          secondary: const Icon(Icons.alarm_on),
                  title: Text(checks[0]),
//            subtitle: Text(''),
                  value: this.isCheck0,
                  onChanged: (bool value) {
                    setState(() {
                      this.isCheck0 = value;
                    });
                  },
                ),
                CheckboxListTile(
//          secondary: const Icon(Icons.alarm_on),
                  title:  Text(checks[1]),
//            subtitle: Text(''),
                  value: this.isCheck1,
                  onChanged: (bool value) {
                    setState(() {
                      this.isCheck1 = value;
                    });
                  },
                ),
                CheckboxListTile(
//          secondary: const Icon(Icons.alarm_on),
                  title:  Text(checks[2]),
//            subtitle: Text(''),
                  value: this.isCheck2,
                  onChanged: (bool value) {
                    setState(() {
                      this.isCheck2 = value;
                    });
                  },
                ),
                TextField(
                    controller: customController,
                    keyboardType: TextInputType.text,
                    minLines: 3,
                    maxLines: 5,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        hintText: '自定义内容',
                        filled: true,
                        fillColor: AppTheme.loginFillColor)),
              ],
            )));
  }

  _onReport() {
    var report = '';
    if(this.isCheck0){
      report += '|'+checks[0];
    }
    if(this.isCheck1){
      report += '|'+checks[1];
    }
    if(this.isCheck2){
      report += '|'+checks[2];
    }
    var custom = customController.text;
    print(report);
    print(custom);
    CHttp.post(
        CHttp.USER_REPORT,
            (data) {
          ToastUtil.showToast(context, data['tips']);
          Navigator.of(context).pop();
        },
        params:
        PReport(Provider.of<App>(context, listen: false).userid,this.ruserid, this.rid,this.type,report,custom)
            .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        });
  }
}
