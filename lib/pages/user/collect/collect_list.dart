import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/user/collect/model/collect_list_model.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/theme/theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';
import '../../doctors/tab_indicator.dart';

/// 渲染列表
class CollectDetailList extends StatelessWidget {
  final _list = ["学术推广", "医生圈"];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    Widget studyCell(BuildContext context, dynamic data) {
      return _ClooectStudyCell(data);
    }

    var content = Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        title: Text("我的收藏"),
        elevation: 0,
      ),
      body: Container(
          child: Column(
        children: [
          Container(
            width: width,
            height: 40,
            child: TabBar(
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: _list.map((e) => Text(e)).toList(),
              indicator: LinearGradientTabIndicatorDecoration(
                  borderSide: BorderSide(width: 4.0, color: Colors.white),
                  insets: EdgeInsets.only(left: 7, right: 7)),
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ThemeColor.colorFF222222,
                  fontSize: 16),
              unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: ThemeColor.colorFF444444,
                  fontSize: 16),
            ),
          ),
          Container(
            height: 0.5,
            color: Color(0xffeeeeee),
          ),
          Expanded(
              child: Container(
            child: TabBarView(children: [
              _SubCollectList<CollectResources>(
                getData: (pageNum) async {
                  var data = await HttpManager("server").post(
                    "/favorite/list",
                    params: {
                      'ps': 10,
                      'pn': pageNum,
                    },
                    showLoading: false,
                  );
                  List<CollectResources> list = data['records']
                      .map<CollectResources>(
                          (item) => CollectResources.fromJson(item))
                      .toList();
                  return list;
                },
                itemBuilder: studyCell,
                emptyMsg: "暂无收藏",
              ),
              _SubCollectList<CollectTimeLineResources>(
                getData: (pageNum) async {
                  var data = await HttpManager("dtp").post(
                    "/favorite/list",
                    params: {
                      'ps': 10,
                      'pn': pageNum,
                    },
                    showLoading: false,
                  );
                  return data;
                },
                itemBuilder: (context, data) {
                  return _DoctorTimeLineCell(data);
                },
                emptyMsg: "暂无收藏",
              ),
            ]),
          ))
        ],
      )),
    );
    return DefaultTabController(length: _list.length, child: content);
  }
}

class _SubCollectList<T> extends StatefulWidget {
  final Widget Function(BuildContext, T) itemBuilder;
  final String emptyMsg;
  final Future<List<T>> Function(int) getData;
  final int pageSize;
  _SubCollectList({
    @required this.itemBuilder,
    this.emptyMsg = "还没有数据哦~",
    this.getData,
    this.pageSize = 10,
  });
  @override
  State<StatefulWidget> createState() {
    return _SubCollectState<T>();
  }
}

