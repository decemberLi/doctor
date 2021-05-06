import 'package:doctor/common/event/event_model.dart';
import 'package:doctor/common/event/event_tab_index.dart';
import 'package:doctor/pages/doctors/tab_indicator.dart';
import 'package:doctor/pages/doctors/widget/doctors_circle_widget.dart';
import 'package:doctor/pages/doctors/widget/gossip_news_widget.dart';
import 'package:doctor/root_widget.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/in_screen_event_model.dart';

class DoctorsHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DoctorsHomeState();
}

class _DoctorsHomeState extends State<DoctorsHome>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List tabs = ['学术圈', '八卦圈'];
  TabController _tabController;
  ScrollOutScreenViewModel _inScreenViewModel;
  var _tabBarColor = 0x00000000;
  var _tabShadowColor = 0x00000000;
  final _map = {PAGE_DOCTOR: 0x00000000, PAGE_GOSSIP: 0x00000000};
  final _shadowMap = {PAGE_DOCTOR: 0x00000000, PAGE_GOSSIP: 0x00000000};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _inScreenViewModel =
        Provider.of<ScrollOutScreenViewModel>(context, listen: false);
    _tabController =
        TabController(initialIndex: 0, length: tabs.length, vsync: this);
    _tabController.addListener(() {
      var pageKey = _tabController.index == 0 ? PAGE_DOCTOR : PAGE_GOSSIP;
      eventBus.fire(EventTabIndex(1, _tabController.index));
      _tabBarColor = _map[pageKey];
      _tabShadowColor = _shadowMap[pageKey];
      setState(() {});
      _inScreenViewModel.setCurrent(pageKey);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _inScreenViewModel.clean();
  }

  final int heightMask = 0xFF000000;
  final int lowMask = 0x00FFFFFF;
  _calcColor(double offset, int colorVal) {
    var heightValue = colorVal & heightMask;
    var lowValue = colorVal & lowMask;
    // 计算高位的值
    var newColorValue = heightValue & (heightValue * (offset / 300)).toInt();
    return newColorValue | lowValue;
  }

  _updateColor(offset, pageName) {
    if (offset < 0) {
      return;
    }
    if (offset == 0) {
      _tabBarColor = 0x00000000;
      _tabShadowColor = 0x00000000;
      setState(() {});
    }
    if (offset > 300) {
      if (_tabBarColor != 0xFFFFFFFF || _tabShadowColor != 0xFFE7E7E7) {
        _map[pageName] = 0xFFFFFFFF;
        _shadowMap[pageName] = 0xFFE7E7E7;
        _tabBarColor = 0xFFFFFFFF;
        _tabShadowColor = 0xFFE7E7E7;
        setState(() {});
      }
      return;
    }
    _map[pageName] = _calcColor(offset, 0xFFFFFFFF);
    _shadowMap[pageName] = _calcColor(offset, 0xFFE7E7E7);
    _tabBarColor = _map[pageName];
    _tabShadowColor = _shadowMap[pageName];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // _setAndroidSystemBar();
    return Scaffold(
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: <Widget>[
              DoctorsPage((offset) {
                _updateColor(offset, PAGE_DOCTOR);
              }),
              GossipNewsPage((offset) {
                _updateColor(offset, PAGE_GOSSIP);
              }),
            ],
          ),
          Positioned(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(_tabBarColor),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 0,
                    spreadRadius: 0,
                    color: Color(_tabShadowColor),
                    offset: Offset(0, 0.3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 6),
                child: SafeArea(
                  child: TabBar(
                    isScrollable: true,
                    indicator: LinearGradientTabIndicatorDecoration(
                        borderSide: BorderSide(
                          width: 6,
                          color: ThemeColor.primaryColor,
                        ),
                        insets: EdgeInsets.only(left: 10, right: 10, top: 30),
                        gradient: const LinearGradient(
                          colors: [
                            ThemeColor.primaryColor,
                            ThemeColor.primaryColor
                          ],
                        ),
                        isRound: true),
                    indicatorWeight: 6,
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ThemeColor.colorFF000000),
                    unselectedLabelStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: ThemeColor.colorFF222222),
                    tabs: _titleWidget(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _titleWidget() {
    List<Widget> tabWidgetList = [];
    tabWidgetList.add(Text(tabs[0]));
    tabWidgetList.add(Text(tabs[1]));

    return tabWidgetList;
  }
}
