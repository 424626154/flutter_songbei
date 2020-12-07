import 'package:flutter/material.dart';
import '../app_config.dart';
import '../app_theme.dart';

class LoginHead extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginHeadState();
  }

}

class _LoginHeadState extends State<LoginHead> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Image(
            image: AssetImage('assets/icon.png'),
            width: 80,
            height: 80,
          ),
          Container(
            height: 10,
          ),
          Text(
            '${AppConfig.APP_NAME}',
            style: TextStyle(
              fontSize: 20,
              color: AppTheme.mainColor,
            ),
          ),
        ],
      ),
    );
  }

}