import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:doctor/model/ucenter/doctor_detail_info_entity.dart';
import 'package:doctor/pages/doctors/doctors_banner.dart';
import 'package:doctor/pages/doctors/doctors_banner_item.dart';
import 'package:doctor/pages/doctors/doctors_list_page.dart';
import 'package:doctor/pages/doctors/doctors_list_page2.dart';
import 'package:doctor/pages/qualification/doctor_physician_status_page.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:doctor/utils/adapt.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/widgets/common_stack.dart';
import 'package:flutter/material.dart';
import 'package:doctor/http/ucenter.dart';
import 'package:flutter/services.dart';
import 'package:http_manager/manager.dart';

import '../../root_widget.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with RouteAware {
  DoctorDetailInfoEntity doctorData;
  var numData;
  dynamic doctorStatus = {
    'WAIT_VERIFY': '未认证',
    'VERIFYING': '审核中',
    'FAIL': '需重新认证',
    'PASS': '已认证',
  };
  dynamic doctorColor = {
    'WAIT_VERIFY': Color(0XFFB9B9B9),
    'VERIFYING': Color(0XFFFFBA00),
    'FAIL': Color(0XFFFFBA00),
    'PASS': Color(0XFF489DFE),
  };

  //获取医生基本信息和收藏患者信息
  //authStatus:认证状态(WAIT_VERIFY-待认证、VERIFYING-认证中、FAIL-认证失败、PASS-认证通过）
  _doctorInfo() async {
    try {
      var basicData = await API.shared.ucenter.getBasicData();
      if (basicData is! DioError) {
        setState(() {
          doctorData = DoctorDetailInfoEntity.fromJson(basicData);
        });
      }
      var basicNumData = await API.shared.ucenter.getBasicNum();
      if (basicNumData is! DioError) {
        setState(() {
          numData = basicNumData;
        });
      }
    } catch (e) {}
  }

  @override
  void initState() {
    _doctorInfo();
    eventBus.on().listen((event) {
      if (event == KEY_UPDATE_USER_INFO) {
        _doctorInfo();
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)); //订阅
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _doctorInfo();
    super.didPopNext();
  }

//跳转列表样式
  Widget messageItem(String lable, String img, callBack, {String num}) {
    var content = Container(
      padding: EdgeInsets.symmetric(horizontal: 34),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: Divider.createBorderSide(context)),
        ),
        child: Row(
          children: [
            Image.asset(
              img,
              width: 24,
              height: 24,
            ),
            Container(
              width: 3,
            ),
            Text(
              lable ?? '',
              style: TextStyle(
                color: ThemeColor.colorFF000000,
                fontSize: 16,
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (lable == "我的收藏")
                      Text(
                        num,
                        style: TextStyle(
                          color: ThemeColor.colorFF000000,
                          fontSize: 14,
                        ),
                      ),
                    Icon(Icons.keyboard_arrow_right,color: Color(0x35000000),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return GestureDetector(
      onTap: (){
        callBack();
      },
      child: content,
    );
  }

//收藏患者样式
  Widget boxItem(
    String img,
    int counts,
    String lable,
    pushRoute,
  ) {
    return InkWell(
      onTap: () {
        pushRoute();
      },
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 12),
            child: Image.asset(
              img,
              width: 40,
              height: 40,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /*2*/
              Container(
                child: Text(
                  '$counts',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF444444),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(
                lable,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF717171),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var favoriteServerNum = 0;
    var favoriteFoundationNum = 0;
    try {
      favoriteServerNum = numData['favoriteServerNum'] as int;
      favoriteFoundationNum = numData["favoriteFoundationNum"] as int;
    } catch (e) {}
    var facNum = favoriteServerNum + favoriteFoundationNum;
    var content = Column(
      children: [
        //头部
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, RouteManager.USERINFO_DETAIL,
                arguments: {'doctorData': doctorData.toJson()});
          },
          child: Container(
            padding: EdgeInsets.only(top: 100, left: 16, bottom: 26),
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/common_statck_bg.png"),
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 62,
                  height: 62,
                  child: doctorData?.fullFacePhoto == null
                      ? Image.asset(
                          "assets/images/doctorHeader.png",
                          width: 35,
                          height: 35,
                        )
                      : Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: NetworkImage(
                                  '${doctorData?.fullFacePhoto?.url}?status=${doctorData?.fullFacePhoto?.ossId}'),
                            ),
                          ),
                        ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x2f000000),
                        offset: Offset(0, 2),
                        blurRadius: 10,
                      ),
                    ],
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 23),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text(
                              doctorData?.doctorName ?? "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              width: 80,
                              height: 20,
                              margin: EdgeInsets.only(left: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: doctorData?.authStatus == 'PASS'
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
                                    if (doctorData?.authStatus == 'PASS')
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
                                      text: doctorData?.authStatus == 'PASS'
                                          ? '资质认证'
                                          : '尚未认证',
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: Adapt.screenW() * 0.6,
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          "${doctorData?.hospitalName}",
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          '${doctorData?.departmentsName} ${doctorData?.jobGradeName}',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 10,
        ),
        // 跳转页面
        Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              messageItem('我的收藏', 'assets/images/fav.png', () {
                Navigator.pushNamed(context, RouteManager.COLLECT_DETAIL);
              }, num: "$facNum"),
              messageItem('设置', 'assets/images/setting.png', () {
                Navigator.pushNamed(context, RouteManager.SETTING);
              }),
              messageItem('关于我们', 'assets/images/aboutus.png', () {
                Navigator.pushNamed(context, RouteManager.ABOUT_US);
              }),
            ],
          ),
        ),
      ],
    );
    return Container(
      child: content,
    );
  }
}
