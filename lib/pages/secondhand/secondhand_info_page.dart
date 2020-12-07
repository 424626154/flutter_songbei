
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/custom/follow_user.dart';
import 'package:flutter_songbei/custom/listitem/comment_list_item.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/models/comment_model.dart';
import 'package:flutter_songbei/models/follow_model.dart';
import 'package:flutter_songbei/models/photo_gallery_model.dart';
import 'package:flutter_songbei/models/secondhand_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/pages/message_center/chat_page.dart';
import 'package:flutter_songbei/pages/user/login_page.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/utils/app_util.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:provider/provider.dart';

import '../../AppEnums.dart';
import '../../app_theme.dart';
import '../photos_gallery_page.dart';
import 'secondhand_comment_page.dart';

class SecondhandInfoPage extends StatefulWidget {
  int id;
  SecondhandInfoPage(this.id);
  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
  
}

class _PageState extends State<SecondhandInfoPage> {

  SecondhandModel _secondhandModel;
  FollowModel follow;
  List<CommentModel> comments = List<CommentModel>();

  @override
  void initState() {
    super.initState();
    _reqSecondhandInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('二手物品'),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context){
    if(_secondhandModel != null){
      return Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 80),
            decoration: BoxDecoration(color: Colors.white),
            child: ListView(
              children: <Widget>[
                _buildFollow(),
                _buildSecondhand(context),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (BuildContext context, int positon) {
                    return CommentLstItem(comments[positon], showLove:false,onComment:(item) {
//                        print('----item:${item}');
                      _onComment(_secondhandModel.id,item.id,item.cuserid,item.head,item.nickname,'回复[${item.nickname}]');
                    }, onDel:(item) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('删除评论'),
                              content: Container(
                                child: Text('是否确认删除评论?'),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: const Text('取消'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                    child: const Text('确认'),
                                    onPressed: () {
                                      _onDelComment(item);
                                      Navigator.of(context).pop();
                                    }),
                              ],
                            );
                          });
                    });
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 0.5,
                      indent: 0,
                      color: Color(0xFFDDDDDD),
                    );
                  },
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                border: Border(top:BorderSide(color: Colors.grey.shade200, width: 1.0) )
              ),
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton.icon(
                    onPressed: () {
                      _onComment(_secondhandModel.id,0,'','','','编辑留言');
                    },
                    icon: Icon(
                      Icons.favorite_outlined,
                      color: Colors.white,
                    ),
                    label: Text('留言'),
                    color: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    textColor: Colors.white,
                  ),
                 Container(width: 10,),
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
      );
    }else{
      return Container();
    }
  }

  Widget _buildFollow() {
    print('------_buildFollow');
    print(follow);
    if (follow != null) {
      return Container(
        child: FollowUser(1, follow, (item) {}),
      );
    } else {
      return Container();
    }
  }


  Widget _buildSecondhand(BuildContext context){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Text('¥${_secondhandModel.price}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.deepOrange),),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Text(
            _secondhandModel.content,
            style: TextStyle(fontSize: 16),
          ),
        ),
        _buildPhotos(context),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                UIManager.getTime(_secondhandModel.time),
                style:
                TextStyle(fontSize: 14,color: AppTheme.grayColor),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildPhotos(BuildContext context) {
    if (_secondhandModel.postExtend != null && _secondhandModel.postExtend.photos.length > 0) {
      var photos = _secondhandModel.postExtend.photos;
      return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext content, int index) {
            return InkWell(
              child: Container(
                constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.width),
                child: CachedNetworkImage(
                  imageUrl: UIManager.getHeadurl(photos[index].photo),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              onTap: (){
                List<PhotoGalleryModel> gallery_photos = List<PhotoGalleryModel>();
                photos.forEach((element) {
                  gallery_photos.add(PhotoGalleryModel(element.photo));
                });
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => PhotosGalleryPage(gallery_photos,index)));
              },
            );
          },
          itemCount: photos.length,
        ),
      );
    } else {
      return Container();
    }
  }

  void _onDelComment(CommentModel comment) {
    if (!AppUtil.isLogin(context)) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()))
          .then((perfect) {
        if (perfect != null) {}
      });
      return;
    }
    var params = PDelCommentV2(
      PostType.Secondhand.index,
      Provider.of<App>(context, listen: false).userid,
      comment.id,)
        .toJson();
    CHttp.post(
        CHttp.COMMENT_DELV2,
            (data) {
          for (var i = comments.length - 1; i >= 0; i--) {
            if (comments[i].id == comment.id) {
              comments.removeAt(i);
            }
          }
          setState(() {});
        },
        params: params,
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        });
  }

  void _reqSecondhandInfo() {
    print('-----userid:${Provider.of<App>(context, listen: false).userid}');
    CHttp.post(
        CHttp.SECONDHAND_INFO,
            (data) {
          if (!mounted) {
            return;
          }
          if(data != null){
            _secondhandModel = SecondhandModel(data);
            _requestFloow(_secondhandModel.userid);
            _requestNewestComment();
          }
          setState(() {});
        },
        params:
        PUID(Provider.of<App>(context, listen: false).userid,widget.id).toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {});
  }

  /**
   * 请求评论列表
   */
  void _requestNewestComment() {
    var fromid = 0;
    if (comments.length > 0) {
      fromid = comments[0].id;
    }
    CHttp.post(
        CHttp.COMMENT_LATEST,
            (data) {
          if (!mounted) {
            return;
          }
          List<CommentModel> temp_comments = List<CommentModel>();
          for (var i = 0; i < data.length; i++) {
            temp_comments.add(CommentModel(data[i]));
          }
          comments.insertAll(0, temp_comments);
          setState(() {});
//          print(data);
        },
        params: PComment(PostType.Secondhand.index, fromid, _secondhandModel.id).toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        });
  }

  void _onChat(){
    if (AppUtil.isLogin(context) == false) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ChatPage(
          tuserid: _secondhandModel.userid,
          head: _secondhandModel.head,
          nickname: _secondhandModel.nickname,
        )));
  }

  void _onComment(int id,int cid,String cuserid,String chead,String cnickname,String hintText){
    if (AppUtil.isLogin(context) == false) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => SecondhandCommentPage(
            id,
            cid,
            cuserid,
            chead,
            cnickname,
            hintText
        )))
    .then((element){
      print('-element:${element}');
      if(element != null){
        comments.insert(0, element);
        setState(() {

        });
      }
    });
  }

  void _requestFloow(String fansid){
    CHttp.post(
        CHttp.USER_FOLLOWINFO,
            (data) {
          if (!mounted) {
            return;
          }
          follow = FollowModel(data);
          setState(() {});
        },
        params:
        PFollowUser(Provider.of<App>(context, listen: false).userid, fansid).toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        });
  }
}