class _SubCollectState<T> extends State<_SubCollectList>
    with AutomaticKeepAliveClientMixin {
  RefreshController _controller = RefreshController(initialRefresh: true);
  List<T> _list = [];
  @override
  bool get wantKeepAlive => true;

  void onRefresh() async {
    try {
      int page = _list.length ~/ widget.pageSize;
      _list = await widget.getData(page);
    } catch (e) {}

    setState(() {});
    _controller.headerMode.value = RefreshStatus.completed;
  }

  void onLoading() async {}

  @override
  Widget build(BuildContext context) {
    Widget child = Center(
      child: ViewStateEmptyWidget(
        message: widget.emptyMsg,
      ),
    );
    if (_list.length > 0) {
      child = ListView.builder(
        itemCount: _list.length,
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        itemBuilder: (context, index) {
          var item = _list[index];
          return widget.itemBuilder(context, item);
        },
      );
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

class _ClooectStudyCell extends StatelessWidget {
  final CollectResources data;
  _ClooectStudyCell(this.data);
  Widget typeDecoratedBox(String type) {
    Color rendColor = ThemeColor.color72c140;
    if (type == 'VIDEO') {
      rendColor = ThemeColor.color5d9df7;
    } else if (type == 'QUESTIONNAIRE') {
      rendColor = ThemeColor.colorefaf41;
    }
    return DecoratedBox(
        decoration: BoxDecoration(color: rendColor),
        child: Padding(
          // 分别指定四个方向的补白
          padding: const EdgeInsets.fromLTRB(30, 1, 30, 1),
          child: Text(MAP_RESOURCE_TYPE[type],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white,
              )),
        ));
  }

  Widget content() {
    var summaryShow = '资料中包含一个附件，请在详情中查看';
    if (data.info != null && data.info.summary != null) {
      summaryShow = data.info.summary;
    }

    return Container(
        child: Stack(
      alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20, left: 30, right: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      data.title,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF222222),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        summaryShow,
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF444444),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Container(width: 10),
                    if (data.thumbnailUrl != null)
                      Container(
                        width: 90,
                        height: 50,
                        color: Colors.grey,
                        child: Stack(
                          alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
                          children: <Widget>[
                            Image.network(data.thumbnailUrl,
                                width: 90, height: 50, fit: BoxFit.cover),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: -52,
          top: -28,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Transform(
                //对齐方式
                alignment: Alignment.topRight,
                //设置扭转值
                transform: Matrix4.rotationZ(-0.9),
                //设置被旋转的容器
                child: typeDecoratedBox("ARTICLE")),
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 12),
      child: FlatButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamed(RouteManager.RESOURCE_DETAIL, arguments: {
            "resourceId": data.resourceId,
            "favoriteId": data.favoriteId,
          });
        },
        child: Container(
          height: 107,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: content(),
        ),
      ),
    );
  }
}

class _DoctorTimeLineCell extends StatelessWidget {
  final CollectTimeLineResources data;
  _DoctorTimeLineCell(this.data);
  Widget typeDecoratedBox(String type) {
    Color rendColor = ThemeColor.color72c140;
    String name = MAP_RESOURCE_TYPE[type];
    if (type == 'VIDEO') {
      rendColor = ThemeColor.color5d9df7;
    } else if (type == 'QUESTIONNAIRE') {
      rendColor = ThemeColor.colorefaf41;
    } else if (type == "GOSSIP") {
      rendColor = Color(0xffF67777);
      name = "八卦";
    } else if (type == "ACADEMIC") {
      rendColor = Color(0xff9577FA);
      name = "学术";
    }
    return DecoratedBox(
      decoration: BoxDecoration(color: rendColor),
      child: Padding(
        // 分别指定四个方向的补白
        padding: const EdgeInsets.fromLTRB(30, 1, 30, 1),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget content() {
    String name;
    Widget head;
    //FF62C1FF
    //ACADEMIC-学术圈，GOSSIP-八卦圈
    if (data.postType == "ACADEMIC") {
      name = data.postUserName;
      head = ImageWidget(url: data.postUserHeader);
    } else {
      name = data.anonymityName;
      head = Text(
        data.anonymityName,
        style: TextStyle(
          fontSize: 8,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    return Container(
        child: Stack(
      alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20, left: 30, right: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    child: head,
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  Container(
                    width: 5,
                  ),
                  Expanded(
                      child: Text(
                    name,
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF222222),
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      data.postTitle,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF444444),
                        fontWeight: FontWeight.normal,
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: -52,
          top: -28,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Transform(
              //对齐方式
              alignment: Alignment.topRight,
              //设置扭转值
              transform: Matrix4.rotationZ(-0.9),
              //设置被旋转的容器
              child: typeDecoratedBox(data.postType),
            ),
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 12),
      child: FlatButton(
        onPressed: () {
          if (data.postStatus == "SHELVES") {
          } else if (data.postStatus == "DOWN_SHELVES") {
            Toast.show("帖子已被删除", context);
          } else {
            Toast.show("未知错误", context);
          }
        },
        child: Container(
          height: 107,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: content(),
        ),
      ),
    );
  }
}
