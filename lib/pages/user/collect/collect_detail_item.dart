import 'package:doctor/route/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/theme/theme.dart';

import 'model/collect_list_model.dart';

/// 渲染列表
class CollectDetailItem extends StatelessWidget {
  final data;
  CollectDetailItem(this.data);
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
            fontSize: 16,
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
          style: TextStyle(color: Color(0xFF666666), fontSize: 14),
          softWrap: true,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget resourcesList(CollectResources item, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(RouteManager.RESOURCE_DETAIL, arguments: {
          "resourceId": item.resourceId,
          "favoriteId": item.favoriteId,
        });
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
              left: -48,
              top: -28,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Transform(
                    //对齐方式
                    alignment: Alignment.topRight,
                    //设置扭转值
                    transform: Matrix4.rotationZ(-0.8),
                    //设置被旋转的容器
                    child: typeDecoratedBox(item.resourceType)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 30, top: 20, bottom: 10),
                    child: learnTitle(item.resourceType, item),
                  ),
                ),
                Row(children: [
                  if (item.thumbnailUrl != null)
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 14),
                      child: Image.network(item.thumbnailUrl,
                          width: 108, height: 70, fit: BoxFit.cover),
                    ),
                ]),
              ],
            ),
            if (item.resourceType == 'VIDEO')
              Positioned(
                right: 14,
                bottom: -5,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: _durationBox(item.info.duration),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: resourcesList(data, context));
  }
}
