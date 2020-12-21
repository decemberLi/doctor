import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef Callback = void Function();

class BottomBarController extends ChangeNotifier {
  int _likeCount = 0;
  String _commentHint = '评论';
  int _commentCount;
  bool _isFavorite = false;
  String _text;
  String _hintText;

  String get hintText => _hintText;

  set hintText(String value) {
    _hintText = value;
    notifyListeners();
  }

  String get commentHint => _commentHint;

  set commentHint(String value) {
    _commentHint = value;
    notifyListeners();
  }

  bool get isFavorite => _isFavorite;

  set isFavorite(bool value) {
    _isFavorite = value;
    notifyListeners();
  }

  int get commentCount => _commentCount;

  set commentCount(int value) {
    _commentCount = value;
    notifyListeners();
  }

  set likeCount(int value) {
    _likeCount = value;
    notifyListeners();
  }

  int get likeCount => _likeCount;

  get liked => _likeCount != 0;

  String get text => _text;

  set text(String value) {
    _text = value;
    notifyListeners();
  }
}

class BottomBarWidget extends StatefulWidget {
  final String hintText;
  final String text;
  final Callback collectCallback;
  final Callback commentCallback;
  final Callback likeCallback;
  final Callback inputCallback;
  final BottomBarController controller;
  final bool isShowLikeBtn;

  BottomBarWidget({
    @required String hintText,
    @required String text,
    @required Callback commentCallback,
    @required Callback collectCallback,
    @required Callback inputCallback,
    @required BottomBarController controller,
    bool isShowLikeBtn = true,
    Callback likeCallback,
  })  : this.isShowLikeBtn = isShowLikeBtn,
        this.hintText = hintText,
        this.text = text,
        this.likeCallback = likeCallback,
        this.commentCallback = commentCallback,
        this.collectCallback = collectCallback,
        this.controller = controller,
        this.inputCallback = inputCallback;

  @override
  State<StatefulWidget> createState() => BottomBarWidgetState();
}

class BottomBarWidgetState extends State<BottomBarWidget> {
  @override
  Widget build(BuildContext context) {
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
        child: ChangeNotifierProvider<BottomBarController>.value(
            value: BottomBarController(),
            builder: (context, child) {
              return Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 9),
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
                              widget.controller.text == null ||
                                      widget.controller.text.length == 0
                                  ? widget.controller._commentHint
                                  : widget.controller.text,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: ThemeColor.colorFF999999),
                            )
                          ],
                        ),
                      ),
                      onTap: debounce(widget.inputCallback),
                    ),
                  ),
                  if (widget.isShowLikeBtn)
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 24),
                        child: _operatorWidget(
                            widget.controller.liked
                                ? 'assets/images/liked_checked.png'
                                : 'assets/images/like_normal.png',
                            '点赞',
                            widget.controller.likeCount),
                      ),
                      onTap: debounce(widget.likeCallback),
                    ),
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 36),
                      child: _operatorWidget(
                          'assets/images/comment_normal.png',
                          widget.controller.commentHint,
                          widget.controller.commentCount),
                    ),
                    onTap: debounce(widget.commentCallback),
                  ),
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 36),
                      child: _operatorWidget(
                          widget.controller.isFavorite
                              ? 'assets/images/collect_checked.png'
                              : 'assets/images/collect_normal.png',
                          '收藏',
                          null),
                    ),
                    onTap: debounce(widget.collectCallback),
                  ),
                ],
              );
            }));
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
}