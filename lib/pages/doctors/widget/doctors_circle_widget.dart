import 'package:doctor/common/event/event_model.dart';
import 'package:doctor/pages/doctors/model/banner_entity.dart';
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
import '../doctors_list_page.dart';
import '../model/doctor_circle_entity.dart';
import '../viewmodel/doctors_view_model.dart';
import 'circleflow/category_widget.dart';
import 'circleflow/enterprise_open_class_widget.dart';
import 'circleflow/hot_post_widget.dart';
import 'circleflow/online_classic.dart';

class EventVideoOutOfScreen {
  double offset;

  EventVideoOutOfScreen(this.offset);
}

final _colorPanel = {
  '文献专区': ThemeColor.colorFF52C41A,
  '病例解析': ThemeColor.colorFF107BFD,
  '每日医讲': ThemeColor.colorFFFAAD14,
};

typedef OnScrollerCallback = void Function(double offset);

openBannerDetail(BuildContext context, data) {
  print("On banner clicked -> [${data?.toJson()}]");
  if (data.bannerType == 'RELEVANCY_POST') {
    Navigator.pushNamed(context, RouteManager.DOCTORS_ARTICLE_DETAIL,
        arguments: {
          'postId': int.parse(data?.relatedContent),
          'from': 'list',
          'type': 'VIDEO_ZONE'
        });
  } else if (data.bannerType == 'ACTIVITY') {
    Navigator.pushNamed(context, RouteManager.COMMON_WEB, arguments: {
      'postId': data?.relatedContent,
      'url': data?.relatedContent,
      'title': ''
    });
  }
}

class DoctorsPage extends StatefulWidget {
  final OnScrollerCallback callback;

  DoctorsPage(this.callback);

  @override
  State<StatefulWidget> createState() => DoctorPageState();
}

class DoctorPageState
    extends AbstractListPageState<DoctorsViewMode, DoctorsPage> {
  ScrollOutScreenViewModel _inScreenViewModel;
  final _model = DoctorsViewMode(type: 'ACADEMIC');

  bool _currentIsOutScreen = false;
  GlobalKey _videoStackKey = GlobalKey();

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
              _model.topBannerStream,
              (context, data, index) {
                return DoctorBannerItemGrass(data, onClick: (data) {
                  openBannerDetail(context, data);
                });
              },
              holder: (context) {
                return SafeArea(
                  child: Container(
                    height: 40,
                  ),
                );
              },
            ),
          ),
          StreamBuilder(
            stream: _model.categoryStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<CategoryEntity>> snapshot) {
              if (snapshot.hasData && snapshot.data.length != 0) {
                return Column(
                  children: [
                    CategoryWidget(snapshot.data),
                    Container(
                      color: ThemeColor.colorFFF9F9F9,
                      width: double.infinity,
                      height: 6,
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
          StreamBuilder(
            stream: _model.onlineClassStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<OnlineClassicEntity>> snapshot) {
              if (snapshot.hasData && snapshot.data.length != 0) {
                return OnlineClassicWidget(snapshot.data);
              }
              return Container(color: Colors.white);
            },
          ),
          StreamBuilder(
            stream: _model.openClassStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<OpenClassEntity>> snapshot) {
              if (snapshot.hasData && snapshot.data.length != 0) {
                return Column(
                  children: [
                    EnterpriseOpenClassWidget(_videoStackKey, snapshot.data),
                    Container(
                      color: ThemeColor.colorFFF9F9F9,
                      width: double.infinity,
                      height: 6,
                    )
                  ],
                );
              }
              return Container(
                color: ThemeColor.colorFFF9F9F9,
                width: double.infinity,
                height: 6,
              );
            },
          ),
          StreamBuilder(
            stream: _model.hotPostStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<HotPostEntity>> snapshot) {
              if (snapshot.hasData && snapshot.data.length != 0) {
                return HotPostWidget(snapshot.data);
              }
              return Container(color: Colors.white);
            },
          ),
          Container(
            color: Colors.white,
            child: DoctorsBanner(
              _model.flowBannerStream,
              (context, data, index) {
                return Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    child: DoctorBannerItemNormal(
                      data,
                      onClick: (data) {
                        openBannerDetail(context, data);
                      },
                    ));
              },
              height: 80,
              holder: (context) {
                return Container(
                  color: Colors.white,
                  height: 12,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget divider(BuildContext context, int index) => Container();

  @override
  DoctorsViewMode getModel() => _model;

  @override
  Widget itemWidget(BuildContext context, int index, dynamic data) {
    return DoctorsListItem(data);
  }

  @override
  void scrollOutOfScreen(bool outScreen) {
    _currentIsOutScreen = outScreen;
    _inScreenViewModel.updateState(PAGE_DOCTOR, _currentIsOutScreen);
  }

  @override
  void scrollOffset(double offset) {
    if (widget.callback != null) {
      RenderBox box = _videoStackKey.currentContext.findRenderObject();
      // print(box.size); // Size(200.0, 100.0)
      var offsetObj = box.localToGlobal(Offset.zero);
      eventBus.fire(EventVideoOutOfScreen(offsetObj.dy));
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
