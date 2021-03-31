import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/custom/follow_user.dart';
import 'package:flutter_songbei/custom/listitem/comment_list_item.dart';
import 'package:flutter_songbei/custom/listitem/post_love_lits_item.dart';
import 'package:flutter_songbei/custom/loading.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/models/comment_model.dart';
import 'package:flutter_songbei/models/follow_model.dart';
import 'package:flutter_songbei/models/love_model.dart';
import 'package:flutter_songbei/models/photo_gallery_model.dart';
import 'package:flutter_songbei/models/post_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/pages/my/report_page.dart';
import 'package:flutter_songbei/pages/user/login_page.dart';
import 'package:flutter_songbei/pages/user/loves_page.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/utils/app_util.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:provider/provider.dart';

import '../../app_enums.dart';
import '../../app_theme.dart';
import '../photos_gallery_page.dart';

class PostPage extends StatefulWidget {
  int id;

  PostPage(this.id);

  @override
  State<StatefulWidget> createState() {
    return _PageState(id);
  }
}

class _PageState extends State<PostPage> {
  int id;
  PostModel post;
  FollowModel follow;
  List<CommentModel> comments = List<CommentModel>();
  List<LoveModel> loves = List<LoveModel>();

  TextEditingController _textController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  String placeholder = '发表评论...';
  String ctips = '';
  int cid = 0;
  String cnickname = '';
  String ccomment = '';
  String comment = '';

  _PageState(this.id);

