import 'package:common_utils/common_utils.dart';
import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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
      padding: EdgeInsets.only(left: 4, right: 4),
      margin: EdgeInsets.only(right: 4),
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
        Duration duration = now.difference(
            DateTime.fromMillisecondsSinceEpoch(this.item.meetingStartTime));
        return '距离会议开始时间：${duration.inDays}天${duration.inHours - 24 * duration.inDays}小时' +
            '${duration.inMinutes - 60 * duration.inHours}分钟';
      }
    }
    return '收到学习计划时间：${DateUtil.formatDateMs(item.createTime, format: 'yyyy年MM月dd HH:mm')}';
  }

  Widget circleRender() {
    double percent = 0;
    String text = '开始学习';
    if (this.item.learnProgress > 0) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 66,
          height: 66,
          margin: EdgeInsets.only(bottom: 8),
          // child: CircularProgressIndicator(
          //   backgroundColor: Color(0xFFDEDEE1),
          //   value: 0.3,
          //   valueColor: new AlwaysStoppedAnimation<Color>(
          //       ThemeColor.colorFF4FD7C8),
          //   strokeWidth: 8,
          // ),
          child: CircularPercentIndicator(
            radius: 60.0,
            lineWidth: 6.0,
            animation: false,
            percent: percent,
            center: centerText,
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: Color(0xFFDEDEE1),
            progressColor: ThemeColor.primaryColor,
          ),
        ),
        Text(
          text,
          style: TextStyle(color: ThemeColor.primaryColor, fontSize: 14),
        ),
      ],
    );
  }

  // 会议进行中
  Widget _meetingStatus(int end) {
    Color rendColor = Color(0xffF6A419);
    String text = '会议进行中';
    int time = new DateTime.now().millisecondsSinceEpoch;
    if (time > end) {
      text = '会议已结束';
      rendColor = Color(0xFFDEDEE1);
    }
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
      margin: EdgeInsets.only(right: 16, bottom: 6, left: 10),
      decoration: BoxDecoration(
        color: rendColor,
        boxShadow: [
          BoxShadow(color: rendColor, offset: Offset(2.0, 2.0), blurRadius: 4.0)
        ],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
            bottomRight: Radius.circular(28)),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: ThemeColor.colorFFFFFF,
            fontSize: 12,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(RouteManager.LEARN_DETAIL, arguments: {
          "learnPlanId": item.learnPlanId,
          "listStatus": listStatus,
        });
        // Navigator.of(context).pushNamed(RouteManager.RESOURCE_DETAIL);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  TASK_TEMPLATE[item.taskTemplate],
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
              if (item.reLearn)
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                  margin: EdgeInsets.only(bottom: 10, left: 10),
                  decoration: BoxDecoration(
                    color: Color(0xffF6A419),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xffF6A419),
                          offset: Offset(2.0, 2.0),
                          blurRadius: 4.0)
                    ],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                        bottomRight: Radius.circular(28)),
                  ),
                  child: Text(
                    item.taskTemplate == 'DOCTOR_LECTURE' ? '需重新上传' : '再次拜访',
                    style: TextStyle(
                        color: ThemeColor.colorFFFFFF,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              // 新
              if (item.status == 'WAIT_LEARN')
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                  margin: EdgeInsets.only(bottom: 10, left: 10),
                  decoration: BoxDecoration(
                    color: ThemeColor.primaryColor,
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xff3AA7FF),
                          offset: Offset(2.0, 2.0),
                          blurRadius: 4.0)
                    ],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                        bottomRight: Radius.circular(28)),
                  ),
                  child: Text(
                    '新',
                    style: TextStyle(
                        color: ThemeColor.colorFFFFFF,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
            ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ResourceTypeListWiget(item.resourceTypeResult),
                  if (this.item.taskTemplate == 'SALON' ||
                      this.item.taskTemplate == 'DEPART')
                    _meetingStatus(this.item.meetingEndTime),
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
                      children: [
                        Text(
                          item.taskName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '医学信息推广专员：${item.representName}',
                          style:
                              TextStyle(color: Color(0xFF666666), fontSize: 12),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          timeRender(),
                          style:
                              TextStyle(color: Color(0xFF666666), fontSize: 10),
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
        ),
      ),
    );
  }
}
