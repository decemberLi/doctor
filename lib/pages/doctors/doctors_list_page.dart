import 'dart:convert';

import 'package:doctor/route/route_manager.dart';
import 'package:doctor/utils/data_format_util.dart';
import 'package:doctor/widgets/table_view.dart';
import 'package:flutter/material.dart';
import 'package:http_manager/api.dart';
import 'package:doctor/http/dtp.dart';
import 'package:provider/provider.dart';

import 'model/doctor_circle_entity.dart';
import 'viewmodel/doctors_view_model.dart';

class DoctorsListPage extends StatefulWidget {
  final String args;

  DoctorsListPage(this.args);

  @override
  State<StatefulWidget> createState() => _DoctorsListStates();
}

class _DoctorsListStates extends State<DoctorsListPage> {
  String title = "";
  String code = "";

  @override
  void initState() {
    super.initState();
    try {
      var data = json.decode(widget.args);
      print("the data is ${data}");
      title = data["title"];
      code = data["code"];
    } catch (e) {}
  }

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
            height: 116,
            padding: EdgeInsets.only(right: 5),
            alignment: Alignment.centerRight,
            child: Image.asset("assets/images/page_list_title.png"),
          ),
        ),
      ],
    );
  }

  String titleFromType(String type) {
    return "每日医讲";
  }

  Widget titleContainer() {
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
              title,
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
          titleContainer(),
          Expanded(
            child: NormalTableView<DoctorCircleEntity>(
              padding: EdgeInsets.only(left: 16, right: 16, top: 20),
              itemBuilder: (context, dynamic d) {
                DoctorCircleEntity data = d;
                return DoctorsListItem(data);
              },
              getData: (page) async {
                var list = await API.shared.dtp.postList(
                  {'postType': 'ACADEMIC','columnCode':code, 'ps': 20, 'pn': page},
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
class DoctorsListItem extends StatefulWidget {
  final DoctorCircleEntity data;

  DoctorsListItem(
      this.data,
      );
  @override
  State<StatefulWidget> createState() {
    return DoctorsListItemStates();
  }

}
class DoctorsListItemStates extends State<DoctorsListItem> {
  DoctorCircleEntity data;
  @override
  void initState() {
    data = widget.data;
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
                            Expanded(
                              child: Container(
                                height: 20,
                                width: 100,
                              ),
                            ),
                            Text(
                              "${formatChineseViewCount(data.viewNum)}阅读",
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
