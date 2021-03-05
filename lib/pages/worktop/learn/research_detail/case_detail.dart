import 'package:flutter/material.dart';

class CaseDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CaseDetailState();
  }
}

class CaseDetailState extends State<CaseDetail> {
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
                padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Container(
                  height: 60,
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
