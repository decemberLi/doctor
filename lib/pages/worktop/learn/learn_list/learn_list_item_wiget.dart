import 'package:common_utils/common_utils.dart';
import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:doctor/widgets/new_text_icon.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/api.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';
import 'package:doctor/http/server.dart';

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
            MAP_RESOURCE_TYPE[resource.resourceType],
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

  LearnListItemWiget(this.item, this.listStatus);

  String timeRender() {
    if (this.item.taskTemplate == 'SALON' ||
        this.item.taskTemplate == 'DEPART') {
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

  Widget circleRender() {
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
      percent = 1;
      text = '查看学习内容';
      centerText = Icon(
        Icons.done,
        size: 40,
        color: ThemeColor.primaryColor,
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
      learn = FlatButton(
        onPressed: () {
          EasyLoading.instance.flash(
            () async {
              await API.shared.server.learnSubmit(
                {
                  'learnPlanId': item.learnPlanId,
                },
              );
              EasyLoading.showToast('提交成功');
            },
          );
        },
        child: learn,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
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

  Widget _buildItem() {
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
    if (listStatus == 'HISTORY') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              taskTemplateWidget,
              resourceTypeListWiget,
              SizedBox(
                height: 6,
              ),
              taskNameWidget,
              SizedBox(
                height: 6,
              ),
              representNameWidget,
            ],
          ),
          Container(
            width: 108,
            child: circleRender(),
          ),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          taskTemplateWidget,
          if (item.reLearn)
            LearnTextIcon(
              text: item.taskTemplate == 'DOCTOR_LECTURE' ? '需重新上传' : '再次拜访',
              color: Color(0xffF6A419),
            ),

          // 新
          if (item.status == 'WAIT_LEARN') LearnTextIcon(),
        ]),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              resourceTypeListWiget,
              if (this.item.taskTemplate == 'SALON' ||
                  this.item.taskTemplate == 'DEPART')
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
                      style: TextStyle(color: Color(0xFF666666), fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 108,
              child: circleRender(),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: _buildItem(),
    );
  }
}
