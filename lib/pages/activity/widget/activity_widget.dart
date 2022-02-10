import 'dart:convert';

import 'package:doctor/model/ucenter/doctor_detail_info_entity.dart';
import 'package:doctor/pages/activity/activity_constants.dart';
import 'package:doctor/pages/activity/entity/activity_entity.dart';
import 'package:doctor/pages/user/ucenter_view_model.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/new_text_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:yyy_route_annotation/yyy_route_annotation.dart';

class ActivityWidget extends StatelessWidget {
  final ActivityEntity _data;

  ActivityWidget(this._data);

  Color _statusColor(String status, bool disable) {
    if (disable) {
      return ThemeColor.colorFFD9D5D5;
    }
    if (status == STATUS_WAIT) {
      return ThemeColor.primaryColor;
    } else if (status == STATUS_EXECUTING) {
      return Color(0xFF5AC624);
    } else {
      return ThemeColor.colorFFD9D5D5;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoViewModel>(
      builder: (_, model, __) {
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.only(left: 20, top: 10),
            height: 150,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: ThemeColor.colorFF91C3FF, width: 1)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '活动·${activityName(_data.activityType)}',
                      style: TextStyle(
                          fontSize: 12,
                          color: ThemeColor.colorFF000000,
                          fontWeight: FontWeight.bold),
                    ),
                    LearnTextIcon(
                        text: activityStatus(_data.status, _data.disable),
                        color: _statusColor(_data.status, _data.disable),
                        margin: EdgeInsets.only(left: 10))
                  ],
                ),
                if (isLectureVideo(_data.activityType))
                  Container(
                    margin: EdgeInsets.only(top: 6),
                    padding: EdgeInsets.only(left: 4, right: 4, bottom: 1),
                    decoration: BoxDecoration(
                      color: Color(0xFF91C3FF),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          child: Image.asset(
                            'assets/images/video_record.png',
                            width: 10,
                            height: 8,
                          ),
                          margin: EdgeInsets.only(top: 1, right: 2),
                        ),
                        Text(
                          '录制视频',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                if (!isLectureVideo(_data.activityType))
                  Container(
                    margin: EdgeInsets.only(top: 6),
                    padding: EdgeInsets.only(left: 4, right: 4, bottom: 1),
                    decoration: BoxDecoration(
                      color: _data.activityType == TYPE_CASE_COLLECTION
                          ? Color(0xFF91C3FF)
                          : Color(0xFF52C41A),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          child: Image.asset(
                            _data.activityType == TYPE_CASE_COLLECTION
                                ? 'assets/images/act_img_upload_pic.png'
                                : 'assets/images/act_img_questions.png',
                            width: 10,
                            height: 8,
                          ),
                          margin: EdgeInsets.only(top: 1, right: 2),
                        ),
                        Text(
                          _data.activityType == TYPE_CASE_COLLECTION
                              ? '上传图片'
                              : '问卷',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                Container(
                  height: 5,
                  width: double.infinity,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              right: BorderSide(
                                  color: Color(0xFFF3F5F8), width: 1))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _data.activityName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Color(0xFF222222),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 12,
                            height: 12,
                          ),
                          Text(
                            '来自企业：${_data.companyName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12, color: ThemeColor.colorFF666666),
                          ),
                          Container(
                            width: 12,
                            height: 12,
                          ),
                          Text(
                            '截止日期：${_endTimeFormat(_data.endTime)} ',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12, color: ThemeColor.colorFF666666),
                          ),
                        ],
                      ),
                    )),
                    progressWidget(model.data)
                  ],
                )
              ],
            ),
          ),
          onTap: () async {
            print("====================++${_data.activityPackageId}");
            RouteManager.push(context,
                "yyy://page/activity_detail_page?activity_package_id=${_data.activityPackageId}&type=${_data.activityType}&remitChannel=${_data.remitChannel}");
          },
        );
      },
    );
  }

  Widget progressWidget(DoctorDetailInfoEntity entity) {
    if (entity?.authStatus == 'PASS') {
      double percent = (_data.schedule ?? 0) / 100;
      if (percent > 1) {
        percent = 1;
      }
      return Container(
        width: 108,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 8.0,
                animation: false,
                percent: percent,
                center: Text('${_data.schedule}%'),
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Color(0xFFDEDEE1),
                progressColor: ThemeColor.primaryColor,
              ),
            ),
            Text(
              "活动详情",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF107BFD),
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      );
    }

    return Container(
      width: 108,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Icon(
              Icons.lock,
              size: 40,
              color: ThemeColor.primaryColor,
            ),
          ),
          Text(
            "认证解锁",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF107BFD),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  String _endTimeFormat(int t) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(t);
    String hour = time.hour < 10 ? '${time.hour}' : "${time.hour}";
    String minute = time.minute < 10 ? '${time.minute}' : "${time.minute}";
    return '${time.year}年${time.month}月${time.day}日 $hour:$minute';
  }
}
