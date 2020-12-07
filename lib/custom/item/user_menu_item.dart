import 'package:flutter/material.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/provider/user.dart';

import '../../app_theme.dart';

class UserMenuItem extends StatelessWidget {
  User user;
  Function onMeFollow;
  Function onFollowMe;

  UserMenuItem(this.user,
      {this.onMeFollow, this.onFollowMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200, width: 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            InkWell(
              child: Column(
                children: <Widget>[
                  Text(
                    '${UIManager.getNum0Str(user.myfollow)}',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                      '关注',
                      style: TextStyle(color: Colors.black45, fontSize: 14),
                    ),
                  )
                ],
              ),
              onTap: () {
                if (onMeFollow != null) onMeFollow();
              },
            ),
            SizedBox(
              width: 1,
              height: 20,
              child: DecoratedBox(
                decoration: BoxDecoration(color: AppTheme.grayColor),
              ),
            ),
            InkWell(
              child: Column(
                children: <Widget>[
                  Text(
                    '${UIManager.getNum0Str(user.followme)}',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                      '粉丝',
                      style: TextStyle(color: Colors.black45, fontSize: 14),
                    ),
                  )
                ],
              ),
              onTap: () {
                if (onFollowMe != null) onFollowMe();
              },
            ),
          ],
        ),
      ),
    );
  }
}

