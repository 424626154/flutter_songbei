import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/app_theme.dart';
import 'package:flutter_songbei/custom/listitem/post_list_item.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/models/classify_item_model.dart';
import 'package:flutter_songbei/models/classify_model.dart';
import 'package:flutter_songbei/models/post_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/pages/home/add_classify_post_page.dart';
import 'package:flutter_songbei/pages/post/post_page.dart';
import 'package:flutter_songbei/pages/user/login_page.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/utils/app_util.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ClassifyItemPage extends StatefulWidget {
  String title;
  int cid;
  ClassifyItemModel item;

  ClassifyItemPage(this.title,this.cid, this.item);

  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<ClassifyItemPage> with SingleTickerProviderStateMixin {

  ClassifyItemModel classifyItem;

  TabController _tabController;

  List<PostModel> posts = List<PostModel>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2)
      ..addListener(() {
        if (_tabController.index.toDouble() == _tabController.animation.value) {
          switch (_tabController.index) {
            case 0:
              if(classifyItem == null){
                _reqClassifyItem();
              }
              break;
            case 1:
              if(posts.length == 0){
                _requestCDiscuss();
              }
              break;
          }
        }
      });
    _reqClassifyItem();
  }

  @override
  Widget build(BuildContext context) {
    print('classify:${classifyItem}');
    return Scaffold(
      backgroundColor:AppTheme.mainColor,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: NestedScrollView(
            headerSliverBuilder:(context, innerScrolled) => <Widget>[
              SliverAppBar(
                leading:  GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back_ios),
                ),
                elevation: 0,
                automaticallyImplyLeading: false,
                title:  Text(widget.title != null?widget.title:'详情'),
                centerTitle: true, // 标题居中
                expandedHeight: 200.0, // 展开高度
                floating: true, // 随着滑动隐藏标题
                pinned: true, // 固定在顶部
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  background:  Container(
                    margin:  EdgeInsets.only(top: kToolbarHeight),
                    color: Colors.white,
                    child: _buildHead(),
                  ),
                ),
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
                      text: "简介",
                    ),
                    Tab(
                      text: "讨论",
                    ),
                  ],
                )),
              )
            ],
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _buildInfo(),
                _buildCircle()
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        onPressed: (){
          if (AppUtil.isLogin(context) == false) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
            return;
          }
          if(AppUtil.isCheckAdd(context) == false){
            ToastUtil.showToast(context, '请先完善资料!');
            return;
          }
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddClassifyPostPage(widget.title, widget.cid,widget.item.id)))
              .then((res) {});
        },
      ),
    );
  }

  Widget _buildHead(){
    var item_w = MediaQuery.of(context).size.width / 4 - 40;
    if(classifyItem != null){
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1.0)
            )
        ),
        child: Row(
          children: [
            CachedNetworkImage(
              width: item_w,
              height: item_w,
              imageUrl: UIManager.getPhoto(classifyItem.logo),
              fit: BoxFit.cover,
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(classifyItem.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }else{
      return Container();
    }
  }

  Widget _buildInfo() {
    if(classifyItem != null){
      return Container(
        padding: EdgeInsets.all(10),
        child: Text(classifyItem.brief != null ? classifyItem.brief : ''),
      );
    }else{
      return Container();
    }
  }

  Widget _buildCircle(){
    if(classifyItem != null){
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50
        ),
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
                // _reqPostStar(item);
              },
              onLove: (item) {
                if (AppUtil.isLogin(context) == false) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                  return;
                }
                // _reqPostLove(item);
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
      );
    }else{
      return Container();
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

  void _reqClassifyItem() {
    CHttp.post(
        CHttp.HOME_CLASSIFY_ITEM,
        (data) {
          if (!mounted) {
            return;
          }
          if(data != null){
            classifyItem = ClassifyItemModel(data);
          }
          setState(() {});
        },
        params: PClassifyItem(Provider.of<App>(context, listen: false).userid,
                widget.item.cid,widget.item.id)
            .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {});
  }

  void _requestCDiscuss() {
    var fromid = 0;
    var forms = posts;
    if (forms.length > 0) {
      fromid = forms[0].id;
    }
    CHttp.post(
        CHttp.DISCUSS_CDISCUSS,
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
          print(posts);
        },
        params:
        PCDiscuss(Provider.of<App>(context, listen: false).userid,1,widget.item.id, fromid)
            .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {

        });
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
          border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1.0))
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
