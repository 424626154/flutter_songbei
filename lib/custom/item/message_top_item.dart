import 'package:flutter/material.dart';

class MessageTopItem extends StatelessWidget {
  String icon;
  String title;
  int num;
  Color color;
  Function onItem;

  MessageTopItem(
      {@required this.icon, @required this.title, @required this.color,@required this.num,@required this.onItem})
      : assert(icon != null),
        assert(title != null),
        assert(color != null),
        assert(num != null),
        assert(onItem != null);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey[200], width: 1.0)
          )
        ),
        child: Row(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        color: color,
                        width: 40,
                        height: 40,
                        child: Image(
                          image: AssetImage(icon),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                num > 0
                    ? Positioned(
                  right: 0.0,
                  top: 0.0,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(9.0))),
                    width: 18,
                    height: 18,
                    child: Text(
                      num > 99 ? '99' : '${num}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
                    : Container()
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            )
          ],
        ),
      ),
      onTap: (){
        if(onItem != null)onItem();
      },
    );
  }
}
