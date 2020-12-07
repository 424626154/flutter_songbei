
import 'package:flutter/material.dart';

import '../app_theme.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 80.0,
        height: 80.0,
        child: Container(
          width: 80.0,
          height: 80.0,
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              SizedBox(
                width: 80.0,
                height: 80.0,
                child: CircularProgressIndicator(
                  backgroundColor: AppTheme.mainColor,
                  valueColor:
                  AlwaysStoppedAnimation(Theme.of(context).accentColor),
                  strokeWidth: 5.0,
                ),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: ShapeDecoration(
                      color: Theme.of(context).accentColor,
//                      borderRadius: BorderRadius.all(Radius.circular(40.0))
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40.0),
                        ),
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/icon.png'),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

}