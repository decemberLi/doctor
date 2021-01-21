import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class DoctorsBanner extends StatefulWidget {
  final List dataList;
  final Function(BuildContext,dynamic,int) itemBuilder;
  final double height;

  DoctorsBanner(this.dataList, this.itemBuilder,{this.height = 237});

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
  void initState() {
    realList.addAll(widget.dataList);
    if (widget.dataList.length > 1) {
      realList.insert(0, widget.dataList[widget.dataList.length - 1]);
      realList.add(widget.dataList[0]);
      _pageController.addListener(() {
        setState(() {
          print("the page == ${_pageController.page}");
          if (_pageController.page == realList.length - 1) {
            _pageController.jumpToPage(1);
            _currentIndex = 0;
          } else if (_pageController.page == 0) {
            _pageController.jumpToPage(widget.dataList.length);
            _currentIndex = widget.dataList.length - 1;
          } else {
            var page = _pageController.page.round() - 1;
            page = min(page, widget.dataList.length - 1);
            page = max(0, page);
            _currentIndex = page;
          }
        });
      });
      _startTimer();
    }else{
      _timer?.cancel();
    }
    super.initState();
  }

  _startTimer() {
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        _pageController.animateToPage(
          _pageController.page.round() + 1,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (widget.dataList.length <= 1) {
          return true;
        }
        if (notification.depth == 0 &&
            notification is ScrollStartNotification) {
          if (notification.dragDetails != null) {
            _timer?.cancel();
          }
        } else if (notification is ScrollEndNotification) {
          _timer?.cancel();
          _startTimer();
        }
        return true;
      },
      child: content(context),
    );
  }

  Widget content(BuildContext context) {
    return Container(
      height: widget.height,
      child: Stack(
        children: [
          PageView(
            physics: widget.dataList.length > 1
                ? null
                : NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: realList.asMap().map((key,value) => MapEntry(key, page(value,key))).values.toList(),
          ),
          if (widget.dataList.length > 1)
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 6,
                margin: EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.dataList
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
            )
        ],
      ),
    );
  }

  Widget page(data,int index) {
    if (widget.itemBuilder != null) {
      return widget.itemBuilder(context,data,index);
    }
    return Container();
  }
}
