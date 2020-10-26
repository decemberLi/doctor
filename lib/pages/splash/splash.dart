import 'dart:ui';
import 'package:doctor/route/route_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class GuidePage extends StatefulWidget {
  static const List<String> images = <String>[
    'android1.png',
    'android2.png',
    'android3.png',
    'android4.png',
  ];

  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  int curIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Stack(
        alignment: Alignment(0, 0.87),
        children: <Widget>[
          Swiper(
              itemBuilder: (ctx, index) => Image.asset(
                  'assets/images/${GuidePage.images[index]}',
                  fit: BoxFit.cover),
              itemCount: GuidePage.images.length,
              loop: false,
              onIndexChanged: (index) {
                setState(() {
                  curIndex = index;
                });
              }),
          Offstage(
            offstage: curIndex != GuidePage.images.length - 1,
            child: CupertinoButton(
              color: Theme.of(context).primaryColor,
              child: Text('点我开始'),
              onPressed: () {
                // 跳转登陆页
                Navigator.of(context).pushReplacementNamed(RouteManager.LOGIN);
              },
            ),
          )
        ],
      ),
    ));
  }
}
