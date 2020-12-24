import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonWebView extends StatefulWidget {
  final String url;
  final String title;

  CommonWebView(this.url,this.title);

  @override
  State<StatefulWidget> createState() => CommonWebViewState();
}

class CommonWebViewState extends State<CommonWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.2,
        title: Text(widget.title??'',style: TextStyle(fontSize: 17, color: ThemeColor.colorFF000000),),
      ),
      body: WebView(
        initialUrl: widget.url,
      ),
    );
  }
}
