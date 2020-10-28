import 'package:doctor/pages/worktop/learn/learn_list/learn_list_item_wiget.dart';
import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:doctor/pages/worktop/learn/view_model/learn_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 学习计划列表
class LearnListPage extends StatefulWidget {
  final String learnStatus;

  LearnListPage(this.learnStatus);
  @override
  _LearnListPageState createState() => _LearnListPageState();
}

class _LearnListPageState extends State<LearnListPage>
    with AutomaticKeepAliveClientMixin {
  // 保持不被销毁
  @override
  bool get wantKeepAlive => true;
  String _isType = '';
  List taskTemplate = [];

  // ignore: non_constant_identifier_names
  Widget _renderTopType(String name, String type) {
    Color rendColor = Color(0xFFDEDEE1);
    if (type == _isType) {
      rendColor = ThemeColor.primaryColor;
    }

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: rendColor,
          borderRadius: BorderRadius.all(Radius.circular(34)),
          boxShadow: [
            BoxShadow(color: rendColor, offset: Offset(0, 2.0), blurRadius: 4.0)
          ],
        ),
        padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
        margin: EdgeInsets.only(
          right: 10,
        ),
        child: Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
      onTap: () {
        print('111=>${type}');
        List _taskTemplate = [];
        if (type == 'SALON') {
          _taskTemplate = ['SALON', 'DEPART'];
        }
        if (type == 'VISIT') {
          _taskTemplate = ['VISIT', 'DOCTOR_LECTURE'];
        }
        if (type == 'SURVEY') {
          _taskTemplate = ['SURVEY'];
        }
        setState(() {
          _isType = type;
          taskTemplate = _taskTemplate;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<LearnListViewModel>(
      model: LearnListViewModel(widget.learnStatus, taskTemplate),
      onModelReady: (model) => model.initData(),
      builder: (context, model, child) {
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
          child: CustomScrollView(slivers: <Widget>[
            //AppBar，包含一个导航栏

            SliverToBoxAdapter(
                child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _renderTopType('全部', ''),
                          _renderTopType('会议', 'SALON'),
                          _renderTopType('拜访', 'VISIT'),
                          _renderTopType('调研', 'SURVEY'),
                        ]))),
            SliverList(
              // Use a delegate to build items as they're scrolled on screen.
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  LearnListItem item = model.list[index];
                  return LearnListItemWiget(item, widget.learnStatus);
                },
                childCount: model.list.length,
              ),
            )
          ]),

          //  ListView.builder(
          //       itemCount: model.list.length,
          //       padding: EdgeInsets.all(16),
          //       itemBuilder: (context, index) {
          //         LearnListItem item = model.list[index];
          //         return LearnListItemWiget(item, widget.learnStatus);
          //       }),
        );
      },
    );
  }
}
