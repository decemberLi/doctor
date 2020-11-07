import 'package:doctor/http/session_manager.dart';
import 'package:doctor/pages/message/message_page.dart';
import 'package:doctor/pages/message/view_model/message_center_view_model.dart';
import 'package:doctor/pages/prescription/prescription_page.dart';
import 'package:doctor/pages/user/setting/update/app_update.dart';
import 'package:doctor/pages/user/ucenter_view_model.dart';
import 'package:doctor/pages/user/user_page.dart';
import 'package:doctor/pages/worktop/work_top_page.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 首页
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _currentIndex = 0;
  final List<Widget> _children = [
    WorktopPage(),
    PrescriptionPage(),
    MessagePage(),
    UserPage(),
    // TestPage()
  ];

  initData() async {
    await AppUpdateHelper.checkUpdate(context);
  }

  void onTabTapped(int index) {
    int preTabIndex = _currentIndex;
    // TODO: 接RDM控制处方是否可见
    if (index == 0) {
      this.updateDoctorInfo();
    }
    setState(() {
      _currentIndex = index;
      if (index == 1) {
        _showGoToQualificationDialog(preTabIndex);
      } else if (index == 2) {
        _refreshMessageCenterData();
      }
    });
  }

  updateDoctorInfo() {
    UserInfoViewModel model =
        Provider.of<UserInfoViewModel>(context, listen: false);
    if (model.data?.authStatus != 'PASS') {
      model.queryDoctorInfo();
    }
  }

  _refreshMessageCenterData() {
    MessageCenterViewModel messageCenterModel =
        Provider.of<MessageCenterViewModel>(context, listen: false);
    messageCenterModel.initData();
  }

  /// 初始化医生用户数据
  initDoctorInfo() async {
    UserInfoViewModel model =
        Provider.of<UserInfoViewModel>(context, listen: false);
    await model.queryDoctorInfo();
    if (model.data != null &&
        model.data.basicInfoAuthStatus == 'NOT_COMPLETE') {
      _showModifyUserInfoDialog(model);
    }
    _refreshMessageCenterData();
  }

  /// 显示完善信息弹窗
  Future<bool> _showModifyUserInfoDialog(UserInfoViewModel model) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Container(
            padding: EdgeInsets.only(top: 12),
            child: Text("您还没有完善医生基础信息"),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "退出登录",
                style: TextStyle(
                  color: ThemeColor.primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                SessionManager.loginOutHandler();
              },
            ),
            FlatButton(
              child: Text(
                "现在去完善",
                style: TextStyle(
                  color: ThemeColor.primaryColor,
                ),
              ),
              onPressed: () async {
                var result = await Navigator.pushNamed(
                    context, RouteManager.USERINFO_DETAIL,
                    arguments: {
                      'doctorData': model.data.toJson(),
                      'openType': 'SURE_INFO',
                    });
                if (result != null) {
                  await model.queryDoctorInfo();
                  if (model.data.basicInfoAuthStatus == 'COMPLETED') {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// 显示去认证弹窗
  _showGoToQualificationDialog(int preTabIndex) async {
    UserInfoViewModel model =
        Provider.of<UserInfoViewModel>(context, listen: false);
    if (model.data?.authStatus == 'PASS') {
      return;
    }
    // 如果没有通过认证再次查询，再次判断
    await model.queryDoctorInfo();
    if (model.data?.authStatus == 'PASS') {
      return;
    }

    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Container(
            padding: EdgeInsets.only(top: 12),
            child: Text("认证后才可以进入开处方页面"),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "取消",
                style: TextStyle(
                  color: ThemeColor.primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onTabTapped(preTabIndex);
              },
            ),
            FlatButton(
              child: Text(
                "马上去",
                style: TextStyle(
                  color: ThemeColor.primaryColor,
                ),
              ),
              onPressed: () async {
                //关闭对话框并返回true
                String path = RouteManager.USERINFO_DETAIL;
                Map arguments = {
                  'doctorData': model.data.toJson(),
                  'qualification': true,
                };
                if (model.data?.authStatus == 'VERIFYING') {
                  path = RouteManager.QUALIFICATION_AUTH_STATUS;
                  arguments = {'authStatus': model.data?.authStatus};
                }
                await Navigator.pushNamed(
                  context,
                  path,
                  arguments: arguments,
                );
                await model.queryDoctorInfo();
                if (model.data?.authStatus == 'PASS') {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      this.initDoctorInfo();
    });
    initData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: _children[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black,
        selectedFontSize: 12.0,
        selectedIconTheme: IconThemeData(size: 24),
        unselectedIconTheme: IconThemeData(size: 24),
        onTap: onTabTapped,
        // new
        currentIndex: _currentIndex,
        // new
        type: BottomNavigationBarType.fixed,
        items: [
          new BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/work_top_uncheck.png',
              width: 24,
              height: 24,
            ),
            activeIcon: Image.asset(
              'assets/images/work_top_checked.png',
              width: 24,
              height: 24,
            ),
            label: '工作台',
          ),
          new BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/prescribe_uncheck.png',
              width: 24,
              height: 24,
            ),
            activeIcon: Image.asset(
              'assets/images/prescribe_checked.png',
              width: 24,
              height: 24,
            ),
            label: '开处方',
          ),
          new BottomNavigationBarItem(
            icon: _messageIcon(false),
            activeIcon: _messageIcon(true),
            label: '消息',
          ),
          new BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/mine_uncheck.png',
              width: 24,
              height: 24,
            ),
            activeIcon: Image.asset(
              'assets/images/mine_checked.png',
              width: 24,
              height: 24,
            ),
            label: '我的',
          ),
        ],
      ),
    );
  }

  _messageIcon(bool isActive) {
    return Consumer<MessageCenterViewModel>(builder: (context, model, child) {
      var assetsUrl;
      if (isActive) {
        assetsUrl = 'assets/images/message_checked.png';
      } else {
        assetsUrl = 'assets/images/message_uncheck.png';
      }
      var icon = Image.asset(assetsUrl, width: 24, height: 24);
      var redDotColor = Colors.transparent;
      if (model != null &&
          model.data != null &&
          model.data.total != null &&
          model.data.total > 0) {
        redDotColor = ThemeColor.colorFFF57575;
      }

      return Stack(
        children: [
          icon,
          Positioned(
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: redDotColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              width: 7,
              height: 7,
            ),
          ),
        ],
      );
    });
  }
}
