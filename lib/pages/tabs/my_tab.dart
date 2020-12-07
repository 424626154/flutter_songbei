
import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sbb_tools/flutter_sbb_tools.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/network/tag.dart';
import 'package:flutter_songbei/pages/my/setting_page.dart';
import 'package:flutter_songbei/pages/user/follow_page.dart';
import 'package:flutter_songbei/pages/user/login_page.dart';
import 'package:flutter_songbei/pages/user/modify_info_page.dart';
import 'package:flutter_songbei/pages/user/my_posts_page.dart';
import 'package:flutter_songbei/pages/user/my_stars_page.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/provider/user.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import '../../app_config.dart';
import '../../app_theme.dart';

class MyTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<MyTab>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的'),
        centerTitle: true,
        backgroundColor: AppTheme.mainColor,
      ),
      body:Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildUser(),
              Divider(
                height: 5,
                color: Colors.white,
              ),
              _buildItem('assets/my/tiezi.png', '我的帖子', true, _onPosts),
              Divider(
                height: 5,
                color: Colors.white,
              ),
              _buildItem('assets/my/shoucang.png', '我的收藏', true, _onStars),
              Divider(
                height: 5,
                color: Colors.white,
              ),
              _buildItem('assets/my/haoping.png', '给个好评', false, _onAppComment),
              Divider(
                height: 5,
                color: Colors.white,
              ),
              GestureDetector(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300], width: 1.0),
                      color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image(
                              image: AssetImage('assets/my/shezhi.png'),
                              width: 30,
                              height: 30,
                              color: Colors.black87,
                            ),
                            Container(
                              width: 10,
                            ),
                            Text(
                              '设置',
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 18.0),
                            )
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[400],
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  _onSetting();
                },
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget _buildUser() {
    var userid = Provider.of<App>(context).userid;
    if (userid.length > 0) {
      var user = Provider.of<User>(context);
      print(user);
      return Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        width: double.infinity,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
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
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    user.nickname != null?user.nickname:'',
                    style: TextStyle(fontSize: 18, color: AppTheme.mainColor),
                  ),
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          '关注 ${UIManager.getNum0Str(user.myfollow)}',
                          style: TextStyle(color: AppTheme.grayColor),
                        ),
                        onPressed: () {
                          _onMeFollow();
                        },
                      ),
                      SizedBox(
                        width: 1,
                        height: 12,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: AppTheme.grayColor),
                        ),
                      ),
                      FlatButton(
                        child: Text(
                          '粉丝  ${UIManager.getNum0Str(user.followme)}',
                          style: TextStyle(color: AppTheme.grayColor),
                        ),
                        onPressed: () {
                          _onFollowMe();
                        },
                      ),
                    ],
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
          ],
        ),
      );
    } else {
      return InkWell(
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
          width: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  color: AppTheme.grayColor,
                  child: Image(
                    width: 60,
                    height: 60,
                    image: AssetImage('assets/head.png'),
                    fit: BoxFit.fill,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Text(
                  '未登录',
                  style: TextStyle(fontSize: 18, color: AppTheme.grayColor),
                ),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
              builder: (BuildContext context) => LoginPage()))
              .then((value) => {
            _reqUserInfo()
          });
        },
      );
    }
  }

  Widget _buildItem(icon, title, b_login, func) {
    if (Provider.of<App>(context).userid.length > 0 || !b_login) {
      return GestureDetector(
        child: DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300], width: 1.0),
              color: Colors.white),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image(
                      image: AssetImage(icon),
                      width: 30,
                      height: 30,
                      color: Colors.black87,
                    ),
                    Container(
                      width: 10,
                    ),
                    Text(
                      title,
                      style: TextStyle(color: Colors.black87, fontSize: 18.0),
                    )
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                )
              ],
            ),
          ),
        ),
        onTap: () {
          func();
        },
      );
    } else {
      return Container();
    }
  }

  void _onMeFollow(){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            FollowPage(0, Provider.of<App>(context, listen: false).userid)));
  }

  void _onFollowMe(){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            FollowPage(1, Provider.of<App>(context, listen: false).userid)));
  }

  void _onPosts() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => MyPostsPage()));
  }

  void _onStars() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            MyStarsPage(Provider.of<App>(context, listen: false).userid)));
  }
  void _onAppComment() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    FlutterSbbTools.joinAppComment(
        AppConfig.IOS_APP_ID, packageInfo.packageName, "");
  }
  void _onSetting() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => SettingPage()));
  }

  void _reqUserInfo(){
    CHttp.post(
        CHttp.USER_INFO,
            (data) {
          if (!mounted) {
            return;
          }
          if (data != null) {
            Provider.of<User>(context, listen: false).upUser(data);
          }
        },
        params: PUserid(Provider.of<App>(context, listen: false).userid).toJson(),
        errorCallback: (err) {
          LogUtil.e(err, tag: Tag.TAG_ERROR);
        });
  }

}