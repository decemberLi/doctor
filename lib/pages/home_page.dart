import 'package:doctor/pages/message/message_page.dart';
import 'package:doctor/pages/prescription/prescription_page.dart';
import 'package:doctor/pages/user/user_page.dart';
import 'package:doctor/pages/worktop/work_top_page.dart';
import 'package:flutter/material.dart';

/// 首页
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    WorktopPage(),
    PrescriptionPage(),
    MessagePage(),
    UserPage(),
    // TestPage()
  ];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black,
        // selectedFontSize: 12.0,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
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
