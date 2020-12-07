
import 'package:flutter/material.dart';

class BottomBarItem extends StatelessWidget{

  Color actionColor = Colors.black87;
  Color menuColor = Color(0xff707070);

  bool isSelect;
  String assetName;
  String title;
  Function onItem;
  BottomBarItem(this.isSelect,this.assetName,this.title,this.onItem);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      height: 60,
      child: InkWell(
        child: Column(
          children: <Widget>[
            Image(
              image: AssetImage(assetName),
              color: isSelect?actionColor:menuColor,
              width: 28,
              height: 28,
            ),
            Text(title,
                style: TextStyle(
                    color:isSelect?actionColor:menuColor
                )
            )
          ],
        ),
        onTap: (){
          this.onItem();
        },
      ),
    );
  }

}