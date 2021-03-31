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
  String ruserid;
  String title;

  ReportPage(this.title, this.rid, this.ruserid, this.type);

  @override
  State<StatefulWidget> createState() {
    return _ReportState(title, rid, ruserid, type);
  }
}

class _ReportState extends State<ReportPage> {
  TextEditingController customController = TextEditingController();

  int type;
  int rid;
  String ruserid;
  String title;

  _ReportState(this.title, this.rid, this.ruserid, this.type);

  bool isCheck0 = false;
  bool isCheck1 = false;
  bool isCheck2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
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
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                if (!(this.isCheck0 || this.isCheck1 || this.isCheck2)) {
                  ToastUtil.showToast(context, '请至少选择一项举报');
                  return;
                }
                this._onReport();
              },
              child: Text(
                '提交',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        body: Container(
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                CheckboxListTile(
//          secondary: const Icon(Icons.alarm_on),
                  title: Text(_getTips(0)),
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
                  title: Text(_getTips(1)),
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
                  title: Text(_getTips(2)),
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
                    )),
              ],
            )));
  }

  /**
   * 1 帖子 2 用户
   */
  String _getTips(int index) {
    if (type == 2) {
      switch (index) {
        case 0:
          return '头像，昵称，签名违规';
        case 1:
          return '冒充官方';
        case 2:
          return '侵犯权益';
      }
    } else {
      switch (index) {
        case 0:
          return '侵犯我的权益';
        case 1:
          return '内容质量低下';
        case 2:
          return '涉及辱骂，歧视，挑衅等';
      }
    }
  }

  _onReport() {
    var report = '';
    if (this.isCheck0) {
      report += '|' + _getTips(0);
    }
    if (this.isCheck1) {
      report += '|' + _getTips(1);
    }
    if (this.isCheck2) {
      report += '|' + _getTips(2);
    }
    var custom = customController.text;
    print(report);
    print(custom);
    CHttp.post(
        CHttp.REPORT,
        (data) {
          ToastUtil.showToast(context, data['tips']);
          Navigator.of(context).pop();
        },
        params: PReport(Provider.of<App>(context, listen: false).userid,
                this.ruserid, this.rid, this.type, report, custom)
            .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        });
  }
}
