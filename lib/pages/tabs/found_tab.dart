import 'package:flutter/material.dart';
import 'package:flutter_songbei/custom/listitem/post_list_item.dart';
import 'package:flutter_songbei/models/post_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/pages/post/post_page.dart';
import 'package:flutter_songbei/pages/user/login_page.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/utils/app_util.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../app_theme.dart';

class FoundTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<FoundTab> {
  List<PostModel> posts = List<PostModel>();

  /**
   *  0 下拉刷新 1 上拉刷新
   */
  int pull_type = 0;

  int count = 0;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    pull_type = 0;
    _requestNDiscuss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('发现'),
        backgroundColor: AppTheme.mainColor,
        centerTitle: true,
      ),
      body: Container(
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView.separated(
            itemBuilder: (content, index) {
              return PostListItem(
                posts[index],
                index,
                this.onItem,
                onStar: (item) {
                  if (AppUtil.isLogin(context) == false) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                    return;
                  }
                  _reqPostStar(item);
                },
                onLove: (item) {
                  if (AppUtil.isLogin(context) == false) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                    return;
                  }
                  _reqPostLove(item);
                },
              );
            },
            itemCount: posts.length,
            separatorBuilder: (context, index) {
              return Divider(
                height: 0.5,
                indent: 0,
                color: Color(0xFFDDDDDD),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onRefresh() {
    pull_type = 0;
    _requestNDiscuss();
  }

  void _onLoading() {
    pull_type = 1;
    if (posts.length < count) {
      _requestHDiscuss();
    } else {
      _refreshController.loadComplete();
    }
  }

  void onItem(item) {
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

  void _requestNDiscuss() {
    var fromid = 0;
    var forms = posts;
    if (forms.length > 0) {
      fromid = forms[0].id;
    }
    CHttp.post(
        CHttp.DISCUSS_NDISCUSS,
        (data) {
          if (!mounted) {
            return;
          }
          count = data['count'];
          var temp_discuss = List<PostModel>();
          var res_discuss = data['discuss'];
          for (var i = 0; i < res_discuss.length; i++) {
            temp_discuss.add(PostModel(res_discuss[i]));
          }
          posts.insertAll(0, temp_discuss);
          setState(() {
          });
          print(posts);
        },
        params:
            PDiscuss(Provider.of<App>(context, listen: false).userid, fromid)
                .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {
          if (pull_type == 0) {
            _refreshController.refreshCompleted();
          } else {
            _refreshController.loadComplete();
          }
        });
  }

  void _requestHDiscuss() {
    var fromid = 0;
    var forms = posts;
    if (forms.length > 0) {
      fromid = forms[forms.length - 1].id;
    }
    CHttp.post(
        CHttp.DISCUSS_HDISCUSS,
        (data) {
          if (!mounted) {
            return;
          }
          count = data['count'];
          var temp_discuss = List<PostModel>();
          var res_discuss = data['discuss'];
          for (var i = 0; i < res_discuss.length; i++) {
            temp_discuss.add(PostModel(res_discuss[i]));
          }
          posts.addAll(temp_discuss);
          setState(() {
          });
          print(posts);
        },
        params: PDiscuss(Provider.of<App>(context).userid, fromid).toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {
          if (pull_type == 0) {
            _refreshController.refreshCompleted();
          } else {
            _refreshController.loadComplete();
          }
        });
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
