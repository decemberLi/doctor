import 'package:doctor/provider/refreshable_view_state_model.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class AbstractListPageState<M extends RefreshableViewStateModel,
        T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  M _model;
  ScrollController _controller;

  get model => _model;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var height = MediaQuery.of(context).size.height;
    _controller.addListener(() {
      scrollOutOfScreen(_controller.offset > height);
      scrollOffset(_controller.offset);
    });
    return ChangeNotifierProvider<M>.value(
      value: _model,
      child: Consumer<M>(
        builder: (context, value, child) {
          return Container(
            color: ThemeColor.colorFFF3F5F8,
            child: SmartRefresher(
              controller: _model.refreshController,
              enablePullUp: !_model.isError,
              header: ClassicHeader(),
              footer: ClassicFooter(
                noDataText: noMoreDataText(),
              ),
              onRefresh: _model.refresh,
              onLoading: _model.loadMore,
              child: body(),
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
      padding: EdgeInsets.only(top: 12),
      itemBuilder: (context, index) {
        var model = _model.list[index];
        return GestureDetector(
          child: Column(
            children: [
              itemWidget(context, index, _model.list[index]),
              if (index != _model.size) divider(context, index)
            ],
          ),
          onTap: () {
            onItemClicked(_model, model);
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return divider(context, index);
      },
    );
  }

  bodyHeader() => Container();

  body() {
    return CustomScrollView(
      controller: _controller,
      slivers: [
        SliverToBoxAdapter(
          child: bodyHeader(),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            var model = _model.list[index];
            return GestureDetector(
              child: Column(
                children: [
                  itemWidget(context, index, _model.list[index]),
                  divider(context, index)
                ],
              ),
              onTap: () {
                onItemClicked(_model, model);
              },
            );
            // return Container(
            //   height: 65,
            //   color: Colors.primaries[index % Colors.primaries.length],
            // );
          }, childCount: _model.size),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _model = getModel();
    _model.refresh(init: false);
  }

  @override
  void dispose() {
    super.dispose();
    _model.dispose();
  }

  Widget emptyWidget(String msg) =>
      Center(child: ViewStateEmptyWidget(message: msg ?? ''));

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

  void onItemClicked(M model, itemData) {}

  String noMoreDataText() => null;

  void scrollOffset(double offset) {}
}
