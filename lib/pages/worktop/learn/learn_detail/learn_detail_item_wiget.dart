import 'package:doctor/route/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';

/// 渲染列表
class PlanDetailList extends StatelessWidget {
  final List formList;
  PlanDetailList(this.formList);

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

  @override
  Widget build(BuildContext context) {
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    for (var item in formList) {
      tiles.add(new Container(
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
                      child: typeDecoratedBox(item['type'])),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.only(left: 30, top: 20, bottom: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFDEDEE1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                      ),
                                      padding:
                                          EdgeInsets.only(left: 4, right: 4),
                                      margin:
                                          EdgeInsets.only(right: 4, bottom: 10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 12,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            '待观看',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFDEDEE1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                      ),
                                      padding:
                                          EdgeInsets.only(left: 4, right: 4),
                                      margin:
                                          EdgeInsets.only(right: 4, bottom: 10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 12,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            '反馈',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                              Text(
                                item['title'],
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
                                '2医学信息推广专员医学信息推广专员息推广专员${item['title']}',
                                style: TextStyle(
                                    color: Color(0xFF666666), fontSize: 14),
                                softWrap: true,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ])),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(RouteManager.RESOURCE_DETAIL);
                    },
                    child: Container(
                      width: 108,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            'assets/images/logo.png',
                            width: 60,
                            height: 60,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          )));
    }
    content = new Column(
        children: tiles //重点在这里，因为用编辑器写Column生成的children后面会跟一个<Widget>[]，
        );
    return content;
  }
}
