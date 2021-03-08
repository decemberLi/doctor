import 'package:doctor/common/event/event_home_tab.dart';
import 'package:doctor/common/event/event_model.dart';
import 'package:doctor/common/event/event_tab_index.dart';
import 'package:doctor/pages/message/message_page.dart';
import 'package:doctor/pages/message/view_model/message_center_view_model.dart';
import 'package:doctor/pages/prescription/prescription_page.dart';
import 'package:doctor/pages/prescription/view_model/prescription_view_model.dart';
import 'package:doctor/pages/reporter_dialog.dart';
import 'package:doctor/pages/user/setting/update/app_update.dart';
import 'package:doctor/pages/user/ucenter_view_model.dart';
import 'package:doctor/pages/user/user_page.dart';
import 'package:doctor/pages/worktop/work_top_page.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:doctor/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:http_manager/manager.dart';
import 'package:doctor/http/ucenter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../root_widget.dart';
import 'doctors/doctors_home.dart';
import 'doctors/model/in_screen_event_model.dart';

/// 首页
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;
  ScrollOutScreenViewModel _outScreenViewModel;
  bool isDoctors = true;

  int _currentIndex = 1;
  int _toIndex = 0;
  final List<Widget> _children = [
    WorktopPage(),
    // PrescriptionPage(),
    DoctorsHome(),
    MessagePage(),
    UserPage(),
    // TestPage()
  ];

  initData() async {
    await AppUpdateHelper.checkUpdate(context);
    bool allowNotification = false;
    try{
      allowNotification = await MedcloudsNativeApi.instance().checkNotification();
    }catch(e){

    }
    var sp = await SharedPreferences.getInstance();
    var notShow = sp.getBool("notShowAlertOpenNotification")??false;
    var showAlert = !allowNotification && !notShow;
    if (showAlert) {
      _showNotifAlert();
    }
  }

  _showNotifAlert(){
    showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Container(
            padding: EdgeInsets.only(top: 12),
            child: Text("记得打开消息通知哦\n这样重要消息就可以及时通知您啦"),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "残忍拒绝",
                style: TextStyle(
                  color: ThemeColor.primaryColor,
                ),
              ),
              onPressed: () async{
                var sp = await SharedPreferences.getInstance();
                sp.setBool("notShowAlertOpenNotification", true);
                Navigator.of(context).maybePop(false);
              },
            ),
            FlatButton(
              child: Text(
                "确认",
                style: TextStyle(
                  color: ThemeColor.primaryColor,
                ),
              ),
              onPressed: () async {
                var sp = await SharedPreferences.getInstance();
                sp.setBool("notShowAlertOpenNotification", true);
                Navigator.of(context).pop();
                MedcloudsNativeApi.instance().openSetting();
              },
            ),
          ],
        );
      },
    );
  }

  void onTabTapped(int index) async {
    _toIndex = index;
    if (index == 1) {
      if (isDoctors) {
        eventBus.fire(_outScreenViewModel.event);
      }
      isDoctors = true;
    } else {
      isDoctors = false;
    }
    eventBus.fire(EventTabIndex(index, null));
    if (index == _currentIndex) {
      return;
    }
    if (index == 3) {
      eventBus.fire(KEY_UPDATE_USER_INFO);
    }
    if (index == 0) {
      showWeekIfNeededReporter(context);
      this.updateDoctorInfo();
    }
    // if (index == 1) {
    //   UserInfoViewModel model =
    //       Provider.of<UserInfoViewModel>(context, listen: false);
    //   if (!await _checkDoctorBindRelation(model.data?.authStatus)) {
    //     return;
    //   }
    //   if (model.data?.authStatus != 'PASS') {
    //     _showAuthenticationDialog(model);
    //     return;
    //   }
    // }
    setState(() {
      _currentIndex = index;
      if (index == 2) {
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

  /// 重置处方数据
  _resetPrescriptionData() {
    PrescriptionViewModel model =
        Provider.of<PrescriptionViewModel>(context, listen: false);
    model.resetData();
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
    _resetPrescriptionData();
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
                SessionManager.shared.session = null;
                MedcloudsNativeApi.instance().logout();
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

  _checkDoctorBindRelation(String authStatus) async {
    if (authStatus != 'PASS') {
      return Future.value(true);
    }
    // 已认证，未绑定代表
    if (authStatus == 'PASS' &&
        !await API.shared.ucenter.queryDoctorRelation()) {
      EasyLoading.showToast('您没有绑定医药代表，暂不能开具处方');
      return Future.value(false);
    }
    // 未认证状态
    return Future.value(true);
  }

  _showAuthenticationDialog(UserInfoViewModel model) {
    showCupertinoDialog<bool>(
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
                Navigator.of(context).maybePop(false);
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
                  Navigator.of(context).maybePop(false);
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
    _outScreenViewModel =
        Provider.of<ScrollOutScreenViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      this.initDoctorInfo();
    });
    initData();
    // showWeekIfNeededReporter(context);
    WidgetsBinding.instance.addObserver(this);
    eventBus.on().listen((event) {
      if(event is EventHomeTab){
        debugPrint("index ------------------> ${event.index}");
        onTabTapped(event.index);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // if (state == AppLifecycleState.resumed && _toIndex == 0) {
    //   showWeekIfNeededReporter(context);
    // }
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
        child: IndexedStack(
          children: _children,
          index: _currentIndex,
        ),
      ),
      bottomNavigationBar: Consumer<ScrollOutScreenViewModel>(
        builder: (BuildContext context, ScrollOutScreenViewModel value,
            Widget child) {
          return BottomNavigationBar(
            backgroundColor: Colors.white,
            unselectedItemColor: Colors.black,
            selectedFontSize: 12.0,
            // iconSize: 24.0,
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
                  // width: 24,
                  // height: 24,
                ),
                activeIcon: Image.asset(
                  'assets/images/work_top_checked.png',
                  // width: 24,
                  // height: 24,
                ),
                label: '工作台',
              ),
              // new BottomNavigationBarItem(
              //   icon: Image.asset(
              //     'assets/images/prescribe_uncheck.png',
              //     // width: 24,
              //     // height: 24,
              //   ),
              //   activeIcon: Image.asset(
              //     'assets/images/prescribe_checked.png',
              //     // width: 24,
              //     // height: 24,
              //   ),
              //   label: '开处方',
              // ),
              _buildDoctorsTabBarItem(value),
              new BottomNavigationBarItem(
                icon: _messageIcon(false),
                activeIcon: _messageIcon(true),
                label: '消息',
              ),
              new BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/mine_uncheck.png',
                  // width: 24,
                  // height: 24,
                ),
                activeIcon: Image.asset(
                  'assets/images/mine_checked.png',
                  // width: 24,
                  // height: 24,
                ),
                label: '我的',
              ),
            ],
          );
        },
      ),
    );
  }

  BottomNavigationBarItem _buildDoctorsTabBarItem(
      ScrollOutScreenViewModel value) {
    var iconImg = Image.asset(
      'assets/images/doctors_checked.png',
      width: 24,
      height: 24,
    );
    var tabText = '医生圈';
    if (value != null &&
        value.event != null &&
        value.event.isOutScreen &&
        isDoctors) {
      iconImg = Image.asset(
        'assets/images/doctors_to_top_icon.png',
        width: 24,
        height: 24,
      );
      tabText = '回到顶部';
    }
    return new BottomNavigationBarItem(
      icon: Image.asset(
        'assets/images/doctors_unchecked.png',
        width: 24,
        height: 24,
      ),
      activeIcon: iconImg,
      label: tabText,
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
      var icon = Image.asset(
        assetsUrl,
        // width: 24,
        // height: 24
      );
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
