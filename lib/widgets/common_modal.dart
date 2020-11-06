import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
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
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 16,
                child: IconButton(
                  color: ThemeColor.secondaryGeryColor,
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
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      title,
                      style: MyStyles.inputTextStyle_16,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(
                    height: 1,
                  ),
                  Expanded(child: child),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
