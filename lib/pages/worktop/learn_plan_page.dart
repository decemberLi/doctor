import 'package:doctor/http/server.dart';
import 'package:doctor/pages/activity/activity_list_page.dart';
import 'package:doctor/pages/doctors/tab_indicator.dart';
import 'package:doctor/pages/worktop/learn/learn_list/learn_list_view.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/widgets/new_text_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_manager/manager.dart';

class LearnPlanPage extends StatefulWidget {
  final int index;

  LearnPlanPage({int index = 0}) : this.index = index;

  @override
  _LearnPlanPageState createState() => _LearnPlanPageState();
}

class _LearnPlanPageState extends State<LearnPlanPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  int _waitLearnCount = 0;

  @override
  void initState() {
    super.initState();
    // 添加监听器
    _tabController = TabController(vsync: this, length: 2)
      ..addListener(() {
        // 避免触发两次
        if (_tabController.index.toDouble() == _tabController.animation.value) {
          setState(() {
            // _currentTabIndex = _tabController.index;
          });
        }
      });
    getLearnCount(TASK_TYPE_MAP[widget.index]['taskTemplate']);
  }

  void getLearnCount(List taskTemplate) async {
    var res = await API.shared.server.getPlanCount({
      'taskTemplate': taskTemplate,
    });
    setState(() {
      _waitLearnCount = res['waitLearnCount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(APP_NAME),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ActivityListPage()));
            },
            child: Container(
              height: 20,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 6, right: 6,bottom: 1),
              decoration: BoxDecoration(
                  color: ThemeColor.color5d9df7,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '活动入口',
                        textAlign: TextAlign.center,
                        softWrap: false,
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
        elevation: 1,
        bottom: PreferredSize(
            child: Container(
              color: ThemeColor.colorFFF3F5F8,
              child: TabBar(
                controller: this._tabController,
                labelColor: ThemeColor.primaryColor,
                labelStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                unselectedLabelColor: ThemeColor.secondaryGeryColor,
                indicatorWeight: 4,
                // indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: ThemeColor.primaryColor,
                indicator: LinearGradientTabIndicatorDecoration(
                    borderSide: BorderSide(
                      width: 6,
                      color: ThemeColor.primaryColor,
                    ),
                    insets: EdgeInsets.only(left: 74, right: 74),
                    gradient: const LinearGradient(
                      colors: [
                        ThemeColor.primaryColor,
                        ThemeColor.primaryColor
                      ],
                    ),
                    isRound: true),
                tabs: [
                  Tab(
                    // text: '学习中',
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Text(
                          '学习中',
                        ),
                        if (_waitLearnCount > 0)
                          Positioned(
                            right: redDotPosition(),
                            top: -8,
                            child: LearnTextIcon(
                              text: '$_waitLearnCount',
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
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
          controller: this._tabController,
          children: [
            LearnListPage('LEARNING',
                index: widget.index, onTaskTypeChange: getLearnCount),
            LearnListPage('HISTORY'),
          ],
        ),
      ),
    );
  }

  double redDotPosition() {
    if (_waitLearnCount > 9999) {
      return -56;
    } else if (_waitLearnCount > 999) {
      return -50;
    } else if (_waitLearnCount > 99) {
      return -42;
    } else if (_waitLearnCount > 9) {
      return -35;
    } else {
      return -30;
    }
  }
}
