import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:doctor/pages/user/setting/update/app_update_info.dart';
import 'package:flutter/material.dart';

class AppUpdateDialog extends StatelessWidget {
  final AppUpdateInfo _updateInfo;

  AppUpdateDialog(this._updateInfo,
      {VoidCallback onPressed, VoidCallback onCancel});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Center(
          child: Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 208,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/app_update_top.png',
                      ),
                      Positioned(
                        right: 16,
                        top: 62,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '发现新版本',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              Text(
                                '版本：${_updateInfo?.appVersion ?? ''}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 版本内容
                Container(
                  width: 208,
                  padding: EdgeInsets.only(left: 15, bottom: 10),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '更新内容:',
                        style: TextStyle(
                            color: ThemeColor.colorFF222222, fontSize: 12),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 16),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildUpdateContentWidget(
                              _updateInfo?.appContent ?? ''),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 35, right: 35, bottom: 5),
                  color: Colors.white,
                  width: 208,
                  child: AceButton(
                    text: '立即更新',
                    width: 137,
                    height: 28,
                    onPressed: () {},
                  ),
                ),
                Container(
                  child: Image.asset(
                    'assets/images/app_update_bottom.png',
                    width: 208,
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
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
        onWillPop: () {
          print('返回键');
          return Future.value(false);
        });
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
