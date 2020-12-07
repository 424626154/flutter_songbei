import 'package:flutter/material.dart';
import 'package:flutter_songbei/custom/listitem/follow_list_item.dart';
import 'package:flutter_songbei/models/follow_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FollowPage extends StatefulWidget {
  int type = 0;
  String myid = '';
  FollowPage(this.type,this.myid);

  @override
  State<StatefulWidget> createState() {
    return _FollowState(type,myid);
  }
}

class _FollowState extends State<FollowPage> {
  int type = 0;
  String myid = '';

  _FollowState(this.type,this.myid);

  List<FollowModel> datas = List<FollowModel>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestFollows();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          type == 1 ? '关注我的' : '我的关注',
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
        padding: EdgeInsets.all(10),
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ListView.separated(
            itemBuilder: (item, index) {
              return FollowListItem(datas[index],(item){
                _reqFollow(item);
              });
            },
            itemCount: datas.length,
            separatorBuilder: (context, index) {
              return Divider(
                height: .5,
                indent: 0,
                color: Color(0xFFDDDDDD),
              );
            },
          ),
        ),
      ),
    );
  }

  _onRefresh() {
    _requestFollows();
  }

  _requestFollows() {
    var user_id = Provider.of<App>(context,listen: false).userid;
    CHttp.post(
        CHttp.USER_FOLLOWS,
        (data) {
          if (!mounted) {
            return;
          }
          List<FollowModel> temp = List<FollowModel>();
          for (var i = 0; i < data.length; i++) {
            temp.add(FollowModel(data[i]));
          }
          setState(() {
            datas = temp;
          });
        },
        params: PFollow(myid, user_id, type).toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {
          _refreshController.refreshCompleted();
        });
  }

  _reqFollow(follow){
    print('follow:${follow}');
    CHttp.post(
        CHttp.USER_FOLLOW,
            (data) {
          print('id:${data['id']}');
          for(var i = 0 ; i < datas.length ; i ++){
            print('datas id:${datas[i].id }');
            if(datas[i].id == data['id']){
              print('fstate:${data['fstate']}');
              datas[i].fstate = data['fstate'];
            }
          }
          setState(() {

          });
        },
        params: PFollowOp(type == 1?follow.fansid:follow.userid,follow.userid,follow.fstate == 0?1:0).toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        });
  }
}