  @override
  void initState() {
    super.initState();
    _requestDiscuss();
    _requestNewestComment();
    _requestLoves();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('帖子'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    print('_buildBody');
    print(post);
    if (post != null) {
      return Column(
        children: <Widget>[
          Flexible(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white),
              child: ListView(
                children: <Widget>[
                  _buildFollow(),
                  _buildPost(context),
                  _buildLoves(),
                  _buildMenus(),
                  Row(
                    children: <Widget>[Text('全部回复:${post.commentnum}')],
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    itemBuilder: (BuildContext context, int positon) {
                      return CommentLstItem(comments[positon], onComment:(item) {
//                        print('----item:${item}');
                        if (AppUtil.isLogin(context) == false) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                          return;
                        }
                        _renderTips(item.id, item.nickname, item.comment);
                      }, onLove:(item) {
                        _onLoveComment(item);
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
          ),
          Divider(height: 1.0),
          Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(), //页面下方的文本输入控件
          )
        ],
      );
    } else {
      return Loading();
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

  Widget _buildPost(BuildContext context) {
    print('post.time:${post.time}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Text(
            post.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Text(
            post.content,
            style: TextStyle(fontSize: 16),
          ),
        ),
        _buildPhotos(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              UIManager.getTime(post.time),
              style:
              TextStyle(fontSize: 14,color: AppTheme.grayColor),
            )
          ],
        )
      ],
    );
  }

  Widget _buildPhotos(BuildContext context) {
    if (post.postExtend != null && post.postExtend.photos.length > 0) {
      var photos = post.postExtend.photos;
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

  Widget _buildLoves() {
    if (post.lovenum > 0) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LovesPage(id)));
        },
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width/2,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: loves.length,
                  itemBuilder: (BuildContext context, int positon) {
                    return PostLoveListItem(loves[positon]);
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 0.5,
                      indent: 0,
                      color: Color(0xFFDDDDDD),
                    );
                  },
                ),
              ),
              Divider(
                height: 5,
                color: Colors.white,
              ),
              Text(
                '${post.lovenum}人赞过 >',
                style: TextStyle(color: Colors.black45),
              )
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildMenus() {
    print('-----_buildMenus');
    print(post);
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            child: Column(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      border: Border.all(color: AppTheme.grayColor)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage(
                            UIManager.getLoveAssetImage(post.mylove)),
                        width: 20,
                        height: 20,
                        color: UIManager.getLoveColor(post.mylove),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    UIManager.getNumStr(post.lovenum),
                    style: TextStyle(color: AppTheme.grayColor),
                  ),
                )
              ],
            ),
            onTap: () {
              _onLove();
            },
          ),
          SizedBox(
            width: 40,
            height: 40,
          ),
          InkWell(
            child: Column(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      border: Border.all(color: AppTheme.grayColor)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage(
                            UIManager.getStarAssetImage(post.mystar)),
                        width: 20,
                        height: 20,
                        color: UIManager.getStarColor(post.mystar),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    UIManager.getNumStr(post.starnum),
                    style: TextStyle(color: AppTheme.grayColor),
                  ),
                )
              ],
            ),
            onTap: () {
              _onStar();
            },
          ),
          SizedBox(
            width: 40,
            height: 40,
          ),
          InkWell(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  border: Border.all(color: AppTheme.grayColor)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/post/jubao.png'),
                    width: 20,
                    height: 20,
                    color: AppTheme.grayColor,
                  )
                ],
              ),
            ),
            onTap: () {
              _onReport();
            },
          ),
          _buildDelete(),
        ],
      ),
    );
  }

  Widget _buildDelete() {
    if (post.userid == Provider.of<App>(context).userid) {
      return Row(
        children: <Widget>[
          SizedBox(
            width: 40,
            height: 40,
          ),
          InkWell(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  border: Border.all(color: AppTheme.grayColor)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/post/shanchu.png'),
                    width: 20,
                    height: 20,
                    color: AppTheme.grayColor,
                  )
                ],
              ),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('删除想法'),
                      content: Container(
                        child: Text('是否确认删除想法?'),
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
                              _onDelDiscuss();
                              Navigator.of(context).pop();
                            }),
                      ],
                    );
                  });
            },
          )
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: <Widget>[
            cid > 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 3 * 2,
//                        child:  Text(ctips,
//                          style: TextStyle(color: Colors.black45),
//                          maxLines: 1,
//                          textAlign: TextAlign.left,
//                          overflow: TextOverflow.ellipsis,
//                          softWrap: true,
//                        ),
                        child: RichText(
                          text: TextSpan(
                              text: '正在回复',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                              children: <TextSpan>[
                                TextSpan(
                                    text: cnickname,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightBlueAccent)),
                                TextSpan(
                                    text: '的',
                                    style: TextStyle(color: Colors.black87)),
                                TextSpan(
                                    text: ccomment,
                                    style: TextStyle(
                                        color: Colors.lightBlueAccent)),
                              ]),
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                      FlatButton(
                        child: Text('取消回复'),
                        onPressed: () {
                          _renderTips(0, '', '');
                          _onHideKey();
                        },
                      )
                    ],
                  )
                : Container(),
            Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    onChanged: (String text) {
                      //new  通过onChanged事件更新_isComposing 标志位的值
                      setState(() {
                        //new  调用setState函数重新渲染受到_isComposing变量影响的IconButton控件
                        _isComposing =
                            text.length > 0; //new  如果文本输入框中的字符串长度大于0则允许发送消息
                      }); //new
                    },
                    //new
                    onSubmitted: _handleSubmitted,
                    decoration:
                        InputDecoration.collapsed(hintText: placeholder),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _isComposing
                        ? () =>
                            _handleSubmitted(_textController.text) //modified
                        : null, //modified  当没有为onPressed绑定处理函数时，IconButton默认为禁用状态
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _renderTips(cid, cnickname, comment) {
//    print('----cnickname:${cnickname}');
    var placeholder = '发表评论...';
    var ctips = '';
    if (cid > 0) {
      placeholder = '回复...';
      ctips = '正在回复[${cnickname}]的[${comment}]';
      print('----${ctips}');
//      this.refs.cinput.focus();
      FocusScope.of(context).requestFocus(_focusNode);
    } else {
      this._onHideKey();
    }
    setState(() {
      this.cid = cid;
      this.cnickname = cnickname;
      this.ccomment = comment;
      this.placeholder = placeholder;
      this.ctips = ctips;
      this.comment = '';
    });
  }

  void _onHideKey() {
    if (_focusNode.hasFocus == true) {
//      FocusScope.of(context).requestFocus(_focusNode);
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  //定义发送文本事件的处理函数
  void _handleSubmitted(String text) {
    comment = _textController.text;
    if (AppUtil.isLogin(context)) {
      _onRelease();
    } else {
      Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()))
          .then((perfect) {
        if (perfect != null) {
          _onRelease();
        }
      });
    }
  }

  void _onRelease() {
    if (comment.length == 0) {
      ToastUtil.showToast(context, '请输入内容');
      return;
    }
    var params = PCommentAdd(PostType.ImageText.index, Provider.of<App>(context, listen: false).userid,
            id, cid, comment)
        .toJson();
    CHttp.post(
        CHttp.COMMENT_ADD,
        (data) {
          if (!mounted) {
            return;
          }
          var temp_comment = CommentModel(data);
          comments.insert(0, temp_comment);
          setState(() {});
          _requestLoveComment();
          ToastUtil.showToast(context, '评论成功');
          _renderTips(0, '', '');
          _textController.clear(); //清空输入框
        },
        params: params,
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        });
  }

  void _onLoveComment(CommentModel comment) {
    if (!AppUtil.isLogin(context)) {
      Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()))
          .then((perfect) {
        if (perfect != null) {}
      });
      return;
    }
    var onlove = comment.love == 1 ? 0 : 1;
    print('---comment.love:${comment.love}');
    print('---onlove:${onlove}');
    var params = PLoveComment(
        PostType.ImageText.index,
        Provider.of<App>(context, listen: false).userid,
        id,
        comment.id,
        onlove)
        .toJson();
    CHttp.post(
        CHttp.LOVE_LOVECOMMENT,
            (data) {
          var id = data['id'];
          var love = data['love'];
          for (var i = 0; i < comments.length; i++) {
            if (comments[i].id == id) {
              var lovenum = comments[i].lovenum;
              if (love == 1) {
                lovenum += 1;
              } else {
                if (lovenum > 0) lovenum -= 1;
              }
              comments[i].lovenum = lovenum;
              comments[i].love = love;
            }
          }
          setState(() {});
        },
        params: params,
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        });
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
    var params = PDelComment(
        PostType.ImageText.index,
        Provider.of<App>(context, listen: false).userid,
        comment.id,id,)
        .toJson();
    CHttp.post(
        CHttp.COMMENT_DEL,
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

  _onDelDiscuss() {
    CHttp.post(
        CHttp.DISCUSS_DEL,
            (data) {
          ToastUtil.showToast(context, '想法删除成功');
          Navigator.of(context).pop({'action': 'del', 'id': post.id});
        },
        params:
        PDiscuss(Provider.of<App>(context, listen: false).userid, id)
            .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        });
  }

  void _onLove() {
    if (AppUtil.isLogin(context) == false) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      return;
    }
    _reqPostLove(post);
  }

  void _onStar() {
    if (AppUtil.isLogin(context) == false) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      return;
    }
    _reqPostStar(post);
  }

  void _onReport() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReportPage('举报帖子',post.id, post.userid, 3)));
  }

  void _requestDiscuss() {
    CHttp.post(
        CHttp.DISCUSS_INFO,
        (data) {
          if (!mounted) {
            return;
          }
          post = PostModel(data);
          setState(() {});
          _requestFloow(post.userid);
        },
        params:
            PPost(Provider.of<App>(context, listen: false).userid, id).toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
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
  /**
   * 请求点单数和评论数
   */
  void _requestLoveComment() {
    CHttp.post(
        CHttp.LOVE_LCNUM,
        (data) {
          if (!mounted) {
            return;
          }
          print(data);
        },
        params: PCommentNum(PostType.ImageText.index, id).toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        });
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
        params: PComment(PostType.ImageText.index, fromid, id).toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
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
        params: PStar(Provider.of<App>(context, listen: false).userid, PostType.ImageText.index,
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
        params: PPostLove(Provider.of<App>(context, listen: false).userid,PostType.ImageText.index,
            post.id, post.mylove == 0 ? 1 : 0)
            .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {

        });
  }

  _requestLoves() {
    CHttp.post(
        CHttp.LOVE_LOVES,
            (data) {
          if (!mounted) {
            return;
          }
          List<LoveModel> temp_loves = List<LoveModel>();
          for (var i = 0; i < data.length; i++) {
            temp_loves.add(LoveModel(data[i]));
          }
          setState(() {
            loves = temp_loves;
          });
        },
        params: PLoves(PostType.ImageText.index, id).toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        });
  }
}
