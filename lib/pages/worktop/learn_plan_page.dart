import 'package:doctor/pages/home_page.dart';
import 'package:doctor/pages/worktop/learn/learn_list/learn_list_view.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/constants.dart';
import 'package:flutter/material.dart';

class LearnPlanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(APP_NAME),
              elevation: 1,
              bottom: PreferredSize(
                  child: Container(
                    color: ThemeColor.colorFFF3F5F8,
                    child: TabBar(
                      labelColor: ThemeColor.primaryColor,
                      labelStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      unselectedLabelColor: ThemeColor.secondaryGeryColor,
                      indicatorWeight: 4,
                      // indicatorSize: TabBarIndicatorSize.label,
                      indicatorPadding: EdgeInsets.only(left: 80, right: 80),
                      indicatorColor: ThemeColor.primaryColor,
                      tabs: [
                        Tab(
                          text: '学习中',
                        ),
                        Tab(
                          text: '学习历史',
                        ),
                      ],
                    ),
                  ),
                  preferredSize: const Size.fromHeight(45.0)),
            ),
            body: Container(
              color: ThemeColor.colorFFF3F5F8,
              child: TabBarView(
                children: [
                  LearnListPage('LEARNING'),
                  LearnListPage('HISTORY'),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () {
          //跳转并关闭当前页面--回到首页
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            ModalRoute.withName('/'),
          );
          // Navigator.pushReplacement(context,
          //     new MaterialPageRoute(builder: (BuildContext context) {
          //   return HomePage();
          // }));
          return;
        });
  }
}
