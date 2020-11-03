import 'package:doctor/http/session_manager.dart';
import 'package:doctor/pages/user/setting/update/app_update.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/platform_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _flag = false;
  String _version = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: Column(
        children: [
          _buildModifyPwdWidget(),
          _buildSwitchWidget(),
          _buildDivider(),
          _buildAppUpdateWidget(context),
          _buildLogoutWidget(),
        ],
      ),
    );
  }

  _buildLogoutWidget() {
    return GestureDetector(
      child: Container(
        height: 50,
        padding: EdgeInsets.only(right: 18),
        margin: EdgeInsets.only(left: 16, right: 16, top: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 24),
                child: Text(
                  '退出登录',
                  style:
                      TextStyle(color: ThemeColor.colorFF222222, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        SessionManager.loginOutHandler();
      },
    );
  }

  _obtainAppVersion() async {
    await PlatformUtils.getAppVersion();
  }

  _buildModifyPwdWidget() {
    return GestureDetector(
      child: Container(
        height: 50,
        padding: EdgeInsets.only(right: 18),
        margin: EdgeInsets.only(left: 16, right: 16, top: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        child: Row(
          children: [
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 24),
              child: Text(
                '修改登录密码',
                style: TextStyle(color: ThemeColor.colorFF222222, fontSize: 14),
                textAlign: TextAlign.left,
              ),
            )),
            Icon(
              Icons.arrow_forward_ios,
              color: ThemeColor.colorFF000000,
              size: 12,
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, RouteManager.MODIFY_PWD);
      },
    );
  }

  _buildAppUpdateWidget(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 50,
        padding: EdgeInsets.only(right: 18),
        margin: EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        child: Row(
          children: [
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 24),
              child: Text(
                '检查更新',
                style: TextStyle(color: ThemeColor.colorFF222222, fontSize: 14),
                textAlign: TextAlign.left,
              ),
            )),
            Text('当前版本 $_version')
          ],
        ),
      ),
      onTap: () {
        AppUpdateHelper.checkUpdate(context);
      },
    );
  }

  _buildSwitchWidget() {
    return GestureDetector(
      child: Container(
        height: 50,
        padding: EdgeInsets.only(right: 18),
        margin: EdgeInsets.only(left: 16, right: 16, top: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        child: Row(
          children: [
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 24),
              child: Text(
                '仅在Wi-Fi下上传/加载视频',
                style: TextStyle(color: ThemeColor.colorFF222222, fontSize: 14),
                textAlign: TextAlign.left,
              ),
            )),
            Switch(
                value: _flag,
                onChanged: (bool) async {
                  _flag = bool;
                  var preference = await SharedPreferences.getInstance();
                  preference.setBool('only_wifi', bool);
                  setState(() {});
                })
          ],
        ),
      ),
    );
  }

  _buildDivider() {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        child: Divider(
          height: 1,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getCacheData();
  }

  _getCacheData() async {
    var preference = await SharedPreferences.getInstance();
    var toggle = preference.getBool('only_wifi');
    if(toggle == null){
      toggle = false;
    }
    _version = await PlatformUtils.getAppVersion();
    setState(() {});
  }
}