
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class AppWebPage extends StatefulWidget {

  String title;
  String url;

  AppWebPage(this.title,this.url);

  @override
  State<StatefulWidget> createState() {
    return _WebState(title,url);
  }

}

class _WebState extends State<AppWebPage> {

  String title;
  String url;

  _WebState(this.title,this.url);

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: url,
      ),
    );
  }

}