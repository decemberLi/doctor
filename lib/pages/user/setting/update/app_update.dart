import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doctor/pages/user/setting/update/app_repository.dart';
import 'package:doctor/pages/user/setting/update/app_update_info.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateHelper {
  /// 显示完善信息弹窗
  static Future<bool> _showUpdateDialog(
      BuildContext context, AppUpdateInfo updateInfo) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Container(
            padding: EdgeInsets.only(top: 12),
            child: Text(updateInfo?.appContent ?? ''),
          ),
          actions: <Widget>[
            FlatButton(
              child: Expanded(
                child: Text(
                  "稍后再说",
                  style: TextStyle(
                    color: ThemeColor.primaryColor,
                  ),
                ),
              ),
              onPressed: () {
                //关闭对话框并返回true
                if (updateInfo.forceUpgrade) {
                  exit(0);
                }
                _record();
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(
                "马上升级",
                style: TextStyle(
                  color: ThemeColor.primaryColor,
                ),
              ),
              onPressed: () {
                if (Platform.isAndroid) {
                  print('download ... ');
                  _downloadApp(context, updateInfo);
                  return;
                } else {
                  _goAppStore();
                }
              },
            ),
          ],
        );
      },
    );
  }

  static Future _downloadApp(
      BuildContext context, AppUpdateInfo appUpdateInfo) async {
    // var url =
    //     'https://medclouds-dev.oss-cn-chengdu.aliyuncs.com/Public-file/DOCTOR_APK/1.12/%E6%98%93%E5%AD%A6%E6%9C%AF-1.12.apk'; //appUpdateInfo.downloadUrl;
    var url = appUpdateInfo.downloadUrl;
    var extDir = await getExternalStorageDirectory();
    debugPrint('extDir path: ${extDir.path}');
    String apkPath = '${extDir.path}/apk/${appUpdateInfo.appVersion}.apk';
    File file = File(apkPath);
    debugPrint('apkPath path: ${file.path}');
    if (!file.existsSync()) {
      // 没有下载过
      if (await _showDownloadDialog(context, url, apkPath) ?? true) {
        OpenFile.open(apkPath);
      }
    } else {
      var reDownload = await _showReDownloadAlertDialog(context, appUpdateInfo);
      //因为点击android的返回键,关闭dialog时的返回值为null
      if (reDownload != null) {
        if (reDownload) {
          //重新下载
          if (await _showDownloadDialog(context, url, apkPath) ?? false) {
            OpenFile.open(apkPath);
          }
        } else {
          //直接安装
          OpenFile.open(apkPath);
        }
      }
    }
  }

  static _showReDownloadAlertDialog(
      context, AppUpdateInfo appUpdateInfo) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(appUpdateInfo.appContent),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('取消'),
          ),
          SizedBox(
            width: 20,
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(
              '重新下载',
            ),
          ),
          FlatButton(
            onPressed: () async {
              Navigator.of(context).pop(false);
            },
            child: Text('安装'),
          ),
        ],
      ),
    );
  }

  static _showDownloadDialog(context, url, path) async {
    DateTime lastBackPressed;
    CancelToken cancelToken = CancelToken();
    bool downloading = false;
    return await showCupertinoDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            if (lastBackPressed == null ||
                DateTime.now().difference(lastBackPressed) >
                    Duration(seconds: 1)) {
              //两次点击间隔超过1秒则重新计时
              lastBackPressed = DateTime.now();
              return false;
            }
            cancelToken.cancel();
            return true;
          },
          child: CupertinoAlertDialog(
            title: Text('下载中'),
            content: Builder(
              builder: (context) {
                debugPrint('Downloader Builder');
                ValueNotifier notifier = ValueNotifier(0.0);
                if (!downloading) {
                  downloading = true;
                  Dio().download(url, path, cancelToken: cancelToken,
                      onReceiveProgress: (progress, total) {
                    debugPrint('value--${progress / total}');
                    notifier.value = progress / total;
                  }).then((Response response) {
                    Navigator.pop(context, true);
                  }).catchError((onError) {
                    EasyLoading.showToast('下载失败');
                    Navigator.pop(context);
                  });
                }
                return ValueListenableBuilder(
                  valueListenable: notifier,
                  builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LinearProgressIndicator(
                        value: value,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  static checkUpdate(BuildContext context, {bool isDriving = false}) async {
    if (!isDriving && !await needCheckUpdate()) {
      return;
    }

    AppUpdateInfo updateInfo = await AppRepository.checkUpdate();
    if (updateInfo == null) {
      return;
    }
    _showUpdateDialog(context, updateInfo);
  }

  static void _goAppStore() async {
    var url = await AppRepository.queryDictionary();
    if (url == null) {
      return;
    }

    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  static void _record() async {
    var reference = await SharedPreferences.getInstance();
    reference.setInt('app_update_time', DateTime.now().millisecondsSinceEpoch);
  }

  static needCheckUpdate() async {
    var reference = await SharedPreferences.getInstance();
    var lastTime = reference.getInt('app_update_time');
    if (lastTime == null) {
      return true;
    }
    var nowTime = DateTime.now().millisecondsSinceEpoch;
    var sinceTime =
        DateTime.now().subtract(Duration(days: 2)).millisecondsSinceEpoch;
    return nowTime - lastTime >= sinceTime;
  }
}
