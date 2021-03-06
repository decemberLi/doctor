import 'package:doctor/common/event/event_model.dart';
import 'package:doctor/common/event/event_tab_index.dart';
import 'package:doctor/pages/doctors/model/in_screen_event_model.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/table_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../root_widget.dart';
import '../doctors_banner.dart';
import '../doctors_banner_item.dart';
import '../doctors_list_page.dart';
import '../viewmodel/doctors_view_model.dart';
import 'circleflow/category_widget.dart';
import 'circleflow/enterprise_open_class_widget.dart';
import 'circleflow/hot_post_widget.dart';
import 'circleflow/online_classic.dart';

class EventVideoOutOfScreen {
  double offset;

  EventVideoOutOfScreen(this.offset);
}
typedef OnScrollerCallback = void Function(double offset);

openBannerDetail(BuildContext context, data) {
  print("On banner clicked -> [${data?.toJson()}]");
  if (data.bannerType == 'RELEVANCY_POST') {
    RouteManagerOld.openDoctorsDetail(int.parse(data?.relatedContent),
        from: "msg");
  } else if (data.bannerType == 'ACTIVITY') {
    RouteManagerOld.openWebPage(data?.relatedContent);
  }
}

class DoctorsPage extends StatefulWidget {
  final OnScrollerCallback callback;

  DoctorsPage(this.callback);

  @override
  State<StatefulWidget> createState() => DoctorPageState();
}

class DoctorPageState
    extends State<DoctorsPage> {
  ScrollOutScreenViewModel _inScreenViewModel;
  final _model = DoctorsViewMode(type: 'ACADEMIC');

  bool _currentIsOutScreen = false;
  GlobalKey _videoStackKey = GlobalKey();
  final NormalTableViewController _controller = NormalTableViewController();


  @override
  void initState() {
    super.initState();
    eventBus.on().listen((event) {
      if (event != null &&
          event is OutScreenEvent &&
          event.page == PAGE_DOCTOR &&
          _currentIsOutScreen) {
        _controller.refresh();
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
                  (context, data, index) {
                return DoctorBannerItemGrass(data, onClick: (data) {
                  openBannerDetail(context, data);
                });
              },
              dataStream: _model.topBannerStream,
              height: 207 + MediaQuery.of(context).padding.top,
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
              if (snapshot.hasData && snapshot.data.length >= 3) {
                return OnlineClassicWidget(snapshot.data);
              }
              return Container(color: Colors.white);
            },
          ),
          Container(
            color: Colors.white,
            child: EnterpriseOpenClassWidget(
              _videoStackKey,
              _model.openClassStream,
              Container(
                color: ThemeColor.colorFFF9F9F9,
                width: double.infinity,
                height: 6,
              ),
            ),
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
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            color: Colors.white,
            child: DoctorsBanner(
                  (context, data, index) {
                return DoctorBannerItemNormal(
                  data,
                  onClick: (data) {
                    openBannerDetail(context, data);
                  },
                );
              },
              dataStream: _model.flowBannerStream,
              height: 80,
              holder: (context) {
                return Container(
                  color: Colors.white,
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget itemWidget(BuildContext context, dynamic data) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          DoctorsListItem(data, () {
            eventBus.fire(EventVideoPause());
            setState(() {});
          }, lineHeight: 0,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(height: 0.5,color: Color(0xffF3F5F8),),
          )
        ],
      ),
    );
  }


  void scrollOutOfScreen(bool outScreen) {
    _currentIsOutScreen = outScreen;
    _inScreenViewModel.updateState(PAGE_DOCTOR, _currentIsOutScreen);
  }


  void scrollOffset(double offset) {
    if (widget.callback != null) {
      RenderBox box = _videoStackKey.currentContext.findRenderObject();
      // print(box.size); // Size(200.0, 100.0)
      var offsetObj = box.localToGlobal(Offset.zero);
      eventBus.fire(EventVideoOutOfScreen(offsetObj.dy));
      widget.callback(offset);
    }
  }

  void onItemClicked(DoctorsViewMode model, itemData) {
    model.markToNative(itemData);
    eventBus.fire(EventVideoPause());
    RouteManagerOld.openDoctorsDetail(itemData?.postId);
  }

  @override
  Widget build(BuildContext context) {
    return NormalTableView(
      controller: _controller,
      pageSize: (page) => page == 1 ? 17 : 20,
      itemBuilder: (context, data) {
        return itemWidget(context, data);
      },
      header: (context) {
        return bodyHeader();
      },
      getData: (page) async {
        if (page == 1) {
          return await _model.refresh();
        }
        return await _model.loadData(pageNum: page);
      },
      onScroll: (context, offset) {
        var outScreen = MediaQuery.of(context).size.height < offset;
        scrollOutOfScreen(outScreen);
        scrollOffset(offset);
      },
    );
  }
}
