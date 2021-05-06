import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> showNoTitleConfirmDialog<bool>(
    {@required BuildContext context, @required String content, bool dismiss}) {
  return showCupertinoDialog<bool>(
    context: context,
    barrierDismissible: dismiss ?? false,
    builder: (context) {
      return CupertinoAlertDialog(
        content: Container(
          padding: EdgeInsets.only(top: 12),
          child: Text(content ?? ''),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("取消"),
            onPressed: () => Navigator.of(context).pop(false), // 关闭对话框
          ),
          TextButton(
            child: Text(
              "确定",
              style: TextStyle(
                color: ThemeColor.primaryColor,
              ),
            ),
            onPressed: () {
              //关闭对话框并返回true
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

Future<bool> showConfirmDialog<bool>({
  @required BuildContext context,
  @required String content,
  String title = '提示',
}) {
  return showCupertinoDialog<bool>(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Container(
          padding: EdgeInsets.only(top: 12),
          child: Text(content ?? ''),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("取消"),
            onPressed: () => Navigator.of(context).pop(false), // 关闭对话框
          ),
          TextButton(
            child: Text(
              "确定",
              style: TextStyle(
                color: ThemeColor.primaryColor,
              ),
            ),
            onPressed: () {
              //关闭对话框并返回true
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

Future<bool> showPrompt<bool>({
  @required BuildContext context,
  @required String content,
  String buttonText,
  bool dismiss,
}) {
  return showCupertinoDialog<bool>(
    context: context,
    barrierDismissible: dismiss ?? false,
    builder: (context) {
      return CupertinoAlertDialog(
        content: Container(
          padding: EdgeInsets.only(top: 12),
          child: Text(content ?? ''),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              buttonText ?? '确定',
              style: TextStyle(
                color: ThemeColor.primaryColor,
              ),
            ),
            onPressed: () {
              //关闭对话框并返回true
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
