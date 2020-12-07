import 'package:doctor/provider/refreshable_view_state_model.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class AbstractListPageState<M extends RefreshableViewStateModel,
    T extends StatefulWidget> extends State<T> {
  RefreshableViewStateModel _model;
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    _controller.addListener(() {
      scrollOutOfScreen(_controller.offset > height);
    });
    return ChangeNotifierProvider<M>.value(
      value: _model,
      child: Consumer<M>(
        builder: (context, value, child) {
          return Container(
            color: ThemeColor.colorFFF3F5F8,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SmartRefresher(
              controller: _model.refreshController,
              enablePullUp: !_model.isError,
              header: ClassicHeader(),
              footer: ClassicFooter(),
              onRefresh: _model.refresh,
              onLoading: _model.loadMore,
              child: bodyWidget(),
            ),
          );
        },
      ),
    );
  }

  bodyWidget() {
    if (_model.isError || _model.list == null || _model.list.length == 0) {
      return emptyWidget(null);
    }
    return ListView.separated(
      controller: _controller,
      itemCount: _model.size,
      itemBuilder: (context, index) {
        return itemWidget(context, index, _model.list[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return divider(context, index);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _model = getModel();
  }

  @override
  void dispose() {
    super.dispose();
    _model.dispose();
  }

  Widget emptyWidget(String msg) => Center(
        child: ViewStateEmptyWidget(
          message: msg ?? '',
        ),
      );

  M getModel();

  Widget itemWidget(BuildContext context, int index, dynamic data);

  Widget divider(BuildContext context, int index) => Divider(
        color: ThemeColor.colorFFF3F5F8,
        height: 12,
      );

  void scrollOutOfScreen(bool outScreen) {
    // Do nothing
  }

  void scrollToTop() {
    if (_controller != null) {
      // _controller.animateTo(_model, duration: null, curve: null)
    }
  }

  void requestRefresh() {
    _model.refreshController
        .requestRefresh(duration: Duration(milliseconds: 100));
  }
}
