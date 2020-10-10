import 'package:doctor/pages/worktop/learn/learn_list/learn_list_item_wiget.dart';
import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:doctor/pages/worktop/learn/view_model/learn_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<LearnListViewModel>(
      model: LearnListViewModel(widget.learnStatus),
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
          child: ListView.builder(
              itemCount: model.list.length,
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                LearnListItem item = model.list[index];
                return LearnListItemWiget(item);
              }),
        );
      },
    );
  }
}
