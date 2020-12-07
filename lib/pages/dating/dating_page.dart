import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/models/dating_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import 'dating_info_page.dart';
import 'my_dating_page.dart';

class DatingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<DatingPage> {

  List<DatingModel> _datings = List<DatingModel>();

  @override
  void initState() {
    super.initState();
    _reqDatings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('婚恋交友'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyDatingPage()))
                    .then((res) {});
              },
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: Text(
                '资料',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Container(
        child: ListView.builder(itemBuilder: (BuildContext context, int positon){
          var item = _datings[positon];
          return Padding(
            padding: EdgeInsets.all(5),
            child: GestureDetector(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black54, width: 1.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            color: AppTheme.grayColor,
                            child: CachedNetworkImage(
                              width: 40,
                              height: 40,
                              imageUrl: UIManager.getHeadurl(item.head),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            item.nickname != null?item.nickname:'',
                            style: TextStyle(fontSize: 18, color: AppTheme.mainColor),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text('个人资料',style: TextStyle(fontSize: 16),),
                    ),
                    Wrap(
                      spacing: 5, //主轴上子控件的间距
                      runSpacing: 5, //交叉轴上子控件之间的间距
                      children: [
                        _buildItem(UIManager.getDatingGenderStr(item)),
                        _buildItem(UIManager.getDatingAgeStr(item)),
                        _buildItem(UIManager.getDatingHeightStr(item)),
                        _buildItem(UIManager.getDatingWeightStr(item)),
                        _buildItem(UIManager.getDatingDegreeStr(item)),
                        _buildItem(UIManager.getDatingLocationStr(item)),
                      ],
                    )
                  ],
                ),
              ),
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DatingInfoPage(item.userid)))
                    .then((res) {});
              },
            ),
          );
        },
        itemCount: _datings.length,),
      ),
    );
  }

  Widget _buildItem(String str){
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black54, width: 1.0),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
        child: Text('${str}'),
      ),
    );
  }

  void _reqDatings() {
    print('-----userid:${Provider.of<App>(context, listen: false).userid}');
    CHttp.post(
        CHttp.DATING_DATINGS,
            (data) {
          if (!mounted) {
            return;
          }
          print(data);
          if(data != null){
            _datings.clear();
            data.forEach((element) {
              _datings.add(DatingModel.initUser(element));
            });
          }
          print(_datings.length);
          setState(() {});
        },
        params:
        PUserid(Provider.of<App>(context, listen: false).userid).toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {});
  }
}
