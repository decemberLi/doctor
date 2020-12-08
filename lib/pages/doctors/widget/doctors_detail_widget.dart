import 'package:doctor/pages/doctors/viewmodel/doctors_detail_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../model/doctor_article_detail_entity.dart';

class DoctorsDetailPage extends StatefulWidget {
  final int postId;

  DoctorsDetailPage(this.postId);

  @override
  State<StatefulWidget> createState() => _DoctorsDetailPageState();
}

class _DoctorsDetailPageState extends State<DoctorsDetailPage> {
  WebViewController _controller;
  TextEditingController _commentTextEdit = TextEditingController();
  FocusNode _commentFocusNode = FocusNode();
  DoctorsDetailViewMode _model = DoctorsDetailViewMode();
  final _kvn = KeyboardVisibilityNotification();
  bool _isInputModel = false;
  int _subscribeId;

  @override
  void initState() {
    super.initState();
    _subscribeId = _kvn.addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          //键盘下降失去焦点
          setState(() {
            // logo = false;
            _isInputModel = false;
          });
          _commentFocusNode.unfocus();
        }
      },
    );
    _model.initArticleDetail(widget.postId);
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
    return Scaffold(
      appBar: AppBar(title: Text('帖子详情'), elevation: 0),
      body: ProviderWidget<DoctorsDetailViewMode>(
        model: _model,
        builder: (context, model, child) {
          return Stack(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: 50),
                  height: MediaQuery.of(context).size.height,
                  child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl:
                        'http://192.168.1.27:8000/#/detail?id=${widget.postId}',
                    onWebViewCreated: (controller) => _controller = controller,
                    onPageFinished: (url) {
                      print(url);
                    },
                    javascriptChannels: <JavascriptChannel>[
                      JavascriptChannel(
                          name: 'reply', onMessageReceived: (message) {}),
                      JavascriptChannel(
                          name: 'ticket', onMessageReceived: (message) {}),
                    ].toSet(),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: _bottomBar(_model.detailEntity),
              )
            ],
          );
        },
      ),
    );
  }

  _bottomBar(DoctorArticleDetailEntity entity) {
    return Container(
      height: 50,
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
      child: Row(
        children: [
          Expanded(
            child: TextField(
              minLines: 1,
              maxLines: 10,
              maxLength: 150,
              controller: _commentTextEdit,
              focusNode: _commentFocusNode,
              // enableInteractiveSelection: false,
              onTap: () {
                FocusScope.of(context).requestFocus(_commentFocusNode);
                setState(() {
                  // logo = false;
                  _isInputModel = true;
                });
              },
              onChanged: (text) {
                setState(() {
                  // commentContent = text;
                });
              },
              decoration: InputDecoration(
                counterText: "",
                fillColor: Color(0XFFEDEDED),
                filled: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  //未选中时候的颜色
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusColor: Colors.transparent,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                hintText: '写评论',
              ),
            ),
          ),
          if (!_isInputModel) _operatorArea(entity)
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
            margin: EdgeInsets.only(left: 24),
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
          margin: EdgeInsets.only(left: 24),
          child: _operatorWidget('assets/images/comment_normal.png', '评论',
              entity?.commentNum ?? 0),
        ),
        GestureDetector(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 24),
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
    return Stack(
      overflow: Overflow.visible,
      children: [
        Container(
          child: Column(
            children: [
              Image.asset(
                asstPath,
                width: 20,
                height: 20,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 10, color: ThemeColor.colorFF999999),
              )
            ],
          ),
        ),
        Positioned(
          right: -12,
          child: Text(
            '${number ?? ''}',
            style: TextStyle(fontSize: 10, color: ThemeColor.colorFF999999),
          ),
        )
      ],
    );
  }
}
