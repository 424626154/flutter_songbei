
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatingItem extends StatelessWidget{

  String title;
  String content;

  DatingItem(this.title,this.content);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${title}',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '${content}',
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }

}