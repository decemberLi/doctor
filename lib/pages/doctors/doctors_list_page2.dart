import 'package:doctor/widgets/table_view.dart';
import 'package:flutter/material.dart';
import 'package:http_manager/api.dart';
import 'package:doctor/http/dtp.dart';

import 'model/doctor_circle_entity.dart';

class DoctorsListPage2 extends StatefulWidget {
  String args;
  DoctorsListPage2(this.args);
  @override
  State<StatefulWidget> createState() => _DoctorsListStates2();
}

class _DoctorsListStates2 extends State<DoctorsListPage2> {
  Widget bg() {
    return Stack(
      children: [
        Container(
          height: 116,
          color: Color(0xff107BFD),
        ),
        SafeArea(
          child: Container(
            color: Color(0xff107BFD),
            height: 170,
            padding: EdgeInsets.only(right: 5),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 20,left: 35),
                    alignment: Alignment.centerLeft,
                    child: Image.asset("assets/images/smallCube.png"),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 40,right: 12),
                    alignment: Alignment.topRight,
                    child: Image.asset("assets/images/bigCube.png"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget title() {
    return Container(
      height: 44,
      child: Row(
        children: [
          Container(
            width: 44,
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "在线医生课堂",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: 44,
          ),
        ],
      ),
    );
  }

  Widget page() {
    return Container(
      child: Column(
        children: [
          title(),
          Expanded(
            child: NormalTableView<DoctorCircleEntity>(
              padding: EdgeInsets.only(left: 16, right: 16),
              header: (context){
                return Container(
                  height: 75,
                  child: Image.asset("assets/images/titlePage.png"),
                );
              },
              itemBuilder: (context, dynamic d) {
                DoctorCircleEntity data = d;
                return Container(
                  height: 112,
                  child: Column(
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 12,
                                  top: 10,
                                  bottom: 8,
                                  right: 12,
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${data.postTitle}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "34次学习",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xff444444)),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              color: Color(0xffEAF3FF),
                              width: 117,
                              height: 100,
                              child: Image.network(
                                "${data.coverUrl}",
                                width: 110,
                                height: 76,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                );
              },
              getData: (page) async {
                var list = await API.shared.dtp.postList(
                  {'postType': widget.args, 'ps': 20, 'pn': page},
                );
                List<DoctorCircleEntity> posts = list['records']
                    .map<DoctorCircleEntity>((item) => DoctorCircleEntity.fromJson(item))
                    .toList();
                return posts;
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffEAF3FF),
      child: Stack(
        children: [
          bg(),
          SafeArea(
            child: page(),
          ),
        ],
      ),
    );
  }
}
