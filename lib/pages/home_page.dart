import 'package:doctor/http/session_manager.dart';
import 'package:doctor/pages/message/message_page.dart';
import 'package:doctor/pages/prescription/prescription_page.dart';
import 'package:doctor/pages/user/user_page.dart';
import 'package:doctor/pages/worktop/work_top_page.dart';
import 'package:doctor/pages/user/ucenter_view_model.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctor/pages/user/setting/update/app_update.dart';
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

  void onTabTapped(int index) {
    int preTabIndex = _currentIndex;
    // TODO: 接RDM控制处方是否可见
    setState(() {
      _currentIndex = index;
      if (index == 1) {
        _showGoToQualificationDialog(preTabIndex);
      }
    });
  }

  /// 初始化医生用户数据
  initDoctorInfo() async {
    UserInfoViewModel model =
        Provider.of<UserInfoViewModel>(context, listen: false);
    await model.queryDoctorInfo();
    if (model.data != null &&
        model.data.basicInfoAuthStatus == 'NOT_COMPLETE') {
      _showModifyUserInfoDialog();
    }
  }

  /// 显示完善信息弹窗
  Future<bool> _showModifyUserInfoDialog() {
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
              onPressed: () {
                //关闭对话框并返回true
                // Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamed(RouteManager.QUALIFICATION_PAGE);
              },
            ),
          ],
        );
      },
    );
  }

  /// 显示去认证弹窗
  _showGoToQualificationDialog(int preTabIndex) {
    UserInfoViewModel model =
        Provider.of<UserInfoViewModel>(context, listen: false);
    if (model.data.authStatus == 'PASS') {
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
                // Navigator.of(context).pop();
                await Navigator.of(context)
                    .pushNamed(RouteManager.QUALIFICATION_PAGE);
                await model.queryDoctorInfo();
                if (model.data.authStatus == 'PASS') {
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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    AppUpdateHelper.checkUpdate(context);
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
        // selectedFontSize: 12.0,
        onTap: onTabTapped,
        // new
        currentIndex: _currentIndex,
        // new
        type: BottomNavigationBarType.fixed,
        items: [
          new BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/learn.png',
              width: 24,
              height: 24,
            ),
            label: '工作台',
          ),
          new BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/user.png',
              width: 24,
              height: 24,
            ),
            label: '开处方',
          ),
          new BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/user.png',
              width: 24,
              height: 24,
            ),
            label: '消息',
          ),
          new BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/user.png',
              width: 24,
              height: 24,
            ),
            label: '我的',
          ),
          // new BottomNavigationBarItem(
          //   icon: Image.asset(
          //     'assets/images/user.png',
          //     width: 24,
          //     height: 24,
          //   ),
          //   label: '测试页',
          // ),
        ],
      ),
    );
  }
}
