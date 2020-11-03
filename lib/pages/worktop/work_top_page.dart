import 'dart:async';

import 'package:doctor/http/session_manager.dart';
import 'package:doctor/model/biz/learn_plan_statistical_entity.dart';
import 'package:doctor/model/ucenter/doctor_detail_info_entity.dart';
import 'package:doctor/pages/login/model/login_info.dart';
import 'package:doctor/pages/worktop/learn/learn_list/learn_list_item_wiget.dart';
import 'package:doctor/pages/worktop/model/work_top_entity.dart';
import 'package:doctor/pages/worktop/resource/view_model/work_top_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/common_stack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WorktopPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WorktopPageState();
  }
}

class _WorktopPageState extends State<WorktopPage>
    with AutomaticKeepAliveClientMixin {
  final WorkTopViewModel _model = WorkTopViewModel();

  @override
  bool get wantKeepAlive => true;

  init() async {
    await _model.initData();
    WorktopPageEntity entity = _model?.list != null && _model?.list.length >= 1
        ? _model.list[0]
        : null;
    if (entity?.doctorInfoEntity != null &&
        entity.doctorInfoEntity.basicInfoAuthStatus == 'NOT_COMPLETE') {
      _showGoToQualificationDialog();
    }
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
    super.dispose();
  }

  /// 显示完善信息弹窗
  Future<bool> _showGoToQualificationDialog() {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Container(
            padding: EdgeInsets.only(top: 12),
            child: Text("您还没有完善医生基础信息"),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "退出登录",
                style: TextStyle(
                  color: ThemeColor.primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                SessionManager.loginOutHandler();
              },
            ),
            FlatButton(
              child: Text(
                "现在去完善",
                style: TextStyle(
                  color: ThemeColor.primaryColor,
                ),
              ),
              onPressed: () {
                //关闭对话框并返回true
                // Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamed(RouteManager.QUALIFICATION_PAGE);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CommonStack(
      body: ChangeNotifierProvider<WorkTopViewModel>.value(
        value: _model,
        child: Consumer<WorkTopViewModel>(
          builder: (context, model, child) {
            WorktopPageEntity entity =
                model?.list != null && model?.list.length >= 1
                    ? model.list[0]
                    : null;
            return SmartRefresher(
              physics: AlwaysScrollableScrollPhysics(),
              header: ClassicHeader(),
              onRefresh: model.refresh,
              controller: model.refreshController,
              child: bodyWidget(entity),
            );
          },
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
          child: GestureDetector(
            onTap: () async {
              await Navigator.of(context).pushNamed(
                RouteManager.LEARN_DETAIL,
                arguments: {
                  'learnPlanId': item.learnPlanId,
                  'listStatus': 'LEARNING',
                },
              );
              // 从详情页回来后刷新数据
              _model.initData();
            },
            child: LearnListItemWiget(item, 'LEARNING'),
          ),
        );
      }, childCount: entity?.learnPlanList?.length ?? 0);
    }

    _buildEmptyContainer() {
      if (entity == null ||
          entity.learnPlanList == null ||
          entity.learnPlanList.length == 0) {
        return ViewStateEmptyWidget(
          message: '暂无学习计划',
        );
      } else {
        return Container();
      }
    }

    return CustomScrollView(
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
                        padding: EdgeInsets.only(left: 16, top: 12),
                        child: const Text(
                          "最近收到",
                          style: TextStyle(
                              fontSize: 12,
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

  doctorInfoWidget(DoctorDetailInfoEntity doctorInfoEntity) {
    // 医生个人信息部分
    return GestureDetector(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // decoration: DashedDecoration(dashedColor: ThemeColor.colorFF222222),
            child: Image.asset(
              "assets/images/avatar.png",
              width: 80,
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Text(doctorInfoEntity?.doctorName ?? '',
                        style: TextStyle(
                            fontSize: 22,
                            color: ThemeColor.colorFF222222,
                            fontWeight: FontWeight.bold)),
                    _buildAuthStatusWidget(doctorInfoEntity),
                  ],
                ),
                Text(
                  doctorInfoEntity?.jobGradeName ?? '',
                  style: TextStyle(
                      fontSize: 12,
                      color: ThemeColor.colorFF222222,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
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
        padding: EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text ?? '',
              style: TextStyle(fontSize: 12, color: ThemeColor.primaryColor),
            ),
            Row(
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

    List<Widget> convertStatics(List<LearnPlanStatisticalEntity> lists) {
      List<Widget> widgets = [];
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
      widgets.add(Expanded(
          child: GestureDetector(
        child: staticsData('拜访', visitCount),
        onTap: () {
          _goLearnPlanPage(2);
        },
      )));
      widgets.add(Expanded(
          child: GestureDetector(
        child: staticsData('会议', meetingCount),
        onTap: () {
          _goLearnPlanPage(1);
        },
      )));
      widgets.add(Expanded(
          child: GestureDetector(
        child: staticsData('调研', surveyCount),
        onTap: () {
          _goLearnPlanPage(3);
        },
      )));
      return widgets;
    }

    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(24, 16, 16, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                doctorInfoWidget(entity?.doctorInfoEntity),
                Container(
                  margin: EdgeInsets.only(top: 13),
                  child: Text(
                    "您收到了",
                    style: TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 18),
                  child: Row(
                      children:
                          convertStatics(entity?.learnPlanStatisticalEntity)),
                ),
                _showOperatorBtn(entity),
              ],
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
    bool isEmpty = true;
    for (var each in list) {
      if (each.unSubmitNum != 0) {
        return false;
      }
    }
    return true;
  }

  Container _showOperatorBtn(WorktopPageEntity entity) {
    if (_isLearnPlanEmpty(entity)) {
      return Container(
        margin: EdgeInsets.only(top: 20, bottom: 12),
        child: AceButton(
          color: ThemeColor.colorFFBCBCBC,
          text: "暂无待处理学习计划",
          onPressed: () {},
        ),
      );
    }
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 12),
      child: AceButton(
        text: "处理一下",
        onPressed: () => {_goLearnPlanPage(0)},
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
      width: 80,
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
              text: doctorInfoEntity?.authStatus == 'PASS' ? '资质认证' : '尚未认证',
            ),
          ],
        ),
      ),
    );
  }
}
