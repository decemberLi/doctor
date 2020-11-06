import 'dart:ui';
import 'package:doctor/http/session_manager.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/utils/adapt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class GuidePage extends StatefulWidget {
  static const List<String> images = <String>[
    'android1.jpg',
    'android2.jpg',
    'android3.jpg',
    'android4.jpg',
  ];

  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  int curIndex = 0;
  double _height = Adapt.screenH();
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
              pagination: new SwiperPagination(
                  margin: EdgeInsets.only(bottom: _height * 0.02)),
              onIndexChanged: (index) {
                setState(() {
                  curIndex = index;
                });
              }),
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
                  String session = SessionManager().getSession();
                  String nextRoute = RouteManager.HOME;
                  if (session == null) {
                    nextRoute = RouteManager.LOGIN_CAPTCHA;
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
