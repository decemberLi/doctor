import 'package:doctor/pages/worktop/learn/learn_list/learn_list_item_wiget.dart';
import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:doctor/pages/worktop/learn/view_model/learn_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 学习计划列表
class LearnListPage extends StatefulWidget {
  final String learnStatus;

  final ValueChanged<List> onTaskTypeChange;
  final int index;

  LearnListPage(this.learnStatus, {int index = 0, this.onTaskTypeChange})
      : this.index = index;

  @override
  _LearnListPageState createState() => _LearnListPageState();
}

class _LearnListPageState extends State<LearnListPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  // 保持不被销毁
  @override
  bool get wantKeepAlive => true;

  TabController _tabController;

  int _currentTabIndex = 0;

  // 列表model
  List<LearnListViewModel> _listModels;

  @override
  void initState() {
    super.initState();
    _listModels = TASK_TYPE_MAP
        .map(
          (e) => LearnListViewModel(widget.learnStatus, e['taskTemplate']),
        )
        .toList();
    _currentTabIndex = widget.index;

    _listModels[_currentTabIndex].initData();

    // 添加监听器
    _tabController = TabController(
      vsync: this,
      initialIndex: widget.index,
      length: TASK_TYPE_MAP.length,
    )..addListener(() {
        // 避免触发两次
        if (_tabController.index.toDouble() == _tabController.animation.value) {
          setState(() {
            _currentTabIndex = _tabController.index;
            _listModels[_currentTabIndex].initData();
            if (widget.onTaskTypeChange != null) {
              widget.onTaskTypeChange(
                  TASK_TYPE_MAP[_currentTabIndex]['taskTemplate']);
            }
          });
        }
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _listModels.forEach((model) {
      model.dispose();
    });
    super.dispose();
  }

  Widget _renderTop(String text, int index) {
    Color color = Color(0xFFDEDEE1);
    if (index == _currentTabIndex) {
      color = ThemeColor.primaryColor;
    }
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(34)),
      ),
      padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
      margin: EdgeInsets.only(
        right: 10,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _renderList(
      BuildContext context, LearnListViewModel model, Widget child) {
    if (model.isError || model.isEmpty) {
      return ViewStateEmptyWidget(onPressed: model.initData);
    }
    return SmartRefresher(
      controller: model.refreshController,
      header: ClassicHeader(),
      footer: ClassicFooter(),
      onRefresh: model.refresh,
      onLoading: model.loadMore,
      enablePullUp: true,
      child: ListView.builder(
        itemCount: model.list.length,
        itemBuilder: (context, index) {
          LearnListItem item = model.list[index];
          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).pushNamed(
                RouteManager.LEARN_DETAIL,
                arguments: {
                  'learnPlanId': item.learnPlanId,
                  'listStatus': widget.learnStatus,
                },
              );
              // 从详情页回来后刷新数据
              if (widget.learnStatus == 'LEARNING') {
                model.refreshController.requestRefresh(needMove: false);
              }
            },
            child: LearnListItemWiget(item, widget.learnStatus),
          );
        },
      ),
    );
  }

  // Widget _renderList(taskTemplate) {
  //   return ProviderWidget<LearnListViewModel>(
  //     model: LearnListViewModel(widget.learnStatus, taskTemplate),
  //     onModelReady: (model) => model.initData(),
  //     // autoDispose: false,
  //     builder: ,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: ThemeColor.colorFFF3F5F8,
        title: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 8),
          child: Theme(
              data: ThemeData(
                ///默认显示的背景颜色
                backgroundColor: ThemeColor.colorFFF3F5F8,

                ///点击的背景高亮颜色
                highlightColor: ThemeColor.colorFFF3F5F8,

                ///点击水波纹颜色
                splashColor: Color.fromRGBO(0, 0, 0, 0),
              ),
              child: new TabBar(
                physics: NeverScrollableScrollPhysics(),
                controller: this._tabController,
                isScrollable: true,
                labelPadding: EdgeInsets.symmetric(horizontal: 8),
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(style: BorderStyle.none)),
                tabs: TASK_TYPE_MAP
                    .map(
                      (e) => Tab(
                        child: _renderTop(e['text'], TASK_TYPE_MAP.indexOf(e)),
                      ),
                    )
                    .toList(),
              )),
        ),
      ),
      body: Container(
          child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: this._tabController,
        children: _listModels != null
            ? _listModels
                .map(
                  (model) => Container(
                    // child: _renderList(e['taskTemplate']),
                    child: ChangeNotifierProvider<LearnListViewModel>.value(
                      value: model,
                      child: Consumer<LearnListViewModel>(
                        builder: this._renderList,
                      ),
                    ),
                  ),
                )
                .toList()
            : [],
      )),
    );
  }
}
