import 'package:flutter/material.dart';

class CaseDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CaseDetailState();
  }
}

class CaseDetailState extends State<CaseDetail> {
  Widget buildItem(String name) {
    var noneBorder = UnderlineInputBorder(
      borderSide: BorderSide(width: 0, color: Colors.transparent),
    );
    return Container(
      child: Column(
        children: [
          Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(name),
                Container(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      hintText: "请输入",
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Color(0xff888888),
                      ),
                      border: noneBorder,
                      focusedBorder: noneBorder,
                      enabledBorder: noneBorder,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 1,
            color: Color(0xffF3F5F8),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("医学调研详情"),
      ),
      body: Container(
        color: Color(0xfff3f5f8),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Container(
                  child: Column(
                    children: [
                      buildItem("患者姓名/编码"),
                      buildItem("年龄"),
                      buildItem("性别"),
                      buildItem("就诊医院"),
                    ],
                  ),
                ),
              ),
              Container(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
