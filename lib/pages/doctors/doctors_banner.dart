import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class DoctorsBanner extends StatefulWidget{
  final List dataList;
  DoctorsBanner(this.dataList);
  @override
  State<StatefulWidget> createState() {
    return _DoctorsBannerState();
  }

}

class _DoctorsBannerState extends State<DoctorsBanner>
{
  List realList = [];
  int _currentIndex = 0;
  PageController _pageController = PageController(initialPage: 1);
  @override
  void initState() {
    realList.addAll(widget.dataList);
    realList.insert(0, widget.dataList[widget.dataList.length - 1]);
    realList.add(widget.dataList[0]);
    _pageController.addListener(() {
      setState(() {
        print("the page == ${_pageController.page}");
        if(_pageController.page == realList.length - 1) {
          _pageController.jumpToPage(1);
          _currentIndex = 0;
        }else if(_pageController.page == 0){
          _pageController.jumpToPage(widget.dataList.length);
          _currentIndex = widget.dataList.length - 1;
        }else{
          var page = _pageController.page.round() - 1;
          page = min(page, widget.dataList.length - 1);
          page = max(0,page);
          _currentIndex = page;
        }
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 237,
      child: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: realList.map((e) => page(e)).toList(),
          ),
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

  Widget page(data) {
    return Container(
      child: Text("$data"),
    );
  }
}
