import 'package:doctor/common/event/event_model.dart';
import 'package:doctor/pages/doctors/tab_indicator.dart';
import 'package:doctor/pages/doctors/widget/doctors_circle_widget.dart';
import 'package:doctor/pages/doctors/widget/gossip_news_widget.dart';
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
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 46,
        flexibleSpace: SafeArea(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding:
                  EdgeInsets.only(left: 100, right: 100, top: 11, bottom: 5),
              child: TabBar(
                  indicator: LinearGradientTabIndicatorDecoration(),
                  labelPadding: EdgeInsets.zero,
                  indicatorWeight: 0,
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ThemeColor.colorFF000000),
                  unselectedLabelStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: ThemeColor.colorFF999999),
                  tabs: _titleWidget()),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          DoctorsPage(),
          GossipNewsPage(),
        ],
      ),
    );
  }

  _titleWidget() {
    List<Widget> tabWidgetList = [];
    tabWidgetList.add(Text(tabs[0]));
    var gossip = Stack(
      overflow: Overflow.visible,
      children: [
        Text(tabs[1]),
        Positioned(
            bottom: 0,
            right: -20,
            child: Image.asset('assets/images/gossip_icon.png',
                width: 20, height: 18))
      ],
    );
    tabWidgetList.add(gossip);

    return tabWidgetList;
  }
}
