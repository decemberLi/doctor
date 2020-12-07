import 'dart:math';

import 'package:doctor/common/event/event_model.dart';
import 'package:doctor/pages/doctors/model/in_screen_event_model.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/refreshable_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../viewmodel/doctors_view_model.dart';
import '../model/doctor_circle_entity.dart';

class DoctorCircleItemWidget extends StatelessWidget {
  final _colorPanel = {
    '文献专区': ThemeColor.colorFF52C41A,
    '案例解析': ThemeColor.colorFF107BFD,
    '每日一讲': ThemeColor.colorFFFAAD14,
  };
  final DoctorCircleEntity data;

  DoctorCircleItemWidget(this.data);

  Color _categoryTextColor(String category) {
    Color color = _colorPanel[category];
    if (color != null) {
      return color;
    }
    var batch = _colorPanel.entries.toList();
    var hitColor = batch[Random().nextInt(batch.length)].value;
    _colorPanel[category] = hitColor;
    return hitColor;
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    if (data?.postUserHeader != null) {
      imageProvider = NetworkImage(data.postUserHeader);
    } else {
      imageProvider = AssetImage('assets/images/doctorAva.png');
    }

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
                      image: imageProvider,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text(data?.postUserName ?? '',
                    style: TextStyle(
                        fontSize: 14, color: ThemeColor.colorFF444444)),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            // title
            child: Text(data?.postTitle ?? '',
                style:
                    TextStyle(fontSize: 16, color: ThemeColor.colorFF222222)),
          ),
          Padding(
            padding: EdgeInsets.only(top: 6, bottom: 8),
            child: Text(data?.postContent ?? '',
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
                  data?.columnName ?? '',
                  style: TextStyle(
                      color: _categoryTextColor(data?.columnName ?? ''),
                      fontSize: 12),
                ),
              ),
              Text(
                formatViewCount(data?.viewNum),
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
  Widget emptyWidget(String msg) {
    return super.emptyWidget('暂无数据，请刷新后重试');
  }

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
  DoctorsViewMode getModel() => DoctorsViewMode('GOSSIP');

  @override
  Widget itemWidget(BuildContext context, int index, dynamic data) =>
      DoctorCircleItemWidget(data);

  @override
  void scrollOutOfScreen(bool outScreen) {
    _currentIsOutScreen = outScreen;
    _inScreenViewModel.updateState(PAGE_DOCTOR, _currentIsOutScreen);
  }
}