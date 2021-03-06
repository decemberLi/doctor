import 'package:doctor/http/server.dart';
import 'package:doctor/pages/worktop/learn/model/learn_detail_model.dart';
import 'package:doctor/pages/worktop/learn/view_model/learn_view_model.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/manager.dart';
import 'package:provider/provider.dart';

/// 渲染列表
class PlanDetailList extends StatelessWidget {
  final data;

  PlanDetailList(this.data);

  Widget typeDecoratedBox(String type) {
    Color rendColor = ThemeColor.color72c140;
    if (type == 'VIDEO') {
      rendColor = ThemeColor.color5d9df7;
    } else if (type == 'QUESTIONNAIRE') {
      rendColor = ThemeColor.colorefaf41;
    }
    return DecoratedBox(
        decoration: BoxDecoration(color: rendColor),
        child: Padding(
          // 分别指定四个方向的补白
          padding: const EdgeInsets.fromLTRB(30, 1, 30, 1),
          child: Text(MAP_RESOURCE_TYPE[type],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white,
              )),
        ));
  }

  // 头部状态
  Widget learnStatusType(
      String resourceType, String status, String taskTemplate, dynamic item) {
    Color rendColor = Color(0xFFDEDEE1);
    String text = '待浏览';
    IconData icon = Icons.access_time;

    if (resourceType == 'ARTICLE') {
      if (item.learnTime >= item.needLearnTime) {
        text = '浏览时长：${item.learnTime}s';
        icon = Icons.done;
        rendColor = ThemeColor.colorFFf25CDA1;
      } else {
        text = item.learnTime <= 0 ? '待浏览' : '浏览时长：${item.learnTime}s';
      }
    } else if (resourceType == 'VIDEO') {
      if (item.learnTime >= item.needLearnTime) {
        text = '观看时长：${item.learnTime}s';
        icon = Icons.done;
        rendColor = ThemeColor.colorFFf25CDA1;
      } else {
        text = item.learnTime <= 0 ? '待观看' : '观看时长：${item.learnTime}s';
      }
    } else if (resourceType == 'QUESTIONNAIRE') {
      if (item.status == 'FINISHED') {
        text = '已完成';
      } else {
        text = '待完成';
      }
    }

    // 录制视频只有一个状态-完成条件只有一个：上传讲课视频
    if (taskTemplate == 'DOCTOR_LECTURE') {
      text = '上传讲课视频';
      if (item.status != null && item.status == 'FINISHED') {
        icon = Icons.done;
        rendColor = ThemeColor.colorFFf25CDA1;
      }
    }
    if (item.status != null && item.status == 'FINISHED') {
      icon = Icons.done;
      rendColor = ThemeColor.colorFFf25CDA1;
    }

    return Container(
        decoration: BoxDecoration(
          color: rendColor,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        padding: EdgeInsets.only(left: 4, right: 4),
        margin: EdgeInsets.only(right: 4, bottom: 10),
        child: Row(
          children: [
            Icon(
              icon,
              size: 12,
              color: Colors.white,
            ),
            SizedBox(
              width: 3,
            ),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ));
  }

  // 反馈
  Widget learnFeedback(dynamic item) {
    Color rendColor = Color(0xFFDEDEE1);
    String text = '反馈';
    IconData icon = Icons.access_time;

    if (item.resourceType == 'QUESTIONNAIRE') {
      return Text('');
    }

    if (item.feedback != null) {
      icon = Icons.done;
      rendColor = ThemeColor.colorFFf25CDA1;
    }

    return Container(
        decoration: BoxDecoration(
          color: rendColor,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        padding: EdgeInsets.only(left: 4, right: 4),
        margin: EdgeInsets.only(right: 4, bottom: 10),
        child: Row(
          children: [
            Icon(
              icon,
              size: 12,
              color: Colors.white,
            ),
            SizedBox(
              width: 3,
            ),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ));
  }

  //数字格式化，将 0~9 的时间转换为 00~09
  formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  // 视频时长
  Widget _durationBox(int duration) {
    int hour = duration ~/ 3600;
    int minute = duration % 3600 ~/ 60;
    int second = duration % 60;
    return Container(
        decoration: BoxDecoration(
          color: Color(0xFF1a3537),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: EdgeInsets.all(2),
        margin: EdgeInsets.only(right: 4, bottom: 10),
        child: Row(
          children: [
            SizedBox(
              width: 3,
            ),
            Text(
              formatTime(hour) +
                  ":" +
                  formatTime(minute) +
                  ":" +
                  formatTime(second),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ));
  }

  // 标题
  Widget learnTitle(String resourceType, dynamic item) {
    String titleShow = '标题';
    String summaryShow = '资料中包含一个附件，请在详情中查看';
    if (item.title == null) {
      titleShow = item.resourceName;
    } else {
      titleShow = item.title;
    }
    if (item.info != null && item.info.summary != null) {
      summaryShow = item.info.summary;
    }
    if (resourceType == 'ATTACHMENT') {
      summaryShow = '资料中包含一个附件，请在详情中查看';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleShow,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF222222),
            fontWeight: FontWeight.w600,
          ),
          // textAlign: TextAlign.left,
          softWrap: true,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          summaryShow,
          style: TextStyle(color: Color(0xFF444444), fontSize: 10),
          softWrap: true,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget resourcesList(
      LearnDetailItem data, Iterable resources, BuildContext context) {
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    if (resources.isEmpty) {
      content = new Column(
          children: tiles //重点在这里，因为用编辑器写Column生成的children后面会跟一个<Widget>[]，
          );
      return content;
    }
    for (var item in resources) {
      tiles.add(new GestureDetector(
          onTap: () async {
            //是会议类型
            bool isMeetingType = data.taskTemplate == 'SALON' ||
                data.taskTemplate == 'DEPART' ||
                data.taskTemplate == "PRODUCT_PROFESSIONAL_SHARE" ||
                data.taskTemplate == "PRODUCT_DOCTOR_EDUCATION";
            num nowDate = DateTime.now().millisecondsSinceEpoch;
            // 如果是会议类型，未到会议开始时间不能跳转资源页面
            if (isMeetingType &&
                data.meetingStartTime != null &&
                nowDate < data.meetingStartTime) {
              EasyLoading.showToast('当前会议尚未开始,请在会议期间打开');
              return;
            }
            final result = await Navigator.of(context)
                .pushNamed(RouteManagerOld.RESOURCE_DETAIL, arguments: {
              "learnPlanId": data.learnPlanId,
              "resourceId": item.resourceId,
              "taskTemplate": data.taskTemplate,
              "meetingStartTime": isMeetingType ? data.meetingStartTime : null,
              "meetingEndTime": isMeetingType ? data.meetingEndTime : null,
              "taskDetailId": data.taskDetailId,
            });
            if (data.taskTemplate != 'DOCTOR_LECTURE') {
              ///提交学习时间
              if (result != null) {
                await API.shared.server.updateLearnTime(result);
              }
            }
            LearnDetailViewModel _model =
                Provider.of<LearnDetailViewModel>(context, listen: false);

            _model.initData();
          },
          child: Container(
              margin: EdgeInsets.only(bottom: 12),
              // margin: EdgeInsets.only(left: 20, top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Stack(
                alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
                children: <Widget>[
                  Positioned(
                    left: -52,
                    top: -28,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Transform(
                          //对齐方式
                          alignment: Alignment.topRight,
                          //设置扭转值
                          transform: Matrix4.rotationZ(-0.9),
                          //设置被旋转的容器
                          child: typeDecoratedBox(item.resourceType)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(
                                left: 34, top: 20, bottom: 10, right: 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      learnStatusType(item.resourceType,
                                          data.status, data.taskTemplate, item),
                                      if (data.taskTemplate != 'DOCTOR_LECTURE')
                                        learnFeedback(item),
                                    ],
                                  ),
                                  Row(children: [
                                    Expanded(
                                        child: learnTitle(
                                            item.resourceType, item)),
                                    if (item.thumbnailUrl != null)
                                      Container(
                                          margin: EdgeInsets.only(left: 12),
                                          child:
                                              Stack(alignment: Alignment.center,
                                                  //指定未定位或部分定位widget的对齐方式
                                                  children: <Widget>[
                                                Image.network(item.thumbnailUrl,
                                                    width: 90,
                                                    height: 50,
                                                    fit: BoxFit.cover),
                                                if (item.resourceType ==
                                                    'VIDEO')
                                                  Positioned(
                                                    right: 4,
                                                    bottom: -10,
                                                    child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 6),
                                                        child: _durationBox(item
                                                            .info.duration)),
                                                  ),
                                              ])),
                                  ])
                                ])),
                      ),
                    ],
                  ),
                ],
              ))));
    }
    content = new Column(
        children: tiles //重点在这里，因为用编辑器写Column生成的children后面会跟一个<Widget>[]，
        );
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: resourcesList(data, data.resources, context));
    // return Container(child: resourcesList(data.resources,context));
  }
}
