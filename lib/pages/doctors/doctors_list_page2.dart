
import 'package:doctor/http/dtp.dart';
import 'package:doctor/pages/doctors/viewmodel/doctors_view_model.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/widgets/table_view.dart';
import 'package:flutter/material.dart';
import 'package:http_manager/api.dart';
import 'package:doctor/http/dtp.dart';

import 'model/doctor_circle_entity.dart';

class DoctorsListPage2 extends StatefulWidget {
  final String args;

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
                    padding: EdgeInsets.only(top: 20, left: 35),
                    alignment: Alignment.centerLeft,
                    child: Image.asset("assets/images/smallCube.png"),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 40, right: 12),
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

  String titleFromType(String type) {
    if (type == "OPEN_CLASS"){
      return "企业公开课";
    }

    return "在线医课堂";
  }

  Widget title() {
    return Container(
      height: 44,
      child: Row(
        children: [
          Container(
            width: 44,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Text(
              titleFromType(widget.args),
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
              header: (context) {
                return Container(
                  height: 75,
                  child: widget.args == "OPEN_CLASS" ?Image.asset("assets/images/titlePage2.png") : Image.asset("assets/images/titlePage.png"),
                );
              },
              itemBuilder: (context, dynamic d) {
                DoctorCircleEntity data = d;
                return DoctorsListCell2(data, widget.args,(){
                  setState(() {

                  });
                });
              },
              getData: (page) async {
                var list = await API.shared.dtp.postList(
                  {'postType': widget.args, 'ps': 20, 'pn': page},
                );
                List<DoctorCircleEntity> posts = list['records']
                    .map<DoctorCircleEntity>(
                        (item) => DoctorCircleEntity.fromJson(item))
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

class DoctorsListCell2 extends StatelessWidget {
  final DoctorCircleEntity data;
  final String type;
  final void Function() onClick;

  DoctorsListCell2(this.data, this.type,this.onClick) ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        RouteManagerOld.openDoctorsDetail(data.postId, );
        data.read = true;
        if (onClick != null) {
          onClick();
        }
      },
      child: content(context, data.read),
    );
  }

  Widget content(BuildContext context, bool isRead) {
    return Container(
      height: 112,
      child: Column(
        children: [
          Container(
            height: 100,
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            data.postTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: isRead
                                  ? Color(0xffc1c1c1)
                                  : Color(0xff222222),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "${formatChineseViewCount(data.viewNum)}次学习",
                              style: TextStyle(
                                fontSize: 12,
                                color: isRead
                                    ? Color(0xffc1c1c1)
                                    : Color(0xff444444),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 16,
                ),
                Container(
                  color: Color(0xffEAF3FF),
                  width: 133,
                  height: 80,
                  child: Image.network("${data.coverUrl}",
                      width: 133, height: 80, fit: BoxFit.cover),
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
  }
}
