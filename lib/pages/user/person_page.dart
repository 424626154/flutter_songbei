import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/custom/item/dating_item.dart';
import 'package:flutter_songbei/custom/item/user_menu_item.dart';
import 'package:flutter_songbei/custom/listitem/my_post_list_item.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/models/dating_model.dart';
import 'package:flutter_songbei/models/photo_gallery_model.dart';
import 'package:flutter_songbei/models/post_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/network/tag.dart';
import 'package:flutter_songbei/pages/message_center/chat_page.dart';
import 'package:flutter_songbei/pages/my/report_page.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/provider/user.dart';
import 'package:flutter_songbei/utils/app_util.dart';
import 'package:flutter_songbei/utils/toast_util.dart';

import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../photos_gallery_page.dart';
import 'follow_page.dart';
import 'login_page.dart';

class PersonPage extends StatefulWidget {
  String userid;

  PersonPage(this.userid);

  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<PersonPage> with SingleTickerProviderStateMixin {
  String userid;
  User user;

  List<PostModel> posts = List<PostModel>();
  DatingModel _datingModel;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2)
      ..addListener(() {
        if (_tabController.index.toDouble() == _tabController.animation.value) {
          switch (_tabController.index) {
            case 0:
              if (posts.length == 0) {
                _reqPosts();
              }
              break;
            case 1:
              _reqDatingInfo();
              break;
          }
        }
      });
    userid = widget.userid;
    _requestOtherInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text('个人信息'),
//        centerTitle: true,
//      ),
      backgroundColor: AppTheme.mainColor,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerScrolled) => <Widget>[
              SliverAppBar(
                backgroundColor: AppTheme.mainColor,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back_ios),
                ),
                elevation: 0,
                automaticallyImplyLeading: false,
                title: Text('个人信息'),
                centerTitle: true,
                // 标题居中
                expandedHeight: 385.0,
                // 展开高度
                floating: true,
                // 随着滑动隐藏标题
                pinned: true,
                // 固定在顶部
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  background: Container(
                    margin: EdgeInsets.only(top: kToolbarHeight),
                    color: Colors.white,
                    child: _buildUser(),
                  ),
                ),
                actions: <Widget>[
                  PopupMenuButton(
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuItem<String>>[
                      PopupMenuItem<String>(value: 'report', child: Text('举报')),
                      PopupMenuItem<String>(value: 'pullblack', child: Text('拉黑')),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case 'report':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReportPage('举报用户',0,userid,2)));
                          break;
                        case 'pullblack':
                          showDialog(context: context,
                              builder: (context) {
                                return AlertDialog(title: Text('拉黑', style: TextStyle(color: Colors.redAccent)),
                                    content: Container(
//                    height: MediaQuery.of(context).size.height/2,
                                      child: SingleChildScrollView(
                                        child: Container(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            '是否确认将[${user.nickname}]拉黑?',
                                            style: TextStyle(
                                                fontSize: 18.0
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(child: Text("取消"), onPressed: () => {
                                        Navigator.of(context).pop()
                                      }),
                                      FlatButton(child: Text("确认"), onPressed: (){
                                        _onPullblack();
                                        Navigator.of(context).pop();
                                      }),
                                    ]);
                              });
                          break;
                      }
                    },
                  )
                ],
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SilverAppBarDelegate(TabBar(
                  labelColor: AppTheme.mainColor,
                  indicatorColor: AppTheme.mainColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  unselectedLabelColor: AppTheme.grayColor,
                  controller: _tabController,
                  tabs: <Widget>[
                    Tab(
                      text: "帖子",
                    ),
                    Tab(
                      text: "个人资料",
                    ),
                  ],
                )),
              )
            ],
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _buildPosts(),
                _buildDating(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUser() {
    if (user != null) {
      return Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 60),
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [AppTheme.mainColor, AppTheme.mainLightestColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        color: AppTheme.grayColor,
                        child: CachedNetworkImage(
                          width: 60,
                          height: 60,
                          imageUrl: user.head,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    onTap: () {
                      var index = 0;
                      List<PhotoGalleryModel> gallery_photos =
                          List<PhotoGalleryModel>();
                      gallery_photos.add(PhotoGalleryModel(user.head));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PhotosGalleryPage(gallery_photos, index)));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      '${user.nickname}',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                      '${user.profile}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: <Widget>[
                  //       Container(
                  //         padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(20),
                  //         ),
                  //         child: Row(
                  //           children: <Widget>[
                  //             Image(
                  //               image: AssetImage(user.gender == 1
                  //                   ? 'assets/user/xingbienan.png'
                  //                   : 'assets/user/xingbienv.png'),
                  //               width: 20,
                  //               height: 20,
                  //             ),
                  //             Padding(
                  //               padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  //               child: Text(
                  //                 UIManager.getAge(user.birth_date),
                  //                 style: TextStyle(fontWeight: FontWeight.bold),
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            UIManager.getFollowStr(user),
                            style: TextStyle(color: Colors.white),
                          ),
                          color: UIManager.getFollowColor(user),
                          shape: StadiumBorder(),
                          onPressed: () {
                            _onFollow();
                          },
                        ),
                        Container(
                          width: 20,
                        ),
                        RaisedButton(
                          child: Text(
                            '私信',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                          shape: StadiumBorder(),
                          onPressed: () {
                            _onChat();
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: UserMenuItem(
              user,
              onMeFollow: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => FollowPage(0, userid)));
              },
              onFollowMe: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => FollowPage(1, userid)));
              },
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildPosts() {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        var post = posts[index];
        return MyPostListItem(post);
      },
      itemCount: posts.length,
      separatorBuilder: (context, index) {
        return Divider(height: 0.5, indent: 0, color: Colors.grey.shade300);
      },
    );
  }

  Widget _buildDating() {
    if (_datingModel != null) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                '个人资料',
                style: TextStyle(fontSize: 16),
              ),
              DatingItem('性别', UIManager.getDatingGenderStr(_datingModel)),
              DatingItem('年龄', UIManager.getDatingAgeStr(_datingModel)),
              DatingItem('身高', UIManager.getDatingHeightStr(_datingModel)),
              DatingItem('体重', UIManager.getDatingWeightStr(_datingModel)),
              DatingItem('学历', UIManager.getDatingDegreeStr(_datingModel)),
              DatingItem('所在地', UIManager.getDatingLocationStr(_datingModel)),
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
                    Text(_datingModel.self_describe)
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  void _onFollow() {
    if (AppUtil.isLogin(context) == false) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      return;
    }
    _requestFollow();
  }

  void _onChat() {
    if (AppUtil.isLogin(context) == false) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ChatPage(
              tuserid: userid,
              head: user.head,
              nickname: user.nickname,
            )));
  }

  void _requestOtherInfo() {
    CHttp.post(
        CHttp.USER_OTHERINFO,
        (data) {
          print(data);
          user = User.initData(data);
          setState(() {});
          _reqPosts();
        },
        params: POther(Provider.of<App>(context, listen: false).userid, userid)
            .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {});
  }

  void _requestFollow() {
    CHttp.post(
        CHttp.USER_FOLLOW,
        (data) {
          setState(() {
            user.fstate = data['fstate'];
          });
        },
        params: PFollowOp(Provider.of<App>(context, listen: false).userid,
                user.userid, user.fstate == 0 ? 1 : 0)
            .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        });
  }

  void _reqPosts() {
    CHttp.post(
        CHttp.DISCUSS_MYDISCUSS,
        (data) {
          if (!mounted) {
            return;
          }
          print(data);
          posts.clear();
          for (var i = 0; i < data.length; i++) {
            posts.add(PostModel(data[i]));
          }
          setState(() {});
        },
        params: PUserid(userid).toJson(),
        errorCallback: (err) {
          LogUtil.e(err, tag: Tag.TAG_ERROR);
        },
        completeCallback: () {});
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

  void _onPullblack(){
    CHttp.post(
        CHttp.USER_PUSHBLACK,
            (data) {
          setState(() {});
          ToastUtil.showToast(context, '拉黑成功');
        },
        params: PBlack(Provider.of<App>(context, listen: false).userid, userid)
            .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {});
  }

}

class _SilverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SilverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 1.0))),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
