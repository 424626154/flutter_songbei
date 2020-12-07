import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/custom/griditem/secondhand_grid_item.dart';
import 'package:flutter_songbei/custom/list_sh_user.dart';
import 'package:flutter_songbei/models/secondhand_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/pages/user/login_page.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/utils/app_util.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../home/add_secondhand_page.dart';
import 'secondhand_info_page.dart';

class SecondhandPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<SecondhandPage> {
  List<SecondhandModel> secondhands = List<SecondhandModel>();

  @override
  void initState() {
    super.initState();
    _reqSecondhands();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('二手物品'),
        centerTitle: true,
      ),
      body: Container(
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: secondhands.length,
          itemBuilder: (BuildContext context, int index) {
            var item = secondhands[index];
            print('item:${item}');
            return SecondhandGridItem(item,(item){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      SecondhandInfoPage(item.id)));
            });
          },
          staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if (AppUtil.isLogin(context) == false) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
            return;
          }
          if (AppUtil.isCheckAdd(context) == false) {
            ToastUtil.showToast(context, '请先完善资料!');
            return;
          }
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddSecondhandPage()))
              .then((res) {});
        },
      ),
    );
  }

  void _reqSecondhands() {
    print('-----userid:${Provider.of<App>(context, listen: false).userid}');
    CHttp.post(
        CHttp.SECONDHAND_SECONDHANDS,
        (data) {
          if (!mounted) {
            return;
          }
          var temp_items = data['items'];
          print('temp_items:${temp_items}');
          secondhands.clear();
          temp_items.forEach((element) {
            secondhands.add(SecondhandModel(element));
          });
          setState(() {});
          print('secondhands:${secondhands}');
        },
        params:
            PUserid(Provider.of<App>(context, listen: false).userid).toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {});
  }
}
