import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:doctor/common/env/environment.dart';
import 'package:doctor/common/env/url_provider.dart';
import 'package:doctor/pages/doctors/viewmodel/doctors_detail_view_model.dart';
import 'package:doctor/plugins/x5web/x5_sdk.dart';
import 'package:doctor/plugins/x5web/x5_webview.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/app_utils.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/utils/debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/manager.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../model/doctor_article_detail_entity.dart';

class DoctorsDetailPage extends StatefulWidget {
  final int postId;

  final String type;

  final String from;

  DoctorsDetailPage({this.postId, this.type, this.from = ''});

  @override
  State<StatefulWidget> createState() => _DoctorsDetailPageState();
}

class _DoctorsDetailPageState extends State<DoctorsDetailPage> {
  WebViewController _webViewController;
  X5WebViewController _x5webViewController;
  TextEditingController _commentTextEditController = TextEditingController();
  FocusNode _commentFocusNode = FocusNode();
  DoctorsDetailViewMode _model = DoctorsDetailViewMode();
  final _kvn = KeyboardVisibilityNotification();
  int _subscribeId;
  String _commentTo;
  String _replyContent;
  int _commentId;
  int _lastCommentId;
  String _cachedContent;
  int _commentContentLength = 0;

  Map<String, dynamic> map;
  var aMap = {};

