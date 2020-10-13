import 'package:doctor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/pages/worktop/worktop_page.dart';
import 'package:doctor/pages/user/user_page.dart';
import 'package:doctor/pages/test/test_page.dart';

/// 首页
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [WorktopPage(), UserPage(), TestPage()];
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
        unselectedItemColor: Colors.grey,
        selectedItemColor: ThemeColor.primaryColor,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
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
            label: '个人中心',
          ),
          new BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/user.png',
              width: 24,
              height: 24,
            ),
            title: Text('测试页'),
          ),
        ],
      ),
    );
  }
}
