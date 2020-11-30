import 'package:doctor/common/event/event_model.dart';
import 'package:doctor/pages/doctors/model/in_screen_event_model.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/refreshable_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../viewmodel/doctors_view_model.dart';

class DoctorCircleItemWidget extends StatelessWidget {
  final int index;

  DoctorCircleItemWidget(this.index);

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    border: new Border.all(
                        color: ThemeColor.colorFFB8D1E2, width: 2),
                    color: ThemeColor.colorFFF3F5F8,
                    borderRadius: new BorderRadius.all(Radius.circular(15)),
                    image: DecorationImage(
                      // fit: BoxFit.fill,
                      fit: BoxFit.fitWidth,
                      image: AssetImage(
                        'assets/images/doctorAva.png',
                      ),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text('慢性病如慢性病如？',
                    style: TextStyle(
                        fontSize: 14, color: ThemeColor.colorFF444444)),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('慢性病如慢性病如？',
                style:
                    TextStyle(fontSize: 16, color: ThemeColor.colorFF222222)),
          ),
          Padding(
            padding: EdgeInsets.only(top: 6, bottom: 8),
            child: Text(
                '这里是一个描述描述描述描述描述这里是一个描述描述描述描述描述这里是一个描述描述这里是一个描述描述描述描述描述这里是一个描述描述描述描述描述这里是一个描述描述这里是一个描述描述描述描述描述这里是一个描述描述描述描述描述这里是一个描述描',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(fontSize: 14, color: ThemeColor.colorFF999999)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: ThemeColor.colorFFF6F6F6,
                    borderRadius: BorderRadius.all(Radius.circular(2))),
                child: Text(
                  '案例分析',
                  style:
                      TextStyle(color: ThemeColor.primaryColor, fontSize: 12),
                ),
              ),
              Text(
                '1.2万阅读',
                style: TextStyle(color: ThemeColor.colorFF999999, fontSize: 10),
              )
            ],
          )
        ],
      ),
    );
  }
}

class DoctorsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DoctorPageState();
}

class DoctorPageState
    extends AbstractListPageState<DoctorsViewMode, DoctorsPage> {
  ScrollOutScreenViewModel _inScreenViewModel;

  bool _currentIsOutScreen = false;

  @override
  void initState() {
    super.initState();
    eventBus.on().listen((event) {
      if (event != null &&
          event is OutScreenEvent &&
          event.page == PAGE_DOCTOR &&
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
      DoctorCircleItemWidget(index);

  @override
  void scrollOutOfScreen(bool outScreen) {
    _currentIsOutScreen = outScreen;
    _inScreenViewModel.updateState(PAGE_DOCTOR, _currentIsOutScreen);
  }
}
