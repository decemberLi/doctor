import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DoctorsDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DoctorsDetailPageState();
}

class _DoctorsDetailPageState extends State<DoctorsDetailPage> {
  WebViewController _controller;
  TextEditingController _commentTextEdit = TextEditingController();
  FocusNode _commentFocusNode = FocusNode();
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
      appBar: AppBar(
        title: Text('详情'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(bottom: 50),
              height: MediaQuery.of(context).size.height,
              child: WebView(
                initialUrl: 'http://www.baidu.com',
                onWebViewCreated: (controller) => _controller = controller,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: _bottomBar(),
          )
        ],
      ),
    );
  }

  _bottomBar() {
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
          if (!_isInputModel) _operatorArea()
        ],
      ),
    );
  }

  _operatorArea() {
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 24),
          child: _operatorWidget('assets/images/like_normal.png', '点赞'),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 24),
          child: _operatorWidget('assets/images/comment_normal.png', '评论'),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 24),
          child: _operatorWidget('assets/images/collect_normal.png', '收藏'),
        ),
      ],
    );
  }

  _operatorWidget(String asstPath, String text) {
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
            '12',
            style: TextStyle(fontSize: 10, color: ThemeColor.colorFF999999),
          ),
        )
      ],
    );
  }
}
