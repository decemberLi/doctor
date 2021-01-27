import 'dart:convert';

import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_manager/session_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonWebView extends StatefulWidget {
  final String url;
  final String title;

  CommonWebView(this.url, this.title);

  @override
  State<StatefulWidget> createState() => CommonWebViewState();
}

class CommonWebViewState extends State<CommonWebView> {
  WebViewController _controller;
  Map<String, dynamic> map;
  var aMap = {};
  String _title = '';
  bool _hasAppBar = true;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    map = {
      'closeWindow': (jsonParam, callJsType) {
        debugPrint(
            'closeWindow -> param: [$jsonParam], callJsType: [$callJsType] ');
        Navigator.pop(context);
      },
      'ticket': (jsonMsg, bizType) {
        debugPrint('comment -> param: [$jsonMsg], callJsType: [$bizType] ');
        _callJs(_commonResult(
            bizType: bizType, content: SessionManager.shared.session));
      },
      'addNewBizType': (jsonParam, bizType) {
        aMap.putIfAbsent(jsonParam['key'], () => bizType);
      },
      'removeBizType': (jsonParam, bizType) {
        aMap.remove(jsonParam['key']);
      },
      'titleBar': (jsonParam, bizType) {
        _hasAppBar = jsonParam['hasTitleBar'];
      },
      'setTitle': (jsonParam, bizType) {
        setState(
          () {
            _title = jsonParam['title'];
          },
        );
      }
    };
  }

  _commonResult({String bizType, int code = 0, dynamic content}) {
    return json.encode({
      'bizType': bizType,
      'param': {'code': code, 'content': content}
    });
  }

  _callJs(param) {
    _controller.evaluateJavascript("nativeCall('$param')");
  }

  _appBar() {
    if (_hasAppBar) {
      return AppBar(
        elevation: 0.2,
        title: Text(
          _title ?? '',
          style: TextStyle(fontSize: 17, color: ThemeColor.colorFF000000),
        ),
      );
    } else {
      return PreferredSize(
        child: Container(),
        preferredSize: Size(0, 0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) async {
          _controller = controller;
          _title = await _controller.getTitle();
          setState(() {});
        },
        initialUrl: widget.url,
        onPageFinished: (url) {
          print(url);
        },
        userAgent: 'Medclouds-doctor',
        javascriptChannels: <JavascriptChannel>[
          JavascriptChannel(
            name: 'jsCall',
            onMessageReceived: (param) async {
              var message = json.decode(param.message);
              map[message['dispatchType']](
                  message['param'], message['bizType']);
            },
          ),
        ].toSet(),
      ),
    );
  }
}
