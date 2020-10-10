import 'package:doctor/pages/worktop/learn/learn_list/learn_list_view.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/constants.dart';
import 'package:flutter/material.dart';

class WorktopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
                  unselectedLabelColor: ThemeColor.colorFF888888,
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
    );
  }
}
