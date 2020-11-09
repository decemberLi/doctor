import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:doctor/pages/user/setting/update/app_repository.dart';
import 'package:doctor/pages/user/setting/update/app_update_info.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/adapt.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateHelper {
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
            title: Text('请稍后，升级包下载中'),
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
    AppUpdateInfo updateInfo = await AppRepository.checkUpdate();
    if (updateInfo == null) {
      print('no new version, return;');
      return;
    }

    if (updateInfo.forceUpgrade) {
      print('find force upgrade version, show dialog');
      _showDialog(context, updateInfo);
      return;
    }

    if (!isDriving && !await needCheckUpdate()) {
      print(
          'condition: ${!isDriving && !await needCheckUpdate()}, don\'t show dialog ');
      return;
    }

    print('show dialog');
    _showDialog(context, updateInfo);
  }

  static void _showDialog(BuildContext context, AppUpdateInfo updateInfo) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AppUpdateDialog(updateInfo, onPressed: () async {
              if (Platform.isAndroid) {
                print('download ... ');
                ConnectivityResult connectivityResult =
                    await (Connectivity().checkConnectivity());

                if (connectivityResult == ConnectivityResult.wifi) {
                  _downloadApp(context, updateInfo);
                } else if (await _showNetDialog(context, updateInfo)) {
                  _downloadApp(context, updateInfo);
                }
                return;
              } else {
                _goAppStore();
              }
            }));
  }

  static Future<bool> _showNetDialog(
      BuildContext context, AppUpdateInfo updateInfo) {
    /// 显示完善信息弹窗
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Container(
            padding: EdgeInsets.only(top: 12),
            child: Text(
                "将使用移动网络下载最新安装包，大概消耗移动流量${updateInfo.packageSize}M,现在下载吗？"),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "稍后再说",
                style: TextStyle(
                  color: ThemeColor.primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text(
                "立即下载",
                style: TextStyle(
                  color: ThemeColor.primaryColor,
                ),
              ),
              onPressed: () {
                //关闭对话框并返回true
                // Navigator.of(context).pop();
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
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

  static needCheckUpdate() async {
    var reference = await SharedPreferences.getInstance();
    var lastTime = reference.getInt('app_update_time');
    if (lastTime == null) {
      print('last save -> app_update_time is null');
      return true;
    }
    var nowTime = DateTime.now().millisecondsSinceEpoch;
    var sinceTime =
        DateTime.now().subtract(Duration(days: 2)).millisecondsSinceEpoch;
    print(
        'last save -> app_update_time is $lastTime, nowTime is $nowTime, time condition ${nowTime - lastTime >= sinceTime}');
    return nowTime - lastTime >= sinceTime;
  }
}

class AppUpdateDialog extends StatelessWidget {
  final AppUpdateInfo _updateInfo;
  final VoidCallback _doUpdate;

  AppUpdateDialog(this._updateInfo, {VoidCallback onPressed})
      : _doUpdate = onPressed;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Container(
          padding: EdgeInsets.only(left: 50, right: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                overflow: Overflow.visible,
                children: [
                  Image.asset('assets/images/app_update_top.png'),
                  Positioned(
                    right: 21,
                    top: 84,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '发现新版本',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            '版本：${_updateInfo?.appVersion ?? ''}',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    height: 30,
                    left: 0,
                    bottom: -5,
                    width: Adapt.screenW() - 100,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 35),
                      child: Text(
                        '更新内容:',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: ThemeColor.colorFF222222, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              // 版本内容
              Container(
                padding:
                    EdgeInsets.only(left: 35, right: 35, bottom: 5, top: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildUpdateContentWidget(
                            _updateInfo?.appContent ?? ''),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24, bottom: 24),
                      child: AceButton(
                        width: 137,
                        text: '立即更新',
                        height: 28,
                        onPressed: _doUpdate ??
                            () {
                              print('立即升级');
                            },
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 36),
                  child: Image.asset(
                    'assets/images/close.png',
                    width: 24,
                    height: 24,
                  ),
                ),
                onTap: () {
                  //关闭对话框并返回true
                  if (_updateInfo.forceUpgrade) {
                    exit(0);
                  }
                  _record();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        onWillPop: () {
          print('返回键');
          return Future.value(false);
        });
  }

  _record() async {
    var reference = await SharedPreferences.getInstance();
    reference.setInt('app_update_time', DateTime.now().millisecondsSinceEpoch);
  }

  List<Widget> _buildUpdateContentWidget(String content) {
    List<Widget> list = [];
    var allMatches = content.split(';');
    for (var each in allMatches) {
      var content = Text(each ?? '',
          style: TextStyle(color: ThemeColor.colorFF222222, fontSize: 12));
      list.add(content);
    }

    return list;
  }
}
