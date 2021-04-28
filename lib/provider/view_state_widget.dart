import 'package:doctor/theme/myIcons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'view_state.dart';

/// 加载中
class ViewStateBusyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

/// 基础Widget
class ViewStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final Widget image;
  final Widget buttonText;
  final String buttonTextData;
  final VoidCallback onPressed;
  final isShowRefreshBtn;

  ViewStateWidget({
    Key key,
    this.image,
    this.title,
    this.message,
    this.buttonText,
    this.onPressed,
    this.buttonTextData,
    this.isShowRefreshBtn = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleStyle = TextStyle(fontSize: 14,color: Color(0xff888888));
        // Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.grey);
    var messageStyle = titleStyle.copyWith(
        color: titleStyle.color.withOpacity(0.7), fontSize: 14);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        image ??
            Icon(
              MyIcons.icon_no_data,
              size: 120,
              color: Color(0xFF70BEE8),
            ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                title ?? '页面错误',
                style: titleStyle,
              ),
              SizedBox(height: 20),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200, minHeight: 60),
                child: SingleChildScrollView(
                  child: Text(message ?? '', style: messageStyle),
                ),
              ),
            ],
          ),
        ),
        isShowRefreshBtn
            ? Center(
                child: ViewStateButton(
                  child: buttonText,
                  textData: buttonTextData,
                  onPressed: onPressed,
                ),
              )
            : Container(),
      ],
    );
  }
}

/// ErrorWidget
class ViewStateErrorWidget extends StatelessWidget {
  final ViewStateError error;
  final String title;
  final String message;
  final Widget image;
  final Widget buttonText;
  final String buttonTextData;
  final VoidCallback onPressed;
  final bool isShowRefreshBtn;

  const ViewStateErrorWidget({
    Key key,
    @required this.error,
    this.image,
    this.title,
    this.message,
    this.buttonText,
    this.buttonTextData,
    this.onPressed,
    this.isShowRefreshBtn = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var defaultTitle = '暂无数据';
    var errorMessage = error.message;
    String defaultTextData = '重试';

    return ViewStateWidget(
      onPressed: this.onPressed,
      image: image,
      title: title ?? defaultTitle,
      message: message ?? errorMessage,
      buttonTextData: buttonTextData ?? defaultTextData,
      buttonText: buttonText,
      isShowRefreshBtn: isShowRefreshBtn,
    );
  }
}

/// 页面无数据
class ViewStateEmptyWidget extends StatelessWidget {
  final String message;
  final Widget image;
  final Widget buttonText;
  final VoidCallback onPressed;
  final bool isShowRefreshBtn;

  const ViewStateEmptyWidget({
    Key key,
    this.image,
    this.message,
    this.buttonText,
    this.onPressed,
    this.isShowRefreshBtn = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      onPressed: this.onPressed,
      image: image ?? Image.asset("assets/images/empty.png"),
      title: message ?? '暂无数据',
      buttonText: buttonText,
      buttonTextData: '刷新',
      isShowRefreshBtn: isShowRefreshBtn,
    );
  }
}

/// 公用Button
class ViewStateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final String textData;

  const ViewStateButton({this.onPressed, this.child, this.textData})
      : assert(child == null || textData == null);

  @override
  Widget build(BuildContext context) {
    if (onPressed == null) {
      return Container();
    }
    return OutlineButton(
      child: child ??
          Text(
            textData ?? '重试',
            style: TextStyle(wordSpacing: 5),
          ),
      textColor: Colors.grey,
      splashColor: Theme.of(context).splashColor,
      onPressed: onPressed,
      highlightedBorderColor: Theme.of(context).splashColor,
    );
  }
}
