import 'package:doctor/theme/common_style.dart';
import 'package:flutter/material.dart';

/// 通用的弹窗样式
class CommonModal {
  static Future showBottomSheet(
    BuildContext context, {
    String title,
    double height = 560,
    @required Widget child,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          height: height,
          padding: EdgeInsets.only(left: 26, right: 26, top: 0),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  title,
                  style: MyStyles.inputTextStyle_16,
                  textAlign: TextAlign.center,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.close),
                  iconSize: 20.0,
                  constraints: BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Divider(
                height: 1,
              ),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }
}
