import 'package:doctor/pages/worktop/learn/learn_list/learn_list_item_wiget.dart';
import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:doctor/pages/worktop/learn/view_model/learn_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/root_widget.dart';
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

  int _currentTabIndex = 0;

  LearnListViewModel model;

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.index;
    model = LearnListViewModel(
      widget.learnStatus,
      TASK_TYPE_MAP[_currentTabIndex]['taskTemplate'],
    );
    model.initData();
    eventBus.on().listen((event) {
      if (event == "studyHistoryRefresh" && widget.learnStatus == "HISTORY"){
        model.refresh();
      }
    });
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  Widget _renderTop(String text, int index) {
    Color color = Color(0xFFDEDEE1);
    if (index == _currentTabIndex) {
      color = ThemeColor.primaryColor;
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
          model.taskTemplate = TASK_TYPE_MAP[_currentTabIndex]['taskTemplate'];
          model.initData();
          if (widget.onTaskTypeChange != null) {
            widget.onTaskTypeChange(
                TASK_TYPE_MAP[_currentTabIndex]['taskTemplate']);
          }
          model?.refreshController?.position?.animateTo(0.0,
              duration: Duration(milliseconds: 16), curve: Curves.linear);
        });
      },
      child: Container(
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
              model.taskTemplate = TASK_TYPE_MAP[_currentTabIndex]['taskTemplate'];
              model.initData();
              if (widget.onTaskTypeChange != null) {
                widget.onTaskTypeChange(
                    TASK_TYPE_MAP[_currentTabIndex]['taskTemplate']);
              }
            },
            child: LearnListItemWiget(item, widget.learnStatus,(){
              model.removeItem(item);
              eventBus.fire("studyHistoryRefresh");
            }),
          );
        },
      ),
    );
  }

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
          padding: EdgeInsets.only(left: 20),
          child: Theme(
            data: ThemeData(
              ///默认显示的背景颜色
              backgroundColor: ThemeColor.colorFFF3F5F8,

              ///点击的背景高亮颜色
              highlightColor: ThemeColor.colorFFF3F5F8,

              ///点击水波纹颜色
              splashColor: Color.fromRGBO(0, 0, 0, 0),
            ),
            child: Row(
              children: TASK_TYPE_MAP
                  .map(
                    (e) => _renderTop(
                      e['text'],
                      TASK_TYPE_MAP.indexOf(e),
                    ),
                  )
                  .toList(),
            ),
            // child: new TabBar(
            //   physics: NeverScrollableScrollPhysics(),
            //   controller: this._tabController,
            //   isScrollable: true,
            //   labelPadding: EdgeInsets.symmetric(horizontal: 8),
            //   indicator: UnderlineTabIndicator(
            //       borderSide: BorderSide(style: BorderStyle.none)),
            //   tabs: TASK_TYPE_MAP
            //       .map(
            //         (e) => Tab(
            //           child: _renderTop(e['text'], TASK_TYPE_MAP.indexOf(e)),
            //         ),
            //       )
            //       .toList(),
            // ),
          ),
        ),
      ),
      body: Container(
        child: ChangeNotifierProvider<LearnListViewModel>.value(
          value: model,
          child: Consumer<LearnListViewModel>(
            builder: this._renderList,
          ),
        ),
      ),
    );
  }
}
