import 'package:doctor/http/foundation.dart';
import 'package:doctor/pages/user/setting/DevSetting.dart';
import 'package:doctor/pages/user/setting/service_aggrement_page.dart';
import 'package:doctor/pages/user/setting/update/app_update.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/utils/platform_utils.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _flag = true;
  String _version = '';
  String _versionCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        elevation: 0,
        title: GestureDetector(
          child: Text('设置'),
          onDoubleTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => DevSetting()));
          },
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            child: _buildItemWidget('修改登录密码'),
            onTap: () {
              Navigator.pushNamed(context, RouteManagerOld.MODIFY_PWD);
            },
          ),
          GestureDetector(
            child: _buildItemWidget('服务协议'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ServiceAgreementPage()));
            },
          ),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: _buildSwitchWidget(),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 18),
                  child: _buildDivider(),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 18),
                  child: _buildAppUpdateWidget(context),
                ),
              ],
            ),
          ),
          _buildLogoutWidget(),
        ],
      ),
    );
  }

  _buildLogoutWidget() {
    return GestureDetector(
      child: Container(
        height: 50,
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
                alignment: Alignment.center,
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
        EasyLoading.instance.flash(() async {
          await API.shared.foundation.pushDeviceDel();
          SessionManager.shared.session = null;
        });
      },
    );
  }

  _buildItemWidget(String text) {
    return Container(
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
                  text,
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
    );
  }

  _buildAppUpdateWidget(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 50,
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
            Text('当前版本 $_version($_versionCode)')
          ],
        ),
      ),
      onTap: () {
        AppUpdateHelper.checkUpdate(context, isDriving: true);
      },
    );
  }

  _buildSwitchWidget() {
    return GestureDetector(
      child: Container(
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 24),
                child: Text(
                  '仅在Wi-Fi下上传/加载视频',
                  style:
                      TextStyle(color: ThemeColor.colorFF222222, fontSize: 14),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Switch(
              value: _flag,
              onChanged: (bool value) async {
                _flag = value;
                var preference = await SharedPreferences.getInstance();
                preference.setBool(ONLY_WIFI, value);
                setState(() {});
              },
            )
          ],
        ),
      ),
    );
  }

  _buildDivider() {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(left: 16),
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
    var toggle = preference.getBool(ONLY_WIFI);
    if (toggle != null) {
      _flag = toggle;
    }
    _version = await PlatformUtils.getAppVersion();
    _versionCode = await PlatformUtils.getBuildNum();

    setState(() {});
  }
}
