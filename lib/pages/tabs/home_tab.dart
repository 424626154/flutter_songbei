
import 'package:flutter/material.dart';
import 'package:flutter_banner_swiper/flutter_banner_swiper.dart';
import 'package:flutter_songbei/app_theme.dart';
import 'package:flutter_songbei/custom/item/home_banner_item.dart';
import 'package:flutter_songbei/custom/item/home_menu_item.dart';
import 'package:flutter_songbei/custom/listitem/post_list_item.dart';
import 'package:flutter_songbei/models/banner_model.dart';
import 'package:flutter_songbei/models/menu_model.dart';
import 'package:flutter_songbei/models/post_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/pages/post/post_page.dart';
import 'package:flutter_songbei/pages/user/login_page.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/utils/app_util.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }

}

class _PageState extends State<HomeTab>{

  List<BannerModel> banners = List<BannerModel>();
  List<MenuModel> menus = List<MenuModel>();
  List<PostModel> posts = List<PostModel>();

  @override
  void initState() {
    super.initState();
    _reqHome();
    _reqPostHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
        backgroundColor: AppTheme.mainColor,
        centerTitle: true,
      ),
      body:RefreshIndicator(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: BannerSwiper(
                //width  和 height 是图片的高宽比  不用传具体的高宽   必传
                height: 16,
                width: 9,
                spaceMode:false,
                //轮播图数目 必传
                length: banners.length,
                //轮播的item  widget 必传
                getwidget: (index) {
//                banners[index % banners.length].cover
                  return HomeBannerItem(banners[index % banners.length]);
                },
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
//                crossAxisSpacing: 8.0,//主轴中间间距
//                mainAxisSpacing: 8.0,//副轴中间间距
                childAspectRatio: 0.9,//item 宽高比
              ),
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return HomeMenuItem(menus[index]);
                },
                childCount: menus.length,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return PostListItem(posts[index],index,_onItem,onLove: (item){
                    if (AppUtil.isLogin(context) == false) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                      return;
                    }
                    _reqPostLove(item);
                  },onStar: (item){
                    if (AppUtil.isLogin(context) == false) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                      return;
                    }
                    _reqPostStar(item);
                  },);
                },
                childCount: posts.length,
              ),
            )
          ],
        ),
        onRefresh: _onRefresh,
      )
    );
  }

  Future<void> _onRefresh() async {
    _reqHome();
  }

  void _onItem(item) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PostPage(item.id)))
        .then((res) {
      if (res != null) {
        print('-----res');
        print(res);
        if (res['action'] == 'del') {
          var id = res['id'];
          var temp_discuss = posts;
          for (var i = temp_discuss.length - 1; i >= 0; i--) {
            if (temp_discuss[i].id == id) {
              temp_discuss.removeAt(i);
            }
          }
          this.setState(() {
            posts = temp_discuss;
          });
        }
      }
    });
  }

  void _reqHome() {
    CHttp.post(
        CHttp.HOME_HOME,
            (data) {
          if (!mounted) {
            return;
          }
          var s_banner = data['banner'];
          banners.clear();
          if (s_banner != null) {
            for (var i = 0; i < s_banner.length; i++) {
              var banner = BannerModel(s_banner[i]);
              banners.add(banner);
            }
          }
          var s_menus = data['menus'];
          menus.clear();
          if (s_menus != null) {
            for (var i = 0; i < s_menus.length; i++) {
              var menu = MenuModel(s_menus[i]);
              menus.add(menu);
            }
          }
          setState(() {});
        },
        params: PUserid(Provider.of<App>(context, listen: false).userid)
            .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {});
  }

  void _reqPostHome() {
    var fromid = 0;
    CHttp.post(
        CHttp.DISCUSS_HOME,
            (data) {
          if (!mounted) {
            return;
          }
          var count = data['count'];
          var temp_discuss = List<PostModel>();
          var res_discuss = data['discuss'];
          for (var i = 0; i < res_discuss.length; i++) {
            temp_discuss.add(PostModel(res_discuss[i]));
          }
          posts.insertAll(0, temp_discuss);
          setState(() {
          });
        },
        params: PHDiscuss(Provider.of<App>(context, listen: false).userid,fromid,1)
            .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {});
  }

  void _reqPostStar(PostModel post) {
    print(post);
    var star = post.mystar != null&&post.mystar == 1 ? 0 : 1;
    CHttp.post(
        CHttp.STATR,
            (data) {
          if (!mounted) {
            return;
          }
          post.mystar = star;
          var starnum = post.starnum != null?post.starnum :0;
          if (star == 1) {
            starnum += 1;
          } else {
            if (starnum > 0) {
              starnum -= 1;
            }
          }
          post.starnum = starnum;
          setState(() {});
          ToastUtil.showToast(context, star == 1 ? '收藏成功' : '取消收藏');
          print(data);
        },
        params: PStar(Provider.of<App>(context, listen: false).userid, 3,
            post.id, star)
            .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        });
  }

  void _reqPostLove(PostModel post) {
    CHttp.post(
        CHttp.LOVE_LOVE,
            (data) {
          if (!mounted) {
            return;
          }
          print(data);
          var love = data['love'];
          var lovenum = post.lovenum;
          if (love == 1) {
            lovenum += 1;
          } else {
            if (lovenum > 0) {
              lovenum -= 1;
            }
          }
          post.lovenum = lovenum;
          post.mylove = love;
          setState(() {});
        },
        params: PPostLove(Provider.of<App>(context, listen: false).userid,3,
            post.id, post.mylove == 0 ? 1 : 0)
            .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {

        });
  }

}