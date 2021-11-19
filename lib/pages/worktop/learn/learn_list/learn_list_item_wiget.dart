import 'package:common_utils/common_utils.dart';
import 'package:doctor/common/statistics/biz_tracker.dart';
import 'package:doctor/http/server.dart';
import 'package:doctor/pages/user/ucenter_view_model.dart';
import 'package:doctor/pages/user/ucenter_view_model.dart';
import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';
import 'package:doctor/widgets/new_text_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/api.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

/// 渲染资源列表
class ResourceTypeListWiget extends StatelessWidget {
  final List<ResourceTypeResult> resourceTypeList;

  ResourceTypeListWiget(this.resourceTypeList);

  Widget renderResourceType(ResourceTypeResult resource) {
    Color textColor = Colors.white;
    Color decorationColor = Color(0xFFDEDEE1);
    IconData icon = Icons.access_time;
    if (resource.complete) {
      icon = Icons.done;
      decorationColor = Color(0xFF25CDA1);
    }
    var type = MAP_RESOURCE_TYPE[resource.resourceType];
    if (type == null){
      type = "问卷";
      print("the type is ${resource.resourceType}");
    }
    return Container(
      decoration: BoxDecoration(
        color: decorationColor,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
      margin: EdgeInsets.only(right: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 12,
            color: textColor,
          ),
          SizedBox(
            width: 3,
          ),
          Text(
           type,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: resourceTypeList.map((e) => renderResourceType(e)).toList(),
      ),
    );
  }
}

/// 学习计划列表项
class LearnListItemWiget extends StatelessWidget {
  final LearnListItem item;
  final String listStatus;
  final Function onSubmit;
  final Function gotoDetail;
  final EdgeInsetsGeometry margin;

  LearnListItemWiget(this.item, this.listStatus, this.onSubmit,this.gotoDetail,{this.margin});

  String timeRender() {
    if (this.item.taskTemplate == 'SALON' ||
        this.item.taskTemplate == 'DEPART'|| this.item.taskTemplate == "PRODUCT_PROFESSIONAL_SHARE" ||
        this.item.taskTemplate == "PRODUCT_DOCTOR_EDUCATION") {
      DateTime now = DateTime.now();
      if (now.millisecondsSinceEpoch < this.item.meetingStartTime) {
        Duration duration =
            DateTime.fromMillisecondsSinceEpoch(this.item.meetingStartTime)
                .difference(now);
        return '距离会议开始时间：${duration.inDays}天 ${duration.inHours - 24 * duration.inDays}小时 ' +
            '${duration.inMinutes - 60 * duration.inHours}分钟';
      }
    }
    return '截止日期：${DateUtil.formatDateMs(item.planImplementEndTime, format: 'yyyy年MM月dd日')}';
  }

