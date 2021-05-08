import 'package:flutter/material.dart';

class ActivityDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ActivityState();
  }
}

class _ActivityState extends State<ActivityDetail> {
  Widget cardTitle(String data) {
    return Text(
      data,
      style: TextStyle(
        color: Color(0xff107BFD),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget card({@required Widget child}) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 12),
      padding: EdgeInsets.symmetric(vertical: 21, horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: child,
    );
  }

  Widget buildInfo() {
    Widget line(String title, String desc) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xff005aa0).withOpacity(0.1)),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff444444),
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 5),
            ),
            Expanded(
              child: Text(
                desc,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xff222222),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              cardTitle("病例征集信息"),
            ],
          ),
          line("活动名称", "问题讨论"),
          line("来自企业", "问题讨论"),
          line("截止日期", "2020年6月1日23:58"),
          Container(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              "当前完成度：0%",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xff107bfd),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDesc() {
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              cardTitle("病例征集说明"),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 12),
          ),
          Text(
            "123",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xff222222),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildList() {
    Widget line(String desc, String status) {
      return Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: Color(0xffe5e5f5),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: [
            Text(
              "123",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xff444444),
              ),
            ),
            Expanded(child: Container()),
            Text(
              "待审核",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xff444444),
              ),
            ),
          ],
        ),
      );
    }

    return card(
      child: Column(
        children: [
          Row(
            children: [
              cardTitle("病例列表"),
            ],
          ),
          line("病例1：已上传15张图片", "待审核"),
          line("病例1：已上传15张图片", "待审核"),
          line("病例1：已上传15张图片", "待审核"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F5F8),
      appBar: AppBar(
        title: Text("病例征集活动"),
      ),
      body: Column(
        children: [
          buildInfo(),
          buildDesc(),
          buildList(),
        ],
      ),
    );
  }
}
