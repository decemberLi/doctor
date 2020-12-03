import 'package:doctor/provider/view_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/theme/theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../doctors/tab_indicator.dart';

/// 渲染列表
class CollectDetailList extends StatelessWidget {
  final _list = ["学术推广","医生圈"];
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    var content = Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        title: Text("我的收藏"),
        elevation: 0,
      ),
      body: Container(
        child:Column(
          children: [
            Container(
              width: width,
              height: 40,
              child: TabBar(
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: _list.map((e) => Text(e)).toList(),
                indicator: LinearGradientTabIndicatorDecoration(
                  borderSide:BorderSide(width: 4.0, color: Colors.white),
                  insets: EdgeInsets.only(left:7,right:7)),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:ThemeColor.colorFF222222,
                  fontSize: 16
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: ThemeColor.colorFF444444,
                  fontSize: 16
                ),
              ),
            ),
            Container(
              height: 0.5,
              color: Color(0xffeeeeee),
            ),
            Expanded(child: 
              Container(
                child:TabBarView(
                  children: [
                    _SubCollectList(),
                    _SubCollectList(),
                  ]
                ),
              )
            )
          ],
        )
      ),
    );
    return DefaultTabController(
      length: _list.length, 
      child: content
    );
  }
}

class _SubCollectList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SubCollectState();
  }

}

class _SubCollectState extends State<_SubCollectList> {
  RefreshController _controller = RefreshController();
  List<int> _list = [1,2,3];
  void onRefresh(){
    Future.delayed(Duration(seconds: 2)).then((value) {
      _controller.headerMode.value = RefreshStatus.completed;
    });
  }
  void onLoading(){

  }
  @override
  Widget build(BuildContext context) {
    Widget child = Center(
      child: ViewStateEmptyWidget(message: "暂无收藏",),
    );
    if (_list.length > 0) {
      child = ListView.builder(
        itemCount: _list.length,
        padding: EdgeInsets.only(left: 16,right: 16,top: 16),
        itemBuilder: (context, index) {
          var item = _list[index];
          return _DoctorTimeLineCell(item);
          return _ClooectStudyCell(item);
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
  final data;
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

  Widget content(){
    return Container(
              child: Stack(
                alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top:20,left: 30,right: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "hell0asldkjflskjdflsjdflsjlsllslakskskskskskkskaaa",
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF222222),
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ),
                          ],
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "ssssssssssssssssssssaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaffffffffffffffffffffffffffffffffffffffssssssssssddddddda",
                                  softWrap: true,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF444444),
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ),
                              Container(width:10),
                              if (true) 
                                Container(
                                        width: 90,
                                        height: 50,
                                        color: Colors.grey,
                                          child: Stack(
                                              alignment: Alignment
                                                  .center, //指定未定位或部分定位widget的对齐方式
                                              children: <Widget>[
                                                Image.network("item.thumbnailUrl",
                                                    width: 90,
                                                    height: 50,
                                                    fit: BoxFit.cover),
                                              ])),
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
              )
            );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom:12),
      child: Container(
        height:107,
        decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
        child: content(),
      ),
    );
  }
}


class _DoctorTimeLineCell extends StatelessWidget {
  final data;
  _DoctorTimeLineCell(this.data);
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

  Widget content(){
    return Container(
              child: Stack(
                alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top:20,left: 30,right: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            Container(width: 5,),
                            Expanded(
                              child: Text(
                                "hell0asldkjflskjdflsjdflsjlsllslakskskskskskkskaaa",
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF222222),
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ),
                          ],
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "ssssssssssssssssssssaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaffffffffffffffffffffffffffffffffffffffssssssssssddddddda",
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF444444),
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
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
              )
            );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom:12),
      child: Container(
        height:107,
        decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
        child: content(),
      ),
    );
  }
}