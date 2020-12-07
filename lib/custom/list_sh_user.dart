import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/app_theme.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/pages/user/person_page.dart';

class ListSHUser extends StatelessWidget {
  String userid;
  String head;
  String name;
  int time;

  ListSHUser(this.userid, this.head, this.name, this.time);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: CachedNetworkImage(
              width: 26,
              height: 26,
              imageUrl: head,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name != null ? name : '',
                  style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54),
                ),
                // Padding(
                //     padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                //     child: Text(
                //       UIManager.getTime(time),
                //       style: TextStyle(color: Colors.grey),
                //     ))
              ],
            ),
          )
        ],
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                PersonPage(userid)));
      },
    );
  }
}
