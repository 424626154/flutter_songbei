import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/models/dating_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/pages/message_center/chat_page.dart';
import 'package:flutter_songbei/pages/user/login_page.dart';
import 'package:flutter_songbei/pages/user/modify_info_page.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/provider/user.dart';
import 'package:flutter_songbei/utils/app_util.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import 'up_dating_page.dart';

class DatingInfoPage extends StatefulWidget {
  String userid;

  DatingInfoPage(this.userid);

  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<DatingInfoPage> {
  DatingModel _datingModel;

  @override
  void initState() {
    super.initState();
    _reqDatingInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的资料'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            height: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                children: [_buildUser(), _buildPersonData()],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton.icon(
                    onPressed: () {
                      _onChat();
                    },
                    icon: Icon(
                      Icons.favorite_outlined,
                      color: Colors.white,
                    ),
                    label: Text('私信'),
                    color: AppTheme.mainColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    textColor: Colors.white,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUser() {
    if(_datingModel != null){
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1.0))),
        child: Container(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  color: AppTheme.grayColor,
                  child: CachedNetworkImage(
                    width: 60,
                    height: 60,
                    imageUrl: UIManager.getHeadurl(_datingModel.head),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  _datingModel.nickname != null ? _datingModel.nickname : '',
                  style: TextStyle(fontSize: 18, color: AppTheme.mainColor),
                ),
              ),
            ],
          ),
        ),
      );
    }else{
      return Container();
    }
  }

  Widget _buildPersonData() {
    if (_datingModel != null) {
      return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              '个人资料',
              style: TextStyle(fontSize: 16),
            ),
            _buildPersonItem('性别', UIManager.getDatingGenderStr(_datingModel)),
            _buildPersonItem('年龄', UIManager.getDatingAgeStr(_datingModel)),
            _buildPersonItem('身高', UIManager.getDatingHeightStr(_datingModel)),
            _buildPersonItem('体重', UIManager.getDatingWeightStr(_datingModel)),
            _buildPersonItem('学历', UIManager.getDatingDegreeStr(_datingModel)),
            _buildPersonItem(
                '所在地', UIManager.getDatingLocationStr(_datingModel)),
            Container(
              padding: EdgeInsets.all(10),
              width: double.maxFinite,
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: Colors.grey.shade300, width: 1.0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '自我描述',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(_datingModel.self_describe)
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildPersonItem(String title, String content) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${title}',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '${content}',
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }

  void _onChat(){
    if (AppUtil.isLogin(context) == false) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      return;
    }
    print('_datingModel:${_datingModel}');
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ChatPage(
          tuserid: _datingModel.userid,
          head: _datingModel.head,
          nickname: _datingModel.nickname,
        )));
  }

  void _reqDatingInfo() {
    print('-----userid:${Provider.of<App>(context, listen: false).userid}');
    CHttp.post(
        CHttp.DATING_MYINFO,
        (data) {
          if (!mounted) {
            return;
          }
          print(data);
          if (data != null) {
            _datingModel = DatingModel.initUser(data);
          }
          setState(() {});
        },
        params: POther(
                Provider.of<App>(context, listen: false).userid, widget.userid)
            .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {});
  }

}
