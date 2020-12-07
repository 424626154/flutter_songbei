import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/models/classify_item_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:provider/provider.dart';

import 'classify_item_page.dart';

class ClassifysPage extends StatefulWidget {
  String title;
  int cid;

  ClassifysPage(this.title, this.cid);

  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<ClassifysPage> {
  List<ClassifyItemModel> items = List<ClassifyItemModel>();

  @override
  void initState() {
    super.initState();
    _reqClassifys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title != null ? widget.title : '松北景点'),
        centerTitle: true,
      ),
      body: Container(
        child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext content, int index) {
              var item = items[index];
              var item_w = MediaQuery.of(context).size.width / 4 - 40;
              return InkWell(
                child:  Container(
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
                        imageUrl: UIManager.getPhoto(item.logo),
                        fit: BoxFit.cover,
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Text(item.brief != null?item.brief:'',maxLines: 3,overflow: TextOverflow.ellipsis,),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => ClassifyItemPage(item.title,widget.cid,item)));
                },
              );
            },
        ),
      ),
    );
  }

  void _reqClassifys() {
    CHttp.post(
        CHttp.HOME_CLASSIFYS,
        (data) {
          if (!mounted) {
            return;
          }
          items.clear();
          for (var i = 0; i < data.length; i++) {
            items.add(ClassifyItemModel(data[i]));
          }
          print(items);
          setState(() {});
        },
        params: PClassifys(
                Provider.of<App>(context, listen: false).userid, widget.cid)
            .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {});
  }
}
