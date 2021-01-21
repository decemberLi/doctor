import 'package:doctor/common/event/event_model.dart';
import 'package:doctor/pages/doctors/model/in_screen_event_model.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/refreshable_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../root_widget.dart';
import '../doctors_banner.dart';
import '../doctors_banner_item.dart';
import '../model/doctor_circle_entity.dart';
import '../viewmodel/doctors_view_model.dart';
import 'circleflow/category_widget.dart';
import 'circleflow/enterprise_open_class_widget.dart';
import 'circleflow/hot_post_widget.dart';
import 'circleflow/online_classic.dart';

final _colorPanel = {
  '文献专区': ThemeColor.colorFF52C41A,
  '病例解析': ThemeColor.colorFF107BFD,
  '每日医讲': ThemeColor.colorFFFAAD14,
};

class DoctorCircleItemWidget extends StatelessWidget {
  final DoctorCircleEntity data;

  DoctorCircleItemWidget(this.data);

  Color _categoryTextColor(String category) {
    Color color = _colorPanel[category];
    if (color != null) {
      return color;
    }
    return ThemeColor.colorFF107BFD;
    // var batch = _colorPanel.entries.toList();
    // var hitColor = batch[Random().nextInt(batch.length)].value;
    // _colorPanel.putIfAbsent(category, () => hitColor);
    // return hitColor;
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Container(
        height: 30,
        color: Colors.red,
      );
    }
    ImageProvider imageProvider;
    if (data?.postUserHeader != null) {
      imageProvider = NetworkImage(data.postUserHeader);
    } else {
      imageProvider = AssetImage('assets/images/doctorAva.png');
    }

    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(0))),
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16,
                    color: data.isClicked
                        ? ThemeColor.colorFFC1C1C1
                        : ThemeColor.colorFF222222)),
          ),
          Padding(
            padding: EdgeInsets.only(top: 6, bottom: 8),
            child: Text(data?.postContent ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14,
                    color: data.isClicked
                        ? ThemeColor.colorFFC1C1C1
                        : ThemeColor.colorFF999999)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: ThemeColor.colorFFF6F6F6,
                    borderRadius: BorderRadius.all(Radius.circular(2))),
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            color: ThemeColor.colorFFF8F8F8,
            height: 1,
          )
        ],
      ),
    );
  }
}

typedef OnScrollerCallback = void Function(double offset);

class DoctorsPage extends StatefulWidget {
  final OnScrollerCallback callback;

  DoctorsPage(this.callback);

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

  bodyHeader() {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: DoctorsBanner(
              [0, 1, 2, 3, 4],
              (context, data, index) {
                return DoctorBannerItemGrass(data);
              },
            ),
          ),
          CategoryWidget([
            CategoryEntity("", "", "每日医讲"),
            CategoryEntity("", "", "病例解析"),
            CategoryEntity("", "", "论文专区")
          ]),
          Container(
            color: ThemeColor.colorFFF9F9F9,
            width: double.infinity,
            height: 6,
          ),
          OnlineClassicWidget([
            OnlineClassicEntity(),
            OnlineClassicEntity(),
            OnlineClassicEntity(),
            OnlineClassicEntity(),
          ]),
          EnterpriseOpenClassWidget([
            OpenClassEntity(),
            OpenClassEntity(),
            OpenClassEntity(),
          ]),
          Container(
            color: ThemeColor.colorFFF9F9F9,
            width: double.infinity,
            height: 6,
          ),
          HotPostWidget([
            HotPostEntity(),
            HotPostEntity(),
            HotPostEntity(),
            HotPostEntity(),
          ]),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: DoctorsBanner([0, 1, 2, 3, 4], (context, data, index) {
              return DoctorBannerItemGrass(data);
            }, height: 80),
          )
        ],
      ),
    );
  }

  @override
  Widget divider(BuildContext context, int index) => Container();

  @override
  DoctorsViewMode getModel() => DoctorsViewMode(type: 'ACADEMIC');

  @override
  Widget itemWidget(BuildContext context, int index, dynamic data) {
    return DoctorCircleItemWidget(data);
  }

  @override
  void scrollOutOfScreen(bool outScreen) {
    _currentIsOutScreen = outScreen;
    _inScreenViewModel.updateState(PAGE_DOCTOR, _currentIsOutScreen);
  }

  @override
  void scrollOffset(double offset) {
    if (widget.callback != null) {
      widget.callback(offset);
    }
  }

  @override
  void onItemClicked(DoctorsViewMode model, itemData) {
    model.markToNative(itemData?.postId);
    Navigator.pushNamed(context, RouteManager.DOCTORS_ARTICLE_DETAIL,
        arguments: {
          'postId': itemData?.postId,
          'from': 'list',
          'type': 'ACADEMIC'
        });
  }

  @override
  String noMoreDataText() => '已显示全部帖子';
}
