import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';

/// 通用的弹窗样式
class CommonModal {
  static Future showBottomSheet(
    BuildContext context, {
    EdgeInsetsGeometry titlePadding =
        const EdgeInsets.only(left: 26, right: 26),
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.only(left: 26, right: 26),
    String title,
    double height = 560,
    bool enableDrag = true,
    @required Widget child,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: enableDrag,
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
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 16,
                child: Padding(
                  padding: titlePadding,
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
              ),
              Padding(
                padding: contentPadding,
                child: Column(
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
              ),
            ],
          ),
        );
      },
    );
  }
}
