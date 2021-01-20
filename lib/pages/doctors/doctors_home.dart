import 'package:doctor/common/event/event_model.dart';
import 'package:doctor/pages/doctors/tab_indicator.dart';
import 'package:doctor/pages/doctors/widget/doctors_circle_widget.dart';
import 'package:doctor/pages/doctors/widget/gossip_news_widget.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
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
  var _tabBarColor = Colors.transparent;
  final _map = {"ACADEMIC": Colors.transparent, "GOSSIP": Colors.transparent};

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
      _inScreenViewModel
          .setCurrent(_tabController.index == 0 ? PAGE_DOCTOR : PAGE_GOSSIP);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _inScreenViewModel.clean();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: <Widget>[
                DoctorsPage((offset) {
                  if (offset > 0) {
                    if (_map["ACADEMIC"] != Colors.white) {
                      _map["ACADEMIC"] = Colors.white;
                      _tabBarColor = _map["ACADEMIC"];
                      setState(() {});
                      return;
                    }
                  } else {
                    _map["ACADEMIC"] = Colors.transparent;
                    _tabBarColor = _map["ACADEMIC"];
                    setState(() {});
                  }
                }),
                GossipNewsPage((offset) {
                  if (offset > 0) {
                    if (_map["GOSSIP"] != Colors.white) {
                      _map["GOSSIP"] = Colors.white;
                      _tabBarColor = _map["GOSSIP"];
                      setState(() {});
                      return;
                    }
                  } else {
                    _map["GOSSIP"] = Colors.transparent;
                    _tabBarColor = _map["GOSSIP"];
                    setState(() {});
                  }
                }),
              ],
            ),
            Positioned(
              child: Container(
                color: _tabBarColor,
                width: double.infinity,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 0, right: 0, top: 11, bottom: 5),
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
          ],
        ),
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