  Widget circleRender(BuildContext context, bool needAuth) {
    double percent = 0;
    String text = '开始学习';
    if (this.item.learnProgress >= 100 &&
        this.item.taskTemplate != "DOCTOR_LECTURE") {
      percent = 1;
      text = '立即提交';
    } else if (this.item.learnProgress > 0) {
      percent = this.item.learnProgress / 100;
      text = '继续学习';
    }
    Widget centerText = Text(
      "${this.item.learnProgress}%",
      style: TextStyle(color: ThemeColor.primaryColor, fontSize: 14.0),
    );
    if (listStatus == 'HISTORY') {
      percent = 0;
      text = '查看学习内容';
      centerText = Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Icon(
          Icons.check_circle_outline_rounded,
          size: 20,
          color: ThemeColor.primaryColor,
        ),
      );
    } else if (needAuth && item.taskTemplate == "MEDICAL_SURVEY") {
      percent = 0;
      text = "认证解锁";
      centerText = Container(
        margin: EdgeInsets.only(bottom: 15),
        child: Icon(
          Icons.lock,
          size: 40,
          color: ThemeColor.primaryColor,
        ),
      );
    }
    Widget learn = Text(
      text,
      style: TextStyle(
          color: ThemeColor.primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.bold),
    );
    if (text == "立即提交") {
      learn = TextButton(
        onPressed: () {

          EasyLoading.instance.flash(
            () async {
              await API.shared.server.learnSubmit(
                {
                  'learnPlanId': item.learnPlanId,
                },
              );
              UserInfoViewModel model = Provider.of<UserInfoViewModel>(context, listen: false);
              eventTracker(Event.PLAN_SUBMIT, {
                "learn_plan_id":"${item?.learnPlanId}",
                "user_id":"${model?.data?.doctorUserId}"
              });
              if (this.onSubmit != null) {
                this.onSubmit();
              }
              EasyLoading.showToast('提交成功');
            },
          );
        },
        child: learn,
      );
    }
    var showAuth = needAuth && item.taskTemplate == "MEDICAL_SURVEY";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        showAuth || listStatus == "HISTORY"
            ? centerText
            : Container(
                width: 66,
                height: 70,
                margin: EdgeInsets.only(bottom: 2),
                child: CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: listStatus == 'HISTORY' ? 5 : 8.0,
                  animation: false,
                  percent: percent,
                  center: centerText,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Color(0xFFDEDEE1),
                  progressColor: ThemeColor.primaryColor,
                ),
              ),
        learn,
      ],
    );
  }

  // 会议进行中
  Widget _meetingStatus(int end, num start) {
    if (listStatus == 'HISTORY') {
      return Container();
    }
    Color rendColor = Color(0xffF6A419);
    String text = '会议进行中';
    int time = new DateTime.now().millisecondsSinceEpoch;
    if (time > end) {
      text = '会议已结束';
      rendColor = Color(0xFFDEDEE1);
    }
    if (time < start) {
      // text = '会议未开始';
      // rendColor = Color(0xFFDEDEE1);
      return Container();
    }
    return LearnTextIcon(
      text: text,
      color: rendColor,
      margin: EdgeInsets.only(right: 16, bottom: 6, left: 10),
    );
  }

  Widget _buildItem(BuildContext context) {
    Widget taskTemplateWidget = Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: 10),
      child: Text(
        TASK_TEMPLATE[item.taskTemplate],
        style: TextStyle(
            color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
    Widget resourceTypeListWiget =
        ResourceTypeListWiget(item.resourceTypeResult);
    Widget taskNameWidget = Text(
      item.taskName,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      softWrap: true,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    Widget representNameWidget = Text(
      '医学信息推广专员：${item.representName}',
      style: TextStyle(color: Color(0xFF666666), fontSize: 12),
    );
    var info = "";

    if (item?.illnessCase?.sex != null ){
      var sexValue = item?.illnessCase?.sex ?? 0;
      var sex = "男";
      if (sexValue == 0) {
        sex = "女";
      }
      info += sex;
    }
    var age = item?.illnessCase?.age ?? 0;
    if (age > 0) {
      if (info.length > 0) info += "|";
      info += "${item.illnessCase.age}";
    }
    var nameLength = item?.illnessCase?.patientName?.length ?? 0;
    if ( nameLength > 0) {
      if (info.length > 0) info += "|";
      info += item.illnessCase.patientName;
    }
    var taskText = "";
    if (item.taskTemplate == "DOCTOR_LECTURE") {
      taskText = '需重新上传';
    }else if (item.taskTemplate == "MEDICAL_SURVEY") {
      taskText = '继续调研';
    }else{
      taskText = '再次拜访';
    }
    var showReLearn = (item.status != "SUBMIT_LEARN" && item.status != "ACCEPTED");
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            taskTemplateWidget,
            if (item.reLearn && showReLearn)
              LearnTextIcon(
                text: taskText,
                color: Color(0xffF6A419),
              ),

            // 新
            if (item.status == 'WAIT_LEARN') LearnTextIcon(),
            Expanded(child: Container()),
            if (item.taskTemplate == 'MEDICAL_SURVEY')
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 5,right: 25),
              child: Text(
                info,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff444444),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              resourceTypeListWiget,
              if (this.item.taskTemplate == 'SALON' ||
                  this.item.taskTemplate == 'DEPART' || this.item.taskTemplate == "PRODUCT_PROFESSIONAL_SHARE" ||
                  this.item.taskTemplate == "PRODUCT_DOCTOR_EDUCATION")
                _meetingStatus(
                    this.item.meetingEndTime, this.item.meetingStartTime),
            ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: ThemeColor.colorFFF3F5F8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 4,
                    ),
                    taskNameWidget,
                    SizedBox(
                      height: 12,
                    ),
                    representNameWidget,
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      timeRender(),
                      style: TextStyle(color: Color(0xFF666666), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 108,
              child: Consumer<UserInfoViewModel>(
                builder: (_, model, __) {
                  return circleRender(context, model?.data?.authStatus != 'PASS');
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var content = Container(
      alignment: Alignment.centerLeft,
      margin: margin == null ?EdgeInsets.fromLTRB(16, 0, 16, 16): margin,
      padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: _buildItem(context),
    );
    return GestureDetector(
      onTap: (){
        UserInfoViewModel model = Provider.of<UserInfoViewModel>(context, listen: false);
        bool needAuth = model?.data?.authStatus != 'PASS';
        if (needAuth && item.taskTemplate == "MEDICAL_SURVEY") {
          if (model?.data?.identityStatus == 'PASS') {
            if (model?.data?.authStatus == 'WAIT_VERIFY' ||
                model?.data?.authStatus == 'FAIL') {
              Navigator.pushNamed(
                  context, RouteManagerOld.DOCTOR_AUTHENTICATION_PAGE);
            } else if (model?.data?.authStatus == 'VERIFYING') {
              Navigator.pushNamed(
                  context, RouteManagerOld.DOCTOR_AUTH_STATUS_VERIFYING_PAGE);
            } else if (model?.data?.authStatus == 'PASS') {
              Navigator.pushNamed(
                  context, RouteManagerOld.DOCTOR_AUTH_STATUS_PASS_PAGE);
            }
          } else {
            Navigator.pushNamed(
                context, RouteManagerOld.DOCTOR_AUTHENTICATION_INFO_PAGE);
          }
        }else if (this.gotoDetail != null){
          this.gotoDetail();
        }
      },
      child: content,
    );
  }
}
