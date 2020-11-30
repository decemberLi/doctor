import 'dart:math';

import 'package:doctor/common/event/event_model.dart';
import 'package:doctor/pages/doctors/model/in_screen_event_model.dart';
import 'package:doctor/pages/doctors/viewmodel/doctors_view_model.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/refreshable_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class GossipNewsItemWidget extends StatelessWidget {
  final int index;
  final List<Color> colors = [
    const Color(0xFF62C1FF),
    const Color(0xFF92E06B),
    const Color(0xFFFABB3E),
  ];

  GossipNewsItemWidget(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: colors[Random().nextInt(3)],
                        borderRadius:
                            new BorderRadius.all(Radius.circular(15))),
                    child: Text(
                      '周',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text('周杰伦',
                        style: TextStyle(
                            fontSize: 14, color: ThemeColor.colorFF444444)),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '1.2万阅读',
                    style: TextStyle(
                        color: ThemeColor.colorFF999999, fontSize: 10),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      '28讨论',
                      style: TextStyle(
                          color: ThemeColor.colorFF999999, fontSize: 10),
                    ),
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
                '这里是一个描述描述描述描述描述这里是一个描述描述描述描述描述这里是一个描述描述这里是一个描述描述描述描述描述这里是一个描述描述描述描述描述这里是一个描述描述这里是一个描述描述描述描述描述这里是一个描述描述描述描述描述这里是一个描述描',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(fontSize: 14, color: ThemeColor.colorFF222222)),
          ),
        ],
      ),
    );
  }
}

class GossipNewsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GossipNewsPageState();
}

class GossipNewsPageState
    extends AbstractListPageState<DoctorsViewMode, GossipNewsPage> {
  DoctorsViewMode mode;
  ScrollOutScreenViewModel _inScreenViewModel;

  bool _currentIsOutScreen = false;

  @override
  void initState() {
    super.initState();
    eventBus.on().listen((event) {
      if (event != null &&
          event is OutScreenEvent &&
          event.page == PAGE_GOSSIP &&
          _currentIsOutScreen) {
        requestRefresh();
      }
    }, cancelOnError: true);
    _inScreenViewModel =
        Provider.of<ScrollOutScreenViewModel>(context, listen: false);
  }

  @override
  Widget divider(BuildContext context, int index) => Divider(
        color: ThemeColor.colorFFF3F5F8,
        height: 12,
      );

  @override
  DoctorsViewMode getModel() => DoctorsViewMode();

  @override
  Widget itemWidget(BuildContext context, int index) =>
      GossipNewsItemWidget(index);

  @override
  void scrollOutOfScreen(bool outScreen) {
    _currentIsOutScreen = outScreen;
    _inScreenViewModel.updateState(PAGE_GOSSIP, _currentIsOutScreen);
  }
}
