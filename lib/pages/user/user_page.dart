import 'package:dio/dio.dart';
import 'package:doctor/pages/user/service.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/common_stack.dart';
import 'package:doctor/widgets/dashed_decoration.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  var doctorData;
  var numData;
  //获取医生基本信息和收藏患者信息

  _doctorInfo() async {
    var basicData = await getBasicData();
    print('res$basicData');
    if (basicData is! DioError) {
      setState(() {
        doctorData = basicData;
      });
    }
    var basicNumData = await getBasicNum();
    print('res$basicNumData');
    if (basicNumData is! DioError) {
      setState(() {
        numData = basicNumData;
      });
    }
  }

  @override
  void initState() {
    _doctorInfo();
    super.initState();
  }

  Widget messageItem(String lable, String img, callBack) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        border: Border(bottom: Divider.createBorderSide(context)),
      ),
      child: ListTile(
        title: Text(
          lable,
          style: TextStyle(
            color: ThemeColor.colorFF000000,
            fontSize: 14,
          ),
        ),
        leading: Image.asset(
          img,
          width: 24,
          height: 24,
        ),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          callBack();
        },
      ),
    );
  }

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            img,
            width: 40,
            height: 40,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /*2*/
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '$counts',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF444444),
                    fontWeight: FontWeight.bold,
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
    if (numData == null) {
      return Container();
    }
    return CommonStack(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 60, left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // decoration:
                    //     DashedDecoration(dashedColor: ThemeColor.colorFF222222),
                    child: Image.asset(
                      "assets/images/avatar.png",
                      width: 80,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            doctorData['doctorName'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            doctorData['hospitalName'],
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        Container(
                          child: Text(
                            '${doctorData['departmentsName']} ${doctorData['jobGradeName']}',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              width: 343,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  boxItem(
                      'assets/images/learn.png', numData['favoriteNum'], '我的收藏',
                      () {
                    Navigator.pushNamed(context, RouteManager.COLLECT_DETAIL);
                  }),
                  VerticalDivider(),
                  boxItem(
                      'assets/images/learn.png', numData['patientNum'], '我的患者',
                      () {
                    Navigator.pushNamed(context, RouteManager.PATIENT);
                  }),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  messageItem('资质认证', 'assets/images/learn.png', () {
                    print('资质认证');
                    Navigator.pushNamed(
                        context, RouteManager.QUALIFICATION_PAGE);
                  }),
                  messageItem('设置', 'assets/images/learn.png', () {
                    print('设置');
                    // TODO: 设置页面
                  }),
                  messageItem('关于我们', 'assets/images/learn.png', () {
                    Navigator.pushNamed(context, RouteManager.ABOUT_US);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
