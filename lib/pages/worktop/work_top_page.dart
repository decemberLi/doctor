import 'dart:async';

import 'package:doctor/http/session_manager.dart';
import 'package:doctor/pages/login/model/login_info.dart';
import 'package:doctor/pages/worktop/learn/learn_list/learn_list_item_wiget.dart';
import 'package:doctor/pages/worktop/model/work_top_entity.dart';
import 'package:doctor/pages/worktop/service.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/common_stack.dart';
import 'package:doctor/widgets/dashed_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'model/doctor_info_entity.dart';
import 'model/learn_plan_statistical_entity.dart';

class WorktopPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WorktopPageState();
  }
}

class _WorktopPageState extends State<WorktopPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final StreamController<WorktopPageEntity> _controller =
      StreamController<WorktopPageEntity>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    LoginInfoModel loginInfo = SessionManager.getLoginInfo();
    if (loginInfo.authStatus == 'WAIT_VERIFY') {
      WidgetsBinding.instance.addPostFrameCallback((callback) {
        _showGoToQualificationDialog();
      });
    } else {
      _refreshData();
    }
    super.initState();
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
          ],
        );
      },
    );
  }

  _refreshData() async {
    WorktopPageEntity data = await obtainWorktopData();
    _controller.sink.add(data);
    _refreshController.loadComplete();
  }

  @override
  void dispose() {
    print("dispose");
    if (!_controller.isClosed) {
      _controller.close();
    }
    if (_refreshController != null) {
      _refreshController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CommonStack(
      body: SmartRefresher(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _refreshController,
        onRefresh: _refreshData,
        child: StreamBuilder(
          stream: _controller.stream,
          builder: (BuildContext context,
              AsyncSnapshot<WorktopPageEntity> snapshot) {
            return bodyWidget(snapshot.data);
          },
        ),
      ),
    );
  }

  Widget bodyWidget(WorktopPageEntity entity) {
    return ListView(
      children: [
        cardPart(entity),
        Container(
          color: Color(0xFFF3F5F8),
          margin: EdgeInsets.only(left: 16, right: 16),
          padding: EdgeInsets.only(top: 12, bottom: 10),
          child: const Text(
            "最近收到",
            style: TextStyle(
                fontSize: 12,
                color: Color(0xFF222222),
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          color: Color(0xFFF9FCFF),
          margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: learnPlan(entity),
        )
      ],
    );
  }

  Widget learnPlan(WorktopPageEntity entity) {
    if (entity == null || entity.learnPlanList == null) {
      print("entity || entity.learnPlanList is null ");
      return Container();
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: entity.learnPlanList.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return LearnListItemWiget(entity.learnPlanList[index], 'LEARNING');
      },
    );
  }

  doctorInfoWidget(DoctorInfoEntity doctorInfoEntity) {
    // 医生个人信息部分
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: DashedDecoration(dashedColor: ThemeColor.colorFF222222),
          child: Image.asset("assets/images/avatar.png"),
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
                  Text(
                    doctorInfoEntity?.jobGradeName ?? '',
                    style: TextStyle(
                        fontSize: 12,
                        color: ThemeColor.colorFF222222,
                        fontWeight: FontWeight.bold),
                  ),
                ],
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
      widgets.add(Expanded(child: staticsData('拜访', visitCount)));
      widgets.add(Expanded(child: staticsData('调研', surveyCount)));
      widgets.add(Expanded(child: staticsData('会议', meetingCount)));

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
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 12),
                  child: AceButton(
                    text: "处理一下",
                    onPressed: () =>
                        {Navigator.pushNamed(context, RouteManager.LEARN_PAGE)},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
