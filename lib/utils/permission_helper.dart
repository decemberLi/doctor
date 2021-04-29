import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> checkCameraPermission(BuildContext context) async {
    var status = await Permission.camera.status;
    print('Is camera permission granted --> $status');
    // 从未申请过权限, 申请权限
    if (await Permission.camera.request().isGranted ||
        status.isGranted) {
      print('undetermined & request permission && isGranted');
      return true;
    }

    // 完全完毕
    if (status == PermissionStatus.denied ||
        status.isPermanentlyDenied ||
        status.isRestricted) {
      await showPermissionDialog(context, '请在手机的隐私设置中，允许易学术访问你的相机');
      var againResult = await Permission.camera.request().isGranted;
      print('Again request camera permission, isGranted: $againResult');
      return againResult;
    }

    return false;
  }

  static Future<bool> checkPhotosPermission(BuildContext context) async {
    var status = await Permission.photos.status;
    print('Is camera permission granted --> $status');

    // 从未申请过权限, 申请权限
    if (await Permission.photos.request().isGranted ||
        status.isGranted) {
      print('undetermined & request permission && isGranted');
      return true;
    }

    if (status.isLimited) {
      return true;
    }
    
    // 完全完毕
    if (status == PermissionStatus.denied) {
      await showPermissionDialog(context, '请在手机的隐私设置中，允许易学术访问你的相册');
      var againResult = await Permission.photos.request().isGranted;
      print('Again request photos permission, isGranted: $againResult');
      return againResult;
    }

    return false;
  }

  static Future<bool> showPermissionDialog(
      BuildContext context, String hintText) {
    return showCupertinoDialog<bool>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Container(
              padding: EdgeInsets.only(top: 12),
              child: Text(hintText),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "好的",
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
        });
  }
}