  @override
  void initState() {
    super.initState();
    _subscribeId = _kvn.addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          if (!ModalRoute.of(context).isCurrent) {
            Navigator.pop(context);
          }
          _commentFocusNode.unfocus();
          //键盘下降失去焦点
          setState(() {});
        }
      },
    );
    map = {
      'closeWindow': (jsonParam, callJsType) {
        debugPrint(
            'closeWindow -> param: [$jsonParam], callJsType: [$callJsType] ');
        Navigator.pop(context);
      },
      'updatePostDetail': (jsonParam, callJsType) {
        debugPrint(
            'updatePostDetail -> param: [$jsonParam], callJsType: [$callJsType] ');
        _model.updateDetail(jsonParam);
      },
      'comment': (jsonParam, callJsType) {
        debugPrint(
            'comment -> param: [$jsonParam], callJsType: [$callJsType] ');
        _commentId = jsonParam['id'];
        _replyContent = jsonParam['commentContent'];
        _commentTo = jsonParam['commentUserName'];
        _showInputBar(_hintText(), true);
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
      'getWifiStatus': (jsonParam, bizType) async {
        if (AppUtils.sp.getBool(ONLY_WIFI) ?? true) {
          ConnectivityResult connectivityResult =
              await (Connectivity().checkConnectivity());
          _callJs(_commonResult(
              bizType: bizType,
              content: connectivityResult == ConnectivityResult.wifi));
        } else {
          _callJs(_commonResult(bizType: bizType, content: true));
        }
      },
      'fullScreen': (jsonParam, bizType) async {
        X5Sdk.openWebActivity(jsonParam['videoUrl'], title: "web页面");
      },
    };
  }

  _commonResult({String bizType, int code = 0, dynamic content}) {
    return json.encode({
      'bizType': bizType,
      'param': {'code': code, 'content': content}
    });
  }

  _callJs(param) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      _x5webViewController.evaluateJavascript("nativeCall('$param')");
    } else {
      _webViewController.evaluateJavascript("nativeCall('$param')");
    }
  }

  @override
  void dispose() {
    if (_kvn.isKeyboardVisible) {
      _commentFocusNode.unfocus();
    }
    _kvn.removeListener(_subscribeId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          title: Text('帖子详情',
              style: TextStyle(fontSize: 17, color: ThemeColor.colorFF000000)),
          elevation: 0),
      body: ProviderWidget<DoctorsDetailViewMode>(
        model: _model,
        builder: (context, model, child) {
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 50),
                height: MediaQuery.of(context).size.height,
                child: TargetPlatform.android == defaultTargetPlatform
                    ? X5WebView(
                        javaScriptEnabled: true,
                        url:
                            '${UrlProvider.doctorsCircleUrl(Environment.instance)}?id=${widget.postId}&from=${widget.from}',
                        // url: 'http://192.168.1.27:9000/#/detail?id=${widget.postId}&from=${widget.from}',
                        header: {},
                        onUrlLoading: (url) {
                          print(url);
                          _x5webViewController.loadUrl(url);
                        },
                        onWebViewCreated: (controller) =>
                            _x5webViewController = controller,
                        onPageFinished: () async {
                          print(await _x5webViewController.currentUrl());
                        },
                        userAgentString: 'Medclouds-doctor',
                        javascriptChannels: JavascriptChannels(
                            <String>['jsCall'], (String name, String data) {
                          var message = json.decode(data);
                          map[message['dispatchType']](
                              message['param'], message['bizType']);
                        }),
                      )
                    : WebView(
                        initialMediaPlaybackPolicy:
                            AutoMediaPlaybackPolicy.always_allow,
                        javascriptMode: JavascriptMode.unrestricted,
                        initialUrl:
                            '${UrlProvider.doctorsCircleUrl(Environment.instance)}?id=${widget.postId}&from=${widget.from}',
                        onWebViewCreated: (controller) =>
                            _webViewController = controller,
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
              ),
              Positioned(bottom: 0, child: _bottomBar(_model.detailEntity))
            ],
          );
        },
      ),
    ));
  }

  _bottomBar(DoctorArticleDetailEntity entity) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 22),
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
          color: ThemeColor.colorFFE7E7E7,
          width: 0.5,
        )),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              blurRadius: 4,
              spreadRadius: 1,
              color: ThemeColor.colorFFE7E7E7,
              offset: Offset(0, -4)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    alignment: Alignment.centerLeft,
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: ThemeColor.colorFFEDEDED,
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.edit,
                            color: ThemeColor.colorFF999999,
                            size: 12,
                          ),
                        ),
                        Text(
                          _cachedContent == null || _cachedContent.length == 0
                              ? _hintText()
                              : _cachedContent,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 14, color: ThemeColor.colorFF999999),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    _commentTextEditController.text = null;
                    _commentId = null;
                    _showInputBar(_hintText(), false);
                  },
                ),
              ),
              _operatorArea(entity)
            ],
          ),
        ],
      ),
    );
  }

  String _hintText() => _model.isAcademic() ? '写评论' : '写讨论';

  _operatorArea(DoctorArticleDetailEntity entity) {
    return Row(
      children: [
        GestureDetector(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 24),
            child: _operatorWidget(
                entity?.likeFlag ?? false
                    ? 'assets/images/liked_checked.png'
                    : 'assets/images/like_normal.png',
                '点赞',
                entity?.likeNum ?? 0),
          ),
          onTap: debounce(() {
            if (entity.likeFlag) {
              EasyLoading.showToast('请坚定你的立场');
              return;
            }
            _model.like(widget.postId);
          }),
        ),
        GestureDetector(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 36),
            child: _operatorWidget('assets/images/comment_normal.png',
                _model.isAcademic() ? '评论' : '讨论', entity?.commentNum ?? 0),
          ),
          onTap: () {
            _callJs(_commonResult(bizType: aMap['scrollToCommentArea']));
          },
        ),
        GestureDetector(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 36),
            child: _operatorWidget(
                entity?.favoriteFlag ?? false
                    ? 'assets/images/collect_checked.png'
                    : 'assets/images/collect_normal.png',
                '收藏',
                null),
          ),
          onTap: debounce(() => _model.collect(widget.postId)),
        ),
      ],
    );
  }

  _operatorWidget(String asstPath, String text, int number) {
    return Container(
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        overflow: Overflow.visible,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(asstPath, width: 20, height: 20),
              Text(text,
                  style:
                      TextStyle(fontSize: 10, color: ThemeColor.colorFF999999))
            ],
          ),
          if (number != null)
            Positioned(
              right: -26,
              top: -1,
              child: Container(
                width: 25,
                height: 14,
                margin: EdgeInsets.only(left: 2),
                child: Text(
                  '${number > 99 ? '99+' : number}',
                  style:
                      TextStyle(fontSize: 10, color: ThemeColor.colorFF999999),
                ),
              ),
            )
        ],
      ),
    );
  }

  _buildCommendArea() {
    if (_commentTo == null || _replyContent == null) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.only(bottom: 12, top: 6, left: 2, right: 2),
      width: double.infinity,
      child: Text(
        '回复 $_commentTo: $_replyContent',
        style: TextStyle(color: ThemeColor.colorFF999999, fontSize: 14),
      ),
    );
  }

  _buildPublishArea() {
    var length = _commentContentLength ?? 0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Text('$length',
                    style: TextStyle(
                        color: length > 150
                            ? ThemeColor.colorFFF67777
                            : ThemeColor.colorFF999999,
                        fontSize: 16)),
                Text(
                  '/150',
                  style:
                      TextStyle(color: ThemeColor.colorFF999999, fontSize: 16),
                )
              ],
            ),
          ),
          GestureDetector(
            child: Text(
              '发表',
              style: TextStyle(color: ThemeColor.primaryColor, fontSize: 16),
            ),
            onTap: debounce(() async {
              if (_commentTextEditController.text == null ||
                  _commentTextEditController.text.length == 0) {
                EasyLoading.showToast('${_hintText()}内容不能为空');
                return;
              }
              if (_commentTextEditController.text.length > 150) {
                EasyLoading.showToast('字数超过限制');
                return;
              }
              await _model.postComment(
                  widget.postId, _commentId, _commentTextEditController.text);
              _callJs(_commonResult(bizType: aMap['updateComment']));
              setState(() {
                _commentTextEditController.text = '';
                _cachedContent = null;
              });
              _commentContentLength = 0;
              Navigator.pop(context);
            }),
          ),
        ],
      ),
    );
  }

  _showInputBar(String hintText, bool isReply) {
    if (_lastCommentId != _commentId) {
      _commentTextEditController.text = '';
      _cachedContent = null;
      _commentContentLength = 0;
    }
    _lastCommentId = _commentId;
    showModalBottomSheet(
      backgroundColor: ThemeColor.colorFFFAFAFA,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (ctx, state) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: Duration(milliseconds: 20),
            child: IntrinsicHeight(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 8, right: 8, top: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (isReply) _buildCommendArea(),
                    TextField(
                      style: TextStyle(fontSize: 14),
                      minLines: 1,
                      maxLines: 5,
                      controller: _commentTextEditController,
                      focusNode: _commentFocusNode,
                      enableInteractiveSelection: true,
                      autofocus: true,
                      onChanged: (text) {
                        if (_commentId == null) {
                          _cachedContent = text;
                        }
                        state(() {
                          _commentContentLength = text?.length ?? 0;
                        });
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          counterText: "",
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: ThemeColor.colorFFD9D5D5,
                            ),
                          ),
                          focusColor: Colors.transparent,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: ThemeColor.colorFFD9D5D5,
                            ),
                          ),
                          hintText: '请输入',
                          hintStyle:
                              TextStyle(color: ThemeColor.colorFF999999)),
                      cursorHeight: 20,
                    ),
                    _buildPublishArea(),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
