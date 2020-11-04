import 'package:doctor/pages/message/message_page.dart';
import 'package:doctor/pages/prescription/prescription_page.dart';
import 'package:doctor/pages/user/user_page.dart';
import 'package:doctor/pages/worktop/work_top_page.dart';
import 'package:flutter/material.dart';
import 'package:doctor/pages/user/setting/update/app_update.dart';

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
    // TODO: 接RDM控制处方是否可见
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
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
