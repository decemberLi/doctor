import 'dart:async';

import 'package:flutter/material.dart';

class DoctorsBanner extends StatefulWidget {
  final Stream<List> dataStream;
  final Function(BuildContext, dynamic, int) itemBuilder;
  final double height;
  final Widget Function(BuildContext) holder;
  final List data;

  DoctorsBanner(this.itemBuilder, {this.dataStream, this.height = 237,this.holder,this.data});

  @override
  State<StatefulWidget> createState() {
    return _DoctorsBannerState();
  }
}

class _DoctorsBannerState extends State<DoctorsBanner> {
  List realList = [];
  int _currentIndex = 0;
  PageController _pageController = PageController(initialPage: 1);
  Timer _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        if (_pageController.page == realList.length - 1) {
          _pageController.jumpToPage(1);
          _currentIndex = 0;
        } else if (_pageController.page == 0) {
          _pageController.jumpToPage(realList.length-2);
          _currentIndex = realList.length-3;
        } else {
          var page = _pageController.page.round() - 1;
          if (page > realList.length - 2 - 1) {
            page = 0;
          } else if (page <= -1) {
            page = realList.length - 2 - 1;
          }
          // page = min(page, );
          // page = max(0, page);
          _currentIndex = page;
        }
      });
    });
    if (widget.dataStream != null) {
      widget.dataStream.listen((event) {
        print("the event is ---$event");
        initDatas(event);
      });
    }else{
      initDatas(widget.data);
    }


    super.initState();
  }

  void initDatas(List dataList){
    realList.clear();
    if (dataList is List) {
      realList.addAll(dataList);
    }

    print("the data is --- $dataList");
    if (realList.length > 1) {
      setState(() {
        realList.insert(0, dataList[dataList.length - 1]);
        realList.add(dataList[0]);
        _currentIndex = 0;
      });
      _startTimer();
      Future.delayed(Duration(milliseconds: 300),(){
        _pageController.jumpToPage(1);
      });

    } else {
      _currentIndex = 0;
      _timer?.cancel();
    }
  }

  _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      Duration(seconds: 10),
      (timer) {
        _pageController.animateToPage(
          _pageController.page.round() + 1,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      },
    );
  }

  Widget _scrollNoti(Widget child) {
    return NotificationListener(
      onNotification: (notification) {
        if (realList.length <= 1) {
          return true;
        }
        if (notification.depth == 0 &&
            notification is ScrollStartNotification) {
          if (notification.dragDetails != null) {
            _timer?.cancel();
            _timer = null;
          }else{

          }
        } else if (notification is ScrollEndNotification) {
          if(_timer == null){
            _startTimer();
          }
        }
        return true;
      },
      child: child,
    );
  }

  Widget point() {
    var sub = realList.sublist(1,realList.length - 1);
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 6,
        margin: EdgeInsets.only(bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: sub
              .asMap()
              .map(
                (key, value) => MapEntry(
                  key,
                  Container(
                    width: 6,
                    height: 6,
                    margin: EdgeInsets.only(left: 2, right: 2),
                    decoration: ShapeDecoration(
                      color: _currentIndex == key
                          ? Color(0xff0077FF)
                          : Colors.white,
                      shape: CircleBorder(),
                    ),
                  ),
                ),
              )
              .values
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (realList.length == 0){
      if (widget.holder != null) {
        return widget.holder(context);
      }else{
        return Container();
      }
    }
    return Container(
      height: widget.height,
      child: Stack(
        children: [
          if (realList.length == 1)
            Container(
              child: page(realList[0], 0),
            ),
          if (realList.length > 1)
            _scrollNoti(PageView(
            controller: _pageController,
            children: realList
                .asMap()
                .map((key, value) => MapEntry(key, page(value, key)))
                .values
                .toList(),
          )),
          if (realList.length > 1) point()
        ],
      ),
    );
  }

  Widget page(data, int index) {
    if (widget.itemBuilder != null) {
      return widget.itemBuilder(context, data, index);
    }
    return Container();
  }
}
