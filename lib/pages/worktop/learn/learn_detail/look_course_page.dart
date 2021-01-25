import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// /**  * @Author: duanruilong  * @Date: 2020-10-31 11:07:21  * @Desc: 如何录制视频  */

class LookCoursePage extends StatefulWidget {
  @override
  _LookCoursePageState createState() => _LookCoursePageState();
}

class _LookCoursePageState extends State<LookCoursePage> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    String url = 'https://mp.weixin.qq.com/s/YprfqD8GdSHCMvtW_LJx9Q';

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(''),
        ),
        body: Container(
          child: SafeArea(
            bottom: false,
            child: WebView(
              initialUrl: url,
              //JS执行模式 是否允许JS执行
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                _controller = controller;
              },
              onPageFinished: (url) {
                _controller
                    .evaluateJavascript("document.title")
                    .then((result) {});
              },
            ),
          ),
        ));
  }
}
