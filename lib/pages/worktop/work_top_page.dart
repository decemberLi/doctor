import 'dart:convert';

import 'package:doctor/common/event/event_tab_index.dart';
import 'package:doctor/model/biz/learn_plan_statistical_entity.dart';
import 'package:doctor/model/ucenter/auth_platform.dart';
import 'package:doctor/model/ucenter/doctor_detail_info_entity.dart';
import 'package:doctor/pages/activity/entity/activity_entity.dart';
import 'package:doctor/pages/activity/widget/activity_widget.dart';
import 'package:doctor/pages/user/ucenter_view_model.dart';
import 'package:doctor/pages/worktop/learn/cache_learn_detail_video_helper.dart';
import 'package:doctor/pages/worktop/learn/learn_list/learn_list_item_wiget.dart';
import 'package:doctor/pages/worktop/model/work_top_entity.dart';
import 'package:doctor/pages/worktop/resource/view_model/work_top_view_model.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/common_stack.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../root_widget.dart';

class WorktopPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WorktopPageState();
  }
}

class _WorktopPageState extends State<WorktopPage>
    with AutomaticKeepAliveClientMixin, RouteAware {
  final WorkTopViewModel userInfoModel = WorkTopViewModel();

  @override
  bool get wantKeepAlive => true;
  bool isShowed = false;

  init() async {
    await userInfoModel.initData();
  }

  @override
  void initState() {
    this.init();
    super.initState();
    eventBus.on().listen((event) {
      if (event is EventTabIndex && event.index == 0) {
        _showUploadVideoDialogIfNeeded();
      }
    });
  }

  void _showUploadVideoDialogIfNeeded() async {
    if (isShowed) {
      return;
    }
    UserInfoViewModel model =
        Provider.of<UserInfoViewModel>(context, listen: false);
    await model.queryDoctorInfo();
    var needShow = await CachedLearnDetailVideoHelper.hasCachedVideo(
        model.data.doctorUserId);
    if (!needShow) {
      return;
    }
    _showUploadVideoAlert(model.data.doctorUserId);
  }

  _showUploadVideoAlert(int userId) {
    isShowed = true;
    showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return WillPopScope(
          child: CupertinoAlertDialog(
            content: Container(
              padding: EdgeInsets.only(top: 12),
              child: Text("您有一个未完成的讲课邀请任务\n是否立即查看详情"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "暂不查看",
                  style: TextStyle(
                    color: ThemeColor.colorFF444444,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text(
                  "查看详情",
                  style: TextStyle(
                    color: ThemeColor.colorFF52C41A,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop(false);
                  CachedVideoInfo videoInfo =
                      await CachedLearnDetailVideoHelper.getCachedVideoInfo(
                          userId);
                  await Navigator.of(context).pushNamed(
                    RouteManagerOld.LEARN_DETAIL,
                    arguments: {
                      'learnPlanId': videoInfo.learnPlanId,
                    },
                  );
                },
              ),
            ],
          ),
          onWillPop: () async => false,
        );
      },
    );
  }

  @override
  void dispose() {
    print('work_top_dispose');
    userInfoModel.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)); //订阅
    super.didChangeDependencies();
  }

  @override
  void didPopNext() async {
    UserInfoViewModel model =
        Provider.of<UserInfoViewModel>(context, listen: false);
    await model.queryDoctorInfo();
    userInfoModel.initData();
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Color(0xFFF3F5F8),
      child: Stack(
        children: [
          Positioned(
            child: Container(
              color: Color(0xFF3AA7FF),
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/images/common_statck_bg.png',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
              width: MediaQuery.of(context).size.width,
              height: 232.0,
            ),
          ),
          Positioned(
            child: SafeArea(
              child: ChangeNotifierProvider<WorkTopViewModel>.value(
                value: userInfoModel,
                child: Consumer<WorkTopViewModel>(
                  builder: (context, model, child) {
                    WorktopPageEntity entity =
                        model?.list != null && model?.list.length >= 1
                            ? model.list[0]
                            : null;
                    return SmartRefresher(
                      physics: AlwaysScrollableScrollPhysics(),
                      header: ClassicHeader(
                        textStyle: TextStyle(color: Colors.white),
                        failedIcon:
                            const Icon(Icons.error, color: Colors.white),
                        completeIcon:
                            const Icon(Icons.done, color: Colors.white),
                        idleIcon: const Icon(Icons.arrow_downward,
                            color: Colors.white),
                        releaseIcon:
                            const Icon(Icons.refresh, color: Colors.white),
                      ),
                      onRefresh: model.refresh,
                      controller: model.refreshController,
                      child: bodyWidget(entity),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bodyWidget(WorktopPageEntity entity) {
    if (entity == null) {
      return Container(
        color: Color(0xFFF3F5F8),
      );
    }
    var learnPlanListCount = entity?.learnPlanList?.length ?? 0;
    var activityCount = entity?.activityPackages?.length ?? 0;
    _buildSliverBuildDelegate() {
      return SliverChildBuilderDelegate((context, index) {
        var item;
        if (index >= activityCount) {
          item = entity.learnPlanList[index - activityCount];
        } else {
          item = entity.activityPackages[index];
        }

        return Container(
          margin: EdgeInsets.only(left: 16, right: 16),
          child: index >= activityCount
              ? LearnListItemWiget(
                  item,
                  'LEARNING',
                  () {
                    userInfoModel.initData();
                  },
                  () async {
                    await Navigator.of(context).pushNamed(
                      RouteManagerOld.LEARN_DETAIL,
                      arguments: {
                        'learnPlanId': item.learnPlanId,
                        'listStatus': 'LEARNING',
                        'from': 'work_top',
                      },
                    );
                    // 无脑刷新数据，从详情页回来后不刷新数据
                    // _model.initData();
                  },
                  margin: EdgeInsets.only(bottom: 10),
                )
              : Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ActivityWidget(item),
                ),
        );
      }, childCount: learnPlanListCount + activityCount);
    }

    _buildEmptyContainer() {
      var learnPlanListCount = entity?.learnPlanList?.length ?? 0;
      var activityCount = entity?.activityPackages?.length ?? 0;
      if (entity == null ||
          entity.learnPlanList == null ||
          learnPlanListCount + activityCount == 0) {
        return Container(
          padding: EdgeInsets.only(top: 60),
          child: ViewStateEmptyWidget(
            message: '暂无学习计划',
          ),
        );
      } else {
        return Container();
      }
    }

    return CustomScrollView(
      physics: NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                cardPart(entity),
                entity.learnPlanList.length == 0 &&
                        entity.activityPackages.length == 0
                    ? Container()
                    : Container(
                        width: double.infinity,
                        color: Colors.transparent,
                        padding: EdgeInsets.only(left: 16, top: 11, bottom: 10),
                        margin: EdgeInsets.only(left: 16, right: 16),
                        child: const Text(
                          "最近收到",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF222222),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                _buildEmptyContainer(),
              ],
            ),
          ),
        ),
        SliverList(delegate: _buildSliverBuildDelegate())
      ],
    );
  }

  doctorAvatarWidget(UserInfoViewModel userModel) {
    DoctorDetailInfoEntity doctorInfoEntity = userModel.data;
    // 医生个人信息部分
    var doctorName = doctorInfoEntity?.doctorName ?? '';
    if (doctorInfoEntity?.basicInfoAuthStatus == 'NOT_COMPLETE') {
      doctorName = '待完善';
    }
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 70,
            alignment: Alignment.center,
            child: doctorInfoEntity?.fullFacePhoto == null
                ? Image.asset(
                    "assets/images/doctorHeader.png",
                  )
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(
                            '${doctorInfoEntity?.fullFacePhoto?.url}?status=${doctorInfoEntity?.fullFacePhoto?.ossId}'),
                      ),
                    ),
                  ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Color(0x2f000000),
                  offset: Offset(0, 2),
                  blurRadius: 10,
                ),
              ],
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          doctorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20,
                              color: ThemeColor.colorFF222222,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (doctorInfoEntity != null)
                        _buildAuthStatusWidget(userModel),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      doctorInfoEntity?.jobGradeName ?? '',
                      style: TextStyle(
                          fontSize: 12,
                          color: ThemeColor.colorFF222222,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    child: Text(
                      "欢迎来到易学术",
                      style: TextStyle(
                          fontSize: 14,
                          color: ThemeColor.colorFF222222,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, RouteManagerOld.USERINFO_DETAIL,
            arguments: {'doctorData': doctorInfoEntity.toJson()});
      },
    );
  }

  Widget cardPart(WorktopPageEntity entity) {
    // 易学术统计
    staticsData(String text, int value) {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text ?? '',
              style: TextStyle(fontSize: 12, color: ThemeColor.primaryColor),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${value ?? 0}',
                  style:
                      TextStyle(fontSize: 36, color: ThemeColor.primaryColor),
                ),
                Container(
                  margin: EdgeInsets.only(left: 4),
                  child: Text(
                    "个",
                    style: TextStyle(
                        fontSize: 12, color: ThemeColor.colorFF222222),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    var visitCount = 0;
    var surveyCount = 0;
    var meetingCount = 0;

    _statics(List<LearnPlanStatisticalEntity> lists) {
      if (lists != null && lists.isNotEmpty) {
        for (var each in lists) {
          if (each.taskTemplate == 'VISIT') {
            visitCount = each.unSubmitNum;
          } else if (each.taskTemplate == 'SURVEY') {
            surveyCount = each.unSubmitNum;
          } else if (each.taskTemplate == 'MEETING') {
            meetingCount = each.unSubmitNum;
          }
        }
      }
    }

    _statics(entity?.learnPlanStatisticalEntity);

    _buildStaticsWidget(List<LearnPlanStatisticalEntity> lists) {
      var leftLineDecoration = BoxDecoration(
          border: new Border(
              left: BorderSide(
        color: ThemeColor.colorFFE7E7E7,
        width: 0.5,
      )));
      return Container(
        margin: EdgeInsets.only(top: 10, left: 10),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  child: staticsData('拜访', visitCount),
                ),
                onTap: () {
                  _goLearnPlanPage(2);
                },
              ),
            ),
            Expanded(
              child: GestureDetector(
                child: Container(
                  decoration: leftLineDecoration,
                  alignment: Alignment.center,
                  child: staticsData('会议', meetingCount),
                ),
                onTap: () {
                  _goLearnPlanPage(1);
                },
              ),
            ),
            Expanded(
              child: GestureDetector(
                child: Container(
                  decoration: leftLineDecoration,
                  alignment: Alignment.center,
                  child: staticsData('调研', surveyCount),
                ),
                onTap: () {
                  _goLearnPlanPage(3);
                },
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.fromLTRB(16, 32, 16, 0),
      padding: EdgeInsets.only(top: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 24),
            child: Consumer<UserInfoViewModel>(
              builder: (_, userModel, __) {
                if (userModel.data == null) {
                  userModel.queryDoctorInfo();
                }
                return doctorAvatarWidget(userModel);
              },
            ),
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFFF0F7FF),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(left: 24, top: 13),
                child: notice(visitCount, surveyCount, meetingCount),
              )
            ],
          ),
          _buildStaticsWidget(entity?.learnPlanStatisticalEntity),
          _showOperatorBtn(entity),
        ],
      ),
    );
  }

  Widget notice(int visitCount, int surveyCount, int meetingCount) {
    var count = visitCount + surveyCount + meetingCount;
    if (count > 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 4),
            child: Image.asset(
              'assets/images/icon_voice.png',
              width: 16,
              fit: BoxFit.fitWidth,
            ),
          ),
          Text(
            "您有",
            style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "${visitCount + surveyCount + meetingCount}个待处理",
            style: TextStyle(
                color: ThemeColor.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "的学习计划",
            style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 4),
          child: Image.asset(
            'assets/images/icon_voice.png',
            width: 16,
            fit: BoxFit.fitWidth,
          ),
        ),
        Text(
          "您暂无待处理的学习计划",
          style: TextStyle(
              color: Color(0xFF222222),
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  _isLearnPlanEmpty(WorktopPageEntity entity) {
    List<LearnPlanStatisticalEntity> list = entity?.learnPlanStatisticalEntity;

    if (list == null || list.length == 0) {
      return true;
    }
    for (var each in list) {
      if (each.unSubmitNum != 0) {
        return false;
      }
    }
    return true;
  }

  Container _showOperatorBtn(WorktopPageEntity entity) {
    bool isEmpty = _isLearnPlanEmpty(entity);
    return Container(
      margin: EdgeInsets.only(bottom: 12, top: 20, left: 24, right: 24),
      child: AceButton(
        height: 42,
        text: isEmpty ? '暂无待处理学习计划' : '处理一下',
        textColor: Colors.white,
        type: _isLearnPlanEmpty(entity)
            ? AceButtonType.secondary
            : AceButtonType.primary,
        onPressed: isEmpty ? () => {} : () => {_goLearnPlanPage(0)},
      ),
    );
  }

  _goLearnPlanPage(int index) async {
    await Navigator.pushNamed(context, RouteManagerOld.LEARN_PAGE, arguments: {
      'index': index,
    });
    userInfoModel.refresh();
  }

  _buildAuthStatusWidget(UserInfoViewModel userModel) {
    DoctorDetailInfoEntity doctorInfoEntity = userModel.data;
    return Container(
      width: 65,
      height: 20,
      margin: EdgeInsets.only(left: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: doctorInfoEntity?.authStatus == 'PASS'
            ? Color(0xFFFAAD14)
            : Color(0xFFB9B9B9),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          print(
              "the identityStatus is ${doctorInfoEntity?.identityStatus} , auth status is ${doctorInfoEntity?.authStatus} ");
          goGoGo(userModel, context);
        },
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              if (doctorInfoEntity?.authStatus == 'PASS')
                WidgetSpan(
                  child: Image.asset(
                    "assets/images/rz.png",
                    width: 14,
                    height: 14,
                  ),
                ),
              TextSpan(
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
                text: doctorInfoEntity?.authStatus == 'PASS' ? '已认证' : '未认证',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool goGoGo(UserInfoViewModel userModel, BuildContext context,{String channel = channelGolden}) {
  DoctorDetailInfoEntity doctorInfo = userModel.data;
  if (!userModel.isIdentityAuthPassedByChannel(channel)) {
    Navigator.pushNamed(
        context, RouteManagerOld.DOCTOR_AUTHENTICATION_INFO_PAGE,
        arguments: channel);
    return false;
  }
  if (doctorInfo?.authStatus == 'WAIT_VERIFY' ||
      doctorInfo.authStatus == 'FAIL') {
    Navigator.pushNamed(context, RouteManagerOld.DOCTOR_AUTHENTICATION_PAGE);
    return false;
  }
  if (doctorInfo?.authStatus == 'VERIFYING') {
    Navigator.pushNamed(
        context, RouteManagerOld.DOCTOR_AUTH_STATUS_VERIFYING_PAGE);
    return false;
  }
  if (doctorInfo.authStatus == 'PASS') {
    Navigator.pushNamed(context, RouteManagerOld.DOCTOR_AUTH_STATUS_PASS_PAGE);
    return false;
  }

  return true;
}
