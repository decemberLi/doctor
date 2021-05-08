import 'package:doctor/pages/activity/activity_constants.dart';
import 'package:doctor/pages/activity/entity/activity_entity.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/new_text_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ActivityWidget extends StatelessWidget {
  final ActivityEntity _data;
  final bool _isAuth;

  ActivityWidget(this._data, this._isAuth);

  Color _statusColor(String status) {
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
    return Container(
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
                  text: activityStatus(_data.status),
                  color: _statusColor(_data.status),
                  margin: EdgeInsets.only(left: 10))
            ],
          ),
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
                  _data.activityType == TYPE_CASE_COLLECTION ? '上传图片' : '问卷',
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
              Container(
                padding: EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        right: BorderSide(color: Color(0xFFF3F5F8), width: 1))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _data.activityName,
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
                      style: TextStyle(
                          fontSize: 12, color: ThemeColor.colorFF666666),
                    ),
                    Container(
                      width: 12,
                      height: 12,
                    ),
                    Text(
                      '截止日期：${_endTimeFormat(_data.endTime)} ',
                      style: TextStyle(
                          fontSize: 12, color: ThemeColor.colorFF666666),
                    ),
                  ],
                ),
              ),
              progressWidget()
            ],
          )
        ],
      ),
    );
  }

  Widget progressWidget() {
    if (_isAuth) {
      return Container(
        width: 60,
        margin: EdgeInsets.only(left: 16),
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 60.0,
              lineWidth: "HISTORY" == 'HISTORY' ? 5 : 8.0,
              animation: false,
              percent: _data.schedule / 100,
              center: Text('${_data.schedule}%'),
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: Color(0xFFDEDEE1),
              progressColor: ThemeColor.primaryColor,
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
      width: 60,
      margin: EdgeInsets.only(left: 16),
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
