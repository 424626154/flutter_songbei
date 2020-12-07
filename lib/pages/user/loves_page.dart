import 'package:flutter/material.dart';
import 'package:flutter_songbei/custom/listitem/love_list_item.dart';
import 'package:flutter_songbei/models/love_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/utils/toast_util.dart';

class LovesPage extends StatefulWidget {
  int id;

  LovesPage(this.id);

  @override
  State<StatefulWidget> createState() {
    return _LovesState(id);
  }
}

class _LovesState extends State<LovesPage> {
  int id;

  List<LoveModel> loves = List<LoveModel>();

  _LovesState(this.id);

  @override
  void initState() {
    _requestLoves();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '点赞',
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
      body: Container(
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: loves.length,
          itemBuilder: (BuildContext context, int positon) {
            return LoveLstItem(loves[positon]);
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 0.5,
              indent: 0,
              color: Color(0xFFDDDDDD),
            );
          },
        ),
      ),
    );
  }

  _requestLoves() {
    var params = PLoves(2, id).toJson();
    CHttp.post(
        CHttp.LOVE_LOVES,
        (data) {
          if (!mounted) {
            return;
          }
          List<LoveModel> temp_loves = List<LoveModel>();
          for (var i = 0; i < data.length; i++) {
            temp_loves.add(LoveModel(data[i]));
          }
          setState(() {
            loves = temp_loves;
          });
        },
        params: params,
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        });
  }
}
