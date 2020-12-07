import 'package:flutter/material.dart';
import 'package:flutter_songbei/AppEnums.dart';
import 'package:flutter_songbei/custom/listitem/star_post_list_item.dart';
import 'package:flutter_songbei/models/post_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../app_theme.dart';

class MyStarsPage extends StatefulWidget {
  String userid;

  MyStarsPage(this.userid);

  @override
  State<StatefulWidget> createState() {
    return _PageState(userid);
  }
}

class _PageState extends State<MyStarsPage>
    with SingleTickerProviderStateMixin {
  String userid;

  _PageState(this.userid);

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
    _requestNStar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的收藏'),
        centerTitle: true,
      ),
      body: Container(
        child: _buildPosts(),
      ),
    );
  }

  Widget _buildPosts() {
    if (posts.length > 0) {
      return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading:_onLoading,
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            var item = posts[index];
            return StarPostListItem(item);
          },
          itemCount: posts.length,
          separatorBuilder: (context, index) {
            return Divider(
              height: 0.5,
              indent: 0,
              color: AppTheme.grayColor,
            );
          },
        ),
      );
    } else {
      return Center(
        child: Text('暂无收录'),
      );
    }
  }

  void _onRefresh() {
    pull_type = 0;
    _requestNStar();
  }

  void _onLoading() {
    pull_type = 1;
    if (posts.length < count) {
      _requestHStar();
    } else {
      _refreshController.loadComplete();
    }
  }

  void _requestNStar() {
    var from_id = 0;
    if (posts.length > 0) {
      from_id = posts[0].id;
    }
//    print(PStars(userid,type,from_id).toJson().toString());

    CHttp.post(
        CHttp.NSTARS,
        (data) {
          print(data);
          var stars = data['stars'];
          count = data['count'];
          List<PostModel> temp_posts = List<PostModel>();
          for (var i = 0; i < stars.length; i++) {
            temp_posts.add(PostModel(stars[i]));
          }
          posts.insertAll(0, temp_posts);
          setState(() {});
        },
        params: PStars(userid, PostType.ImageText.index, from_id).toJson(),
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

  void _requestHStar() {
    var from_id = 0;
    if (posts.length > 0) {
      from_id = posts[posts.length - 1].id;
    }
    CHttp.post(
        CHttp.HSTARS,
        (data) {
          count = data['count'];
          var stars = data['stars'];
          for (var i = 0; i < stars.length; i++) {
            posts.add(PostModel(stars[i]));
          }
          setState(() {});
        },
        params: PStars(userid, PostType.ImageText.index, from_id).toJson(),
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
}
