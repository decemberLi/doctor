import 'package:doctor/pages/worktop/learn/learn_list/learn_list_view.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/widgets/new_text_icon.dart';
import 'package:flutter/material.dart';
import 'package:doctor/http/server.dart';
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

  int _currentTabIndex = 0;

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
            _currentTabIndex = _tabController.index;
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
                indicatorPadding: EdgeInsets.only(left: 80, right: 80),
                indicatorColor: ThemeColor.primaryColor,
                tabs: [
                  Tab(
                    // text: '学习中',
                    child: Stack(
                      overflow: Overflow.visible,
                      children: [
                        Text(
                          '学习中',
                        ),
                        if (_waitLearnCount > 0)
                          Positioned(
                            right: -30,
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
            LearnListPage('LEARNING',index: widget.index, onTaskTypeChange: getLearnCount),
            LearnListPage('HISTORY'),
          ],
        ),
      ),
    );
  }
}
