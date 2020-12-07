import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/models/dating_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/pages/user/login_page.dart';
import 'package:flutter_songbei/pages/user/modify_info_page.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/provider/user.dart';
import 'package:flutter_songbei/utils/app_util.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import 'up_dating_page.dart';

class MyDatingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<MyDatingPage> {

  DatingModel _datingModel;

  @override
  void initState() {
    super.initState();
    _reqMyInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的资料'),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildUser(),
              _buildPersonData()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUser(){
    var user = Provider.of<User>(context);
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1.0))),
      child: Stack(children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                color: AppTheme.grayColor,
                child: CachedNetworkImage(
                  width: 60,
                  height: 60,
                  imageUrl: UIManager.getHeadurl(user.head),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                user.nickname != null?user.nickname:'',
                style: TextStyle(fontSize: 18, color: AppTheme.mainColor),
              ),
            ),
          ],
        ),
        Positioned(
          right: 10,
          child: InkWell(
            child: Image(
              image: AssetImage('assets/user/upuser.png'),
              width: 20,
              height: 20,
              color: AppTheme.grayColor,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ModifyInfoPage()));
            },
          ),
        )
      ],),
    );
  }

  Widget _buildPersonData(){
    if(_datingModel != null){
      return Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text('个人资料',style: TextStyle(fontSize: 16),),
                _buildPersonItem('性别',UIManager.getDatingGenderStr(_datingModel)),
                _buildPersonItem('年龄', UIManager.getDatingAgeStr(_datingModel)),
                _buildPersonItem('身高', UIManager.getDatingHeightStr(_datingModel)),
                _buildPersonItem('体重', UIManager.getDatingWeightStr(_datingModel)),
                _buildPersonItem('学历', UIManager.getDatingDegreeStr(_datingModel)),
                _buildPersonItem('所在地', UIManager.getDatingLocationStr(_datingModel)),
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.shade300, width: 1.0))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '自我描述',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                          _datingModel.self_describe
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.shade300, width: 1.0))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('其他人是否可见',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                     Row(
                       children: [
                         Text('${_datingModel.state == 1 ?'可见':'不可见'}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                         Switch(
                           value: _datingModel.state == 1,
                           onChanged: (bool value){
                             print('value:${value}');
                             var temp_state = 0;
                             if(value == true){
                               // _datingModel.state = 1;
                               temp_state = 1;
                             }else{
                               // _datingModel.state = 0;
                             }
                             // setState(() {
                             //
                             // });
                             _reqUpState(temp_state);
                           },
                         )
                       ],
                     )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: InkWell(
              child: Image(
                image: AssetImage('assets/user/upuser.png'),
                width: 20,
                height: 20,
                color: AppTheme.grayColor,
              ),
              onTap: () {
                _onUpDating();
              },
            ),
          )
        ],
      );
    }else{
      return Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('完善个人资料，获得展示机会',style: TextStyle(fontSize: 18),),
              FlatButton(
                child: Text('去完善 >',style: TextStyle(fontSize: 16,color: AppTheme.mainColor),),
                onPressed: (){
                  _onUpDating();
                },
              )
            ],
          ),
        ),
      );
    }
  }

  Widget _buildPersonItem(String title,String content){
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

  void _onUpDating(){
    if (AppUtil.isLogin(context) == false) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => UpDatingPage(_datingModel)))
        .then((dating){
      if(dating != null){
        _datingModel = dating;
        setState(() {

        });
      }
    });
  }

  void _reqMyInfo() {
    print('-----userid:${Provider.of<App>(context, listen: false).userid}');
    CHttp.post(
        CHttp.DATING_MYINFO,
            (data) {
          if (!mounted) {
            return;
          }
          print(data);
          if(data != null){
            _datingModel = DatingModel(data);
          }
          setState(() {});
        },
        params:
        PUserid(Provider.of<App>(context, listen: false).userid).toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {});
  }

  void _reqUpState(int state){
    CHttp.post(
        CHttp.DATING_UPSTATE,
            (data) {
          if (!mounted) {
            return;
          }
          _datingModel.state = state;
          setState(() {});
        },
        params:
        PUpDatingState(Provider.of<App>(context, listen: false).userid,state).toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {});
  }

}
