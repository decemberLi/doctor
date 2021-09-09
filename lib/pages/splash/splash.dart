import 'dart:ui';

import 'package:doctor/route/route_manager.dart';
import 'package:doctor/utils/adapt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http_manager/manager.dart';

class GuidePage extends StatefulWidget {
  static const List<String> images = <String>[
    'guidance1.png',
    'guidance2.png',
  ];

  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  int curIndex = 0;
  double _height = Adapt.screenH();
  PageController _controller = PageController();
  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        curIndex = _controller.page.floor();
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Stack(
        alignment: Alignment(0, 0.87),
        children: <Widget>[
          PageView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, index) => Image.asset(
              'assets/images/${GuidePage.images[index]}',
              fit: BoxFit.cover,
            ),
            itemCount: GuidePage.images.length,
            controller: _controller,
          ),
          Positioned(child: Indicator(
            controller: _controller,
            itemCount: GuidePage.images.length,
          )),
          Offstage(
            offstage: curIndex != GuidePage.images.length - 1,
            child: Container(
              margin: EdgeInsets.only(bottom: _height * 0.1),
              child: RaisedButton(
                padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50 / 2),
                  ),
                ),
                color: Color(0xFF41A4F8),
                child: Text(
                  '立即体验',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  String session = SessionManager.shared.session;
                  String nextRoute = RouteManagerOld.HOME;
                  if (session == null) {
                    nextRoute = RouteManagerOld.LOGIN_CAPTCHA;
                  }
                  // 跳转
                  Navigator.of(context).pushReplacementNamed(nextRoute);
                },
              ),
            ),
          )
        ],
      ),
    ));
  }
}

class Indicator extends StatelessWidget {
  Indicator({
    this.controller,
    this.itemCount: 0,
  }) : assert(controller != null);

  /// PageView的控制器
  final PageController controller;

  /// 指示器的个数
  final int itemCount;

  /// 普通的颜色
  final Color normalColor = Colors.white;

  /// 选中的颜色
  final Color selectedColor = Colors.blue;

  /// 点的大小
  final double size = 8.0;

  /// 点的间距
  final double spacing = 4.0;

  /// 点的Widget
  Widget _buildIndicator(
      int index, int pageCount, double dotSize, double spacing) {
    // 是否是当前页面被选中
    bool isCurrentPageSelected = index ==
        (controller.page != null ? controller.page.round() % pageCount : 0);

    return new Container(
      height: size,
      width: size + (2 * spacing),
      child: new Center(
        child: new Material(
          color: isCurrentPageSelected ? selectedColor : normalColor,
          type: MaterialType.circle,
          child: new Container(
            width: dotSize,
            height: dotSize,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, (int index) {
        return _buildIndicator(index, itemCount, size, spacing);
      }),
    );
  }
}
