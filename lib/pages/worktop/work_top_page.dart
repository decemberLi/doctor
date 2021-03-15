import 'package:doctor/model/biz/learn_plan_statistical_entity.dart';
import 'package:doctor/model/ucenter/doctor_detail_info_entity.dart';
import 'package:doctor/pages/user/ucenter_view_model.dart';
import 'package:doctor/pages/worktop/learn/learn_list/learn_list_item_wiget.dart';
import 'package:doctor/pages/worktop/model/work_top_entity.dart';
import 'package:doctor/pages/worktop/resource/view_model/work_top_view_model.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/common_stack.dart';
import 'package:doctor/widgets/image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../root_widget.dart';
import 'learn/research_detail/research_detail.dart';

class WorktopPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WorktopPageState();
  }
}

class _WorktopPageState extends State<WorktopPage>
    with AutomaticKeepAliveClientMixin, RouteAware {
  final WorkTopViewModel _model = WorkTopViewModel();

  @override
  bool get wantKeepAlive => true;

  init() async {
    await _model.initData();
  }

  @override
  void initState() {
    this.init();
    super.initState();
  }

  @override
  void dispose() {
    print('work_top_dispose');
    _model.dispose();
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
    _model.initData();
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CommonStack(
      body: SafeArea(
        child: ChangeNotifierProvider<WorkTopViewModel>.value(
          value: _model,
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
                  failedIcon: const Icon(Icons.error, color: Colors.white),
                  completeIcon: const Icon(Icons.done, color: Colors.white),
                  idleIcon:
                      const Icon(Icons.arrow_downward, color: Colors.white),
                  releaseIcon: const Icon(Icons.refresh, color: Colors.white),
                ),
                onRefresh: model.refresh,
                controller: model.refreshController,
                child: bodyWidget(entity),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget bodyWidget(WorktopPageEntity entity) {
    _buildSliverBuildDelegate() {
      return SliverChildBuilderDelegate((context, index) {
        var item = entity.learnPlanList[index];
        return Container(
          color: Color(0xFFF3F5F8),
          child: LearnListItemWiget(
            item,
            'LEARNING',
            () {
              _model.initData();
            },
            () async {
              await Navigator.of(context).pushNamed(
                RouteManager.LEARN_DETAIL,
                arguments: {
                  'learnPlanId': item.learnPlanId,
                  'listStatus': 'LEARNING',
                  'from': 'work_top',
                },
              );
              // 无脑刷新数据，从详情页回来后不刷新数据
              // _model.initData();
            },
          ),
        );
      }, childCount: entity?.learnPlanList?.length ?? 0);
    }

    _buildEmptyContainer() {
      if (entity == null ||
          entity.learnPlanList == null ||
          entity.learnPlanList.length == 0) {
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
                _isLearnPlanEmpty(entity)
                    ? Container()
                    : Container(
                        width: double.infinity,
                        color: Color(0xFFF3F5F8),
                        padding: EdgeInsets.only(left: 16, top: 11, bottom: 10),
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

  doctorAvatarWidget(DoctorDetailInfoEntity doctorInfoEntity) {
    var avatar;
    if (doctorInfoEntity?.fullFacePhoto?.url != null) {
      avatar = ImageWidget(
        url: doctorInfoEntity.fullFacePhoto.url,
        width: 70,
        height: 70,
        fit: BoxFit.fill,
      );
    } else {
      avatar = Image.asset(
        "assets/images/doctorAva.png",
        width: 70,
        fit: BoxFit.fill,
      );
    }
    // 医生个人信息部分
    var doctorName = doctorInfoEntity?.doctorName ?? '';
    if (doctorInfoEntity?.basicInfoAuthStatus == 'NOT_COMPLETE') {
      doctorName = '待完善';
    }
    return GestureDetector(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            alignment: Alignment.center,
            child: doctorInfoEntity?.fullFacePhoto == null
                ? Image.asset(
                    "assets/images/doctorHeader.png",
                    width: 40,
                    height: 40,
                  )
                : Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(
                            '${doctorInfoEntity?.fullFacePhoto?.url}?status=${doctorInfoEntity?.fullFacePhoto?.ossId}'),
                      ),
                    ),
                  ),
            decoration: BoxDecoration(
              color: Colors.white,
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
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      doctorName,
                      style: TextStyle(
                          fontSize: 22,
                          color: ThemeColor.colorFF222222,
                          fontWeight: FontWeight.bold),
                    ),
                    if (doctorInfoEntity != null)
                      _buildAuthStatusWidget(doctorInfoEntity),
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
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, RouteManager.USERINFO_DETAIL,
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
              crossAxisAlignment: CrossAxisAlignment.baseline,
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

    _buildStaticsWidget(List<LearnPlanStatisticalEntity> lists) {
      var visitCount = 0;
      var surveyCount = 0;
      var meetingCount = 0;

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
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Container(
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
                      builder: (_, model, __) {
                        return doctorAvatarWidget(model.data);
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 24, top: 13),
                    child: Text(
                      "您收到了",
                      style: TextStyle(
                          color: Color(0xFF222222),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildStaticsWidget(entity?.learnPlanStatisticalEntity),
                  _showOperatorBtn(entity),
                ],
              ),
            ),
          ),
        ],
      ),
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
        type: _isLearnPlanEmpty(entity)
            ? AceButtonType.grey
            : AceButtonType.primary,
        onPressed: isEmpty ? () => {} : () => {_goLearnPlanPage(0)},
      ),
    );
  }

  _goLearnPlanPage(int index) async {
    await Navigator.pushNamed(context, RouteManager.LEARN_PAGE, arguments: {
      'index': index,
    });
    _model.refresh();
  }

  _buildAuthStatusWidget(DoctorDetailInfoEntity doctorInfoEntity) {
    return Container(
      width: 65,
      height: 20,
      margin: EdgeInsets.only(left: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: doctorInfoEntity?.identityStatus == 'PASS'
            ? Color(0xFFFAAD14)
            : Color(0xFFB9B9B9),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: FlatButton(
        onPressed: () {
          print(
              "the identityStatus is ${doctorInfoEntity?.identityStatus} - ${doctorInfoEntity?.authStatus} ");
          if (doctorInfoEntity?.identityStatus == 'PASS') {
            if (doctorInfoEntity?.authStatus == 'WAIT_VERIFY' ||
                doctorInfoEntity.authStatus == 'FAIL') {
              Navigator.pushNamed(
                  context, RouteManager.DOCTOR_AUTHENTICATION_PAGE);
            } else if (doctorInfoEntity.authStatus == 'VERIFYING') {
              Navigator.pushNamed(
                  context, RouteManager.DOCTOR_AUTH_STATUS_VERIFYING_PAGE);
            } else if (doctorInfoEntity.authStatus == 'PASS') {
              Navigator.pushNamed(
                  context, RouteManager.DOCTOR_AUTH_STATUS_PASS_PAGE);
            }
          } else {
            Navigator.pushNamed(
                context, RouteManager.DOCTOR_AUTHENTICATION_INFO_PAGE);
          }
        },
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              if (doctorInfoEntity?.identityStatus == 'PASS')
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
                text: doctorInfoEntity?.identityStatus == 'PASS' ? '已认证' : '未认证',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
