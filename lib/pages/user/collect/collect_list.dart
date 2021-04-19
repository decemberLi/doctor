import 'package:doctor/pages/user/collect/model/collect_list_model.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../doctors/tab_indicator.dart';
import 'package:doctor/http/server.dart';
import 'package:doctor/http/dtp.dart';

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

    Widget timeLineCell(BuildContext context, dynamic data) {
      print("the cell is $data");
      return _DoctorTimeLineCell(data);
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
              tabs: _list
                  .map(
                    (e) => Row(
                      children: [
                        Text(e),
                      ],
                    ),
                  )
                  .toList(),
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
                  List<CollectResources> list = [];
                  try {
                    var data = await API.shared.server.favoriteList(pageNum);
                    list = data['records']
                        .map<CollectResources>(
                            (item) => CollectResources.fromJson(item))
                        .toList();
                  } catch (e) {
                    print(e);
                  }

                  return list;
                },
                itemBuilder: studyCell,
                emptyMsg: "暂无收藏",
              ),
              _SubCollectList<CollectTimeLineResources>(
                getData: (pageNum) async {
                  List<CollectTimeLineResources> list = [];
                  try {
                    var data = await API.shared.dtp.favoriteList(pageNum);
                    list = data['records']
                        .map<CollectTimeLineResources>(
                            (item) => CollectTimeLineResources.fromJson(item))
                        .toList();
                  } catch (e) {
                    print(e);
                  }
                  return list;
                },
                itemBuilder: timeLineCell,
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
  RefreshController _controller = RefreshController(initialRefresh: false);
  List<T> _list = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _loadingGetData();
    super.initState();
  }

  _loadingGetData() async {
    EasyLoading.show();
    _firstGetData();
    EasyLoading.dismiss();
  }

  _firstGetData() async {
    var array = await widget.getData(0);
    if (array.length >= widget.pageSize) {
      _controller.footerMode.value = LoadStatus.idle;
    } else {
      _controller.footerMode.value = LoadStatus.noMore;
    }

    setState(() {
      _list = array;
    });
  }

  void onRefresh() async {
    try {
      _list = await widget.getData(0);
    } catch (e) {}

    _controller.headerMode.value = RefreshStatus.completed;
    setState(() {

    });
  }

  void onLoading() async {
    try {
      int page = _list.length ~/ widget.pageSize;
      var array = await widget.getData(page);
      _list += array;
      if (array.length >= widget.pageSize) {
        _controller.footerMode.value = LoadStatus.idle;
      } else {
        _controller.footerMode.value = LoadStatus.noMore;
      }

      setState(() {});
    } catch (e) {
      _controller.footerMode.value = LoadStatus.failed;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                fontSize: 12,
                color: Colors.white,
              )),
        ));
  }

  Widget content() {
    var summaryShow = '资料中包含一个附件，请在详情中查看';
    if (data.info != null && data.info.summary != null) {
      summaryShow = data.info.summary;
    }

    var title = data.title ?? "资料";

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
                        title,
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
                Container(
                  height: 10,
                ),
                Row(
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
                            Image.network(
                              data.thumbnailUrl,
                              width: 90,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                Container(
                  height: 12,
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
                  child: typeDecoratedBox(data.resourceType)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 12),
      child: FlatButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            RouteManager.RESOURCE_DETAIL,
            arguments: {
              "resourceId": data.resourceId,
              "favoriteId": data.favoriteId,
            },
          );
        },
        child: Container(
          // height: 107,
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
    } else if (type == "ACADEMIC" || type == "OPEN_CLASS" || type == "VIDEO_ZONE") {
      rendColor = Color(0xff9577FA);
      name = "学术";
    }else{
      return Container();
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
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget content() {
    String name;
    Widget head;
    Color headColor = Color(0xFF62C1FF);
    // ACADEMIC-学术圈，GOSSIP-八卦圈
    if (data.postType != "GOSSIP") {
      name = data.postUserName ?? "匿名";
      headColor = Color(0xffB8D1E2);
      if (data.postUserHeader == null) {
        head = Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          child: Image.asset(
            "assets/images/doctorAva.png",
            width: 18,
            height: 18,
          ),
        );
      } else {
        head = ImageWidget(
          url: data.postUserHeader ?? "",
          width: 20,
          height: 20,
        );
      }
    } else {
      name = data.anonymityName ?? "Name";
      head = Text(
        name[0],
        style: TextStyle(
          fontSize: 12,
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
          padding: EdgeInsets.only(top: 20, left: 30, right: 28),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    child: head,
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: headColor,
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
              Container(
                height: 6,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    data.postTitle ?? "这是一条圈子",
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
              Container(
                height: 12,
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
          RouteManager.openDoctorsDetail(data.postId);
        },
        child: Container(
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
