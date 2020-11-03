import 'package:doctor/main.dart';
import 'package:doctor/pages/user/collect/view_model/collect_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/theme/theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'collect_detail_item.dart';
import 'model/collect_list_model.dart';

/// 渲染列表
class CollectDetailList extends StatefulWidget {
  @override
  _CollectDetailListState createState() => _CollectDetailListState();
}

class _CollectDetailListState extends State<CollectDetailList> with RouteAware {
  CollectListViewModel _model = CollectListViewModel();
  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)); //订阅
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _model.refresh();
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        title: Text('我的收藏'),
        elevation: 0,
      ),
      body: ProviderWidget<CollectListViewModel>(
        model: _model,
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
                CollectResources item = model.list[index];
                return CollectDetailItem(item);
              },
            ),
          );
        },
      ),
    );
  }
}
