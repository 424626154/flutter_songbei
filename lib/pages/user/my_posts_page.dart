import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/custom/listitem/my_post_list_item.dart';
import 'package:flutter_songbei/models/post_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/network/tag.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../app_theme.dart';

class MyPostsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<MyPostsPage> {
  List<PostModel> posts = List<PostModel>();
  int pull_type = 0;
  int post_count = 0;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _requestNewest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的想法'),
        centerTitle: true,
      ),
      body: _buildPosts(),
    );
  }

  Widget _buildPosts() {
    if (posts.length == 0) {
      return Center(
        child: Text('暂无内容'),
      );
    } else {
      return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: () {
          pull_type = 0;
          _requestNewest();
        },
        onLoading: () {
          pull_type = 1;
          if (posts.length < post_count) {
            _requestHistory();
          } else {
            _refreshController.loadComplete();
            ToastUtil.showToast(context, '已经到底啦！');
          }
        },
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            var post = posts[index];
            return MyPostListItem(post);
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
    }
  }

  _requestNewest() {
    var from_id = posts.length > 0 ? posts[0].id : 0;
    CHttp.post(
        CHttp.DISCUSS_NMYDISCUSS,
        (data) {
          if (!mounted) {
            return;
          }
          print(data);
          posts.clear();
          var temp_posts = data['discuss'];
          post_count = data['count'];
          for (var i = 0; i < temp_posts.length; i++) {
            posts.add(PostModel(temp_posts[i]));
          }
          setState(() {});
        },
        params: PUID(Provider.of<App>(context, listen: false).userid, from_id)
            .toJson(),
        errorCallback: (err) {
          LogUtil.e(err, tag: Tag.TAG_ERROR);
        },
        completeCallback: () {
          if (pull_type == 0) {
            _refreshController.refreshCompleted();
          } else {
            _refreshController.loadComplete();
          }
        });
  }

  _requestHistory() {
    var from_id = posts.length > 0 ? posts[posts.length - 1].id : 0;
    CHttp.post(
        CHttp.DISCUSS_HMYDISCUSS,
        (data) {
          if (!mounted) {
            return;
          }
          print(data);
          var temp_posts = data['discuss'];
          post_count = data['count'];
          for (var i = 0; i < temp_posts.length; i++) {
            posts.add(PostModel(data[i]));
          }
          setState(() {});
        },
        params: PUID(Provider.of<App>(context, listen: false).userid, from_id)
            .toJson(),
        errorCallback: (err) {
          LogUtil.e(err, tag: Tag.TAG_ERROR);
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
