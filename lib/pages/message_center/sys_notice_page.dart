
import 'package:flutter/material.dart';
import 'package:flutter_songbei/custom/listitem/sys_notice_list_item.dart';
import 'package:flutter_songbei/db/daos/sys_notice_dao.dart';
import 'package:flutter_songbei/models/sys_notice_model.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:provider/provider.dart';

import 'sys_notice_details_page.dart';

class SysNoticePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }

}

class _PageState extends State<SysNoticePage>{

  List<SysNoticeModel> notices = List<SysNoticeModel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SysNoticeDao noticeDao = SysNoticeDao();
      noticeDao
          .queryNotices(Provider.of<App>(context,listen: false).userid)
          .then((db_notices) {
        setState(() {
          notices = db_notices;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('系统消息'),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                //这是点击弹出菜单的操作，点击对应菜单后，改变屏幕中间文本状态，将点击的菜单值赋予屏幕中间文本
                onSelected: (String value) {
                  print(value);
                  if (value == 'read_all') {
                    SysNoticeDao noticeDao = SysNoticeDao();
                    noticeDao.upAllRead(
                        Provider.of<App>(context,listen: false).userid, true);
                    var temp_notices = notices;
                    for (var i = 0; i < notices.length; i++) {
                      temp_notices[i].red = true;
                    }
                    setState(() {
                      notices = temp_notices;
                    });
                  } else if (value == 'del_all') {
                    SysNoticeDao noticeDao = SysNoticeDao();
                    noticeDao.deleteAllNotice(
                        Provider.of<App>(context,listen: false).userid);
                    setState(() {
                      notices = List<SysNoticeModel>();
                    });
                  }
                  setState(() {

                  });
                },
                //这是弹出菜单的建立，包含了两个子项，分别是增加和删除以及他们对应的值
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[Text('全部已读')],
                    ),
                    value: 'read_all',
                  ),
                  PopupMenuItem(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[Text('删除全部')],
                    ),
                    value: 'del_all',
                  ),
                ])
          ],
        ),
        body: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (item, index) {
            return SysNoticeListItem(notices[index],_onDelItem,_onItem);
          },
          itemCount: notices.length,
          separatorBuilder: (context, index) {
            return Divider(
              height: .5,
              indent: 0,
              color: Color(0xFFDDDDDD),
            );
          },
        ),
    );
  }

  void _onDelItem(SysNoticeModel notice) {
    print('${notice}');
    SysNoticeDao noticeDao = SysNoticeDao();
    noticeDao.deleteNotice(notice.id);
    var temp_notices = notices;
    for (var i = temp_notices.length - 1; i >= 0; i--) {
      if (temp_notices[i].id == notice.id) {
        temp_notices.removeAt(i);
      }
    }
    setState(() {
      notices = temp_notices;
    });
  }

  void _onItem(SysNoticeModel notice) {
    SysNoticeDao noticeDao = SysNoticeDao();
    noticeDao.upRead(notice.id, true);
    var temp_notices = notices;
    for (var i = 0; i < notices.length; i++) {
      if (temp_notices[i].id == notice.id) {
        temp_notices[i].red = true;
      }
    }
    setState(() {
      notices = temp_notices;
    });
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SysNoticeDetailsPage(notice)));
  }

}