import 'package:connectivity/connectivity.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/app_utils.dart';
import 'package:doctor/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 不在wifi网络下弹窗提示
class NoWifiNoticeHelper {
  /// 检查连接
  static Future<bool> checkConnect({
    @required BuildContext context,
    String message,
  }) async {
    var onlyWifi = AppUtils.sp.getBool(ONLY_WIFI) ?? true;
    if (onlyWifi) {
      ConnectivityResult connectivityResult =
          await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        bool confirm =
            await NoWifiNoticeHelper._confirmDialog(context, message);
        return confirm;
      }
    }
    return true;
  }

  /// 确认弹窗
  static Future<bool> _confirmDialog(BuildContext context, String message) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("提示"),
          content: Container(
            padding: EdgeInsets.only(top: 12),
            child: Text(message ?? ''),
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
}
