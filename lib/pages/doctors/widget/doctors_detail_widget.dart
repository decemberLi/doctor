import 'package:doctor/http/session_manager.dart';
import 'package:doctor/pages/doctors/viewmodel/doctors_detail_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

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
  WebViewController _controller;
  TextEditingController _commentTextEditController = TextEditingController();
  FocusNode _commentFocusNode = FocusNode();
  DoctorsDetailViewMode _model = DoctorsDetailViewMode();
  final _kvn = KeyboardVisibilityNotification();
  int _subscribeId;
  bool _inputModel = false;
  int _commentTo = null;
  Map<String, dynamic> map;

  @override
  void initState() {
    super.initState();
    _subscribeId = _kvn.addNewListener(
      onChange: (bool visible) {
        print('visible ----- $visible');
        if (!visible) {
          _commentFocusNode.unfocus();
          Navigator.pop(context);
          //键盘下降失去焦点
          setState(() {});
        }
      },
    );
    map = {
      'closeWindow': (jsonMsg, callJsType) {
        Navigator.pop(context);
      },
      'updatePostDetail': (jsonMsg, callJsType) {
        _model.updateDetail(jsonMsg);
      },
      'comment': (jsonParam, callJsType) {
        var postId = jsonParam['postId'];
        var commentId = jsonParam['commentId'];
        var commentContent = jsonParam['commentContent'];
        var name = jsonParam['name'];
        _model.postComment(postId, commentId, commentContent);
      },
      'ticket': (jsonMsg, callJsType) {
        return SessionManager.getLoginInfo()?.ticket;
      }
    };
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
      appBar: AppBar(title: Text('帖子详情'), elevation: 0),
      body: ProviderWidget<DoctorsDetailViewMode>(
        model: _model,
        builder: (context, model, child) {
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 50),
                height: MediaQuery.of(context).size.height,
                child: WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl:
                      'http://192.168.1.27:8000/#/detail?id=${widget.postId}&from=${widget.from}',
                  onWebViewCreated: (controller) => _controller = controller,
                  onPageFinished: (url) {
                    print(url);
                  },
                  javascriptChannels: <JavascriptChannel>[
                    JavascriptChannel(
                      name: 'jsCall',
                      onMessageReceived: (param) async {
                        var message = json.decode(param.message);
                        var result = await map[message['dispatchType']](
                            message['param'], message['bizType']);
                        _controller.evaluateJavascript(
                            'nativeCall({param:$result, bizType:${message['bizType']}})');
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
            blurRadius: 10,
            spreadRadius: 2,
            color: ThemeColor.colorFFE7E7E7,
          ),
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
                          '写讨论',
                          style: TextStyle(
                              fontSize: 14, color: ThemeColor.colorFF999999),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    _showInputBar(widget.type == 'ACADEMIC' ? '写评论' : '写讨论');
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

  _operatorArea(DoctorArticleDetailEntity entity) {
    return Row(
      children: [
        GestureDetector(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 22),
            child: _operatorWidget(
                entity?.likeFlag ?? false
                    ? 'assets/images/liked_checked.png'
                    : 'assets/images/like_normal.png',
                '点赞',
                entity?.likeNum ?? 0),
          ),
          onTap: () {
            if (entity.likeFlag) {
              EasyLoading.showToast('请坚定你的立场');
              return;
            }
            _model.like(widget.postId);
          },
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 22),
          child: _operatorWidget('assets/images/comment_normal.png', '评论',
              entity?.commentNum ?? 0),
        ),
        GestureDetector(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 22),
            child: _operatorWidget(
                entity?.favoriteFlag ?? false
                    ? 'assets/images/collect_checked.png'
                    : 'assets/images/collect_normal.png',
                '收藏',
                null),
          ),
          onTap: () => _model.collect(widget.postId),
        ),
      ],
    );
  }

  _operatorWidget(String asstPath, String text, int number) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            Container(
              margin: EdgeInsets.only(left: 2),
              child: Text(
                '${number ?? ''}',
                style: TextStyle(fontSize: 10, color: ThemeColor.colorFF999999),
              ),
            )
        ],
      ),
    );
  }

  _buildCommendArea() {
    return Container(
      padding: EdgeInsets.only(bottom: 12, top: 6, left: 2, right: 2),
      width: double.infinity,
      child: Text(
        '回复 张三: 惺惺相惜放假时间发了多少分惺惺相惜放假时间发了多少分惺惺相惜放假时间发了',
        style: TextStyle(color: ThemeColor.colorFF999999, fontSize: 14),
      ),
    );
  }

  _buildPublishArea() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_commentTextEditController.text?.length ?? 0}/150',
            style: TextStyle(color: ThemeColor.colorFF999999, fontSize: 16),
          ),
          Text(
            '发表',
            style: TextStyle(color: ThemeColor.primaryColor, fontSize: 16),
          ),
        ],
      ),
    );
  }

  _showInputBar(String hintText) {
    showModalBottomSheet(
      backgroundColor: ThemeColor.colorFFFAFAFA,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: Duration(milliseconds: 20),
          child: IntrinsicHeight(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildCommendArea(),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 14),
                          minLines: 1,
                          maxLines: 5,
                          controller: _commentTextEditController,
                          focusNode: _commentFocusNode,
                          enableInteractiveSelection: true,
                          autofocus: true,
                          onChanged: (text) {
                            setState(() {
                              // commentContent = text;
                            });
                          },
                          decoration: InputDecoration(
                              counterText: "",
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
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
                              hintText: hintText,
                              hintStyle:
                                  TextStyle(color: ThemeColor.colorFF999999)),
                          cursorHeight: 20,
                        ),
                      ),
                    ],
                  ),
                  _buildPublishArea(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
