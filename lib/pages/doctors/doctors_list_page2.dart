import 'package:doctor/route/route_manager.dart';
import 'package:doctor/utils/data_format_util.dart';
import 'package:doctor/widgets/table_view.dart';
import 'package:flutter/material.dart';
import 'package:http_manager/api.dart';
import 'package:doctor/http/dtp.dart';
import 'package:provider/provider.dart';

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
    return "在线医生课堂";
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
                  child: Image.asset("assets/images/titlePage.png"),
                );
              },
              itemBuilder: (context, dynamic d) {
                DoctorCircleEntity data = d;
                return DoctorsListCell2(data, widget.args);
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

class DoctorsListCell2 extends StatefulWidget {
  final DoctorCircleEntity data;
  final String type;

  DoctorsListCell2(this.data, this.type);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DoctorsListCell2States();
  }

}
  class DoctorsListCell2States extends State<DoctorsListCell2> {
  DoctorCircleEntity data;
  String type;

  @override
  void initState() {
    data = widget.data;
    type = widget.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteManager.DOCTORS_ARTICLE_DETAIL,
          arguments: {
            'postId': data.postId,
            'from': 'list',
            'type': type,
          },
        );
        setState(() {
          data.read = true;
        });
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
                              "${dateFormat(data.updateShelvesTime)}",
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
                  width: 116,
                  height: 80,
                  child: Image.network("${data.coverUrl}",
                      width: 116, height: 80, fit: BoxFit.cover),
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
