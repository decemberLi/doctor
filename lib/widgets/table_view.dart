import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NormalTableViewController {
  _SubCollectState _inState;

  void refresh() {
    _inState._scrollController.jumpTo(0);
    _inState._controller.requestRefresh();
  }
}

int _defaultPageSize(page) => 10;
class NormalTableView<T> extends StatefulWidget {
  final Widget Function(BuildContext, T) itemBuilder; // 返回列表中每行Item
  final Widget Function(bool, String) holder; // 空页面或者错误占位页面
  final EdgeInsets padding;
  final Future<List<T>> Function(int) getData; // 获取数据（接口函数）
  final int Function(int) pageSize; // 每页数据个数，默认10个
  final Widget Function(BuildContext) header;
  final void Function(BuildContext context, double offset) onScroll;
  final NormalTableViewController controller;

  NormalTableView(
      {@required this.itemBuilder,
      this.holder,
      this.header,
      this.getData,
      this.pageSize = _defaultPageSize,
      this.padding = EdgeInsets.zero,
      this.onScroll,
      this.controller});

  @override
  State<StatefulWidget> createState() {
    return _SubCollectState<T>();
  }
}

class _SubCollectState<T> extends State<NormalTableView>
    with AutomaticKeepAliveClientMixin {
  RefreshController _controller = RefreshController(initialRefresh: false);
  ScrollController _scrollController = ScrollController();
  String _error;
  List<T> _list = [];
  bool _firstLoading = true;
  int _page = 1;


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _loadingGetData();
    if (widget.controller != null) {
      widget.controller._inState = this;
    }
    _scrollController.addListener(() {
      if (widget.onScroll != null) {
        widget.onScroll(context, _scrollController.offset);
      }
    });
    super.initState();
  }

  @override
  dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  //第一次获取数据的时候，显示加载loading
  _loadingGetData() async {
    try {
      _firstLoading = true;
      await _firstGetData();
    } on DioError catch (e) {
      setState(() {
        if (e.error is SocketException) {
          _error = "网络错误，请点击重试";
        } else {
          _error = e.message;
        }
      });
    } catch (e) {
      _error = "$e";
    } finally {
      EasyLoading.dismiss();
      setState(() {
        _firstLoading = false;
      });
    }
  }

  _firstGetData() async {
    _page = 1;
    var array = await widget.getData(1);
    if (!(array is List)) {
      setState(() {
        _error = "数据为空";
      });
      return;
    }
    if (array.length >= widget.pageSize(1)) {
      _controller.footerMode.value = LoadStatus.idle;
    } else {
      _controller.footerMode.value = LoadStatus.noMore;
    }
    setState(() {
      _error = null;
      _list = array;
    });
  }

  //下来获取数据
  void onRefresh() async {
    try {
      await _firstGetData();
      _controller.headerMode.value = RefreshStatus.completed;
    } catch (e) {
      _controller.headerMode.value = RefreshStatus.failed;
    }
  }

  //加载更多
  void onLoading() async {
    try {
      var array = await widget.getData(_page+1);
      _list += array;
      if (array.length >= widget.pageSize(_page+1)) {
        _controller.footerMode.value = LoadStatus.idle;
      } else {
        _controller.footerMode.value = LoadStatus.noMore;
      }
      _page ++;
      setState(() {});
    } catch (e) {
      _controller.footerMode.value = LoadStatus.failed;
    }
  }

  Widget _showHolder() {
    if (_firstLoading) {
      return Container();
    }
    var child = widget.holder is Function
        ? widget.holder(_error != null, _error)
        : ViewStateEmptyWidget(
            message: _error != null ? "$_error" : "没有数据",
          );

    return Center(
      child: FlatButton(
        child: child,
        onPressed: () {
          _loadingGetData();
        },
      ),
    );
  }

  Widget loading(){
    return Container(
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child:Theme(
            data: ThemeData(
                cupertinoOverrideTheme: CupertinoThemeData(
                  brightness: Brightness.dark,
                )
            ),
            child: CupertinoActivityIndicator(
              radius: 14,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget child = _showHolder();
    if(_firstLoading){
      return loading();
    }else if (_list.length > 0) {
      child = CustomScrollView(
        controller: _scrollController,
        slivers: [
          if (widget.header != null)
            SliverToBoxAdapter(
              child: widget.header(context),
            ),
          SliverPadding(
            padding: widget.padding,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return widget.itemBuilder(context, _list[index]);
                },
                childCount: _list.length,
              ),
            ),
          )
        ],
      );
    } else if (_error != null) {
      return child;
    }
    return SmartRefresher(
      controller: _controller,
      header: ClassicHeader(),
      footer: ClassicFooter(),
      onRefresh: onRefresh,
      onLoading: onLoading,
      enablePullUp: true,
      child: child,
    );
  }
}
