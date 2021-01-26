import 'package:doctor/utils/data_format_util.dart';
import 'package:doctor/widgets/table_view.dart';
import 'package:flutter/material.dart';
import 'package:http_manager/api.dart';
import 'package:doctor/http/dtp.dart';

import 'model/doctor_circle_entity.dart';
import 'viewmodel/doctors_view_model.dart';

class DoctorsListPage extends StatefulWidget {
  String args;
  DoctorsListPage(this.args);
  @override
  State<StatefulWidget> createState() => _DoctorsListStates();
}

class _DoctorsListStates extends State<DoctorsListPage> {
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

  String titleFromType(String type){
    return "每日医讲";
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
              padding: EdgeInsets.only(left: 16, right: 16, top: 20),
              itemBuilder: (context, dynamic d) {
                DoctorCircleEntity data = d;
                return DoctorsListItem(data);
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


class DoctorsListItem extends StatelessWidget {
  final DoctorCircleEntity data;
  DoctorsListItem(this.data);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      child: Column(
        children: [
          Container(
            height: 100,
            padding: EdgeInsets.only(
                left: 12, right: 12, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(
                            data.postTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "${dateFormat(data.updateShelvesTime)}",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff444444)),
                            ),
                            Expanded(
                              child: Container(
                                height: 20,
                                width: 100,
                              ),
                            ),
                            Text(
                              "阅读${formatChineseViewCount(data.viewNum)}",
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
                  width: 20,
                ),
                Container(
                  color: Color(0xffEAF3FF),
                  width: 110,
                  height: 76,
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
  }
}